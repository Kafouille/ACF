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
	Engine12I4.torque = 10		--in Meter/Kg
	Engine12I4.idlerpm = 1500	--in Rotations Per Minute
	Engine12I4.peakminrpm = 7000
	Engine12I4.peakmaxrpm = 12000
	Engine12I4.limitprm = 14000
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
	Engine20I4.torque = 20		--in Meter/Kg
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
	Engine150I4.torque = 200		--in Meter/Kg
	Engine150I4.idlerpm = 200	--in Rotations Per Minute
	Engine150I4.peakminrpm = 500
	Engine150I4.peakmaxrpm = 1500
	Engine150I4.limitprm = 2000
	if ( CLIENT ) then
		Engine150I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine150I4.guiupdate = function() return end
	end
MobilityTable["15.0-I4"] = Engine150I4

local EngineCarV8 = {}
	EngineCarV8.id = "5.0-V8"
	EngineCarV8.ent = "acf_engine"
	EngineCarV8.type = "Mobility"
	EngineCarV8.name = "5.0L V8"
	EngineCarV8.desc = "Heavier car engine, with a large powerband\n"
	EngineCarV8.model = "models/vehicle/vehicle_engine_block.mdl"
	EngineCarV8.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	EngineCarV8.weight = 250
	EngineCarV8.torque = 45
	EngineCarV8.idlerpm = 800
	EngineCarV8.peakminrpm = 2500
	EngineCarV8.peakmaxrpm = 5500
	EngineCarV8.limitprm = 6500
	if ( CLIENT ) then
		EngineCarV8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		EngineCarV8.guiupdate = function() return end
	end
MobilityTable["5.0-V8"] = EngineCarV8

local Gearbox4Small = {}
	Gearbox4Small.id = "4Gear-Small"
	Gearbox4Small.ent = "acf_gearbox"
	Gearbox4Small.type = "Mobility"
	Gearbox4Small.name = "4-Speed Gearbox, Small"
	Gearbox4Small.desc = "Small 4 speed gearbox"
	Gearbox4Small.model = "models/props_junk/PlasticCrate01a.mdl"
	Gearbox4Small.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gearbox4Small.weight = 50
	Gearbox4Small.switch = 0.3
	Gearbox4Small.maxtorque = 80
	Gearbox4Small.gears = 4
	Gearbox4Small.geartable = {}
		Gearbox4Small.geartable[-1] = -0.1
		Gearbox4Small.geartable[0] = 0
		Gearbox4Small.geartable[1] = 0.02
		Gearbox4Small.geartable[2] = 0.05
		Gearbox4Small.geartable[3] = 0.08
		Gearbox4Small.geartable[4] = 0.1
	if ( CLIENT ) then
		Gearbox4Small.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gearbox4Small.guiupdate = function() return end
	end
MobilityTable["4Gear-Small"] = Gearbox4Small

local Tracks = {}
	Tracks.id = "CarV8"
	Tracks.ent = "acf_engine"
	Tracks.type = "Mobility"
	Tracks.name = "Track"
	Tracks.desc = "Tank tracks"
	Tracks.model = "models/vehicle/vehicle_engine_block.mdl"
	Tracks.weight = 200
	if ( CLIENT ) then
		Tracks.guicreate = (function( Panel, Table ) ACFTrackGUICreate( Table ) end or nil)
		Tracks.guiupdate = function() return end
	end
MobilityTable["Tracks"] = Tracks

list.Set( "ACFEnts", "Mobility", MobilityTable )	--end mobility listing