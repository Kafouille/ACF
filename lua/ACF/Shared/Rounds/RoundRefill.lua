AddCSLuaFile( "ACF/Shared/Rounds/RoundRefill.lua" )

local DefTable = {}
	DefTable.type = "Ammo"										--Tells the spawn menu what entity to spawn
	DefTable.name = "Refill"										--Human readable name
	DefTable.model = "models/munitions/round_100mm_shot.mdl"	--Shell flight model
	DefTable.desc = "Ammo Refill"
	
	DefTable.convert = function( Crate, Table ) local Result = ACF_RefillConvert( Crate, Table ) return Result end
	
	DefTable.guicreate = function( Panel, Table ) ACF_RefillGUICreate( Panel, Table ) end	--References the function to use to draw that round menu
	DefTable.guiupdate = function( Panel, Table ) ACF_RefillGUIUpdate( Panel, Table ) end	--References the function to use to update that round menu

list.Set( "ACFRoundTypes", "Refill", DefTable )  --Set the round properties

function ACF_RefillConvert( Crate, PlayerData )		--Function to convert the player's slider data into the complete round data
	
	local BulletData = {}
		BulletData["Id"] = PlayerData["Id"]
		BulletData["Type"] = PlayerData["Type"]
		
		BulletData["Caliber"] = ACF.Weapons["Guns"][PlayerData["Id"]]["caliber"]
		BulletData["ProjMass"] = 0.5*7.9/100 --Volume of the projectile as a cylinder * streamline factor (Data5) * density of steel
		BulletData["PropMass"] = 0.5*ACF.PDensity/1000 --Volume of the case as a cylinder * Powder density converted from g to kg
		BulletData["RoundVolume"] = 1
			
	return BulletData
	
end

--GUI stuff after this
function ACF_RefillGUICreate( Panel, Table )

	acfmenupanel.CData["Id"] = "AmmoMedium"
	acfmenupanel.CData["Type"] = "Ammo"
	acfmenupanel.CData["AmmoId"] = "12.7mmMG"

	--Creating the ammo crate selection
	acfmenupanel.CData.CrateSelect = vgui.Create( "DMultiChoice" )	--Every display and slider is placed in the Round table so it gets trashed when selecting a new round type
		acfmenupanel.CData.CrateSelect:SetSize(100, 30)
		table.SortByMember(acfmenupanel.WeaponData["Ammo"],"caliber")
		for Key, Value in pairs( acfmenupanel.WeaponData["Ammo"] ) do
			acfmenupanel.CData.CrateSelect:AddChoice( Value.id , Key )
		end
		acfmenupanel.CData.CrateSelect.OnSelect = function( index , value , data )
			RunConsoleCommand( "acfmenu_id", data )
		end
		if acfmenupanel.CData["Id"] then
			acfmenupanel.CData.CrateSelect:SetText(acfmenupanel.CData["Id"])
			RunConsoleCommand( "acfmenu_id", acfmenupanel.CData["Id"] )
		else
			acfmenupanel.CData.CrateSelect:SetText("AmmoSmall")
			RunConsoleCommand( "acfmenu_id", "AmmoSmall" )
		end
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.CrateSelect )	
	
	--Create the caliber selection display
	acfmenupanel.CData.CaliberSelect = vgui.Create( "DMultiChoice" )	
		acfmenupanel.CData.CaliberSelect:SetSize(100, 30)
		for Key, Value in pairs( acfmenupanel.WeaponData["Guns"] ) do
			acfmenupanel.CData.CaliberSelect:AddChoice( Value.id , Key )
		end
		acfmenupanel.CData.CaliberSelect.OnSelect = function( index , value , data )
			acfmenupanel.CData["AmmoId"] = acfmenupanel.WeaponData["Guns"][data]["round"]["id"]
			ACF_RefillGUIUpdate()
		end
		acfmenupanel.CData.CaliberSelect:SetText(acfmenupanel.CData["AmmoId"])
	acfmenupanel.CustomDisplay:AddItem( acfmenupanel.CData.CaliberSelect )	
		
	ACF_RefillGUIUpdate( Panel, Table )

end

function ACF_RefillGUIUpdate( Panel, Table )
		
	RunConsoleCommand( "acfmenu_data1", acfmenupanel.CData["AmmoId"] )
	RunConsoleCommand( "acfmenu_data2", "Refill")
		
	acfmenupanel.CustomDisplay:PerformLayout()
	
end