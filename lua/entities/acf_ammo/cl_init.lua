include("shared.lua")

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DoNormalDraw()
    Wire_Render(self.Entity)
	
	if self.RefillAmmoEffect then
		self:DrawRefillAmmo()
	end
	
end

function ENT:DrawRefillAmmo()
	for k,v in pairs( self.RefillAmmoEffect ) do
		local Time = SysTime() - v.StTime
		local Pos = (v.EntTo:GetPos() - v.EntFrom:GetPos()) * (Time/5) + v.EntFrom:GetPos()
		local Dir = (v.EntTo:GetPos() - v.EntFrom:GetPos()):GetAngle()
		for i=0,v.Amount do
			cam.Start3D2D(Pos, Dir, 1)
				surface.SetDrawColor( Color( 0, 0, 0 ) )
				surface.DrawRect( -5, -5, 10, 10 )
			cam.End3D2D()
		end
	end
end

function ENT:DoNormalDraw()
	local e = self.Entity
	if (LocalPlayer():GetEyeTrace().Entity == e and EyePos():Distance(e:GetPos()) < 256) then
		local Tracer = ""
		if self:GetNetworkedInt("Tracer") > 0 then Tracer = "-T" end
		local txt = self:GetNetworkedString("AmmoID").." : " ..self:GetNetworkedString("Ammo").. "\nRound Type : "..self:GetNetworkedString("AmmoType")..Tracer.."\n"
		self.AmmoString = ACF.RoundTypes[self:GetNetworkedString("AmmoType")]["cratetxt"] or ""
		local Ammotxt = self:AmmoString()
		if (not game.SinglePlayer()) then
			local PlayerName = self:GetPlayerName()
			txt = txt .."".. Ammotxt .. "\n(" .. PlayerName .. ")"
		end
		AddWorldTip(e:EntIndex(),txt,0.5,e:GetPos(),e)
	end
	e:DrawModel()
end

function ENT:AmmoString()

	return ""
end

function ENT:Think()
	if (CurTime() >= (self.NextRBUpdate or 0)) then
	    self.NextRBUpdate = CurTime() + math.random(30,100)/10 --update renderbounds every 3 to 10 seconds
		Wire_UpdateRenderBounds(self.Entity)
	end
end

net.Receive("ACF_RefillEffect", function()
	local Amount, EntFrom, EntTo = net.ReadFloat(), ents.GetByIndex( net.ReadFloat() ), ents.GetByIndex( net.ReadFloat() )
	if not IsValid( EntFrom ) or not IsValid( EntTo ) then return end
	ENT.RefillAmmoEffect = ENT.RefillAmmoEffect or {}
	table.insert( ENT.RefillAmmoEffect, {Amount = Amount,EntFrom = EntFrom, EntTo = EntTo,StTime = SysTime()} )
	
end)