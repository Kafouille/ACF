AddCSLuaFile( "ACF/Shared/Rounds/RoundHE.lua" )

local DefTable = {}
	DefTable.type = "Ammo"										--Tells the spawn menu what entity to spawn
	DefTable.name = "HE"										--Human readable name
	DefTable.model = "models/munitions/round_100mm_shot.mdl"	--Shell flight model
	DefTable.desc = "Instant detonation HE shell"
	DefTable.netid = 2											--Unique ammotype ID for network transmission
	
	DefTable.limitvel = 500										--Most efficient penetration speed in m/s
	
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
	
	local BulletData = {}
		BulletData["Id"] = PlayerData["Id"]
		BulletData["Type"] = PlayerData["Type"]
		
		BulletData["Caliber"] = ACF.Weapons["Guns"][PlayerData["Id"]]["caliber"]
		BulletData["FrAera"] = 3.1416 * (BulletData["Caliber"]/2)^2
		BulletData["PenAera"] = BulletData["FrAera"]^ACF.PenAreaMod
		
		BulletData["PropMass"] = BulletData["FrAera"] * (PlayerData["PropLenght"]*ACF.PDensity/1000) --Volume of the case as a cylinder * Powder density converted from g to kg
		local BulletMax = ACF.Weapons["Guns"][PlayerData["Id"]]["round"]
		
		PlayerData["ProjLenght"] = math.max(PlayerData["ProjLenght"],BulletData["Caliber"]*1.5)
		
		BulletData["Tracer"] = 0
		if PlayerData["Data10"]*1 > 0 then	--Check for tracer
			BulletData["Tracer"] = math.min(5/BulletData["Caliber"],2.5)
		end
		
		if ( BulletData["PropMass"] > BulletMax["propweight"] ) then
			PlayerData["PropLenght"] = (BulletMax["propweight"]*1000/ACF.PDensity) / (3.1416*(BulletData["Caliber"]/2)^2)
			BulletData["PropMass"] = BulletData["FrAera"] * (PlayerData["PropLenght"]*ACF.PDensity/1000)
		end	
		
		if ( (PlayerData["ProjLenght"] + PlayerData["PropLenght"] + BulletData["Tracer"]) > BulletMax["maxlength"] ) then
			local Ratio = BulletMax["maxlength"]/(PlayerData["ProjLenght"] + PlayerData["PropLenght"] + BulletData["Tracer"])
			PlayerData["ProjLenght"] = PlayerData["ProjLenght"] * Ratio
			PlayerData["PropLenght"] = PlayerData["PropLenght"] * Ratio
		end
		
		PlayerData["Data5"] = math.min(PlayerData["Data5"],ACF_HEMaxFiller( BulletData["PropMass"], BulletData["Caliber"], PlayerData["ProjLenght"] , PlayerData["Data5"] ))
		BulletData["FillerMass"] = PlayerData["Data5"]*ACF.HEDensity/1000
		
		BulletData["RoundVolume"] = BulletData["FrAera"] * (PlayerData["ProjLenght"] + PlayerData["PropLenght"])	
		local ProjVolume = BulletData["FrAera"] * PlayerData["ProjLenght"]
		BulletData["ProjMass"] = (ProjVolume-PlayerData["Data5"])*7.9/1000 + BulletData["FillerMass"] --Volume of the projectile as a cylinder - Volume of the filler * density of steel + Volume of the filler * density of TNT
		
		BulletData["MuzzleVel"] = ACF_MuzzleVelocity( BulletData["PropMass"], BulletData["ProjMass"], BulletData["Caliber"] )
		BulletData["DragCoef"] = ((BulletData["FrAera"]/10000)/BulletData["ProjMass"])
		BulletData["BoomPower"] = BulletData["PropMass"] + BulletData["FillerMass"]
	
	return BulletData
	
end

function ACF_HECreate( Gun, BulletData )
	
	ACF_CreateBullet( BulletData )
	
end

function ACF_HEPropImpact( Index, Bullet, Target, HitNormal, HitPos )

	if ACF_Check( Target ) then
		local Angle = ACF_GetHitAngle( HitNormal , Bullet["Flight"] )
		local Speed = Bullet["Flight"]:Length()
		local Energy = ACF_Kinetic( Speed , Bullet["ProjMass"] - Bullet["FillerMass"], ACF.RoundTypes["HE"]["limitvel"] )
		local HitRes = ACF_Damage ( Target , Energy , Bullet["PenAera"] , Angle , Bullet["Owner"] )  --DAMAGE !!
		
		local phys = Target:GetPhysicsObject() 
		if (phys:IsValid()) then	
			phys:ApplyForceCenter( Bullet["Flight"]:GetNormal() * (Energy.Momentum*HitRes.Loss*39.37) )	
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
		Flash:SetScale( math.max( Radius/200, 1 ) )									--Scale of the particles
		Flash:SetRadius( math.max( Radius/50, 1 ) )								--Radius of the smoke
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

function ACF_HEMaxFiller( PropWeight, Caliber, ProjLength , CurFillerVol )
	
	if not CurFillerVol then CurFillerVol = 0 end
	local Aera = 3.1416*(Caliber/2)^2
	
	local ProjVolume = Aera * ProjLength
	local ProjWeight = math.max(ProjVolume-CurFillerVol,0)*7.9/1000 + math.min(CurFillerVol,ProjVolume)*ACF.HEDensity/1000--Volume of the projectile as a cylinder - Volume of the filler * density of steel + Volume of the filler * density of TNT
	local Velocity = ACF_MuzzleVelocity( PropWeight, ProjWeight, Caliber )
	local Energy = ACF_Kinetic( Velocity*39.37 , ProjVolume*7.9/1000, 0 )
	local MinWall = 0.3+((Energy.Momentum/Aera)^0.7)/50 --The minimal shell wall thickness required to survive firing at the current energy level
	
	local MaxFiller = (3.1416*math.max((Caliber/2)-MinWall,0)^2) * (ProjLength-MinWall*0.2) --Calculating the free space you have with those walls
	
	return MaxFiller
	
end

--GUI stuff after this
function ACF_HEGUICreate( Panel, Table )

	acfmenupanel.CData["Id"] = "AmmoMedium"
	acfmenupanel.CData["Type"] = "Ammo"

	if not acfmenupanel.AmmoData then
		acfmenupanel.AmmoData = {}
			acfmenupanel.AmmoData["PropLength"] = 0
			acfmenupanel.AmmoData["ProjLength"] = 0
			acfmenupanel.AmmoData["FillerVol"] = 0
			acfmenupanel.AmmoData["Data"] = acfmenupanel.WeaponData["Guns"]["12.7mmMG"]["round"]
	end
	
	--Creating the ammo crate selection
	acfmenupanel.CData.CrateSelect = vgui.Create( "DMultiChoice" )	--Every display and slider is placed in the Round table so it gets trashed when selecting a new round type
		acfmenupanel.CData.CrateSelect:SetSize(100, 30)
		table.SortByMember(acfmenupanel.WeaponData["Ammo"],"caliber")
		for Key, Value in pairs( acfmenupanel.WeaponData["Ammo"] ) do
			acfmenupanel.CData.CrateSelect:AddChoice( Value.id , Key )
		end
		acfmenupanel.CData.CrateSelect.OnSelect = function( index , value , data )
			RunConsoleCommand( "acfmenu_id", data )
		end
		if acfmenupanel.CData["Id"] then
			acfmenupanel.CData.CrateSelect:SetText(acfmenupanel.CData["Id"])
			RunConsoleCommand( "acfmenu_id", acfmenupanel.CData["Id"] )
		else
			acfmenupanel.CData.CrateSelect:SetText("AmmoSmall")
			RunConsoleCommand( "acfmenu_id", "AmmoSmall" )
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.CrateSelect )	
	
	--Create the caliber selection display
	acfmenupanel.CData.CaliberSelect = vgui.Create( "DMultiChoice" )	
		acfmenupanel.CData.CaliberSelect:SetSize(100, 30)
		for Key, Value in pairs( acfmenupanel.WeaponData["Guns"] ) do
			acfmenupanel.CData.CaliberSelect:AddChoice( Value.id , Key )
		end
		acfmenupanel.CData.CaliberSelect.OnSelect = function( index , value , data )
			acfmenupanel.AmmoData = {}
				acfmenupanel.AmmoData["PropLength"] = 0
				acfmenupanel.AmmoData["ProjLength"] = 0
				acfmenupanel.AmmoData["FillerVol"] = 0
				acfmenupanel.AmmoData["Tracer"] = false
				acfmenupanel.AmmoData["Data"] = acfmenupanel.WeaponData["Guns"][data]["round"]
			ACF_HEGUIUpdate()
		end
		acfmenupanel.CData.CaliberSelect:SetText(acfmenupanel.AmmoData["Data"]["id"])
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.CaliberSelect )	
	
	acfmenupanel.CData.lengthDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.lengthDisplay:SetText( "" )
		acfmenupanel.CData.lengthDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.lengthDisplay )
	
	--Create the round schematic
	acfmenupanel.CData.PropSchem = vgui.Create( "DShape" )
		acfmenupanel.CData.PropSchem:SetType( "Rect" )
		acfmenupanel.CData.PropSchem:SetPos( 0, 0 )
		acfmenupanel.CData.PropSchem:SetSize( 100, 20 )
		acfmenupanel.CData.PropSchem:SetColor( 255, 20, 20, 255 )
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.PropSchem )
	
	--Create the value sliders	
	
	--Propellant Lenght Slider
	acfmenupanel.CData.SetPropLength = vgui.Create( "DNumSlider" )
		acfmenupanel.CData.SetPropLength:SetText( "Propellant length" )
		acfmenupanel.CData.SetPropLength:SetMin( 0 )
		acfmenupanel.CData.SetPropLength:SetMax( 1000 )
		acfmenupanel.CData.SetPropLength:SetDecimals( 3 )
		if acfmenupanel.AmmoData["PropLength"] then
			acfmenupanel.CData.SetPropLength:SetValue(acfmenupanel.AmmoData["PropLength"])
		end
		acfmenupanel.CData.SetPropLength.OnValueChanged = function( slider, val )
			if acfmenupanel.AmmoData["PropLength"] != val then
				ACF_HEGUIUpdate()
			end
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.SetPropLength )
	
	acfmenupanel.CData.PropellantWeight = vgui.Create( "DLabel" )
		acfmenupanel.CData.PropellantWeight:SetText( "" )
		acfmenupanel.CData.PropellantWeight:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.PropellantWeight )
	
	--Projectile Lenght Slider
	acfmenupanel.CData.SetProjLength = vgui.Create( "DNumSlider" )
		acfmenupanel.CData.SetProjLength:SetText( "Projectile length" )
		acfmenupanel.CData.SetProjLength:SetMin( 0 )
		acfmenupanel.CData.SetProjLength:SetMax( 1000 )
		acfmenupanel.CData.SetProjLength:SetDecimals( 3 )
		if acfmenupanel.AmmoData["ProjLength"] then
			acfmenupanel.CData.SetProjLength:SetValue(acfmenupanel.AmmoData["ProjLength"])
		end
		acfmenupanel.CData.SetProjLength.OnValueChanged = function( slider, val )
			if acfmenupanel.AmmoData["ProjLength"] != val then
				ACF_HEGUIUpdate()
			end
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.SetProjLength )
	
	acfmenupanel.CData.ProjWeight = vgui.Create( "DLabel" )
		acfmenupanel.CData.ProjWeight:SetText( "" )
		acfmenupanel.CData.ProjWeight:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.ProjWeight )
	
	--Filler Volume Slider
	acfmenupanel.CData.SetFillerVol = vgui.Create( "DNumSlider" )
		acfmenupanel.CData.SetFillerVol:SetText( "HE Filler volume" )
		acfmenupanel.CData.SetFillerVol:SetMin( 0 )
		acfmenupanel.CData.SetFillerVol:SetMax( 1000 )
		acfmenupanel.CData.SetFillerVol:SetDecimals( 3 )
		if acfmenupanel.AmmoData["FillerVol"] then
			acfmenupanel.CData.SetFillerVol:SetValue(acfmenupanel.AmmoData["FillerVol"])
		end
		acfmenupanel.CData.SetFillerVol.OnValueChanged = function( slider, val )
			if acfmenupanel.AmmoData["FillerVol"] != val then
				ACF_HEGUIUpdate()
			end
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.SetFillerVol )
	
	--Tracer checkbox
	acfmenupanel.CData.SetTracer = vgui.Create( "DCheckBoxLabel" )
		acfmenupanel.CData.SetTracer:SetText( "Tracer" )
		acfmenupanel.CData.SetTracer:SizeToContents()
		if acfmenupanel.AmmoData["Tracer"] != nil then
			acfmenupanel.CData.SetTracer:SetChecked(acfmenupanel.AmmoData["Tracer"])
		end
		acfmenupanel.CData.SetTracer.OnChange = function( check, bval )
			acfmenupanel.AmmoData["Tracer"] = bval
			ACF_HEGUIUpdate()
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.SetTracer )
	
	acfmenupanel.CData.FillerWeight = vgui.Create( "DLabel" )
		acfmenupanel.CData.FillerWeight:SetText( "" )
		acfmenupanel.CData.FillerWeight:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.FillerWeight )
	
	acfmenupanel.CData.VelocityDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.VelocityDisplay:SetText( "" )
		acfmenupanel.CData.VelocityDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.VelocityDisplay )
	
	acfmenupanel.CData.BlastDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.BlastDisplay:SetText( "" )
		acfmenupanel.CData.BlastDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.BlastDisplay )
	
	acfmenupanel.CData.FragDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.FragDisplay:SetText( "" )
		acfmenupanel.CData.FragDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.FragDisplay )
		
	ACF_HEGUIUpdate( Panel, Table )

end

function ACF_HEGUIUpdate( Panel, Table )
	
	local Caliber = acfmenupanel.WeaponData["Guns"][acfmenupanel.AmmoData["Data"]["id"]]["caliber"]
	local Aera = 3.1416*(Caliber/2)^2
		
	local PropWeight = Aera * (acfmenupanel.AmmoData["PropLength"]*ACF.PDensity/1000) --Volume of the case as a cylinder * Powder density converted from g to kg
	local TracerLenght = 0
	if acfmenupanel.AmmoData["Tracer"] then
		TracerLenght = math.min(5/Caliber,2.5)
	end
	local Freelength = acfmenupanel.AmmoData["Data"]["maxlength"] - (acfmenupanel.AmmoData["ProjLength"] + acfmenupanel.AmmoData["PropLength"] + TracerLenght)
	
	local MinPropLength = 0.01
	local MaxPropLength = math.min( (acfmenupanel.AmmoData["Data"]["propweight"]*1000/ACF.PDensity) / Aera , acfmenupanel.AmmoData["PropLength"]+Freelength )
	local ClampProp = math.floor(math.Clamp(acfmenupanel.CData.SetPropLength:GetValue()*1000,MinPropLength*1000,MaxPropLength*1000))/1000
	acfmenupanel.CData.SetPropLength:SetMin( MinPropLength ) 
	acfmenupanel.CData.SetPropLength:SetMax( MaxPropLength )
	acfmenupanel.AmmoData["PropLength"] = ClampProp

	local MinProjLength = Caliber*1.5
	local MaxProjLength = math.min(acfmenupanel.AmmoData["ProjLength"]+Freelength,acfmenupanel.AmmoData["Data"]["maxlength"])
	local ClampProj = math.floor(math.Clamp(acfmenupanel.CData.SetProjLength:GetValue()*1000,MinProjLength*1000,MaxProjLength*1000))/1000
	acfmenupanel.CData.SetProjLength:SetMin( MinProjLength ) 
	acfmenupanel.CData.SetProjLength:SetMax( MaxProjLength )
	acfmenupanel.AmmoData["ProjLength"] = ClampProj	
		
	local MinFillerVol = 0
	local MaxFillerVol = ACF_HEMaxFiller( PropWeight, Caliber, ClampProj , acfmenupanel.AmmoData["FillerVol"] )
	local ClampFillerVol = math.floor(math.Clamp(acfmenupanel.CData.SetFillerVol:GetValue()*1000,MinFillerVol*1000,MaxFillerVol*1000))/1000
	local FillerWeight = ClampFillerVol*ACF.HEDensity/1000
	acfmenupanel.CData.SetFillerVol:SetMin( MinFillerVol ) 
	acfmenupanel.CData.SetFillerVol:SetMax( MaxFillerVol )
	acfmenupanel.AmmoData["FillerVol"] = ClampFillerVol	
		
	--Set the values on the sliders if they have changed.
	if acfmenupanel.CData.SetPropLength:GetValue() != ClampProp then acfmenupanel.CData.SetPropLength:SetValue( ClampProp ) return end
	if acfmenupanel.CData.SetProjLength:GetValue() != ClampProj then acfmenupanel.CData.SetProjLength:SetValue( ClampProj ) return end
	if acfmenupanel.CData.SetFillerVol:GetValue() != ClampFillerVol then acfmenupanel.CData.SetFillerVol:SetValue( ClampFillerVol ) return end	
	
	RunConsoleCommand( "acfmenu_data1", acfmenupanel.AmmoData["Data"]["id"] )
	RunConsoleCommand( "acfmenu_data2", "HE")
	RunConsoleCommand( "acfmenu_data3", ClampProp )		--For Gun ammo, Data3 should always be Propellant
	RunConsoleCommand( "acfmenu_data4", ClampProj )		--And Data4 total round mass
	RunConsoleCommand( "acfmenu_data5", ClampFillerVol )
	RunConsoleCommand( "acfmenu_data10", TracerLenght )
	
	acfmenupanel.CData.lengthDisplay:SetText( "Total Round length : "..(math.floor((acfmenupanel.AmmoData["Data"]["maxlength"] - Freelength)*1000)/1000).."cm/"..acfmenupanel.AmmoData["Data"]["maxlength"].."cm" )
	acfmenupanel.CData.lengthDisplay:SizeToContents()
	
	acfmenupanel.CData.PropSchem:SetSize( 100, 20 )
	
	acfmenupanel.CData.SetTracer:SetText( "Tracer : "..(math.floor(math.min(5/Caliber,2.5)*100)/100).."cm\n" )
	
	acfmenupanel.CData.PropellantWeight:SetText( "Propellant Weight : "..(math.floor(PropWeight*1000)).." g" )
	acfmenupanel.CData.PropellantWeight:SizeToContents()
	
	local ProjVolume = Aera * ClampProj
	local ProjWeight = (ProjVolume-ClampFillerVol)*7.9/1000 + FillerWeight --Volume of the projectile as a cylinder - Volume of the filler * density of steel + Volume of the filler * density of TNT
	acfmenupanel.CData.ProjWeight:SetText( "Projectile Weight : "..(math.floor(ProjWeight*1000)).." g" )
	acfmenupanel.CData.ProjWeight:SizeToContents()
	
	acfmenupanel.CData.FillerWeight:SetText( "Filler Weight : "..(math.floor(FillerWeight*1000)).." g" )
	acfmenupanel.CData.FillerWeight:SizeToContents()
	
	local Velocity = ACF_MuzzleVelocity( PropWeight, ProjWeight, Caliber )
	acfmenupanel.CData.VelocityDisplay:SetText( "Muzzle Velocity : "..math.floor(Velocity*ACF.VelScale).." m\s" )
	acfmenupanel.CData.VelocityDisplay:SizeToContents()
	
	acfmenupanel.CData.BlastDisplay:SetText( "Blast Radius : "..(math.floor(FillerWeight^0.33*5*10)/10).." m" )
	acfmenupanel.CData.BlastDisplay:SizeToContents()
	
	local FragMass = ProjWeight - FillerWeight
	local Fragments = math.max(math.floor((FillerWeight/FragMass)*ACF.HEFrag),2)
	local FragWeight = FragMass/Fragments
	local FragVel = (FillerWeight*ACF.HEPower*1000/FragWeight/Fragments)^0.5
	
	acfmenupanel.CData.FragDisplay:SetText( "Fragments : "..Fragments.."\n Average Fragment Weight : "..(math.floor(FragWeight*10000)/10).." g \n Average Fragment Velocity : "..math.floor(FragVel).." m/s" )
	acfmenupanel.CData.FragDisplay:SizeToContents()
		
	acfmenupanel.CustomDisplay:PerformLayout()
	
end
