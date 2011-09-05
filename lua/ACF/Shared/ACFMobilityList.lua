AddCSLuaFile( "ACF/Shared/ACFMobilityList.lua" )

local MobilityTable = {}  --Start mobility listing

local Engine12I4 = {}
	Engine12I4.id = "1.2-I4"
	Engine12I4.ent = "acf_engine"
	Engine12I4.type = "Mobility"
	Engine12I4.name = "1.2L I4 Diesel"
	Engine12I4.desc = "Very small and light diesel, for low power applications requiring a wide powerband"
	Engine12I4.model = "models/engines/inline4s.mdl"
	Engine12I4.sound = "I4D.Small"
	Engine12I4.weight = 70
	Engine12I4.torque = 55		--in Meter/Kg
	Engine12I4.idlerpm = 1000	--in Rotations Per Minute
	Engine12I4.peakminrpm = 2000
	Engine12I4.peakmaxrpm = 4000
	Engine12I4.limitprm = 5000
	if ( CLIENT ) then
		Engine12I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine12I4.guiupdate = function() return end
	end
MobilityTable["1.2-I4"] = Engine12I4

local Engine20I4 = {}
	Engine20I4.id = "2.0-I4"
	Engine20I4.ent = "acf_engine"
	Engine20I4.type = "Mobility"
	Engine20I4.name = "2.0L I4 Diesel"
	Engine20I4.desc = "Car sized diesel engine, with low power but decent low end torque"
	Engine20I4.model = "models/engines/inline4m.mdl"
	Engine20I4.sound = "I4D.Medium"
	Engine20I4.weight = 250
	Engine20I4.torque = 200		--in Meter/Kg
	Engine20I4.idlerpm = 800	--in Rotations Per Minute
	Engine20I4.peakminrpm = 1800
	Engine20I4.peakmaxrpm = 3500
	Engine20I4.limitprm = 4500
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
	Engine150I4.desc = "Small boat sized diesel, with large amounts of torque"
	Engine150I4.model = "models/engines/inline4l.mdl"
	Engine150I4.sound = "I4D.Large"
	Engine150I4.weight = 1500
	Engine150I4.torque = 1800		--in Meter/Kg
	Engine150I4.idlerpm = 300	--in Rotations Per Minute
	Engine150I4.peakminrpm = 500
	Engine150I4.peakmaxrpm = 1500
	Engine150I4.limitprm = 2000
	if ( CLIENT ) then
		Engine150I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine150I4.guiupdate = function() return end
	end
MobilityTable["15.0-I4"] = Engine150I4

local Engine180V8 = {}
	Engine180V8.id = "18.0-V8"
	Engine180V8.ent = "acf_engine"
	Engine180V8.type = "Mobility"
	Engine180V8.name = "18.0L V8 Petrol"
	Engine180V8.desc = "American Ford GAA V8, decent overall power and torque and fairly lightweight"
	Engine180V8.model = "models/engines/v8l.mdl"
	Engine180V8.sound = "V8.Large"
	Engine180V8.weight = 900
	Engine180V8.torque = 1420		--in Meter/Kg
	Engine180V8.idlerpm = 600	--in Rotations Per Minute
	Engine180V8.peakminrpm = 1600
	Engine180V8.peakmaxrpm = 2600
	Engine180V8.limitprm = 3000
	if ( CLIENT ) then
		Engine180V8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine180V8.guiupdate = function() return end
	end
MobilityTable["18.0-V8"] = Engine180V8

local Engine90V8 = {}
	Engine90V8.id = "9.0-V8"
	Engine90V8.ent = "acf_engine"
	Engine90V8.type = "Mobility"
	Engine90V8.name = "9.0L V8 Petrol"
	Engine90V8.desc = "Thirsty, giant V8, for medium applications"
	Engine90V8.model = "models/engines/v8m.mdl"
	Engine90V8.sound = "V8.Medium"
	Engine90V8.weight = 600
	Engine90V8.torque = 710		--in Meter/Kg
	Engine90V8.idlerpm = 700	--in Rotations Per Minute
	Engine90V8.peakminrpm = 2200
	Engine90V8.peakmaxrpm = 3500
	Engine90V8.limitprm = 5000
	if ( CLIENT ) then
		Engine90V8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine90V8.guiupdate = function() return end
	end
MobilityTable["9.0-V8"] = Engine90V8

local Engine57V8 = {}
	Engine57V8.id = "5.7-V8"
	Engine57V8.ent = "acf_engine"
	Engine57V8.type = "Mobility"
	Engine57V8.name = "5.7L V8 Petrol"
	Engine57V8.desc = "Car sized petrol engine, good power and mid range torque"
	Engine57V8.model = "models/engines/v8s.mdl"
	Engine57V8.sound = "V8.Small"
	Engine57V8.weight = 350
	Engine57V8.torque = 340		--in Meter/Kg
	Engine57V8.idlerpm = 800	--in Rotations Per Minute
	Engine57V8.peakminrpm = 3000
	Engine57V8.peakmaxrpm = 5000
	Engine57V8.limitprm = 6500
	if ( CLIENT ) then
		Engine57V8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine57V8.guiupdate = function() return end
	end
MobilityTable["5.7-V8"] = Engine57V8


local Gear4TS = {}
	Gear4TS.id = "4Gear-T-S"
	Gear4TS.ent = "acf_gearbox"
	Gear4TS.type = "Mobility"
	Gear4TS.name = "4-Speed, Transaxial, Small"
	Gear4TS.desc = "A small, and light 4 speed gearbox, with a somewhat limited max torque rating\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear4TS.model = "models/engines/transaxial_s.mdl"
	Gear4TS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TS.weight = 50
	Gear4TS.switch = 0.3
	Gear4TS.maxtq = 80
	Gear4TS.gears = 4
	Gear4TS.doubleclutch = false
	Gear4TS.geartable = {}
		Gear4TS.geartable[-1] = 0.5
		Gear4TS.geartable[0] = 0
		Gear4TS.geartable[1] = 0.1
		Gear4TS.geartable[2] = 0.2
		Gear4TS.geartable[3] = 0.4
		Gear4TS.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TS.guiupdate = function() return end
	end
MobilityTable["4Gear-T-S"] = Gear4TS

local Gear4TM = {}
	Gear4TM.id = "4Gear-T-M"
	Gear4TM.ent = "acf_gearbox"
	Gear4TM.type = "Mobility"
	Gear4TM.name = "4-Speed, Transaxial, Medium"
	Gear4TM.desc = "A medium sized, 4 speed gearbox"
	Gear4TM.model = "models/engines/transaxial_m.mdl"
	Gear4TM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TM.weight = 150
	Gear4TM.switch = 0.4
	Gear4TM.maxtq = 500
	Gear4TM.gears = 4
	Gear4TM.doubleclutch = false
	Gear4TM.geartable = {}
		Gear4TM.geartable[-1] = 0.5
		Gear4TM.geartable[0] = 0
		Gear4TM.geartable[1] = 0.1
		Gear4TM.geartable[2] = 0.2
		Gear4TM.geartable[3] = 0.4
		Gear4TM.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TM.guiupdate = function() return end
	end
MobilityTable["4Gear-T-M"] = Gear4TM

local Gear4TL = {}
	Gear4TL.id = "4Gear-T-L"
	Gear4TL.ent = "acf_gearbox"
	Gear4TL.type = "Mobility"
	Gear4TL.name = "4-Speed, Transaxial, Large"
	Gear4TL.desc = "A large, heavy and sturdy 4 speed gearbox"
	Gear4TL.model = "models/engines/transaxial_l.mdl"
	Gear4TL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TL.weight = 500
	Gear4TL.switch = 0.6
	Gear4TL.maxtq = 6000
	Gear4TL.gears = 4
	Gear4TL.doubleclutch = false
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

local Gear4TDS = {}
	Gear4TDS.id = "4Gear-TD-S"
	Gear4TDS.ent = "acf_gearbox"
	Gear4TDS.type = "Mobility"
	Gear4TDS.name = "4-Speed, Transaxial Dual Clutch, Small"
	Gear4TDS.desc = "A small, and light 4 speed gearbox, with a somewhat limited max torque rating. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear4TDS.model = "models/engines/transaxial_s.mdl"
	Gear4TDS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TDS.weight = 65
	Gear4TDS.switch = 0.3
	Gear4TDS.maxtq = 80
	Gear4TDS.gears = 4
	Gear4TDS.doubleclutch = true
	Gear4TDS.geartable = {}
		Gear4TDS.geartable[-1] = 0.5
		Gear4TDS.geartable[0] = 0
		Gear4TDS.geartable[1] = 0.1
		Gear4TDS.geartable[2] = 0.2
		Gear4TDS.geartable[3] = 0.4
		Gear4TDS.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TDS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TDS.guiupdate = function() return end
	end
MobilityTable["4Gear-TD-S"] = Gear4TDS

local Gear4TDM = {}
	Gear4TDM.id = "4Gear-TD-M"
	Gear4TDM.ent = "acf_gearbox"
	Gear4TDM.type = "Mobility"
	Gear4TDM.name = "4-Speed, Transaxial Dual Clutch, Medium"
	Gear4TDM.desc = "A medium sized, 4 speed gearbox. The dual clutch allows you to apply power and brake each side independently"
	Gear4TDM.model = "models/engines/transaxial_m.mdl"
	Gear4TDM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TDM.weight = 200
	Gear4TDM.switch = 0.4
	Gear4TDM.maxtq = 500
	Gear4TDM.gears = 4
	Gear4TDM.doubleclutch = true
	Gear4TDM.geartable = {}
		Gear4TDM.geartable[-1] = 0.5
		Gear4TDM.geartable[0] = 0
		Gear4TDM.geartable[1] = 0.1
		Gear4TDM.geartable[2] = 0.2
		Gear4TDM.geartable[3] = 0.4
		Gear4TDM.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TDM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TDM.guiupdate = function() return end
	end
MobilityTable["4Gear-TD-M"] = Gear4TDM

local Gear4TDL = {}
	Gear4TDL.id = "4Gear-TD-L"
	Gear4TDL.ent = "acf_gearbox"
	Gear4TDL.type = "Mobility"
	Gear4TDL.name = "4-Speed, Transaxial Dual Clutch, Large"
	Gear4TDL.desc = "A large, heavy and sturdy 4 speed gearbox. The dual clutch allows you to apply power and brake each side independently"
	Gear4TDL.model = "models/engines/transaxial_l.mdl"
	Gear4TDL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TDL.weight = 650
	Gear4TDL.switch = 0.6
	Gear4TDL.maxtq = 6000
	Gear4TDL.gears = 4
	Gear4TDL.doubleclutch = true
	Gear4TDL.geartable = {}
		Gear4TDL.geartable[-1] = 1
		Gear4TDL.geartable[0] = 0
		Gear4TDL.geartable[1] = 0.1
		Gear4TDL.geartable[2] = 0.2
		Gear4TDL.geartable[3] = 0.4
		Gear4TDL.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TDL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TDL.guiupdate = function() return end
	end
MobilityTable["4Gear-TD-L"] = Gear4TDL

local Gear6TS = {}
	Gear6TS.id = "6Gear-T-S"
	Gear6TS.ent = "acf_gearbox"
	Gear6TS.type = "Mobility"
	Gear6TS.name = "6-Speed, Transaxial, Small"
	Gear6TS.desc = "A small and light 6 speed gearbox, with a limited max torque rating."
	Gear6TS.model = "models/engines/transaxial_s.mdl"
	Gear6TS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6TS.weight = 70
	Gear6TS.switch = 0.3
	Gear6TS.maxtq = 70
	Gear6TS.gears = 6
	Gear6TS.doubleclutch = false
	Gear6TS.geartable = {}
		Gear6TS.geartable[-1] = 0.5
		Gear6TS.geartable[0] = 0
		Gear6TS.geartable[1] = 0.1
		Gear6TS.geartable[2] = 0.2
		Gear6TS.geartable[3] = 0.3
		Gear6TS.geartable[4] = 0.4
		Gear6TS.geartable[5] = 0.5
		Gear6TS.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6TS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6TS.guiupdate = function() return end
	end
MobilityTable["6Gear-T-S"] = Gear6TS

local Gear6TM = {}
	Gear6TM.id = "6Gear-T-M"
	Gear6TM.ent = "acf_gearbox"
	Gear6TM.type = "Mobility"
	Gear6TM.name = "6-Speed, Transaxial, Medium"
	Gear6TM.desc = "A medium duty 6 speed gearbox with a limited torque rating."
	Gear6TM.model = "models/engines/transaxial_m.mdl"
	Gear6TM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6TM.weight = 250
	Gear6TM.switch = 0.4
	Gear6TM.maxtq = 400
	Gear6TM.gears = 6
	Gear6TM.doubleclutch = false
	Gear6TM.geartable = {}
		Gear6TM.geartable[-1] = 0.5
		Gear6TM.geartable[0] = 0
		Gear6TM.geartable[1] = 0.1
		Gear6TM.geartable[2] = 0.2
		Gear6TM.geartable[3] = 0.3
		Gear6TM.geartable[4] = 0.4
		Gear6TM.geartable[5] = 0.5
		Gear6TM.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6TM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6TM.guiupdate = function() return end
	end
MobilityTable["6Gear-T-M"] = Gear6TM

local Gear6TL = {}
	Gear6TL.id = "6Gear-T-L"
	Gear6TL.ent = "acf_gearbox"
	Gear6TL.type = "Mobility"
	Gear6TL.name = "6-Speed, Transaxial, Large"
	Gear6TL.desc = "Heavy duty 6 speed gearbox, however not as resilient as a 4 speed."
	Gear6TL.model = "models/engines/transaxial_l.mdl"
	Gear6TL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6TL.weight = 700
	Gear6TL.switch = 0.6
	Gear6TL.maxtq = 6000
	Gear6TL.gears = 6
	Gear6TL.doubleclutch = false
	Gear6TL.geartable = {}
		Gear6TL.geartable[-1] = 1
		Gear6TL.geartable[0] = 0
		Gear6TL.geartable[1] = 0.1
		Gear6TL.geartable[2] = 0.2
		Gear6TL.geartable[3] = 0.3
		Gear6TL.geartable[4] = 0.4
		Gear6TL.geartable[5] = 0.5
		Gear6TL.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6TL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6TL.guiupdate = function() return end
	end
MobilityTable["6Gear-T-L"] = Gear6TL

local Gear6TDS = {}
	Gear6TDS.id = "6Gear-TD-S"
	Gear6TDS.ent = "acf_gearbox"
	Gear6TDS.type = "Mobility"
	Gear6TDS.name = "6-Speed, Transaxial Dual Clutch, Small"
	Gear6TDS.desc = "A small and light 6 speed gearbox, with a limited max torque rating. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear6TDS.model = "models/engines/transaxial_s.mdl"
	Gear6TDS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6TDS.weight = 100
	Gear6TDS.switch = 0.3
	Gear6TDS.maxtq = 70
	Gear6TDS.gears = 6
	Gear6TDS.doubleclutch = true
	Gear6TDS.geartable = {}
		Gear6TDS.geartable[-1] = 0.5
		Gear6TDS.geartable[0] = 0
		Gear6TDS.geartable[1] = 0.1
		Gear6TDS.geartable[2] = 0.2
		Gear6TDS.geartable[3] = 0.3
		Gear6TDS.geartable[4] = 0.4
		Gear6TDS.geartable[5] = 0.5
		Gear6TDS.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6TDS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6TDS.guiupdate = function() return end
	end
MobilityTable["6Gear-TD-S"] = Gear6TDS

local Gear6TDM = {}
	Gear6TDM.id = "6Gear-TD-M"
	Gear6TDM.ent = "acf_gearbox"
	Gear6TDM.type = "Mobility"
	Gear6TDM.name = "6-Speed, Transaxial Dual Clutch, Medium"
	Gear6TDM.desc = "A a medium duty 6 speed gearbox. The added gears reduce torque capacity substantially. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear6TDM.model = "models/engines/transaxial_m.mdl"
	Gear6TDM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6TDM.weight = 400
	Gear6TDM.switch = 0.4
	Gear6TDM.maxtq = 400
	Gear6TDM.gears = 6
	Gear6TDM.doubleclutch = true
	Gear6TDM.geartable = {}
		Gear6TDM.geartable[-1] = 0.5
		Gear6TDM.geartable[0] = 0
		Gear6TDM.geartable[1] = 0.1
		Gear6TDM.geartable[2] = 0.2
		Gear6TDM.geartable[3] = 0.3
		Gear6TDM.geartable[4] = 0.4
		Gear6TDM.geartable[5] = 0.5
		Gear6TDM.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6TDM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6TDM.guiupdate = function() return end
	end
MobilityTable["6Gear-TD-M"] = Gear6TDM

local Gear6TDL = {}
	Gear6TDL.id = "6Gear-TD-L"
	Gear6TDL.ent = "acf_gearbox"
	Gear6TDL.type = "Mobility"
	Gear6TDL.name = "6-Speed, Transaxial Dual Clutch, Large"
	Gear6TDL.desc = "Heavy duty 6 speed gearbox, however not as resilient as a 4 speed. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear6TDL.model = "models/engines/transaxial_l.mdl"
	Gear6TDL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6TDL.weight = 900
	Gear6TDL.switch = 0.6
	Gear6TDL.maxtq = 3500
	Gear6TDL.gears = 6
	Gear6TDL.doubleclutch = true
	Gear6TDL.geartable = {}
		Gear6TDL.geartable[-1] = 1
		Gear6TDL.geartable[0] = 0
		Gear6TDL.geartable[1] = 0.1
		Gear6TDL.geartable[2] = 0.2
		Gear6TDL.geartable[3] = 0.3
		Gear6TDL.geartable[4] = 0.4
		Gear6TDL.geartable[5] = 0.5
		Gear6TDL.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6TDL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6TDL.guiupdate = function() return end
	end
MobilityTable["6Gear-TD-L"] = Gear6TDL

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

local MobClass = {}

local SingleClutchT = {}
	SingleClutchT.type = "Gearbox"
	SingleClutchT.name = "Single Clutch, Transverse"
MobClass["Gear-SC-T"] = SingleClutchT	

local DualClutchT = {}
	DualClutchT.type = "Gearbox"
	DualClutchT.name = "Dual Clutch, Transverse"
MobClass["Gear-DC-T"] = DualClutchT

local Inline4D = {}
	Inline4D.type = "Engine"
	Inline4D.name = "Inline 4, Diesel"
MobClass["Engine-I4-D"] = Inline4D

list.Set( "ACFClasses", "MobClass", MobClass )	--End mobility classes listing