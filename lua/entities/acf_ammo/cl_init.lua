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
		local St, En = v.EntFrom:LocalToWorld(v.EntFrom:OBBCenter()), v.EntTo:LocalToWorld(v.EntTo:OBBCenter())
		local Vec = En - St
		local Distance = Vec:Length()
		local Ang = Vec:Angle()
		local Amount = math.Clamp((Distance/50),2,100)
		local Time = (SysTime() - v.StTime)
		for I = 1, Amount do
			local MdlTbl = {
				model = v.Model,
				pos = Vec * ((((I+Time)%Amount))/Amount) + St,
				angle = Ang
			}
			render.Model( MdlTbl )
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

usermessage.Hook("ACF_RefillEffect", function( msg )
	local EntFrom, EntTo, Index = ents.GetByIndex( msg:ReadFloat() ), ents.GetByIndex( msg:ReadFloat() ), msg:ReadString()
	if not IsValid( EntFrom ) or not IsValid( EntTo ) then return end
	local List = list.Get( "ACFRoundTypes")
	local Mdl = List[Index].model or "models/munitions/round_100mm_shot.mdl"

	EntFrom.RefillAmmoEffect = EntFrom.RefillAmmoEffect or {}
	table.insert( EntFrom.RefillAmmoEffect, {EntFrom = EntFrom, EntTo = EntTo, Model = Mdl, StTime = SysTime()} )

end)
usermessage.Hook("ACF_StopRefillEffect", function( msg )
	local EntFrom, EntTo = ents.GetByIndex( msg:ReadFloat() ), ents.GetByIndex( msg:ReadFloat() )
	if not IsValid( EntFrom ) or not IsValid( EntTo )or not EntFrom.RefillAmmoEffect then return end
	for k,v in pairs( EntFrom.RefillAmmoEffect ) do
		if v.EntTo == EntTo then
			if #EntFrom.RefillAmmoEffect<=1 then 
				EntFrom.RefillAmmoEffect = nil
				return
			end
			table.remove(EntFrom.RefillAmmoEffect, k)
		end
	end
end)