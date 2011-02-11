-- This file is meant for the advanced damage functions used by the Armored Combat Framework
function ACF_HEAT( Self , HitPos , FlightVector , Power , AP , Radius )

	if !Self or !Self:IsValid() then return end
	local PenFilter = { Self }
	local CanPen = true
	local HitPosOrig = HitPos
	util.BlastDamage(Self, Self, HitPos, Radius/2, Power)  
	
	while ( CanPen ) do	 -- If the shell has enough energy left, continue tracing	
		CanPen = false	
		local PenTrace =  {}                                -- Do a trace forward of the shell, ignoring any previously hit entity
			PenTrace.start = HitPos
			PenTrace.endpos = HitPos + FlightVector:GetNormal() * Radius
			PenTrace.filter = PenFilter
		local PenTrc = util.TraceLine( PenTrace )
			
		if ( PenTrc.HitNonWorld ) then				
			table.insert( PenFilter , PenTrc.Entity )  -- Adds the entity we just traced to the trace filter table		
			if ACF_Check( PenTrc.Entity ) then  -- Check if the target we just hit is valid	
				local Falloff = (Radius - HitPosOrig:Distance(PenTrc.HitPos))/Radius						
				local Angle = ACF_GetHitAngle( PenTrc.HitNormal , FlightVector )
				local Penetration = ACF_Damage( PenTrc.Entity , Power*Falloff , AP*Falloff , Angle , Self )
				if Penetration > 30 then
					CanPen = true
					if Penetration == 101 then
						local Debris = ACF_HEKill( PenTrc.Entity , FlightVector:GetNormal() )
						table.insert( PenFilter , Debris )
					end
				end
			end	
		elseif ( PenTrc.HitWorld ) then
			
			util.Decal("FadingScorch", PenTrc.HitPos+PenTrc.HitNormal, PenTrc.HitPos-PenTrc.HitNormal) 
			local MaxDig = math.min((Power * AP)/2,Radius)
			local CurDig = 0
			local DigStep = 50
			local i = 0
			
			while i < MaxDig/DigStep and !CanPen do
				i = i+1
				--Msg("Step : ")
				--print(i)
				CurDig = DigStep*i
				local DigTr = { }
					DigTr.start = HitPos + FlightVector*CurDig
					DigTr.endpos = HitPos
					DigTr.filter = PenFilter
					DigTr.mask = 16395
				local DigRes = util.TraceLine(DigTr)					--Trace to see if it will hit anything
				
				if DigRes.Hit then			
					if DigRes.Fraction < 0.01 then 
						--Msg("Failed to penetrate the wall\n") 	
					elseif DigRes.Fraction > 0.95 then
						--Msg("Paperthin wall\n")
					else				
						HitPos = DigRes.HitPos
						CanPen = true					
						local Powerloss = (MaxDig - (CurDig - DigStep*DigRes.Fraction))/MaxDig
						--print(Powerloss)
						Power = Power*Powerloss					--Apply penalties for the loss of power sustained during the penetration
						AP = AP*Powerloss		
						util.Decal("FadingScorch", DigRes.HitPos+DigRes.HitNormal, DigRes.HitPos-DigRes.HitNormal) 			
						--Msg("Penetrated the wall\n")	
					end
				else
					--Msg("Didn't Hit\n")			
				end
			end
		end	
	end
	
end

function ACF_HE( Hitpos , HitNormal , FillerMass, FragMass , Inflictor, NoOcc )	--HitPos = Detonation center, FillerMass = mass of TNT being detonated in KG, FragMass = Mass of the round casing for fragmentation purposes, Inflictor owner of said TNT

	local Power = FillerMass * ACF.HEPower					--Power in KiloJoules of the filler mass of  TNT 
	local Radius = (FillerMass)^0.33*8*39.37				--Scalling law found on the net, based on 1PSI overpressure from 1 kg of TNT at 15m
	local Amp = math.min(Power/2000,50)
	util.ScreenShake( Hitpos, Amp, Amp, Amp/15, Radius*10 )  
	--local Targets = ents.FindInSphere( Hitpos, Radius )
	local Targets = ents.GetAll()
	for k,v in pairs (Targets) do
		local epos = v:GetPos()
		if Hitpos:Distance(epos) > Radius then
		Targets[k] = nil
		end
	end
	
	local Fragments = math.max(math.floor((FillerMass/FragMass)*ACF.HEFrag),2)
	local FragWeight = FragMass/Fragments
	local FragVel = (Power*1000/FragWeight/Fragments)^0.5
	local FragAera = (FragWeight/7.8)^0.33
	
	local OccFilter = { NoOcc }
	local LoopKill = true
	
	while LoopKill and Power > 0 do
		LoopKill = false
		local PowerSpent = 0
		local Iterations = 0
		local Damage = {}
		local TotalAera = 0
		for i,Tar in pairs(Targets) do
			Iterations = i
			--Msg("Target : " ..Tar:GetClass().. "\n")
			if ( Tar.Entity != nil and Power > 0 and not Tar.Entity.Exploding ) then
				local Type = ACF_Check(Tar.Entity)
				if ( Type ) then
					local Hitat = nil
					if Type == "Squishy" then 										--A little hack so it doesn't check occlusion at the feet of players
						local Eyes = Tar.Entity:LookupAttachment("eyes")
						if Eyes then
							Hitat = Tar.Entity:GetAttachment( Eyes )
							if Hitat then
								--Msg("Hitting Eyes\n")
								Hitat = Hitat.Pos
							else
								Hitat = Tar:NearestPoint( Hitpos )
							end
						end
					else
						Hitat = Tar:NearestPoint( Hitpos )
					end
					
					local Occlusion = {}
						Occlusion.start = Hitpos
						Occlusion.endpos = Hitat + (Hitat-Hitpos):GetNormalized()*100
						Occlusion.filter = OccFilter
						Occlusion.mask = MASK_SOLID
					local Occ = util.TraceLine( Occlusion )					
					
					if ( !Occ.Hit and Hitpos != Hitat ) then
						local Hitat = Tar.Entity:GetPos()
						local Occlusion = {}
							Occlusion.start = Hitpos
							Occlusion.endpos = Hitat + (Hitat-Hitpos):GetNormalized()*100
							Occlusion.filter = OccFilter
							Occlusion.mask = MASK_SOLID
						Occ = util.TraceLine( Occlusion )	
					end
					
					if ( Occ.Hit and Occ.Entity:EntIndex() != Tar.Entity:EntIndex() ) then 
						--print(Occ.Entity)
					elseif ( !Occ.Hit and Hitpos != Hitat ) then
						--print("No Hit")
						--print(Tar.Entity)
						--print((Hitpos - Hitat):Length())
					else
						Targets[i] = nil								--Remove the thing we just hit from the table so we don't hit it again in the next round
						local Table = {}
							Table.Ent = Tar.Entity
							Table.Dist = Hitpos:Distance(Hitat)
							Table.Vec = (Tar.Entity:GetPos() - Hitpos):GetNormal()
							Table.Aera = math.min((Tar.ACF.MaxHealth*ACF.Threshold)/math.max(4 * 3.1415 * (Table.Dist*2.54 )^2,1 ),0.5)
						table.insert(Damage, Table)						--Add it to the Damage table so we know to damage it once we tallied everything
						TotalAera = TotalAera + Table.Aera
					end
				else
					Targets[i] = nil											--Target was invalid, so let's ignore it
					table.insert( OccFilter , Tar.Entity )
				end	
			end
		end
		
		for i,Table in pairs(Damage) do
			
			local Tar = Table.Ent
			local AeraFraction = Table.Aera/TotalAera
			local PowerFraction = Power * AeraFraction										--How much of the total power goes to that prop
			
			local Blast = {}
				Blast.Momentum = PowerFraction/(math.max(1,Table.Dist/200)^0.05)
				Blast.Penetration = 0.1
			local BlastRes = ACF_Damage ( Tar.Entity , Blast , Tar.ACF.MaxHealth , 0 , Inflictor )--Vel is just the speed of sound in air
			PowerSpent = PowerSpent + PowerFraction*BlastRes.Loss/2--Removing the energy spent killing props
			
			--print("Momentum = "..Blast.Momentum)
			--print(PowerSpent)
			local FragHit = Fragments * AeraFraction
			local FragVel = math.max(FragVel - ( (Table.Dist/FragVel) * FragVel^2 * FragWeight^0.33/10000 )/ACF.DragDiv,0)
			local FragKE = ACF_Kinetic( FragVel , FragWeight, 1500 )
			if FragHit < 0 then 
				if math.Rand(0,1) > FragHit then FragHit = 1 else FragHit = 0 end
			end
			
			local FragRes = ACF_Damage ( Tar.Entity , FragKE , (FragWeight/7.8)^0.33*FragHit , 0 , Inflictor )
			
			if BlastRes.Kill or FragRes.Kill then
				local Debris = ACF_HEKill( Tar.Entity , Table.Vec , PowerFraction )
				table.insert( OccFilter , Debris )						--Add the debris created to the ignore so we don't hit it in other rounds
				LoopKill = true
			else
				local phys = Tar.Entity:GetPhysicsObject() 
				if (phys:IsValid()) then 
					phys:ApplyForceOffset( Table.Vec * PowerFraction / Tar.Entity:GetPhysicsObject():GetMass() ,  Vector(0,0,2) )	
				end
			end
			
		end
		Power = math.max(Power - PowerSpent,0)	
	end
		
end

function ACF_Spall( HitPos , HitVec , HitMask , KE , Caliber , Armour , Inflictor )
	
	local TotalWeight = 3.1416*(Caliber/2)^2 * Armour * 0.00079
	local Spall = math.max(math.floor(Caliber*ACF.KEtoSpall),2)
	local SpallWeight = TotalWeight/Spall
	local SpallVel = (KE*2000/SpallWeight)^0.5/Spall
	local SpallAera = (SpallWeight/7.8)^0.33 
	local SpallEnergy = ACF_Kinetic( SpallVel , SpallWeight, ACF.RoundTypes["AP"]["limitvel"] )
	
	for i = 1,Spall do
		local SpallTr = { }
			SpallTr.start = HitPos
			SpallTr.endpos = HitPos + (HitVec:GetNormalized()+VectorRand()/2):GetNormalized()*SpallVel
			SpallTr.filter = HitMask

			ACF_SpallTrace( HitVec , SpallTr , SpallEnergy , SpallAera , Inflictor )
	end

end

function ACF_SpallTrace( HitVec , SpallTr , SpallEnergy , SpallAera , Inflictor )

	local SpallRes = util.TraceLine(SpallTr)
	
	if SpallRes.Hit and ACF_Check( SpallRes.Entity ) then
	
		local Angle = ACF_GetHitAngle( SpallRes.HitNormal , HitVec )
		local HitRes = ACF_Damage( SpallRes.Entity , SpallEnergy , SpallAera , Angle , Inflictor )  --DAMAGE !!
		if HitRes.Kill then
			ACF_APKill( SpallRes.Entity , HitVec:GetNormalized() , SpallEnergy.Kinetic )
		end	
		if HitRes.Overkill > 0 then
			table.insert( SpallTr.filter , Target )					--"Penetrate" (Ingoring the prop for the retry trace)
			SpallEnergy.Penetration = SpallEnergy.Penetration*(1-HitRes.Loss)
			SpallEnergy.Momentum = SpallEnergy.Momentum*(1-HitRes.Loss)
			ACF_SpallTrace( HitVec , SpallTr , SpallEnergy , SpallAera , Inflictor )
		end
		
	end
	
end

function ACF_HEKill( Entity , HitVector , Energy )

	constraint.RemoveAll( Entity )
	Entity:Remove()
	
	local Debris = ents.Create( "Debris" )
		Debris:SetModel( Entity:GetModel() )
		Debris:SetAngles( Entity:GetAngles() )
		Debris:SetPos( Entity:GetPos() )
		Debris:SetMaterial("models/props_wasteland/metal_tram001a")
		Debris:Spawn()
		Debris:Ignite(60,0)
		Debris:Activate()

	local phys = Debris:GetPhysicsObject() 
	if (phys:IsValid()) then
		phys:ApplyForceOffset( HitVector:GetNormal() * Energy * 1000 / Debris:GetPhysicsObject():GetMass() , Vector(0,0,100) ) 	
	end

	return Debris
	
end

function ACF_APKill( Entity , HitVector , Power )

	constraint.RemoveAll( Entity )
	Entity:Remove()

	local Debris = ents.Create( "Debris" )
		Debris:SetModel( Entity:GetModel() )
		Debris:SetAngles( Entity:GetAngles() )
		Debris:SetPos( Entity:GetPos() )
		Debris:SetMaterial(Entity:GetMaterial())
		Debris:SetColor(120,120,120,255)
		Debris:Spawn()
		Debris:Activate()
		
	local BreakEffect = EffectData()				
		BreakEffect:SetOrigin( Entity:GetPos() )
		BreakEffect:SetScale( 20 )
	util.Effect( "WheelDust", BreakEffect )	
		
	local phys = Debris:GetPhysicsObject() 
	if (phys:IsValid()) then	
		phys:ApplyForceOffset( HitVector:GetNormal() * 1000 * Power ,  Vector(0,0,100) )	
	end

	return Debris
	
end

function ACF_AmmoExplosion( Origin , Pos )

	local HEWeight = Origin.BulletData["BoomPower"]*Origin.Ammo/2
	local LastHE = 0
	local Power = HEWeight * ACF.HEPower					--Power in KiloJoules of the filler mass of  TNT 
	local Radius = (HEWeight)^0.33*8*39.37				--Scalling law found on the net, based on 1PSI overpressure from 1 kg of TNT at 15m
	local Search = true
	local Filter = {Origin}
	Origin.IsExplosive = false
	Origin.Exploding = true
	Origin:Remove()
	
	while Search do
		for key,Found in pairs(ents.FindInSphere(Pos, Radius)) do
			if Found.IsExplosive and not Found.Exploding then	
				local Hitat = Found:NearestPoint( Pos )
				
				local Occlusion = {}
					Occlusion.start = Pos
					Occlusion.endpos = Hitat
					Occlusion.filter = Filter
				local Occ = util.TraceLine( Occlusion )
				
				if ( Occ.Fraction == 0 ) then
					table.insert(Filter,Occ.Entity)
					local Occlusion = {}
						Occlusion.start = Pos
						Occlusion.endpos = Hitat
						Occlusion.filter = Filter
					Occ = util.TraceLine( Occlusion )
					--print("Ignoring nested prop")
				end
					
				if ( Occ.Hit and Occ.Entity:EntIndex() != Found.Entity:EntIndex() ) then 
						--Msg("Target Occluded\n")
				else
					local FoundHE = Found.BulletData["BoomPower"]*Found.Ammo
					--Msg("Adding " ..FoundAmmo.. " to the blast\n")
					HEWeight = HEWeight + FoundHE
					--Msg("Boom = " ..BoomPower.. "\n")
					Found.IsExplosive = false
					Found.DamageAction = false
					Found.KillAction = false
					Found.Exploding = true
					table.insert(Filter,Found)
					Found:Remove()
					
				end			
			end
		end	
		
		if HEWeight > LastHE then
			Search = true
			LastHE = HEWeight
			Radius = (HEWeight)^0.33*8*39.37
		else
			Search = false
		end
		
	end	
	
	ACF_HE( Pos , Vector(0,0,1) , HEWeight , HEWeight*0.5 , Origin , Origin )
	
	local Flash = EffectData()
		Flash:SetOrigin( Pos )
		Flash:SetNormal( Vector(0,0,-1) )
		Flash:SetScale( math.max( Radius/200, 1 ) )									--Scale of the particles
		Flash:SetRadius( math.max( Radius/50, 1 ) )								--Radius of the smoke
	util.Effect( "ACF_Scaled_Explosion", Flash )

end

function ACF_GetHitAngle( HitNormal , HitVector )
	
	HitVector = HitVector*-1
	local Angle = math.min(math.deg(math.acos(HitNormal:Dot( HitVector:GetNormal() ) ) ),89.999 )
	--Msg("Angle : " ..Angle.. "\n")
	return Angle
	
end
