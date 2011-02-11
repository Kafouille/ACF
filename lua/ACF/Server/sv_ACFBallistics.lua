ACF.Bullet = {}
ACF.CurBulletIndex = 0
ACF.BulletIndexLimt = 1000  --The maximum number of bullets in flight at any one time

function ACF_CreateBullet( BulletData )
	
	ACF.CurBulletIndex = ACF.CurBulletIndex + 1		--Increment the index
	if ACF.CurBulletIndex > ACF.BulletIndexLimt then
		ACF.CurBulletIndex = 1
	end
	
	BulletData["Accel"] = Vector(0,0,server_settings.Int( "sv_gravity", 600 )*-1)			--Those are BulletData settings that are global and shouldn't change round to round
	BulletData["LastThink"] = CurTime() - 0.015
	BulletData["Filter"] = { BulletData["Gun"] }
	BulletData["Index"] = ACF.CurBulletIndex
		
	ACF.Bullet[ACF.CurBulletIndex] = table.Copy(BulletData)		--Place the bullet at the current index pos
	ACF_BulletClient( ACF.CurBulletIndex, ACF.Bullet[ACF.CurBulletIndex], "Init" , 0 )
	ACF_CalcBulletFlight( ACF.CurBulletIndex, ACF.Bullet[ACF.CurBulletIndex] )
	
end

function ACF_ManageBullets()

	for Index,Bullet in pairs(ACF.Bullet) do
		ACF_CalcBulletFlight( Index, Bullet )			--This is the bullet entry in the table, the Index var omnipresent refers to this
	end
	
end
hook.Add("Think", "ACF_ManageBullets", ACF_ManageBullets)

function ACF_RemoveBullet( Index )
	
	ACF.Bullet[Index] = nil

end

function ACF_CalcBulletFlight( Index, Bullet )
	--print("Bullet CalcFlight")
	
	if not Bullet.LastThink then ACF_RemoveBullet( Index ) return end
	local Time = CurTime()
	local DeltaTime = Time - Bullet.LastThink
	Bullet.LastThink = Time
	
	local Drag = Bullet.Flight:GetNormalized() * (Bullet.DragCoef * (Bullet.Flight:Length())^2)/ACF.DragDiv
	Bullet.NextPos = Bullet.Pos + (Bullet.Flight * ACF.VelScale * DeltaTime)		--Calculates the next shell position
	Bullet.Flight = Bullet.Flight + (Bullet.Accel * ACF.VelScale - Drag)*DeltaTime				--Calculates the next shell vector
	
	ACF_DoBulletsFlight( Index, Bullet )
	
end

function ACF_DoBulletsFlight( Index, Bullet )

	local FlightTr = { }
		FlightTr.start = Bullet.Pos
		FlightTr.endpos = Bullet.NextPos
		FlightTr.filter = Bullet.Filter
	local FlightRes = util.TraceLine(FlightTr)					--Trace to see if it will hit anything
	
	if FlightRes.HitNonWorld then
		ACF_BulletPropImpact = ACF.RoundTypes[Bullet.Type]["propimpact"]		
		local Retry = ACF_BulletPropImpact( Index, Bullet, FlightRes.Entity , FlightRes.HitNormal , FlightRes.HitPos )				--If we hit stuff then send the resolution to the damage function	
		if Retry == "Penetrated" then												--If we should do the same trace again, then do so
			ACF_DoBulletsFlight( Index, Bullet )
			--Msg("Retrying\n")
		elseif Retry == "Ricochet"  then
			ACF_CalcBulletFlight( Index, Bullet )
		else						--Else end the flight here
			ACF_BulletEndFlight = ACF.RoundTypes[Bullet.Type]["endflight"]
			ACF_BulletEndFlight( Index, Bullet, FlightRes.HitPos, FlightRes.HitNormal )	
		end
	elseif FlightRes.HitWorld then									--If we hit the world then try to see if it's thin enough to penetrate
		ACF_BulletWorldImpact = ACF.RoundTypes[Bullet.Type]["worldimpact"]
		ACF_BulletWorldImpact( Index, Bullet, FlightRes.HitPos, FlightRes.HitNormal )
	else															--If we didn't hit anything, move the shell and schedule next think
		Bullet.Pos = Bullet.NextPos
	end
	
end

function ACF_BulletClient( Index, Bullet, Type, Hit, HitPos )

	if Type == "Update" then
		local Effect = EffectData()
			Effect:SetAttachment( Index )		--Bulet Index
			Effect:SetStart( Bullet.Flight/10 )	--Bullet Direction
			if Hit > 0 then		-- If there is a hit then set the effect pos to the impact pos instead of the retry pos
				Effect:SetOrigin( HitPos )		--Bullet Pos
			else
				Effect:SetOrigin( Bullet.Pos )
			end
			Effect:SetScale( Hit )	--Hit Type 
		util.Effect( "ACF_BulletEffect", Effect )

	else
		local Effect = EffectData()
			local Filler = 0
			if Bullet["FillerMass"] then Filler = Bullet["FillerMass"]*15 end
			Effect:SetAttachment( Index )		--Bulet Index
			Effect:SetStart( Bullet.Flight/10 )	--Bullet Direction
			Effect:SetOrigin( Bullet.Pos )
			Effect:SetMagnitude( Bullet["Crate"] ) --Encodes the crate the ammo originates from so clientside knows the crate from wich to pull ammo data
			Effect:SetScale( 0 )
		util.Effect( "ACF_BulletEffect", Effect )

	end

end

function ACF_BulletWorldImpact( Bullet, Index, HitPos, HitNormal )
	--You overwrite this with your own function, defined in the ammo definition file
end

function ACF_BulletPropImpact( Bullet, Index, Target, HitNormal, HitPos )
	--You overwrite this with your own function, defined in the ammo definition file
end

function ACF_BulletEndFlight( Bullet, Index, HitPos )
	--You overwrite this with your own function, defined in the ammo definition file
end

