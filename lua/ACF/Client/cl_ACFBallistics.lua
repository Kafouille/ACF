ACF.BulletEffect = {}

function ACF_ManageBulletEffects()
	
	for Index,Bullet in pairs(ACF.BulletEffect) do
		ACF_SimBulletFlight( Bullet, Index )			--This is the bullet entry in the table, the omnipresent Index var refers to this
	end
	
end
hook.Add("Think", "ACF_ManageBulletEffects", ACF_ManageBulletEffects)

function ACF_SimBulletFlight( Bullet, Index )

	local Time = CurTime()
	local DeltaTime = Time - Bullet.LastThink
	
	local Drag = Bullet.SimFlight:GetNormalized() * (Bullet.DragCoef * Bullet.SimFlight:Length()^2)/ACF.DragDiv
	--print(Drag)

	Bullet.SimPos = Bullet.SimPos + (Bullet.SimFlight * ACF.VelScale * DeltaTime)		--Calculates the next shell position
	Bullet.SimFlight = Bullet.SimFlight + (Bullet.Accel * ACF.VelScale - Drag)*DeltaTime			--Calculates the next shell vector
	
	if Bullet and Bullet.Effect:IsValid() then
		Bullet.Effect:ApplyMovement( Bullet )
	end
	Bullet.LastThink = Time
	
end
