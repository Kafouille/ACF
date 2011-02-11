include("shared.lua")

ENT.RenderGroup 		= RENDERGROUP_OPAQUE

ENT.AutomaticFrameAdvance = true 

function ENT:Draw()
	self:DoNormalDraw()
	self:DrawModel()
    Wire_Render(self.Entity)
end

function ENT:Initialize()

	self.LastFire = 0
	self.Reload = 1
	self.CloseTime = 1
	self.Rate = 1
	self.RateScale = 1
	self.FireAnim = self:LookupSequence( "shoot" )
	self.CloseAnim = self:LookupSequence( "load" )

end

function ENT:DoNormalDraw()
	local e = self.Entity
	if (LocalPlayer():GetEyeTrace().Entity == e and EyePos():Distance(e:GetPos()) < 256) then
		if(self:GetOverlayText() ~= "") then
			AddWorldTip(e:EntIndex(),self:GetOverlayText(),0.5,e:GetPos(),e)
		end
	end
end

function ENT:Think()
	if (CurTime() >= (self.NextRBUpdate or 0)) then
	    self.NextRBUpdate = CurTime() + math.random(30,100)/10 --update renderbounds every 3 to 10 seconds
		Wire_UpdateRenderBounds(self.Entity)
	end
		
	local SinceFire = (CurTime() - self.LastFire)
	self:SetCycle( SinceFire*self.Rate/self.RateScale )
	if CurTime() > self.LastFire + self.CloseTime and self.CloseAnim then
		self:ResetSequence( self.CloseAnim )
		local RateScale = self:SequenceDuration()
		self:SetCycle( (SinceFire - self.CloseTime)*self.Rate/self.RateScale )
		self.Rate = 1/(self.Reload - self.CloseTime)	--Base anim time is 1s, rate is in 1/10 of a second
		self:SetPlaybackRate( self.Rate )
	end
	
	self.Entity:NextThink(CurTime())
	return true
end

function ENT:Animate( Class, ReloadTime )
	
	if self.CloseAnim and self.CloseAnim > 0 then
		self.CloseTime = math.max(ReloadTime-0.75,ReloadTime*0.75)
	else
		self.CloseTime = ReloadTime
		self.CloseAnim = nil
	end
	
	self:ResetSequence( self.FireAnim )
	self:SetCycle( 0 )
	self.RateScale = self:SequenceDuration()
	self.Rate = 1/math.Clamp(self.CloseTime,0.1,1.5)	--Base anim time is 1s, rate is in 1/10 of a second
	self:SetPlaybackRate( self.Rate )
	self.LastFire = CurTime()
	self.Reload = ReloadTime

	self:EmitSound(ACF.Classes["GunClass"][Class]["sound"],500,50)
	
end

function ACFGunGUICreate( Table )
		
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
	
	acfmenupanel.CData.Caliber = vgui.Create( "DLabel" )
		acfmenupanel.CData.Caliber:SetText( "Caliber : "..(Table.caliber*10).."mm" )
		acfmenupanel.CData.Caliber:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.Caliber )
	
	acfmenupanel.CData.Weight = vgui.Create( "DLabel" )
		acfmenupanel.CData.Weight:SetText( "Weight : "..Table.weight.."kg" )
		acfmenupanel.CData.Weight:SizeToContents()
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.Weight )
	
	acfmenupanel.CustomDisplay:PerformLayout()
	
end

