AddCSLuaFile( "ACF/Shared/Rounds/RoundHE.lua" )

local DefTable = {}
	DefTable.type = "Ammo"										--Tells the spawn menu what entity to spawn
	DefTable.name = "High Explosive"							--Human readable name
	DefTable.model = "models/munitions/round_100mm_shot.mdl"	--Shell flight model
	DefTable.desc = "A shell filled with explosives, detonating on impact"
	DefTable.netid = 2											--Unique ammotype ID for network transmission
	
	DefTable.limitvel = 500										--Most efficient penetration speed in m/s
	DefTable.ketransfert = 0.1									--Kinetic energy transfert to the target for movement purposes
	
	DefTable.create = function( Gun, BulletData ) ACF_HECreate( Gun, BulletData ) end
	DefTable.convert = function( Crate, Table ) local Result = ACF_HEConvert( Crate, Table ) return Result end
	
	DefTable.propimpact = function( Bullet, Index, Target, HitNormal, HitPos ) local Result = ACF_HEPropImpact( Bullet, Index, Target, HitNormal, HitPos ) return Result end
	DefTable.worldimpact = function( Bullet, Index, HitPos, HitNormal ) ACF_HEWorldImpact( Bullet, Index, HitPos, HitNormal ) end
	DefTable.endflight = function( Bullet, Index, HitPos, HitNormal ) ACF_HEEndFlight( Bullet, Index, HitPos, HitNormal ) end
	
	DefTable.endeffect = function( Effect, Pos, Flight, RoundMass, FillerMass ) ACF_HEEndEffect( Effect, Pos, Flight, RoundMass, FillerMass ) end
	DefTable.pierceeffect = function( Effect, Pos, Flight, RoundMass, FillerMass ) ACF_HEPierceEffect( Effect, Pos, Flight, RoundMass, FillerMass ) end
	DefTable.ricocheteffect = function( Effect, Pos, Flight, RoundMass, FillerMass ) ACF_HERicochetEffect( Effect, Pos, Flight, RoundMass, FillerMass ) end
	
	DefTable.guicreate = function( Panel, Table ) ACF_HEGUICreate( Panel, Table ) end	--References the function to use to draw that round menu
	DefTable.guiupdate = function( Panel, Table ) ACF_HEGUIUpdate( Panel, Table ) end	--References the function to use to update that round menu

list.Set( "ACFRoundTypes", "HE", DefTable )  --Set the round properties
list.Set( "ACFIdRounds", 2 , "HE" ) --Index must equal the ID entry in the table above, Data must equal the index of the table above

function ACF_HEConvert( Crate, PlayerData )		--Function to convert the player's slider data into the complete round data
	
	local Data = {}
	local ServerData = {}
	local GUIData = {}
	
	if not PlayerData["PropLength"] then PlayerData["PropLength"] = 0 end
	if not PlayerData["ProjLength"] then PlayerData["ProjLength"] = 0 end
	if not PlayerData["Data5"] then PlayerData["Data5"] = 0 end
	if not PlayerData["Data10"] then PlayerData["Data10"] = 0 end
	
	PlayerData, Data, ServerData, GUIData = ACF_RoundBaseGunpowder( PlayerData, Data, ServerData, GUIData )
	
	--Shell sturdiness calcs
	Data["ProjMass"] = math.max(GUIData["ProjVolume"]-PlayerData["Data5"],0)*7.9/1000 + math.min(PlayerData["Data5"],GUIData["ProjVolume"])*ACF.HEDensity/1000--Volume of the projectile as a cylinder - Volume of the filler * density of steel + Volume of the filler * density of TNT
	Data["MuzzleVel"] = ACF_MuzzleVelocity( Data["PropMass"], Data["ProjMass"], Data["Caliber"] )
	local Energy = ACF_Kinetic( Data["MuzzleVel"]*39.37 , Data["ProjMass"], ACF.RoundTypes[PlayerData["Type"]]["limitvel"] )
		
	GUIData["MinFillerVol"] = 0
	GUIData["MaxFillerVol"] = math.min(GUIData["ProjVolume"],ACF_RoundShellCapacity( Energy.Momentum, Data["FrAera"], Data["Caliber"], Data["ProjLength"] ))
	GUIData["FillerVol"] = math.min(PlayerData["Data5"],GUIData["MaxFillerVol"])
	Data["FillerMass"] = GUIData["FillerVol"] * ACF.HEDensity/1000
	
	--Random bullshit left
	Data["ShovePower"] = 0.1
	Data["PenAera"] = Data["FrAera"]^ACF.PenAreaMod
	Data["DragCoef"] = ((Data["FrAera"]/10000)/Data["ProjMass"])
	
	Data["BoomPower"] = Data["PropMass"] + Data["FillerMass"]

	if SERVER then --Only the crates need this part
		ServerData["Id"] = PlayerData["Id"]
		ServerData["Type"] = PlayerData["Type"]
		return table.Merge(Data,ServerData)
	end
	
	if CLIENT then --Only tthe GUI needs this part
		GUIData["BlastRadius"] = Data["FillerMass"]^0.33*5*10	
		local FragMass = Data["ProjMass"] - Data["FillerMass"]
		GUIData["Fragments"] = math.max(math.floor((Data["FillerMass"]/FragMass)*ACF.HEFrag),2)
		GUIData["FragMass"] = FragMass/GUIData["Fragments"]
		GUIData["FragVel"] = (Data["FillerMass"]*ACF.HEPower*1000/GUIData["FragMass"]/GUIData["Fragments"])^0.5
		return table.Merge(Data,GUIData)
	end
	
end

function ACF_HECreate( Gun, BulletData )
	
	ACF_CreateBullet( BulletData )
	
end

function ACF_HEPropImpact( Index, Bullet, Target, HitNormal, HitPos ) 	--Can be called from other round types

	if ACF_Check( Target ) then
		local Type = Bullet["Type"]
		local Angle = ACF_GetHitAngle( HitNormal , Bullet["Flight"] )
		local Speed = Bullet["Flight"]:Length()
		local Energy = ACF_Kinetic( Speed , Bullet["ProjMass"] - Bullet["FillerMass"], ACF.RoundTypes[Type]["limitvel"] )
		local HitRes = ACF_Damage ( Target , Energy , Bullet["PenAera"] , Angle , Bullet["Owner"] )  --DAMAGE !!
		
		local phys = Target:GetPhysicsObject() 
		if (Target:GetParent():IsValid()) then
			phys = Target:GetParent():GetPhysicsObject() 
		end
		if (phys:IsValid()) then	
			phys:ApplyForceOffset( Bullet["Flight"]:GetNormal() * (Energy.Kinetic*HitRes.Loss*1000*ACF.RoundTypes[Type]["ketransfert"]), HitPos )	--Assuming about a third of the energy goes to propelling the target prop (Kinetic in KJ * 1000 to get J then divided by ketransfert round data)
		end
		
		if HitRes.Kill then
			local Debris = ACF_APKill( Target , (Bullet["Flight"]):GetNormalized() , Energy.Kinetic )
			table.insert( Bullet["Filter"] , Debris )
		end	
	end
	
	return false

end

function ACF_HEWorldImpact( Index, Bullet, HitPos, HitNormal )
		
	ACF_HEEndFlight( Index, Bullet, HitPos, HitNormal )

end

function ACF_HEEndFlight( Index, Bullet, HitPos, HitNormal )
	
	ACF_BulletClient( Index, Bullet, "Update" , 1 , HitPos  )
	ACF_HE( HitPos , HitNormal , Bullet["FillerMass"] , Bullet["ProjMass"] - Bullet["FillerMass"] , Bullet["Owner"] )
	ACF_RemoveBullet( Index )
	
end

--Clientside effects
function ACF_HEDetEffect( Effect, Pos, Flight, RoundMass, FillerMass )
	
	local Radius = (FillerMass)^0.33*8*39.37
	local Flash = EffectData()
		Flash:SetOrigin( Pos )
		Flash:SetNormal( Flight:GetNormalized() )
		Flash:SetRadius( math.max( Radius, 1 ) )
	util.Effect( "ACF_Scaled_Explosion", Flash )
	
end

function ACF_HEEndEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet stops here, do what you  have to do clientside
		
	ACF_HEDetEffect( Effect, Pos, Flight, RoundMass, FillerMass )

end

function ACF_HEPierceEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet penetrated something, do what you have to clientside

	local BulletEffect = {}
		BulletEffect.Num = 1
		BulletEffect.Src = Pos - Flight:GetNormalized()
		BulletEffect.Dir = Flight:GetNormalized()
		BulletEffect.Spread = Vector(0,0,0)
		BulletEffect.Tracer = 0
		BulletEffect.Force = 0
		BulletEffect.Damage = 0	 
	LocalPlayer():FireBullets(BulletEffect) 	
	
	util.Decal("ExplosiveGunshot", Pos + Flight*10, Pos - Flight*10)
	
	local Spall = EffectData()
		Spall:SetOrigin( Pos )
		Spall:SetNormal( (Flight):GetNormalized() )
		Spall:SetScale( math.max(((RoundMass * (Flight:Length()/39.37)^2)/2000)/10000,1) )
	util.Effect( "AP_Hit", Spall )

end

function ACF_HERicochetEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet ricocheted off something, do what you have to clientside

	local BulletEffect = {}
		BulletEffect.Num = 1
		BulletEffect.Src = Pos - Flight:GetNormalized()
		BulletEffect.Dir = Flight
		BulletEffect.Spread = Vector(0,0,0)
		BulletEffect.Tracer = 0
		BulletEffect.Force = 0
		BulletEffect.Damage = 0	 
	LocalPlayer():FireBullets(BulletEffect) 
	
	local Sparks = EffectData()
		Sparks:SetOrigin( Pos )
		Sparks:SetNormal( (Flight):GetNormalized() )
	util.Effect( "ManhackSparks", Sparks )

end

--GUI stuff after this
function ACF_HEGUICreate( Panel, Table )

	acfmenupanel:AmmoSelect()

	acfmenupanel:AmmoText("LengthDisplay", "")	--Total round length (Name, Desc)
	
	acfmenupanel:AmmoSlider("PropLength",0,0,1000,3, "Propellant Length", "")	--Propellant Length Slider (Name, Value, Min, Max, Decimals, Title, Desc)
	acfmenupanel:AmmoSlider("ProjLength",0,0,1000,3, "Projectile Length", "")	--Projectile Length Slider (Name, Value, Min, Max, Decimals, Title, Desc)
	acfmenupanel:AmmoSlider("FillerVol",0,0,1000,3, "HE Filler", "")--Hollow Point Cavity Slider (Name, Value, Min, Max, Decimals, Title, Desc)
	
	acfmenupanel:AmmoCheckbox("Tracer", "Tracer", "")			--Tracer checkbox (Name, Title, Desc)
	
	acfmenupanel:AmmoText("VelocityDisplay", "")	--Proj muzzle velocity (Name, Desc)
	acfmenupanel:AmmoText("BlastDisplay", "")	--HE Blast data (Name, Desc)
	acfmenupanel:AmmoText("FragDisplay", "")	--HE Fragmentation data (Name, Desc)
	
	ACF_HEGUIUpdate( Panel, Table )
	
end

function ACF_HEGUIUpdate( Panel, Table )

	local PlayerData = {}
		PlayerData["Id"] = acfmenupanel.AmmoData["Data"]["id"]			--AmmoSelect GUI
		PlayerData["Type"] = "HE"										--Hardcoded, match ACFRoundTypes table index
		PlayerData["PropLength"] = acfmenupanel.AmmoData["PropLength"]	--PropLength slider
		PlayerData["ProjLength"] = acfmenupanel.AmmoData["ProjLength"]	--ProjLength slider
		PlayerData["Data5"] = acfmenupanel.AmmoData["FillerVol"]
		--PlayerData["Data6"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data7"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data8"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data9"] = acfmenupanel.AmmoData[Name]		--Not used
		local Tracer = 0
		if acfmenupanel.AmmoData["Tracer"] then Tracer = 1 end
		PlayerData["Data10"] = Tracer				--Tracer
	
	local Data = ACF_HEConvert( Panel, PlayerData )
	
	RunConsoleCommand( "acfmenu_data1", acfmenupanel.AmmoData["Data"]["id"] )
	RunConsoleCommand( "acfmenu_data2", "HE" )					--Hardcoded, match ACFRoundTypes table index
	RunConsoleCommand( "acfmenu_data3", Data.PropLength )		--For Gun ammo, Data3 should always be Propellant
	RunConsoleCommand( "acfmenu_data4", Data.ProjLength )		--And Data4 total round mass
	RunConsoleCommand( "acfmenu_data5", Data.FillerVol )
	RunConsoleCommand( "acfmenu_data10", Data.Tracer )
	
	acfmenupanel:AmmoSlider("PropLength",Data.PropLength,Data.MinPropLength,Data["MaxTotalLength"],3, "Propellant Length", "Propellant Mass : "..(math.floor(Data.PropMass*1000)).." g" )	--Propellant Length Slider (Name, Min, Max, Decimals, Title, Desc)
	acfmenupanel:AmmoSlider("ProjLength",Data.ProjLength,Data.MinProjLength,Data["MaxTotalLength"],3, "Projectile Length", "Projectile Mass : "..(math.floor(Data.ProjMass*1000)).." g")	--Projectile Length Slider (Name, Min, Max, Decimals, Title, Desc)
	acfmenupanel:AmmoSlider("FillerVol",Data.FillerVol,Data.MinFillerVol,Data.MaxFillerVol,3, "HE Filler Volume", "HE Filler Mass : "..(math.floor(Data["FillerMass"]*1000)).." g")	--HE Filler Slider (Name, Min, Max, Decimals, Title, Desc)
	
	acfmenupanel:AmmoCheckbox("Tracer", "Tracer : "..(math.floor(Data.Tracer*10)/10).."cm\n", "" )			--Tracer checkbox (Name, Title, Desc)

	acfmenupanel:AmmoText("LengthDisplay", "Round Length : "..(math.floor((Data.PropLength+Data.ProjLength+Data.Tracer)*100)/100).."/"..(Data.MaxTotalLength).." cm")	--Total round length (Name, Desc)
	acfmenupanel:AmmoText("VelocityDisplay", "Muzzle Velocity : "..math.floor(Data.MuzzleVel*ACF.VelScale).." m\s")	--Proj muzzle velocity (Name, Desc)	
	acfmenupanel:AmmoText("BlastDisplay", "Blast Radius : "..(math.floor(Data.BlastRadius*100)/1000).." m\n")	--Proj muzzle velocity (Name, Desc)
	acfmenupanel:AmmoText("FragDisplay", "Fragments : "..(Data.Fragments).."\n Average Fragment Weight : "..(math.floor(Data.FragMass*10000)/10).." g \n Average Fragment Velocity : "..math.floor(Data.FragVel).." m/s")	--Proj muzzle penetration (Name, Desc)
	
end
