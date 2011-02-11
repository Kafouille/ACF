TOOL.Category		= "Construction"
TOOL.Name			= "Particle Tester (Pairs are ofsets, odds are world pos"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar[ "name" ] = "Rocket Motor"
TOOL.ClientConVar[ "CP1X" ] = "0"
TOOL.ClientConVar[ "CP1Y" ] = "0"
TOOL.ClientConVar[ "CP1Z" ] = "0"

TOOL.ClientConVar[ "CP2X" ] = "0"
TOOL.ClientConVar[ "CP2Y" ] = "0"
TOOL.ClientConVar[ "CP2Z" ] = "0"

TOOL.ClientConVar[ "CP3X" ] = "0"
TOOL.ClientConVar[ "CP3Y" ] = "0"
TOOL.ClientConVar[ "CP3Z" ] = "0"

TOOL.ClientConVar[ "CP4X" ] = "0"
TOOL.ClientConVar[ "CP4Y" ] = "0"
TOOL.ClientConVar[ "CP4Z" ] = "0"

TOOL.ClientConVar[ "CP5X" ] = "0"
TOOL.ClientConVar[ "CP5Y" ] = "0"
TOOL.ClientConVar[ "CP5Z" ] = "0"

TOOL.ClientConVar[ "CP6X" ] = "0"
TOOL.ClientConVar[ "CP6Y" ] = "0"
TOOL.ClientConVar[ "CP6Z" ] = "0"

TOOL.ClientConVar[ "CP7X" ] = "0"
TOOL.ClientConVar[ "CP7Y" ] = "0"
TOOL.ClientConVar[ "CP7Z" ] = "0"

TOOL.ClientConVar[ "CP8X" ] = "0"
TOOL.ClientConVar[ "CP8Y" ] = "0"
TOOL.ClientConVar[ "CP8Z" ] = "0"

TOOL.ClientConVar[ "CP9X" ] = "0"
TOOL.ClientConVar[ "CP9Y" ] = "0"
TOOL.ClientConVar[ "CP9Z" ] = "0"

function TOOL:LeftClick( trace )

	if (CLIENT) then return true end

	if ( !trace.Entity:IsValid() && !trace.Entity:IsWorld() ) then return false end
	
	local ply = self:GetOwner()
	local Name = self:GetClientInfo( "name" )
	self.CP1P = Vector(self:GetClientInfo( "CP1X" ),self:GetClientInfo( "CP1Y" ),self:GetClientInfo( "CP1Z" ))
	self.CP2P = Vector(self:GetClientInfo( "CP2X" ),self:GetClientInfo( "CP2Y" ),self:GetClientInfo( "CP2Z" ))
	self.CP3P = Vector(self:GetClientInfo( "CP3X" ),self:GetClientInfo( "CP3Y" ),self:GetClientInfo( "CP3Z" ))
	self.CP4P = Vector(self:GetClientInfo( "CP4X" ),self:GetClientInfo( "CP4Y" ),self:GetClientInfo( "CP4Z" ))
	self.CP5P = Vector(self:GetClientInfo( "CP5X" ),self:GetClientInfo( "CP5Y" ),self:GetClientInfo( "CP5Z" ))
	self.CP6P = Vector(self:GetClientInfo( "CP6X" ),self:GetClientInfo( "CP6Y" ),self:GetClientInfo( "CP6Z" ))
	self.CP7P = Vector(self:GetClientInfo( "CP7X" ),self:GetClientInfo( "CP7Y" ),self:GetClientInfo( "CP7Z" ))
	self.CP8P = Vector(self:GetClientInfo( "CP8X" ),self:GetClientInfo( "CP8Y" ),self:GetClientInfo( "CP8Z" ))
	self.CP9P = Vector(self:GetClientInfo( "CP9X" ),self:GetClientInfo( "CP9Y" ),self:GetClientInfo( "CP9Z" ))

	PrecacheParticleSystem( Name )
	
	self.CP1 = ents.Create( "info_particle_system" )
	self.CP1:SetKeyValue( "effect_name", Name)
	self.CP1:SetPos(self.CP1P)
	self.CP1:SetKeyValue( "targetname", Name.."CP1")
	self.CP1:Spawn()
	
	self.CP2 = ents.Create( "info_particle_system" )
	self.CP2:SetKeyValue( "effect_name", Name)
	self.CP2:SetPos(trace.HitPos + self.CP2P)
	self.CP2:SetKeyValue( "targetname", Name.."CP2")
	self.CP2:Spawn()
	
	self.CP3 = ents.Create( "info_particle_system" )
	self.CP3:SetKeyValue( "effect_name", Name)
	self.CP3:SetPos(self.CP3P)
	self.CP3:SetKeyValue( "targetname", Name.."CP3")
	self.CP3:Spawn()
	self.CP3:Activate()
	
	self.CP4 = ents.Create( "info_particle_system" )
	self.CP4:SetKeyValue( "effect_name", Name)
	self.CP4:SetPos(trace.HitPos + self.CP4P)
	self.CP4:SetKeyValue( "targetname", Name.."CP4")
	self.CP4:Spawn()
	self.CP4:Activate()
	
	self.CP5 = ents.Create( "info_particle_system" )
	self.CP5:SetKeyValue( "effect_name", Name)
	self.CP5:SetPos(self.CP5P)
	self.CP5:SetKeyValue( "targetname", Name.."CP5")
	self.CP5:Spawn()
	self.CP5:Activate()
	
	self.CP6 = ents.Create( "info_particle_system" )
	self.CP6:SetKeyValue( "effect_name", Name)
	self.CP6:SetPos(trace.HitPos + self.CP6P)
	self.CP6:SetKeyValue( "targetname", Name.."CP6")
	self.CP6:Spawn()
	self.CP6:Activate()
	
	self.CP7 = ents.Create( "info_particle_system" )
	self.CP7:SetKeyValue( "effect_name", Name)
	self.CP7:SetPos(self.CP7P)
	self.CP7:SetKeyValue( "targetname", Name.."CP7")
	self.CP7:Spawn()
	self.CP7:Activate()
	
	self.CP8 = ents.Create( "info_particle_system" )
	self.CP8:SetKeyValue( "effect_name", Name)
	self.CP8:SetPos(trace.HitPos + self.CP8P)
	self.CP8:SetKeyValue( "targetname", Name.."CP8")
	self.CP8:Spawn()
	self.CP8:Activate()
	
	self.CP9 = ents.Create( "info_particle_system" )
	self.CP9:SetKeyValue( "effect_name", Name)
	self.CP9:SetPos(self.CP9P)
	self.CP9:SetKeyValue( "targetname", Name.."CP9")
	self.CP9:Spawn()
	self.CP9:Activate()
	
	self.Effect = ents.Create( "info_particle_system" )
	self.Effect:SetPos(trace.HitPos)
	self.Effect:SetAngles(trace.HitNormal:Angle())
	self.Effect:SetKeyValue( "effect_name", Name)
	self.Effect:SetKeyValue( "targetname", Name.."Start")
	self.Effect:SetKeyValue( "start_active", "1")
	self.Effect:SetKeyValue( "cpoint1", Name.."CP1")
	self.Effect:SetKeyValue( "cpoint2", Name.."CP2")
	self.Effect:SetKeyValue( "cpoint3", Name.."CP3")
	self.Effect:SetKeyValue( "cpoint4", Name.."CP4")
	self.Effect:SetKeyValue( "cpoint5", Name.."CP5")
	self.Effect:SetKeyValue( "cpoint6", Name.."CP6")
	self.Effect:SetKeyValue( "cpoint7", Name.."CP7")
	self.Effect:SetKeyValue( "cpoint8", Name.."CP8")
	self.Effect:SetKeyValue( "cpoint9", Name.."CP9")
	self.Effect:Spawn()
	self.Effect:Activate()
	
end

function TOOL:Think()

	if self.Effect then
		if self:GetOwner():KeyDown(IN_ATTACK )then
			local trace = {}
				trace.start = self:GetOwner():GetShootPos()
				trace.endpos = self:GetOwner():GetShootPos() + ( self:GetOwner():GetAimVector() * 5000 )
				trace.filter = self:GetOwner()
			local tr = util.TraceLine( trace )
			self.Effect:SetPos(tr.HitPos)
			self.CP1:SetPos(self.CP1P)
			self.CP2:SetPos(tr.HitPos + self.CP2P)
			self.CP3:SetPos(self.CP3P)
			self.CP4:SetPos(tr.HitPos + self.CP4P)
			self.CP5:SetPos(self.CP5P)
			self.CP6:SetPos(tr.HitPos + self.CP6P)
			self.CP7:SetPos(self.CP7P)
			self.CP8:SetPos(tr.HitPos + self.CP8P)
			self.CP9:SetPos(self.CP9P)
		else
			self.Effect:Fire("Kill", "", 0)
			self.Effect = nil
			self.CP1:Fire("Kill", "", 0)
			self.CP1 = nil
			self.CP2:Fire("Kill", "", 0)
			self.CP2 = nil
			self.CP3:Fire("Kill", "", 0)
			self.CP3 = nil
			self.CP4:Fire("Kill", "", 0)
			self.CP4 = nil
			self.CP5:Fire("Kill", "", 0)
			self.CP5 = nil
			self.CP6:Fire("Kill", "", 0)
			self.CP6 = nil
			self.CP7:Fire("Kill", "", 0)
			self.CP7 = nil
			self.CP8:Fire("Kill", "", 0)
			self.CP8 = nil
			self.CP9:Fire("Kill", "", 0)
			self.CP9 = nil
		end
	end
	
	return true
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl("TextBox", {
		Label = "Name",
		MaxLength = 255,
		Text = "Enter the name here",
		Command = "particle_tester_name",
	}) 

	CPanel:NumSlider("CP1 X", "particle_tester_CP1X", -2000, 2000, 0)
	CPanel:NumSlider("CP1 Y", "particle_tester_CP1Y", -2000, 2000, 0)
	CPanel:NumSlider("CP1 Z", "particle_tester_CP1Z", -2000, 2000, 0)
	
	CPanel:NumSlider("CP2 X", "particle_tester_CP2X", -2000, 2000, 0)
	CPanel:NumSlider("CP2 Y", "particle_tester_CP2Y", -2000, 2000, 0)
	CPanel:NumSlider("CP2 Z", "particle_tester_CP2Z", -2000, 2000, 0)

	CPanel:NumSlider("CP3 X", "particle_tester_CP3X", -2000, 2000, 0)
	CPanel:NumSlider("CP3 Y", "particle_tester_CP3Y", -2000, 2000, 0)
	CPanel:NumSlider("CP3 Z", "particle_tester_CP3Z", -2000, 2000, 0)

	CPanel:NumSlider("CP4 X", "particle_tester_CP4X", -2000, 2000, 0)
	CPanel:NumSlider("CP4 Y", "particle_tester_CP4Y", -2000, 2000, 0)
	CPanel:NumSlider("CP4 Z", "particle_tester_CP4Z", -2000, 2000, 0)

	CPanel:NumSlider("CP5 X", "particle_tester_CP5X", -2000, 2000, 0)
	CPanel:NumSlider("CP5 Y", "particle_tester_CP5Y", -2000, 2000, 0)
	CPanel:NumSlider("CP5 Z", "particle_tester_CP5Z", -2000, 2000, 0)	
	
	CPanel:NumSlider("CP6 X", "particle_tester_CP6X", -2000, 2000, 0)
	CPanel:NumSlider("CP6 Y", "particle_tester_CP6Y", -2000, 2000, 0)
	CPanel:NumSlider("CP6 Z", "particle_tester_CP6Z", -2000, 2000, 0)	
	
	CPanel:NumSlider("CP7 X", "particle_tester_CP7X", -2000, 2000, 0)
	CPanel:NumSlider("CP7 Y", "particle_tester_CP7Y", -2000, 2000, 0)
	CPanel:NumSlider("CP7 Z", "particle_tester_CP7Z", -2000, 2000, 0)	
	
	CPanel:NumSlider("CP8 X", "particle_tester_CP8X", -2000, 2000, 0)
	CPanel:NumSlider("CP8 Y", "particle_tester_CP8Y", -2000, 2000, 0)
	CPanel:NumSlider("CP8 Z", "particle_tester_CP8Z", -2000, 2000, 0)	

	CPanel:NumSlider("CP9 X", "particle_tester_CP9X", -2000, 2000, 0)
	CPanel:NumSlider("CP9 Y", "particle_tester_CP9Y", -2000, 2000, 0)
	CPanel:NumSlider("CP9 Z", "particle_tester_CP9Z", -2000, 2000, 0)	
	
end
