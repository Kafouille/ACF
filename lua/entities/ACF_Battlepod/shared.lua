ENT.Type 		= "vehicle"
ENT.Base 		= "base_anim"
ENT.PrintName 		= "BattlePod"
ENT.Author 		= "Kafouille"
ENT.Information 	= "Battle Pod"
ENT.Spawnable 		= true
ENT.AdminSpawnable 	= false

function ENT:GetDriver( )

	return self:GetOwner()

end

function ENT:CalcView( pl, origin, angles, fov )

	local viewentity = ( SERVER ) && pl:GetViewEntity() || GetViewEntity()
	if ( !ValidEntity( viewentity ) || viewentity:GetClass() != "acf_battlepod_avatar" ) then return end

	local ang = pl:GetAimVector():Angle()
	local Head = viewentity:LookupAttachment("eyes")
	local AngPos = viewentity:GetAttachment(Head)
	
	local view = {
		origin = AngPos.Pos,
		angles = ang,
		fov = 90,
	}
	return view

end


