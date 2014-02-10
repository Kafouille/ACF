--[[

	This file is loaded when ACF starts, just after all of the settings are set to their default values.
	Rename this file to acf_userconfig.lua to enable this file, and customize those settings.
	
	Move this file outside of the ACF folder to stop it being overwritten.
	Put it in another addon folder (acf2, acfconfig), or put it in garrysmod/lua/acf/shared/

]]--

-- IMPORTANT: AddCSLuaFile is required!  Do not remove it.
AddCSLuaFile() 



-- Some example settings are below.  They enable damage protection, change smoke wind, and make fuel more powerful.
-- There are more settings like this.  Find them all in lua/autorun/shared/acf_globals.lua


ACF.EnableDefaultDP = true 	-- Enable the inbuilt damage protection system.
ACF.SmokeWind = 30			-- Affects the ability of smoke to be used for screening effect
ACF.TorqueBoost = 2			-- Torque multiplier from using fuel