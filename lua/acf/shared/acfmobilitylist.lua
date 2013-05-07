
-- This now loads the files in the engines and gearboxes folders!
-- Go edit those files instead of this one.

AddCSLuaFile()

local MobilityTable = {}

-- setup base engine/gearbox tables so we're not repeating a bunch of unnecessary shit
local engine_base = {}
engine_base.ent = "acf_engine"
engine_base.type = "Mobility"
/*engine_base.powerband = function( rpm ) -- should return a percentage (0-1) of peak torque available
	math.max( math.min( rpm / self.PeakMinRPM, ( self.LimitRPM - rpm ) / ( self.LimitRPM - self.PeakMaxRPM ), 1 ), 0 )
end*/

local gearbox_base = {}
gearbox_base.ent = "acf_gearbox"
gearbox_base.type = "Mobility"
gearbox_base.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"

if CLIENT then
	engine_base.guicreate = function( panel, tbl ) ACFEngineGUICreate( tbl ) end or nil
	engine_base.guiupdate = function() return end
	gearbox_base.guicreate = function( panel, tbl ) ACFGearboxGUICreate( tbl ) end or nil
	gearbox_base.guiupdate = function() return end
end

-- some functions for defining engines and gearboxes
function ACF_DefineEngine( id, data )
	data.id = id
	table.Inherit( data, engine_base )
	MobilityTable[ id ] = data
end

function ACF_DefineGearbox( id, data )
	data.id = id
	table.Inherit( data, gearbox_base )
	MobilityTable[ id ] = data
end

-- search for and load a bunch of files or whatever
local engines = file.Find( "lua/acf/shared/engines/*.lua", "GAME" )
for k, v in pairs( engines ) do
	AddCSLuaFile( "acf/shared/engines/" .. v )
	include( "acf/shared/engines/" .. v )
end

local gearboxes = file.Find( "lua/acf/shared/gearboxes/*.lua", "GAME" )
for k, v in pairs( gearboxes ) do
	AddCSLuaFile( "acf/shared/gearboxes/" .. v )
	include( "acf/shared/gearboxes/" .. v )
end

-- now that the mobility table is populated, throw it in the acf ents list
list.Set( "ACFEnts", "Mobility", MobilityTable )
