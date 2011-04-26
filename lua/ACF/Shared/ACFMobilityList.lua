AddCSLuaFile( "ACF/Shared/ACFMobilityList.lua" )

local MobilityTable = {}  --Start mobility listing

local Engine12I4 = {}
	Engine12I4.id = "1.2-I4"
	Engine12I4.ent = "acf_engine"
	Engine12I4.type = "Mobility"
	Engine12I4.name = "1.2L I4"
	Engine12I4.desc = "Very small and light bike engine, with the powerband \n high up in the revs\n"
	Engine12I4.model = "models/engines/inline4s.mdl"
	Engine12I4.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Engine12I4.weight = 60
	Engine12I4.torque = 30		--in Meter/Kg
	Engine12I4.idlerpm = 1500	--in Rotations Per Minute
	Engine12I4.peakminrpm = 8000
	Engine12I4.peakmaxrpm = 10000
	Engine12I4.limitprm = 12000
	if ( CLIENT ) then
		Engine12I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine12I4.guiupdate = function() return end
	end
MobilityTable["1.2-I4"] = Engine12I4

local Engine20I4 = {}
	Engine20I4.id = "2.0-I4"
	Engine20I4.ent = "acf_engine"
	Engine20I4.type = "Mobility"
	Engine20I4.name = "2.0L I4"
	Engine20I4.desc = "Small and light car engine, with the powerband \n high up in the revs\n"
	Engine20I4.model = "models/engines/inline4m.mdl"
	Engine20I4.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Engine20I4.weight = 120
	Engine20I4.torque = 150		--in Meter/Kg
	Engine20I4.idlerpm = 1000	--in Rotations Per Minute
	Engine20I4.peakminrpm = 5000
	Engine20I4.peakmaxrpm = 7000
	Engine20I4.limitprm = 8500
	if ( CLIENT ) then
		Engine20I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine20I4.guiupdate = function() return end
	end
MobilityTable["2.0-I4"] = Engine20I4

local Engine150I4 = {}
	Engine150I4.id = "15.0-I4"
	Engine150I4.ent = "acf_engine"
	Engine150I4.type = "Mobility"
	Engine150I4.name = "15.0L I4 Diesel"
	Engine150I4.desc = "Heavy Marine diesel, with lots of torque \nbut slow reving\n"
	Engine150I4.model = "models/engines/inline4l.mdl"
	Engine150I4.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Engine150I4.weight = 1500
	Engine150I4.torque = 5000		--in Meter/Kg
	Engine150I4.idlerpm = 200	--in Rotations Per Minute
	Engine150I4.peakminrpm = 500
	Engine150I4.peakmaxrpm = 1500
	Engine150I4.limitprm = 2000
	if ( CLIENT ) then
		Engine150I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine150I4.guiupdate = function() return end
	end
MobilityTable["15.0-I4"] = Engine150I4

local Gearbox4Small = {}
	Gearbox4Small.id = "4Gear-T-S"
	Gearbox4Small.ent = "acf_gearbox"
	Gearbox4Small.type = "Mobility"
	Gearbox4Small.name = "4-Speed Gearbox, Transaxial, Small"
	Gearbox4Small.desc = "A small, and light 4 speed gearbox, with a somewhat limited max torque rating\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gearbox4Small.model = "models/engines/transaxial_s.mdl"
	Gearbox4Small.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gearbox4Small.weight = 50
	Gearbox4Small.switch = 0.3
	Gearbox4Small.maxtq = 80
	Gearbox4Small.gears = 4
	Gearbox4Small.geartable = {}
		Gearbox4Small.geartable[-1] = 0.5
		Gearbox4Small.geartable[0] = 0
		Gearbox4Small.geartable[1] = 0.1
		Gearbox4Small.geartable[2] = 0.2
		Gearbox4Small.geartable[3] = 0.4
		Gearbox4Small.geartable[4] = 0.8
	if ( CLIENT ) then
		Gearbox4Small.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gearbox4Small.guiupdate = function() return end
	end
MobilityTable["4Gear-T-S"] = Gearbox4Small

local Gearbox4Medium = {}
	Gearbox4Medium.id = "4Gear-T-M"
	Gearbox4Medium.ent = "acf_gearbox"
	Gearbox4Medium.type = "Mobility"
	Gearbox4Medium.name = "4-Speed Gearbox, Transaxial, Medium"
	Gearbox4Medium.desc = "A medium sized, 4 speed gearbox"
	Gearbox4Medium.model = "models/engines/transaxial_m.mdl"
	Gearbox4Medium.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gearbox4Medium.weight = 150
	Gearbox4Medium.switch = 0.4
	Gearbox4Medium.maxtq = 500
	Gearbox4Medium.gears = 4
	Gearbox4Medium.geartable = {}
		Gearbox4Medium.geartable[-1] = 0.5
		Gearbox4Medium.geartable[0] = 0
		Gearbox4Medium.geartable[1] = 0.1
		Gearbox4Medium.geartable[2] = 0.2
		Gearbox4Medium.geartable[3] = 0.4
		Gearbox4Medium.geartable[4] = 0.8
	if ( CLIENT ) then
		Gearbox4Medium.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gearbox4Medium.guiupdate = function() return end
	end
MobilityTable["4Gear-T-M"] = Gearbox4Medium

local Gear4TL = {}
	Gear4TL.id = "4Gear-T-L"
	Gear4TL.ent = "acf_gearbox"
	Gear4TL.type = "Mobility"
	Gear4TL.name = "4-Speed Gearbox, Transaxial, Large"
	Gear4TL.desc = "A large, heavy and sturdy 4 speed gearbox"
	Gear4TL.model = "models/engines/transaxial_l.mdl"
	Gear4TL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TL.weight = 500
	Gear4TL.switch = 0.6
	Gear4TL.maxtq = 8000
	Gear4TL.gears = 4
	Gear4TL.geartable = {}
		Gear4TL.geartable[-1] = 1
		Gear4TL.geartable[0] = 0
		Gear4TL.geartable[1] = 0.1
		Gear4TL.geartable[2] = 0.2
		Gear4TL.geartable[3] = 0.4
		Gear4TL.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TL.guiupdate = function() return end
	end
MobilityTable["4Gear-T-L"] = Gear4TL

-- local Tracks = {}
	-- Tracks.id = "CarV8"
	-- Tracks.ent = "acf_engine"
	-- Tracks.type = "Mobility"
	-- Tracks.name = "Track"
	-- Tracks.desc = "Tank tracks"
	-- Tracks.model = "models/vehicle/vehicle_engine_block.mdl"
	-- Tracks.weight = 200
	-- if ( CLIENT ) then
		-- Tracks.guicreate = (function( Panel, Table ) ACFTrackGUICreate( Table ) end or nil)
		-- Tracks.guiupdate = function() return end
	-- end
-- MobilityTable["Tracks"] = Tracks

list.Set( "ACFEnts", "Mobility", MobilityTable )	--end mobility listing