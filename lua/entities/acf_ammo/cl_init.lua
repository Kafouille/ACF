include("shared.lua")

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

/*-------------------------------------
Shamefully stolen from lua rollercoaster. I'M SO SORRY. I HAD TO.
-------------------------------------*/

local function Bezier( a, b, c, d, t )
	local ab,bc,cd,abbc,bccd 
	
	ab = LerpVector(t, a, b)
	bc = LerpVector(t, b, c)
	cd = LerpVector(t, c, d)
	abbc = LerpVector(t, ab, bc)
	bccd = LerpVector(t, bc, cd)
	dest = LerpVector(t, abbc, bccd)
	
	return dest
end


local function BezPoint(perc, Table)
	perc = perc or self.Perc
	
	local vec = Vector(0, 0, 0)
	
	vec = Bezier(Table[1], Table[2], Table[3], Table[4], perc)
	
    return vec
end

-----------------------------------

function ENT:Draw()
	self:DoNormalDraw()
    Wire_Render(self)	
	if self.RefillAmmoEffect then
		ACF_DrawRefillAmmo( self.RefillAmmoEffect )
	end
end

local nullcrate = {cratetxt = function() return "" end}

function ENT:DoNormalDraw()
	local e = self
	if (LocalPlayer():GetEyeTrace().Entity == e and EyePos():Distance(e:GetPos()) < 256) then
		local Tracer = ""
		if self:GetNetworkedInt("Tracer") > 0 then Tracer = "-T" end
		local txt = self:GetNetworkedString("AmmoID").." : " ..self:GetNetworkedString("Ammo").. "\nRound Type : "..self:GetNetworkedString("AmmoType")..Tracer.."\n"
		local atype = self:GetNetworkedString("AmmoType")
		self.AmmoString = (ACF.RoundTypes[atype] or nullcrate)["cratetxt"](self)
		local Ammotxt = self:GetAmmoString()
		if (not game.SinglePlayer()) then
			local PlayerName = self:GetPlayerName()
			txt = txt .."".. Ammotxt .. "\n(" .. PlayerName .. ")"
		end
		AddWorldTip(e:EntIndex(),txt,0.5,e:GetPos(),e)
	end
	e:DrawModel()
end

function ENT:GetAmmoString()

	return self.AmmoString or ""
end


function ACF_DrawRefillAmmo( Table )
	for k,v in pairs( Table ) do
		local St, En = v.EntFrom:LocalToWorld(v.EntFrom:OBBCenter()), v.EntTo:LocalToWorld(v.EntTo:OBBCenter())
		local Distance = (En - St):Length()
		local Amount = math.Clamp((Distance/50),2,100)
		local Time = (SysTime() - v.StTime)
		local En2, St2 = En + Vector(0,0,100), St + ((En-St):GetNormalized() * 10)
		local vectab = { St, St2, En2, En}
		local center = (St+En)/2
		for I = 1, Amount do
			local point = BezPoint(((((I+Time)%Amount))/Amount), vectab)
			local ang = (point - center):Angle()
			local MdlTbl = {
				model = v.Model,
				pos = point,
				angle = ang
			}
			render.Model( MdlTbl )
		end
	end
end

function ENT:Think()
	if (CurTime() >= (self.NextRBUpdate or 0)) then
	    self.NextRBUpdate = CurTime() + math.random(30,100)/10 --update renderbounds every 3 to 10 seconds
		Wire_UpdateRenderBounds(self)
	end
end

usermessage.Hook("ACF_RefillEffect", function( msg )
	local EntFrom, EntTo, Weapon = ents.GetByIndex( msg:ReadFloat() ), ents.GetByIndex( msg:ReadFloat() ), msg:ReadString()
	if not IsValid( EntFrom ) or not IsValid( EntTo ) then return end
	//local List = list.Get( "ACFRoundTypes")	
	local Mdl = ACF.Weapons.Guns[Weapon].round.model or "models/munitions/round_100mm_shot.mdl"
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