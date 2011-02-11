function PANEL:Init( )

	acfmenupanel = self.Panel
		
	// height
	self:SetTall( 1000 )

	//Weapon Select	
	
	self.WeaponSelect = vgui.Create( "DTree", self )

	self.Classes = ACF.Classes
	self.WeaponData = ACF.Weapons
	local Guns = self.WeaponSelect:AddNode( "Guns" )
	for ClassID,Class in pairs(self.Classes["GunClass"]) do
	
		local SubNode = Guns:AddNode( Class.name or "No Name" )
		
		for Type, Ent in pairs(self.WeaponData["Guns"]) do	
			if Ent.gunclass == ClassID then
				local EndNode = SubNode:AddNode( Ent.name or "No Name" )
				EndNode.mytable = Ent
				function EndNode:DoClick()
					RunConsoleCommand( "acfmenu_type", self.mytable.type )
					acfmenupanel:UpdateDisplay( self.mytable )
				end
				EndNode.Icon:SetImage( "gui/silkicons/newspaper" )
			end
		end
		
	end

	self.RoundAttribs = list.Get("ACFRoundTypes")
	local Ammo = self.WeaponSelect:AddNode( "Ammo" )
	for AmmoID,AmmoTable in pairs(self.RoundAttribs) do
		
		if AmmoTable.gunclass == ClassID then
			local EndNode = Ammo:AddNode( AmmoTable.name or "No Name" )
			EndNode.mytable = AmmoTable
			function EndNode:DoClick()
				RunConsoleCommand( "acfmenu_type", self.mytable.type )
				acfmenupanel:UpdateDisplay( self.mytable )
			end
			EndNode.Icon:SetImage( "gui/silkicons/newspaper" )
		end
		
	end
	
	-- local Engines = self.WeaponSelect:AddNode( "Engines" )
	-- for EngineID,EngineTable in pairs(self.WeaponData["Engines"]) do
		
		-- local EndNode = Engines:AddNode( EngineTable.name or "No Name" )
		-- EndNode.mytable = EngineTable
		-- function EndNode:DoClick()
			-- RunConsoleCommand( "acfmenu_type", self.mytable.type )
			-- acfmenupanel:UpdateDisplay( self.mytable )
		-- end
		-- EndNode.Icon:SetImage( "gui/silkicons/newspaper" )
		
	-- end
	
	self.WeaponDisplay = vgui.Create( "DPanelList", self )
	self.WeaponDisplay:SetSpacing( 5 )
	self.WeaponDisplay:EnableHorizontal( false ) 
	self.WeaponDisplay:EnableVerticalScrollbar( false ) 
			
	local DefaultTable = { self.WeaponData["Guns"] }
	--self:UpdateDisplay( DefaultTable )
	
end

/*------------------------------------
	Think
------------------------------------*/
function PANEL:Think( )

end

function PANEL:UpdateDisplay( Table )
	
	RunConsoleCommand( "acfmenu_id", Table.id or 0 )
	
	--If a previous display exists, erase it
	if ( self.CustomDisplay ) then
		self.CustomDisplay:Clear()
		self.WeaponDisplay:RemoveItem( self.CustomDisplay )
		self.CustomDisplay = nil
	end
	
	--Create the space to display the custom data
	acfmenupanel.CustomDisplay = vgui.Create( "DPanelList" )	
		acfmenupanel.CustomDisplay:SetSpacing( 5 )
		acfmenupanel.CustomDisplay:EnableHorizontal( false ) 
		acfmenupanel.CustomDisplay:EnableVerticalScrollbar( false ) 
		acfmenupanel.CustomDisplay:SetSize( acfmenupanel.WeaponDisplay:GetWide(), 650 )
	acfmenupanel.WeaponDisplay:AddItem( acfmenupanel.CustomDisplay )
	
	if not acfmenupanel.CData then
		--Create a table for the display to store data
		acfmenupanel.CData = {}	
	end
		
	self.CreateAttribs = Table.guicreate
	self.UpdateAttribs = Table.guiupdate
	self:CreateAttribs( Table )
	
	self:PerformLayout()

end

function PANEL:CreateAttribs( Table )
	--You overwrite this with your own function, defined in the ammo definition file, so each ammotype creates it's own menu
end

function PANEL:UpdateAttribs( Table )
	--You overwrite this with your own function, defined in the ammo definition file, so each ammotype creates it's own menu
end

function PANEL:PerformLayout( )
	
	// starting positions
	local vspacing = 10;
	local ypos = 0;
	
	// model select
	self.WeaponSelect:SetPos( 0, ypos )
	self.WeaponSelect:SetSize( self:GetWide(), 165 )
	ypos = self.WeaponSelect.Y + self.WeaponSelect:GetTall() + vspacing
	
	self.WeaponDisplay:SetPos( 0, ypos )
	self.WeaponDisplay:SetSize( self:GetWide(), 800 )
	self.WeaponDisplay:PerformLayout()
	ypos = self.WeaponDisplay.Y + self.WeaponDisplay:GetTall() + vspacing	

end

