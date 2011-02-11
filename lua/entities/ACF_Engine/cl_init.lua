include("shared.lua")

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.AutomaticFrameAdvance = true 

function ENT:Draw()
	self:DoNormalDraw()
	self:DrawModel()
    Wire_Render(self.Entity)
end

function ENT:DoNormalDraw()
	local e = self.Entity
	if (LocalPlayer():GetEyeTrace().Entity == e and EyePos():Distance(e:GetPos()) < 256) then
		if(self:GetOverlayText() ~= "") then
			AddWorldTip(e:EntIndex(),self:GetOverlayText(),0.5,e:GetPos(),e)
		end
	end
end


function ACFEngineGUICreate( Table )
		
	acfmenupanel.CData.Name = vgui.Create( "DLabel" )
		acfmenupanel.CData.Name:SetText( Table.name )
		acfmenupanel.CData.Name:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.Name )
	
	acfmenupanel.CData.DisplayModel = vgui.Create( "DModelPanel" )
		acfmenupanel.CData.DisplayModel:SetModel( Table.model )
		acfmenupanel.CData.DisplayModel:SetCamPos( Vector( 70 , 70 , 30 ) )
		acfmenupanel.CData.DisplayModel:SetLookAt( Vector( 0, 0, 0 ) )
		acfmenupanel.CData.DisplayModel:SetFOV( 90 )
		acfmenupanel.CData.DisplayModel:SetSize(acfmenupanel.WeaponDisplay:GetWide(),100)
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.DisplayModel )
	
	acfmenupanel.CData.Desc = vgui.Create( "DLabel" )
		acfmenupanel.CData.Desc:SetText( Table.desc )
		acfmenupanel.CData.Desc:SetSize(acfmenupanel.WeaponDisplay:GetWide(),100)
		acfmenupanel.CData.Desc:SizeToContentsY()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.Desc )
	
	acfmenupanel.CData.Weight = vgui.Create( "DLabel" )
		acfmenupanel.CData.Weight:SetText( "Weight : "..Table.weight.."kg" )
		acfmenupanel.CData.Weight:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.Weight )
	
	acfmenupanel.CustomDisplay:PerformLayout()
	
end

