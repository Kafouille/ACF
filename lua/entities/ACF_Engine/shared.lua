ENT.Type 			= "anim"
ENT.Base 			= "base_gmodentity"  
ENT.Author			= "Kafouille"
 
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

function ENT:GetOverlayText()
	local Ammo = self.Entity:GetNetworkedBeamInt("Power")
	local txt = Power or ""
	if (not SinglePlayer()) then
		local PlayerName = self:GetPlayerName()
		txt = txt .. "\n(" .. PlayerName .. ")"
	end
	if(name and name ~= "") then
	    if (txt == "") then
	        return "- "..name.." -"
	    end
	    return "- "..name.." -\n"..txt
	end
	return txt
end


