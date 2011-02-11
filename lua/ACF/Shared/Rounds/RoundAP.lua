AddCSLuaFile( "ACF/Shared/Rounds/RoundAP.lua" )

local DefTable = {}
	DefTable.type = "Ammo"										--Tells the spawn menu what entity to spawn
	DefTable.name = "AP"										--Human readable name
	DefTable.model = "models/munitions/round_100mm_shot.mdl"	--Shell flight model
	DefTable.desc = "Solid AP shot"
	DefTable.netid = 1											--Unique ammotype ID for network transmission

	DefTable.limitvel = 600										--Most efficient penetration speed in m/s
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
	
	local BulletData = {}
		BulletData["Id"] = PlayerData["Id"]
		BulletData["Type"] = PlayerData["Type"]
		
		BulletData["Caliber"] = ACF.Weapons["Guns"][PlayerData["Id"]]["caliber"]
		BulletData["FrAera"] = 3.1416 * (BulletData["Caliber"]/2)^2
		BulletData["PropMass"] = BulletData["FrAera"] * (PlayerData["PropLenght"]*ACF.PDensity/1000) --Volume of the case as a cylinder * Powder density converted from g to kg
		local BulletMax = ACF.Weapons["Guns"][PlayerData["Id"]]["round"]
		
		PlayerData["ProjLenght"] = math.max(PlayerData["ProjLenght"],BulletData["Caliber"]*1.5)
		
		BulletData["Tracer"] = 0
		if PlayerData["Data10"]*1 > 0 then	--Check for tracer
			BulletData["Tracer"] = math.min(5/BulletData["Caliber"],2.5)
		end
		
		if ( BulletData["PropMass"] > BulletMax["propweight"] ) then	--These 3 if statements are checking if the round fits into parameters and to fail gracefully if not
			PlayerData["PropLenght"] = (BulletMax["propweight"]*1000/ACF.PDensity) / (BulletData["FrAera"])
			BulletData["PropMass"] = BulletData["FrAera"] * (PlayerData["PropLenght"]*ACF.PDensity/1000)
		end	
		
		if ( (PlayerData["ProjLenght"] + PlayerData["PropLenght"] + BulletData["Tracer"]) > BulletMax["maxlength"] ) then
			local Ratio = BulletMax["maxlength"]/(PlayerData["ProjLenght"] + PlayerData["PropLenght"] + BulletData["Tracer"])
			PlayerData["ProjLenght"] = PlayerData["ProjLenght"] * Ratio
			PlayerData["PropLenght"] = PlayerData["PropLenght"] * Ratio
		end
		
		BulletData["RoundVolume"] = BulletData["FrAera"] * (PlayerData["ProjLenght"] + PlayerData["PropLenght"])	
		BulletData["ProjMass"] = BulletData["FrAera"] * (PlayerData["ProjLenght"]*7.9/1000) --Volume of the projectile as a cylinder * streamline factor (Data5) * density of steel
		
		BulletData["DragCoef"] = ((BulletData["FrAera"]/10000)/BulletData["ProjMass"])
		BulletData["PenAera"] = BulletData["FrAera"]^ACF.PenAreaMod
		BulletData["MuzzleVel"] = ACF_MuzzleVelocity( BulletData["PropMass"], BulletData["ProjMass"], BulletData["Caliber"] )
		BulletData["BoomPower"] = BulletData["PropMass"]
	
	return BulletData
	
end

function ACF_APCreate( Gun, BulletData )
	
	ACF_CreateBullet( BulletData )
	
end

function ACF_APPropImpact( Index, Bullet, Target, HitNormal, HitPos )

	if ACF_Check( Target ) then
		local Angle = ACF_GetHitAngle( HitNormal , Bullet["Flight"] )
		local Speed = Bullet["Flight"]:Length()
		local Energy = ACF_Kinetic( Speed , Bullet["ProjMass"], ACF.RoundTypes["AP"]["limitvel"] )
		local Ricochet = 0
		local MinAngle = ACF.RoundTypes["AP"]["ricochet"] - Speed/39.37/15	--Making the chance of a ricochet get higher as the speeds increase
		if Angle > math.random(MinAngle,90) and Angle < 89.9 then	--Checking for ricochet
			Ricochet = (Angle/100)			--If ricocheting, calculate how much of the energy is dumped into the plate and how much is carried by the ricochet
			Energy.Penetration = Energy.Penetration - Energy.Penetration*Ricochet/4 --Ricocheting can save plates that would theorically get penetrated, can add up to 1/4 rating
		end
		local HitRes = ACF_Damage ( Target , Energy , Bullet["PenAera"] , Angle , Bullet["Owner"] )  --DAMAGE !!

		local phys = Target:GetPhysicsObject() 
		if (phys:IsValid()) then	
			phys:ApplyForceCenter( Bullet["Flight"]:GetNormal() * (Energy.Momentum*HitRes.Loss*39.37) )	
		end
		
		if HitRes.Kill then
			local Debris = ACF_APKill( Target , (Bullet["Flight"]):GetNormalized() , Energy.Kinetic )
			table.insert( Bullet["Filter"] , Debris )
		end	
		if HitRes.Overkill > 0 then
			table.insert( Bullet["Filter"] , Target )					--"Penetrate" (Ingoring the prop for the retry trace)
			ACF_Spall( HitPos , Bullet["Flight"] , Bullet["Filter"] , Energy.Kinetic*HitRes.Loss , Bullet["Caliber"] , Target.ACF.Armour , Bullet["Owner"] ) --Do some spalling
			Bullet["Flight"] = Bullet["Flight"]:GetNormalized() * (Energy.Kinetic*(1-HitRes.Loss)*2000/Bullet["ProjMass"])^0.5 * 39.37
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

--Clientside effects
function ACF_APEndEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet stops here, do what you  have to do clientside

	local BulletEffect = {}
		BulletEffect.Num = 1
		BulletEffect.Src = Pos - Flight:GetNormalized()*2
		BulletEffect.Dir = Flight:GetNormalized()
		BulletEffect.Spread = Vector(0,0,0)
		BulletEffect.Tracer = 0
		BulletEffect.Force = 0
		BulletEffect.Damage = 0	 
	LocalPlayer():FireBullets(BulletEffect) 	

end

function ACF_APPierceEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet penetrated something, do what you have to clientside

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

function ACF_APRicochetEffect( Effect, Pos, Flight, RoundMass, FillerMass )	--Bullet ricocheted off something, do what you have to clientside

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
function ACF_APGUICreate( Panel, Table )

	acfmenupanel.CData["Id"] = "AmmoMedium"
	acfmenupanel.CData["Type"] = "Ammo"

	if not acfmenupanel.AmmoData then
		acfmenupanel.AmmoData = {}
			acfmenupanel.AmmoData["PropLength"] = 0
			acfmenupanel.AmmoData["ProjLength"] = 0
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
				acfmenupanel.AmmoData["Tracer"] = false
				acfmenupanel.AmmoData["Data"] = acfmenupanel.WeaponData["Guns"][data]["round"]
			ACF_APGUIUpdate()
		end
		acfmenupanel.CData.CaliberSelect:SetText(acfmenupanel.AmmoData["Data"]["id"])
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.CaliberSelect )	
	
	acfmenupanel.CData.lengthDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.lengthDisplay:SetText( "" )
		acfmenupanel.CData.lengthDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.lengthDisplay )
	
	--Create the round schematic
	acfmenupanel.CData.PropSchem = vgui.Create( "DShape" )
		acfmenupanel.CData.PropSchem:SetType("Rect")
		acfmenupanel.CData.PropSchem:SetSize( 100, 20 )
		acfmenupanel.CData.PropSchem:SetColor( 255, 255, 255, 255 )
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
				ACF_APGUIUpdate()
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
				ACF_APGUIUpdate()
			end
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.SetProjLength )
	
	--Tracer checkbox
	acfmenupanel.CData.SetTracer = vgui.Create( "DCheckBoxLabel" )
		acfmenupanel.CData.SetTracer:SetText( "Tracer" )
		acfmenupanel.CData.SetTracer:SizeToContents()
		if acfmenupanel.AmmoData["Tracer"] != nil then
			acfmenupanel.CData.SetTracer:SetChecked(acfmenupanel.AmmoData["Tracer"])
		end
		acfmenupanel.CData.SetTracer.OnChange = function( check, bval )
			acfmenupanel.AmmoData["Tracer"] = bval
			ACF_APGUIUpdate()
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.SetTracer )
	
	acfmenupanel.CData.ProjWeight = vgui.Create( "DLabel" )
		acfmenupanel.CData.ProjWeight:SetText( "" )
		acfmenupanel.CData.ProjWeight:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.ProjWeight )

	acfmenupanel.CData.VelocityDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.VelocityDisplay:SetText( "" )
		acfmenupanel.CData.VelocityDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.VelocityDisplay )
	
	acfmenupanel.CData.PenetrationDisplay = vgui.Create( "DLabel" )
		acfmenupanel.CData.PenetrationDisplay:SetText( "" )
		acfmenupanel.CData.PenetrationDisplay:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.PenetrationDisplay )
	
	ACF_APGUIUpdate( Panel, Table )

end

function ACF_APGUIUpdate( Panel, Table )
	
	local Caliber = acfmenupanel.WeaponData["Guns"][acfmenupanel.AmmoData["Data"]["id"]]["caliber"]
		
	local ProjWeight = 3.1416*(Caliber/2)^2 * (acfmenupanel.AmmoData["ProjLength"]*7.9/1000) --Volume of the projectile as a cylinder * streamline factor * density of steel
	local PropWeight = 3.1416*(Caliber/2)^2 * (acfmenupanel.AmmoData["PropLength"]*ACF.PDensity/1000) --Volume of the case as a cylinder * Powder density converted from g to kg
	local TracerLenght = 0
	if acfmenupanel.AmmoData["Tracer"] then
		TracerLenght = math.min(5/Caliber,2.5)
	end
	local Freelength = acfmenupanel.AmmoData["Data"]["maxlength"] - (acfmenupanel.AmmoData["ProjLength"] + acfmenupanel.AmmoData["PropLength"] + TracerLenght)
	
	local MinPropLength = 0.01
	local MaxPropLength = math.min( (acfmenupanel.AmmoData["Data"]["propweight"]*1000/ACF.PDensity) / (3.1416*(Caliber/2)^2) , acfmenupanel.AmmoData["PropLength"]+Freelength )
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
	
	--Set the values on the sliders if they have changed.
	if acfmenupanel.CData.SetPropLength:GetValue() != ClampProp then acfmenupanel.CData.SetPropLength:SetValue( ClampProp ) return end
	if acfmenupanel.CData.SetProjLength:GetValue() != ClampProj then acfmenupanel.CData.SetProjLength:SetValue( ClampProj ) return end	
	
	RunConsoleCommand( "acfmenu_data1", acfmenupanel.AmmoData["Data"]["id"] )
	RunConsoleCommand( "acfmenu_data2", "AP")
	RunConsoleCommand( "acfmenu_data3", ClampProp )		--For Gun ammo, Data3 should always be Propellant
	RunConsoleCommand( "acfmenu_data4", ClampProj )		--And Data4 total round mass
	RunConsoleCommand( "acfmenu_data10", TracerLenght )
	
	acfmenupanel.CData.lengthDisplay:SetText( "Total Round length : "..(math.floor((acfmenupanel.AmmoData["Data"]["maxlength"] - Freelength)*1000)/1000).."cm/"..acfmenupanel.AmmoData["Data"]["maxlength"].."cm" )
	acfmenupanel.CData.lengthDisplay:SizeToContents()
	
	acfmenupanel.CData.PropSchem:SetSize( 100, 20 )
	
	acfmenupanel.CData.SetTracer:SetText( "Tracer : "..(math.floor(math.min(5/Caliber,2.5)*100)/100).."cm\n" )
	
	acfmenupanel.CData.PropellantWeight:SetText( "Propellant Weight : "..(math.floor(PropWeight*1000)).." g" )
	acfmenupanel.CData.PropellantWeight:SizeToContents()
	
	acfmenupanel.CData.ProjWeight:SetText( "Projectile Weight : "..(math.floor(ProjWeight*1000)).." g" )
	acfmenupanel.CData.ProjWeight:SizeToContents()
	
	local Velocity = ACF_MuzzleVelocity( PropWeight, ProjWeight, acfmenupanel.WeaponData["Guns"][acfmenupanel.AmmoData["Data"]["id"]]["caliber"] )
	acfmenupanel.CData.VelocityDisplay:SetText( "Muzzle Velocity : "..math.floor(Velocity*ACF.VelScale).." m\s" )
	acfmenupanel.CData.VelocityDisplay:SizeToContents()
	
	local Energy = ACF_Kinetic( Velocity*39.37 , ProjWeight, ACF.RoundTypes["AP"]["limitvel"] )
	local Aera = ( 3.1416*(Caliber/2)^2 )^ACF.PenAreaMod
	local Penetration = (Energy.Penetration/Aera)*ACF.KEtoRHA
	acfmenupanel.CData.PenetrationDisplay:SetText( "Maximum Penetration : "..math.floor(Penetration).." mm RHA" )
	acfmenupanel.CData.PenetrationDisplay:SizeToContents()
		
	acfmenupanel.CustomDisplay:PerformLayout()
	
end
