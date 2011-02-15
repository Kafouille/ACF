AddCSLuaFile( "ACF/Shared/Rounds/RoundAP.lua" )

local DefTable = {}
	DefTable.type = "Ammo"										--Tells the spawn menu what entity to spawn
	DefTable.name = "Armour Piercing"							--Human readable name
	DefTable.model = "models/munitions/round_100mm_shot.mdl"	--Shell flight model
	DefTable.desc = "A shell made out of a solid piece of steel, meant to penetrate armour"
	DefTable.netid = 1											--Unique ammotype ID for network transmission

	DefTable.limitvel = 800										--Most efficient penetration speed in m/s
	DefTable.ricochet = 75										--Base ricochet angle
	
	DefTable.create = function( Gun, BulletData ) ACF_APCreate( Gun, BulletData ) end
	DefTable.convert = function( Crate, Table ) local Result = ACF_APConvert( Crate, Table ) return Result end
	
	DefTable.propimpact = function( Bullet, Index, Target, HitNormal, HitPos ) local Result = ACF_APPropImpact( Bullet, Index, Target, HitNormal, HitPos ) return Result end
	DefTable.worldimpact = function( Bullet, Index, HitPos, HitNormal ) ACF_APWorldImpact( Bullet, Index, HitPos, HitNormal ) end
	DefTable.endflight = function( Bullet, Index, HitPos, HitNormal ) ACF_APEndFlight( Bullet, Index, HitPos, HitNormal ) end
	
	DefTable.endeffect = function( Effect, Pos, Flight, RoundMass, FillerMass ) ACF_APEndEffect( Effect, Pos, Flight, RoundMass, FillerMass ) end
	DefTable.pierceeffect = function( Effect, Pos, Flight, RoundMass, FillerMass ) ACF_APPierceEffect( Effect, Pos, Flight, RoundMass, FillerMass ) end
	DefTable.ricocheteffect = function( Effect, Pos, Flight, RoundMass, FillerMass ) ACF_APRicochetEffect( Effect, Pos, Flight, RoundMass, FillerMass ) end
	
	DefTable.guicreate = function( Panel, Table ) ACF_APGUICreate( Panel, Table ) end	--References the function to use to draw that round menu
	DefTable.guiupdate = function( Panel, Table ) ACF_APGUIUpdate( Panel, Table ) end	--References the function to use to update that round menu

list.Set( "ACFRoundTypes", "AP", DefTable )  --Set the round properties
list.Set( "ACFIdRounds", 1 , "AP" ) --Index must equal the ID entry in the table above, Data must equal the index of the table above


function ACF_APConvert( Crate, PlayerData )		--Function to convert the player's slider data into the complete round data
	
	local Data = {}
	local ServerData = {}
	local GUIData = {}
	
	if not PlayerData["PropLength"] then PlayerData["PropLength"] = 0 end
	if not PlayerData["ProjLength"] then PlayerData["ProjLength"] = 0 end
	if not PlayerData["Data10"] then PlayerData["Data10"] = 0 end
	
	PlayerData, Data, ServerData, GUIData = ACF_RoundBaseGunpowder( PlayerData, Data, ServerData, GUIData )
	
	Data["ProjMass"] = Data["FrAera"] * (Data["ProjLength"]*7.9/1000) --Volume of the projectile as a cylinder * density of steel
	Data["ShovePower"] = 0.2
	Data["PenAera"] = Data["FrAera"]^ACF.PenAreaMod
	Data["DragCoef"] = ((Data["FrAera"]/10000)/Data["ProjMass"])
	Data["MuzzleVel"] = ACF_MuzzleVelocity( Data["PropMass"], Data["ProjMass"], Data["Caliber"] )
	
	Data["BoomPower"] = Data["PropMass"]

	if SERVER then --Only the crates need this part
		ServerData["Id"] = PlayerData["Id"]
		ServerData["Type"] = PlayerData["Type"]
		return table.Merge(Data,ServerData)
	end
	
	if CLIENT then --Only tthe GUI needs this part
		local Energy = ACF_Kinetic( Data["MuzzleVel"]*39.37 , Data["ProjMass"], ACF.RoundTypes[PlayerData["Type"]]["limitvel"] )
		GUIData["MaxPen"] = (Energy.Penetration/Data["PenAera"])*ACF.KEtoRHA
		return table.Merge(Data,GUIData)
	end
	
end

function ACF_APCreate( Gun, BulletData )
	
	ACF_CreateBullet( BulletData )
	
end

function ACF_APPropImpact( Index, Bullet, Target, HitNormal, HitPos )	--Can be called from other round types

	if ACF_Check( Target ) then
		local Type = Bullet["Type"]
		local Angle = ACF_GetHitAngle( HitNormal , Bullet["Flight"] )
		local Speed = Bullet["Flight"]:Length()
		local Energy = ACF_Kinetic( Speed , Bullet["ProjMass"], ACF.RoundTypes[Type]["limitvel"] )
		local Ricochet = 0
		local MinAngle = ACF.RoundTypes[Type]["ricochet"] - Speed/39.37/15	--Making the chance of a ricochet get higher as the speeds increase
		if Angle > math.random(MinAngle,90) and Angle < 89.9 then	--Checking for ricochet
			Ricochet = (Angle/100)			--If ricocheting, calculate how much of the energy is dumped into the plate and how much is carried by the ricochet
			Energy.Penetration = Energy.Penetration - Energy.Penetration*Ricochet/4 --Ricocheting can save plates that would theorically get penetrated, can add up to 1/4 rating
		end
		local HitRes = ACF_Damage ( Target , Energy , Bullet["PenAera"] , Angle , Bullet["Owner"] )  --DAMAGE !!
		local NewSpeed = (Energy.Kinetic*(1-HitRes.Loss)*2000/Bullet["ProjMass"])^0.5
		local phys = Target:GetPhysicsObject() 
		
		if (Target:GetParent():IsValid()) then
			phys = Target:GetParent():GetPhysicsObject() 
		end
		if (phys:IsValid()) then	
			phys:ApplyForceOffset( Bullet["Flight"]:GetNormal() * (Energy.Kinetic*HitRes.Loss*1000*Bullet["ShovePower"]), HitPos )
		end
		
		if HitRes.Kill then
			local Debris = ACF_APKill( Target , (Bullet["Flight"]):GetNormalized() , Energy.Kinetic )
			table.insert( Bullet["Filter"] , Debris )
		end	
		if HitRes.Overkill > 0 then
			table.insert( Bullet["Filter"] , Target )					--"Penetrate" (Ingoring the prop for the retry trace)
			ACF_Spall( HitPos , Bullet["Flight"] , Bullet["Filter"] , Energy.Kinetic*HitRes.Loss , Bullet["Caliber"] , Target.ACF.Armour , Bullet["Owner"] ) --Do some spalling
			Bullet["Flight"] = Bullet["Flight"]:GetNormalized() * NewSpeed * 39.37
			ACF_BulletClient( Index, Bullet, "Update" , 2 , HitPos )
			return "Penetrated"
		elseif Ricochet > 0 then
			Bullet["Pos"] = HitPos
			Bullet["Flight"] = (Bullet["Flight"]:GetNormalized() + HitNormal*(1-Ricochet+0.05) + VectorRand()*0.05):GetNormalized() * Speed * Ricochet
			ACF_BulletClient( Index, Bullet, "Update" , 3 , HitPos )
			return "Ricochet"
		else
			return false
		end
	else 
		table.insert( Bullet["Filter"] , Target )
	return "Penetrated" end
	
	ACF_RemoveBullet( Index )
	return false
	
end

function ACF_APWorldImpact( Index, Bullet, HitPos, HitNormal )
	
	local Energy = ACF_Kinetic( Bullet["Flight"]:Length(), Bullet["ProjMass"], ACF.RoundTypes["AP"]["limitvel"] )
	local MaxDig = ((Energy.Penetration/Bullet["PenAera"])*ACF.KEtoRHA/ACF.GroundtoRHA)/25.4
	local CurDig = 0
	local DigStep = math.min(50,MaxDig)
	--print(MaxDig/DigStep)
	--print(MaxDig)
	
	for i = 1,MaxDig/DigStep do
		--Msg("Step : ")
		--print(i)
		CurDig = DigStep*i
		local DigTr = { }
			DigTr.start = HitPos + (Bullet["Flight"]):GetNormalized()*CurDig
			DigTr.endpos = HitPos
			DigTr.filter = Bullet["Filter"]
			DigTr.mask = 16395
		local DigRes = util.TraceLine(DigTr)					--Trace to see if it will hit anything
		
		if DigRes.Hit then
			if DigRes.Fraction > 0.01 and DigRes.Fraction < 0.99 then 							
				local Powerloss = (MaxDig - (CurDig - DigStep*DigRes.Fraction))/MaxDig
				--print(Powerloss)
				Bullet["Flight"] = Bullet["Flight"] * Powerloss
				
				--Msg("Penetrated the wall\n")
				ACF_BulletClient( Index, Bullet, "Update" , 2 , HitPos )
				Bullet["Pos"] = DigRes.HitPos
				ACF_CalcBulletFlight( Index, Bullet )
				return true
			else
				ACF_APEndFlight( Index, Bullet, HitPos )	
				--Msg("Failed to penetrate the wall\n") 
			return end
		else
			--Msg("Didn't Hit\n")
		end
	end
	
	ACF_APEndFlight( Index, Bullet, HitPos )

end

function ACF_APEndFlight( Index, Bullet, HitPos )

	ACF_BulletClient( Index, Bullet, "Update" , 1 , HitPos  )

	ACF_RemoveBullet( Index )
	
end

--Clientside effects, called from ACF_Bulleteffect
function ACF_APEndEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet stops here, do what you  have to do clientside
	
	local Spall = EffectData()
		Spall:SetOrigin( Pos )
		Spall:SetNormal( (Flight):GetNormalized() )
		Spall:SetScale( Flight:Length() )
		Spall:SetMagnitude( RoundMass )
	util.Effect( "ACF_AP_Impact", Spall )

end

function ACF_APPierceEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet penetrated something, do what you have to clientside

	local Spall = EffectData()
		Spall:SetOrigin( Pos )
		Spall:SetNormal( (Flight):GetNormalized() )
		Spall:SetScale( Flight:Length() )
		Spall:SetMagnitude( RoundMass )
	util.Effect( "ACF_AP_Penetration", Spall )

end

function ACF_APRicochetEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet ricocheted off something, do what you have to clientside

	local Spall = EffectData()
		Spall:SetOrigin( Pos )
		Spall:SetNormal( (Flight):GetNormalized() )
		Spall:SetScale( Flight:Length() )
		Spall:SetMagnitude( RoundMass )
	util.Effect( "ACF_AP_Ricochet", Spall )
	
end

--GUI stuff after this
function ACF_APGUICreate( Panel, Table )

	acfmenupanel:AmmoSelect()
	
	acfmenupanel:AmmoText("LengthDisplay", "")	--Total round length (Name, Desc)
	
	acfmenupanel:AmmoSlider("PropLength",0,0,1000,3, "Propellant Length", "")	--Propellant Length Slider (Name, Value, Min, Max, Decimals, Title, Desc)
	acfmenupanel:AmmoSlider("ProjLength",0,0,1000,3, "Projectile Length", "")	--Projectile Length Slider (Name, Value, Min, Max, Decimals, Title, Desc)
	
	acfmenupanel:AmmoCheckbox("Tracer", "Tracer", "")			--Tracer checkbox (Name, Title, Desc)
	
	acfmenupanel:AmmoText("VelocityDisplay", "")	--Proj muzzle velocity (Name, Desc)
	acfmenupanel:AmmoText("PenetrationDisplay", "")	--Proj muzzle penetration (Name, Desc)
	
	ACF_APGUIUpdate( Panel, Table )

end

function ACF_APGUIUpdate( Panel, Table )
	
	local PlayerData = {}
		PlayerData["Id"] = acfmenupanel.AmmoData["Data"]["id"]			--AmmoSelect GUI
		PlayerData["Type"] = "AP"										--Hardcoded, match ACFRoundTypes table index
		PlayerData["PropLength"] = acfmenupanel.AmmoData["PropLength"]	--PropLength slider
		PlayerData["ProjLength"] = acfmenupanel.AmmoData["ProjLength"]	--ProjLength slider
		--PlayerData["Data5"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data6"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data7"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data8"] = acfmenupanel.AmmoData[Name]		--Not used
		--PlayerData["Data9"] = acfmenupanel.AmmoData[Name]		--Not used
		local Tracer = 0
		if acfmenupanel.AmmoData["Tracer"] then Tracer = 1 end
		PlayerData["Data10"] = Tracer				--Tracer
	
	local Data = ACF_APConvert( Panel, PlayerData )
	
	RunConsoleCommand( "acfmenu_data1", acfmenupanel.AmmoData["Data"]["id"] )
	RunConsoleCommand( "acfmenu_data2", "AP" )					--Hardcoded, match ACFRoundTypes table index
	RunConsoleCommand( "acfmenu_data3", Data.PropLength )		--For Gun ammo, Data3 should always be Propellant
	RunConsoleCommand( "acfmenu_data4", Data.ProjLength )		--And Data4 total round mass
	RunConsoleCommand( "acfmenu_data10", Data.Tracer )
	
	acfmenupanel:AmmoSlider("PropLength",Data.PropLength,Data.MinPropLength,Data["MaxTotalLength"],3, "Propellant Length", "Propellant Mass : "..(math.floor(Data.PropMass*1000)).." g" )	--Propellant Length Slider (Name, Min, Max, Decimals, Title, Desc)
	acfmenupanel:AmmoSlider("ProjLength",Data.ProjLength,Data.MinProjLength,Data["MaxTotalLength"],3, "Projectile Length", "Projectile Mass : "..(math.floor(Data.ProjMass*1000)).." g")	--Projectile Length Slider (Name, Min, Max, Decimals, Title, Desc)

	acfmenupanel:AmmoCheckbox("Tracer", "Tracer : "..(math.floor(Data.Tracer*10)/10).."cm\n", "" )			--Tracer checkbox (Name, Title, Desc)
	
	acfmenupanel:AmmoText("LengthDisplay", "Round Length : "..(math.floor((Data.PropLength+Data.ProjLength+Data.Tracer)*100)/100).."/"..(Data.MaxTotalLength).." cm")	--Total round length (Name, Desc)
	acfmenupanel:AmmoText("VelocityDisplay", "Muzzle Velocity : "..math.floor(Data.MuzzleVel*ACF.VelScale).." m\s")	--Proj muzzle velocity (Name, Desc)
	acfmenupanel:AmmoText("PenetrationDisplay", "Maximum Penetration : "..math.floor(Data.MaxPen).." mm RHA")	--Proj muzzle penetration (Name, Desc)
	
end
