/*
Weight STool 1.21
	by Spoco
*/

TOOL.Category		= "Construction"
TOOL.Name			= "#Tool.acfarmorprop.name"
TOOL.Command		= nil
TOOL.ConfigName		= ""

TOOL.ClientConVar["mass"] = "1"
TOOL.ClientConVar["thick"] = "1"
TOOL.ClientConVar["ductility"] = "0"
TOOL.ClientConVar["mhealth"] = "1"
TOOL.ClientConVar["marmor"] = "1"
TOOL.ClientConVar["area"] = "1"

if CLIENT then
	language.Add( "Tool.acfarmorprop.name", "ACF Armor Properties" )
	language.Add( "Tool.acfarmorprop.desc", "Sets objects armor" )
	language.Add( "Tool.acfarmorprop.0", "Left click to apply options. Right click to props properties. Reload to get Total Mass of a Constrained Contraption" )
	language.Add( "Tool_acfarmorprop_weight", "Weight:" )
	language.Add( "Tool_acfarmorprop_thick" , "Armour Thickness")
	language.Add( "Tool_acfarmorprop_thick_desc" , "Set a thickness and the weight will be scaled" )
	language.Add( "Tool_acfarmorprop_ductility", "Ductility:" )
	language.Add( "Tool_acfarmorprop_ductility_desc" , "Sets ductility of prop. Higher than zero will make prop more resistant to penetration but it will lower its health. Lower than zero will make prop less resistant to penetration but it will endure longer fire" )
	language.Add( "Tool_acfarmorprop_zeromass", "Mass must be above 0!" )
end

if SERVER and not Weights then Weights = {} end

local function ApplySettings( Player, Entity, Data )
	if not SERVER then return end

	if Data.Mass then
		local physobj = Entity:GetPhysicsObject()
		if physobj:IsValid() then physobj:SetMass(Data.Mass) end
	end
	if Data.Ductility then
		Entity.ACF = Entity.ACF or {}
		Entity.ACF.Ductility = (Data.Ductility/100)
	end
	
	duplicator.StoreEntityModifier( Entity, "acfsettings", Data )
end

duplicator.RegisterEntityModifier( "acfsettings", ApplySettings )

local function Recalc(Ply, What)
	local Millimeter, Ductility, Area
	if SERVER or CLIENT then
		Millimeter = Ply:GetInfo("acfarmorprop_thick")
		Ductility = Ply:GetInfo("acfarmorprop_ductility")/100
		Area = Ply:GetInfo("acfarmorprop_area") or 1
	end

	local Mass = (Millimeter + Millimeter * Ductility) * 0.78 * Area / 1000
	if What == "ductility" then
		if Mass > 50000 then
			Mass = 50000
			Ductility = (Mass/(0.78*1000*Area) - Millimeter)/Millimeter
		elseif Mass < 0.1 then
			Mass = 0.1
			Ductility = (Mass/(0.78*1000*Area) - Millimeter)/Millimeter
		end
		Ply:ConCommand("acfarmorprop_ductility "..(Ductility*100));
	end
	
	if What == "thick" then
		if Mass > 50000 then
			Mass = 50000
			Millimeter = Mass*1000 / Area / 0.78
			Millimeter = math.Clamp(Millimeter + Millimeter * Ductility,0.1,90000000000)
		elseif Mass < 0.1 then
			Mass = 0.1
			Millimeter = Mass*1000 / Area / 0.78
			Millimeter = math.Clamp(Millimeter + Millimeter * Ductility,0.1,90000000000)
		end
		Ply:ConCommand("acfarmorprop_thick "..Millimeter);
	end
	Ply:ConCommand("acfarmorprop_mass "..Mass);
	
	if CLIENT then
		local MArmour = Mass*1000 / Area / 0.78
		local MHealth = Area/ACF.Threshold
		MArmour = math.Clamp(MArmour + MArmour * Ductility,0.1,90000000000)
		MHealth = math.Clamp(MHealth - MHealth * Ductility,0.1,90000000000)
		
		Ply:ConCommand("acfarmorprop_mhealth "..MHealth)
		Ply:ConCommand("acfarmorprop_marmor "..MArmour)
		Ply:ConCommand("acfarmorprop_reloadui")
	end
end

local function IsReallyValid(trace)
	if not trace.Entity:IsValid() then return false end
	if trace.Entity:IsPlayer() then return false end
	if SERVER and not trace.Entity:GetPhysicsObject():IsValid() then return false end
	return true
end

function TOOL:LeftClick( trace )
	if CLIENT and IsReallyValid(trace) then return true end
	if not IsReallyValid(trace) then return false end
	
	self:GetOwner():ConCommand("acfarmorprop_area "..trace.Entity.ACF.Aera);
	
	Recalc(self:GetOwner())
	
	local mass = tonumber(self:GetClientInfo("mass"))
	local ductility = tonumber(self:GetClientInfo("ductility"))
	
	ApplySettings( self:GetOwner(), trace.Entity, { Mass = mass, Ductility = ductility } )
	self.updateacf = true
	
	return true;
end

function TOOL:RightClick( trace )
	if CLIENT and IsReallyValid(trace) then return true end
	if not IsReallyValid(trace) then return end
	local ent = trace.Entity
	
	local mass = ent:GetPhysicsObject():GetMass()
	local ductility = ent.ACF.Ductility
	local mhealth = ent.ACF.MaxHealth
	local marmor = ent.ACF.MaxArmour
	local thick = ent.ACF.MaxArmour
	local area = ent.ACF.Aera
	self:GetOwner():ConCommand("acfarmorprop_mass "..mass);
	self:GetOwner():ConCommand("acfarmorprop_ductility "..ductility);
	self:GetOwner():ConCommand("acfarmorprop_mhealth "..mhealth);
	self:GetOwner():ConCommand("acfarmorprop_marmor "..marmor);
	self:GetOwner():ConCommand("acfarmorprop_thick "..marmor);
	self:GetOwner():ConCommand("acfarmorprop_area "..area);
	self:GetOwner():ConCommand("acfarmorprop_reloadui");
	
	self.updateacf = true
	return true;
end

function TOOL:Reload( trace )
	if CLIENT then return false end;
	if not IsReallyValid(trace) then return false end
	local mass = 0
		for ent , v in pairs( constraint.GetAllConstrainedEntities(trace.Entity) ) do
			if IsValid(ent) and ent != NULL then
				local phys = ent:GetPhysicsObject()
				mass = mass + phys:GetMass()
			end
		end
		self:GetOwner():PrintMessage(HUD_PRINTCENTER , "Total Mass is: "..tostring(mass) )
	return true
end


function TOOL:Think()
	if CLIENT then return end;
	local pl = self:GetOwner()
	local wep = pl:GetActiveWeapon()
	if not wep:IsValid() or wep:GetClass() != "gmod_tool" or pl:GetInfo("gmod_toolmode") != "acfarmorprop" then return end
	local trace = pl:GetEyeTrace()
	if IsReallyValid(trace) then pl:SetNetworkedFloat("WeightMass", trace.Entity:GetPhysicsObject():GetMass()) end
	

	local ent = trace.Entity
	if ent != self.lastent or self.updateacf then
		if( ACF_Check ~= mil ) then
			local valid = ACF_Check( ent )
			if valid then
				self.Weapon:SetNetworkedInt( "HP", ent.ACF.Health )
				self.Weapon:SetNetworkedInt( "Armour", ent.ACF.Armour )
				self.Weapon:SetNetworkedInt( "MaxHP", ent.ACF.MaxHealth )
				self.Weapon:SetNetworkedInt( "MaxArmour", ent.ACF.MaxArmour )
			end
		end
		self.lastent = ent
		self.updateacf = false
	end
	if ent:IsWorld() and !self.updateacf then
		self.Weapon:SetNetworkedInt( "HP", 0 )
		self.Weapon:SetNetworkedInt( "Armour", 0 )
		self.Weapon:SetNetworkedInt( "MaxHP", 0 )
		self.Weapon:SetNetworkedInt( "MaxArmour", 0 )
		self.updateacf = true
	end
end

if CLIENT then
	function TOOL.BuildCPanel( cp )
		cp:AddControl( "Header", { Text = "#Tool.acfarmorprop.name", Description	= "#Tool.acfarmorprop.desc" }  )
		cp:AddControl( "Header", { Text = "This tool is WIP", Description	= "If you find any bugs or you have problems with it, please inform Frankess about it" }  )

		local params = { Label = "#Presets", MenuButton = 1, Folder = "weight", Options = {}, CVars = {} }
		
		params.Options.default = { acf_weight_set = 1 }
		table.insert( params.CVars, "acfarmorprop_mass" )
		
		cp:AddControl("ComboBox", params )
		cp:AddControl("Header", {Text = "Actual Weight" , Description = "Weight: "..math.floor(GetConVarNumber("acfarmorprop_mass")*10)/10  } )
		cp:AddControl("Header", {Text = "Actual MaxHealth" , Description = "Max Health: "..math.floor(GetConVarNumber("acfarmorprop_mhealth")*10)/10  } )
		cp:AddControl("Header", {Text = "Actual MaxArmor" , Description = "Max Armor: "..math.floor(GetConVarNumber("acfarmorprop_marmor")*10)/10  } )

		cp:AddControl("Slider", { Label = "#Tool_acfarmorprop_thick", Type = "Numeric", Min = "1", Max = "5000", Command = "acfarmorprop_thick" } )
		cp:AddControl("Header", {Text = "Armour Thickness Setting" , Description = "#Tool_acfarmorprop_thick_desc" } )
		
		
		cp:AddControl("Slider", { Label = "#Tool_acfarmorprop_ductility", Type = "Numeric", Min = "-99", Max = "99", Command = "acfarmorprop_ductility" } )
		cp:AddControl("Header", {Text = "Ductility Setting" , Description = "#Tool_acfarmorprop_ductility_desc" } )
	end

	local BuildCPanel = TOOL.BuildCPanel
	concommand.Add( "acfarmorprop_reloadui", function()
		local CPanel = controlpanel.Get( "acfarmorprop" )
		CPanel:Clear()
			
		BuildCPanel( CPanel )
	end)

	cvars.AddChangeCallback("acfarmorprop_ductility", function() 
		if timer.Exists("RecalcTimer") then timer.Remove("RecalcTimer") end
		timer.Create("RecalcTimer", 1, 1, function()
			Recalc(LocalPlayer(), "ductility")
		end)
	end)
	cvars.AddChangeCallback("acfarmorprop_thick", function() 
		if timer.Exists("RecalcTimer") then timer.Remove("RecalcTimer") end
		timer.Create("RecalcTimer", 1, 1, function()
			Recalc(LocalPlayer(), "thick")
		end)
	end)

	function TOOL:DrawToolScreen(w,h)
		local Health = math.floor((self.Weapon:GetNetworkedBool("HP")or 0) *10)/10 
		local MaxHealth = math.floor((self.Weapon:GetNetworkedBool("MaxHP")or 0) * 10)/10
		local Armour = math.floor((self.Weapon:GetNetworkedBool("Armour")or 0) *100)/100
		local MaxArmour = math.floor((self.Weapon:GetNetworkedBool("MaxArmour")or 0) *100)/100
		
		local HealthTxt = Health.."/"..MaxHealth.."\n"
		local ArmourTxt = Armour.."/"..MaxArmour.."\n"
		
		local HealthPercent = (Health/MaxHealth) * 226
		local ArmourPercent = (Armour/MaxArmour) * 226
		
		cam.Start2D()
			render.Clear(0,0,0,0)
			local Flicker = 255
			surface.SetDrawColor(255,255,255,Flicker)
			local tex=surface.GetTextureID(	"models/props_combine/combine_interface_disp")
			surface.SetTexture(tex) 
			surface.DrawTexturedRect(0, 0, 256, 256)
			surface.SetDrawColor(255,255,255,255)

			surface.SetFont("Torchfont")
			local w, h = surface.GetTextSize(" ")
			
			draw.SimpleTextOutlined("ACF Stats", "Torchfont", 128, 30, Color(224, 224, 255, Flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0, 0, 0, Flicker))
			
			draw.RoundedBox( 6, 10, 83, 236, 64, Color(200, 200, 200, Flicker))
			if Armour != 0 and MaxArmour != 0 then
				draw.RoundedBox( 6, 15, 88, ArmourPercent , 54, Color(0, 0, 200, Flicker))
			end
			
			draw.RoundedBox( 6, 10, 183, 236, 64, Color(200, 200, 200, Flicker))
			if Health != 0 and MaxHealth != 0 then
				draw.RoundedBox( 6, 15, 188, HealthPercent , 54, Color(200, 0, 0, Flicker))
			end
			
			draw.SimpleTextOutlined("Armour", "Torchfont", 128, 100, Color(224, 224, 255, Flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0, 0, 0, Flicker))
				draw.SimpleTextOutlined(ArmourTxt, "Torchfont", 128, 150, Color(224, 224, 255, Flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0, 0, 0, Flicker))
			
			draw.SimpleTextOutlined("Health", "Torchfont", 128, 200, Color(224, 224, 255, Flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0, 0, 0, Flicker))
			draw.SimpleTextOutlined(HealthTxt, "Torchfont", 128, 250, Color(224, 224, 255, Flicker), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, Color(0, 0, 0, Flicker))
		cam.End2D()
	end
end






