AddCSLuaFile( "ACF/Shared/ACFMobilityList.lua" )

local MobilityTable = {}  --Start mobility listing




--fix 6.5l i6 sound & 1l sound


-- Petrol I4s
local Engine10I4 = {}
	Engine10I4.id = "1.0-I4"
	Engine10I4.ent = "acf_engine"
	Engine10I4.type = "Mobility"
	Engine10I4.name = "1.0L I4 Petrol"
	Engine10I4.desc = "Low power, high revving bike engine, power in the upper powerband"
	Engine10I4.model = "models/engines/inline4s.mdl"
	Engine10I4.sound = "I4P.Small"
	Engine10I4.weight = 55
	Engine10I4.torque = 40		--in Meter/Kg
	Engine10I4.idlerpm = 1000	--in Rotations Per Minute
	Engine10I4.peakminrpm = 5250
	Engine10I4.peakmaxrpm = 8000
	Engine10I4.limitprm = 9000
	if ( CLIENT ) then
		Engine10I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine10I4.guiupdate = function() return end
	end
MobilityTable["1.0-I4"] = Engine10I4

local Engine18I4 = {}
	Engine18I4.id = "1.8-I4"
	Engine18I4.ent = "acf_engine"
	Engine18I4.type = "Mobility"
	Engine18I4.name = "1.8L I4 Petrol"
	Engine18I4.desc = "Car sized petrol I4, good for burning rice"
	Engine18I4.model = "models/engines/inline4m.mdl"
	Engine18I4.sound = "I4P.Medium"
	Engine18I4.weight = 200
	Engine18I4.torque = 150		--in Meter/Kg
	Engine18I4.idlerpm = 900	--in Rotations Per Minute
	Engine18I4.peakminrpm = 5400
	Engine18I4.peakmaxrpm = 7000
	Engine18I4.limitprm = 8000
	if ( CLIENT ) then
		Engine18I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine18I4.guiupdate = function() return end
	end
MobilityTable["1.8-I4"] = Engine18I4

local Engine160I4 = {}
	Engine160I4.id = "16.0-I4"
	Engine160I4.ent = "acf_engine"
	Engine160I4.type = "Mobility"
	Engine160I4.name = "16.0L I4 Petrol"
	Engine160I4.desc = "Giant, thirsty I4 petrol, most commonly used in boats"
	Engine160I4.model = "models/engines/inline4l.mdl"
	Engine160I4.sound = "I4P.Large"
	Engine160I4.weight = 800
	Engine160I4.torque = 950		--in Meter/Kg
	Engine160I4.idlerpm = 500	--in Rotations Per Minute
	Engine160I4.peakminrpm = 1750
	Engine160I4.peakmaxrpm = 3250
	Engine160I4.limitprm = 3500
	if ( CLIENT ) then
		Engine160I4.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine160I4.guiupdate = function() return end
	end
MobilityTable["16.0-I4"] = Engine160I4




-- Diesel I4s
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




--Diesel L6s
local Engine30I6 = {}
	Engine30I6.id = "3.0-I6"
	Engine30I6.ent = "acf_engine"
	Engine30I6.type = "Mobility"
	Engine30I6.name = "3.0L I6 Diesel"
	Engine30I6.desc = "Car sized I6 diesel, good, wide powerband"
	Engine30I6.model = "models/engines/inline6s.mdl"
	Engine30I6.sound = "L6D.Small"
	Engine30I6.weight = 300
	Engine30I6.torque = 240		--in Meter/Kg
	Engine30I6.idlerpm = 650	--in Rotations Per Minute
	Engine30I6.peakminrpm = 1000
	Engine30I6.peakmaxrpm = 3000
	Engine30I6.limitprm = 4500
	if ( CLIENT ) then
		Engine30I6.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine30I6.guiupdate = function() return end
	end
MobilityTable["3.0-I6"] = Engine30I6

local Engine65I6 = {}
	Engine65I6.id = "6.5-I6"
	Engine65I6.ent = "acf_engine"
	Engine65I6.type = "Mobility"
	Engine65I6.name = "6.5L I6 Diesel"
	Engine65I6.desc = "Truck duty I6, good overall powerband and torque"
	Engine65I6.model = "models/engines/inline6m.mdl"
	Engine65I6.sound = "L6D.Medium"
	Engine65I6.weight = 650
	Engine65I6.torque = 550		--in Meter/Kg
	Engine65I6.idlerpm = 600	--in Rotations Per Minute
	Engine65I6.peakminrpm = 1600
	Engine65I6.peakmaxrpm = 3500
	Engine65I6.limitprm = 4000
	if ( CLIENT ) then
		Engine65I6.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine65I6.guiupdate = function() return end
	end
MobilityTable["6.5-I6"] = Engine65I6

local Engine200I6 = {}
	Engine200I6.id = "20.0-I6"
	Engine200I6.ent = "acf_engine"
	Engine200I6.type = "Mobility"
	Engine200I6.name = "20.0L I6 Diesel"
	Engine200I6.desc = "Heavy duty diesel I6, used in generators and heavy movers"
	Engine200I6.model = "models/engines/inline6l.mdl"
	Engine200I6.sound = "L6D.Large"
	Engine200I6.weight = 1800
	Engine200I6.torque = 2000		--in Meter/Kg
	Engine200I6.idlerpm = 400	--in Rotations Per Minute
	Engine200I6.peakminrpm = 500
	Engine200I6.peakmaxrpm = 1700
	Engine200I6.limitprm = 2250
	if ( CLIENT ) then
		Engine200I6.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine200I6.guiupdate = function() return end
	end
MobilityTable["20.0-I6"] = Engine200I6



--Petrol L6s
local Engine22I6 = {}
	Engine22I6.id = "2.2-I6"
	Engine22I6.ent = "acf_engine"
	Engine22I6.type = "Mobility"
	Engine22I6.name = "2.2L I6 Petrol"
	Engine22I6.desc = "Car sized I6 petrol with power in the high revs"
	Engine22I6.model = "models/engines/inline6s.mdl"
	Engine22I6.sound = "L6P.Small"
	Engine22I6.weight = 250
	Engine22I6.torque = 170		--in Meter/Kg
	Engine22I6.idlerpm = 800	--in Rotations Per Minute
	Engine22I6.peakminrpm = 4000
	Engine22I6.peakmaxrpm = 6500
	Engine22I6.limitprm = 8000
	if ( CLIENT ) then
		Engine22I6.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine22I6.guiupdate = function() return end
	end
MobilityTable["2.2-I6"] = Engine22I6

local Engine48I6 = {}
	Engine48I6.id = "4.8-I6"
	Engine48I6.ent = "acf_engine"
	Engine48I6.type = "Mobility"
	Engine48I6.name = "4.8L I6 Petrol"
	Engine48I6.desc = "Light truck duty I6, good for offroad applications"
	Engine48I6.model = "models/engines/inline6m.mdl"
	Engine48I6.sound = "L6P.Medium"
	Engine48I6.weight = 350
	Engine48I6.torque = 400		--in Meter/Kg
	Engine48I6.idlerpm = 900	--in Rotations Per Minute
	Engine48I6.peakminrpm = 3800
	Engine48I6.peakmaxrpm = 5800
	Engine48I6.limitprm = 6500
	if ( CLIENT ) then
		Engine48I6.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine48I6.guiupdate = function() return end
	end
MobilityTable["4.8-I6"] = Engine48I6

local Engine172I6 = {}
	Engine172I6.id = "17.2-I6"
	Engine172I6.ent = "acf_engine"
	Engine172I6.type = "Mobility"
	Engine172I6.name = "17.2L I6 Petrol"
	Engine172I6.desc = "Heavy tractor duty petrol I6, decent overall powerband"
	Engine172I6.model = "models/engines/inline6l.mdl"
	Engine172I6.sound = "L6P.Large"
	Engine172I6.weight = 1000
	Engine172I6.torque = 1100		--in Meter/Kg
	Engine172I6.idlerpm = 500	--in Rotations Per Minute
	Engine172I6.peakminrpm = 2300
	Engine172I6.peakmaxrpm = 3500
	Engine172I6.limitprm = 3500
	if ( CLIENT ) then
		Engine172I6.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine172I6.guiupdate = function() return end
	end
MobilityTable["17.2-I6"] = Engine172I6




--Petrol V8s
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
	Engine90V8.weight = 550
	Engine90V8.torque = 500		--in Meter/Kg
	Engine90V8.idlerpm = 700	--in Rotations Per Minute
	Engine90V8.peakminrpm = 3800
	Engine90V8.peakmaxrpm = 5000
	Engine90V8.limitprm = 5500
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




--Diesel V8s
local Engine190V8 = {}
	Engine190V8.id = "19.0-V8"
	Engine190V8.ent = "acf_engine"
	Engine190V8.type = "Mobility"
	Engine190V8.name = "19.0L V8 Diesel"
	Engine190V8.desc = "Heavy duty diesel V8, used for heavy construction equipment"
	Engine190V8.model = "models/engines/v8l.mdl"
	Engine190V8.sound = "V8D.Large"
	Engine190V8.weight = 2200
	Engine190V8.torque = 2400		--in Meter/Kg
	Engine190V8.idlerpm = 500	--in Rotations Per Minute
	Engine190V8.peakminrpm = 700
	Engine190V8.peakmaxrpm = 1650
	Engine190V8.limitprm = 2500
	if ( CLIENT ) then
		Engine190V8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine190V8.guiupdate = function() return end
	end
MobilityTable["19.0-V8"] = Engine190V8

local Engine78V8 = {}
	Engine78V8.id = "7.8-V8"
	Engine78V8.ent = "acf_engine"
	Engine78V8.type = "Mobility"
	Engine78V8.name = "7.8L V8 Diesel"
	Engine78V8.desc = "Utility grade V8 diesel, has a good, wide powerband"
	Engine78V8.model = "models/engines/v8m.mdl"
	Engine78V8.sound = "V8D.Medium"
	Engine78V8.weight = 750
	Engine78V8.torque = 710		--in Meter/Kg
	Engine78V8.idlerpm = 650	--in Rotations Per Minute
	Engine78V8.peakminrpm = 800
	Engine78V8.peakmaxrpm = 3000
	Engine78V8.limitprm = 4000
	if ( CLIENT ) then
		Engine78V8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine78V8.guiupdate = function() return end
	end
MobilityTable["7.8-V8"] = Engine78V8

local Engine45V8 = {}
	Engine45V8.id = "4.5-V8"
	Engine45V8.ent = "acf_engine"
	Engine45V8.type = "Mobility"
	Engine45V8.name = "4.5L V8 Diesel"
	Engine45V8.desc = "Light duty diesel v8, good for light vehicles that require a lot of torque"
	Engine45V8.model = "models/engines/v8s.mdl"
	Engine45V8.sound = "V8D.Small"
	Engine45V8.weight = 400
	Engine45V8.torque = 400		--in Meter/Kg
	Engine45V8.idlerpm = 800	--in Rotations Per Minute
	Engine45V8.peakminrpm = 1000
	Engine45V8.peakmaxrpm = 3000
	Engine45V8.limitprm = 5000
	if ( CLIENT ) then
		Engine45V8.guicreate = (function( Panel, Table ) ACFEngineGUICreate( Table ) end or nil)
		Engine45V8.guiupdate = function() return end
	end
MobilityTable["4.5-V8"] = Engine45V8




-- 1 speed reduction gearboxes

local Gear1TS = {}
	Gear1TS.id = "1Gear-T-S"
	Gear1TS.ent = "acf_gearbox"
	Gear1TS.type = "Mobility"
	Gear1TS.name = "1-Speed, Transaxial, Small"
	Gear1TS.desc = "Small, 1 speed reduction gearbox, useful for boats and aircraft\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear1TS.model = "models/engines/transaxial_s.mdl"
	Gear1TS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear1TS.weight = 20
	Gear1TS.switch = 0.3
	Gear1TS.maxtq = 180
	Gear1TS.gears = 1
	Gear1TS.doubleclutch = false
	Gear1TS.geartable = {}
		Gear1TS.geartable[-1] = 0.5
		Gear1TS.geartable[0] = 0
		Gear1TS.geartable[1] = 0.1
	if ( CLIENT ) then
		Gear1TS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear1TS.guiupdate = function() return end
	end
MobilityTable["1Gear-T-S"] = Gear1TS

local Gear1TM = {}
	Gear1TM.id = "1Gear-T-M"
	Gear1TM.ent = "acf_gearbox"
	Gear1TM.type = "Mobility"
	Gear1TM.name = "1-Speed, Transaxial, Medium"
	Gear1TM.desc = "Medium sized single speed gearbox"
	Gear1TM.model = "models/engines/transaxial_m.mdl"
	Gear1TM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear1TM.weight = 70
	Gear1TM.switch = 0.4
	Gear1TM.maxtq = 1000
	Gear1TM.gears = 1
	Gear1TM.doubleclutch = false
	Gear1TM.geartable = {}
		Gear1TM.geartable[-1] = 0.5
		Gear1TM.geartable[0] = 0
		Gear1TM.geartable[1] = 0.1
	if ( CLIENT ) then
		Gear1TM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear1TM.guiupdate = function() return end
	end
MobilityTable["1Gear-T-M"] = Gear1TM

local Gear1TL = {}
	Gear1TL.id = "1Gear-T-L"
	Gear1TL.ent = "acf_gearbox"
	Gear1TL.type = "Mobility"
	Gear1TL.name = "1-Speed, Transaxial, Large"
	Gear1TL.desc = "Heavy duty single speed, best used with heavy marine vehicles and large aircraft"
	Gear1TL.model = "models/engines/transaxial_l.mdl"
	Gear1TL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear1TL.weight = 250
	Gear1TL.switch = 0.6
	Gear1TL.maxtq = 10000
	Gear1TL.gears = 1
	Gear1TL.doubleclutch = false
	Gear1TL.geartable = {}
		Gear1TL.geartable[-1] = 1
		Gear1TL.geartable[0] = 0
		Gear1TL.geartable[1] = 0.1
	if ( CLIENT ) then
		Gear1TL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear1TL.guiupdate = function() return end
	end
MobilityTable["1Gear-T-L"] = Gear1TL



local Gear1LS = {}
	Gear1LS.id = "1Gear-L-S"
	Gear1LS.ent = "acf_gearbox"
	Gear1LS.type = "Mobility"
	Gear1LS.name = "1-Speed, Inline, Small"
	Gear1LS.desc = "Small, 1 speed reduction gearbox, useful for boats and aircraft\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear1LS.model = "models/engines/linear_s.mdl"
	Gear1LS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear1LS.weight = 20
	Gear1LS.switch = 0.3
	Gear1LS.maxtq = 180
	Gear1LS.gears = 1
	Gear1LS.doubleclutch = false
	Gear1LS.geartable = {}
		Gear1LS.geartable[-1] = 0.5
		Gear1LS.geartable[0] = 0
		Gear1LS.geartable[1] = 0.1
	if ( CLIENT ) then
		Gear1LS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear1LS.guiupdate = function() return end
	end
MobilityTable["1Gear-L-S"] = Gear1LS

local Gear1LM = {}
	Gear1LM.id = "1Gear-L-M"
	Gear1LM.ent = "acf_gearbox"
	Gear1LM.type = "Mobility"
	Gear1LM.name = "1-Speed, Inline, Medium"
	Gear1LM.desc = "Medium sized single speed gearbox"
	Gear1LM.model = "models/engines/linear_m.mdl"
	Gear1LM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear1LM.weight = 70
	Gear1LM.switch = 0.4
	Gear1LM.maxtq = 1000
	Gear1LM.gears = 1
	Gear1LM.doubleclutch = false
	Gear1LM.geartable = {}
		Gear1LM.geartable[-1] = 0.5
		Gear1LM.geartable[0] = 0
		Gear1LM.geartable[1] = 0.1
	if ( CLIENT ) then
		Gear1LM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear1LM.guiupdate = function() return end
	end
MobilityTable["1Gear-L-M"] = Gear1LM

local Gear1LL = {}
	Gear1LL.id = "1Gear-L-L"
	Gear1LL.ent = "acf_gearbox"
	Gear1LL.type = "Mobility"
	Gear1LL.name = "1-Speed, Inline, Large"
	Gear1LL.desc = "Heavy duty single speed, best used with heavy marine vehicles and large aircraft"
	Gear1LL.model = "models/engines/linear_l.mdl"
	Gear1LL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear1LL.weight = 250
	Gear1LL.switch = 0.6
	Gear1LL.maxtq = 10000
	Gear1LL.gears = 1
	Gear1LL.doubleclutch = false
	Gear1LL.geartable = {}
		Gear1LL.geartable[-1] = 1
		Gear1LL.geartable[0] = 0
		Gear1LL.geartable[1] = 0.1
	if ( CLIENT ) then
		Gear1LL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear1LL.guiupdate = function() return end
	end
MobilityTable["1Gear-L-L"] = Gear1LL




-- 4 speed normal gearboxes
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
	Gear4TM.maxtq = 550
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




-- 4 speed dual clutch gearboxes
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
	Gear4TDM.maxtq = 550
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




-- 6 speed normal gearboxes
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




-- 6 speed dual clutch gearboxes
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




-- 4 speed normal inline gearboxes
local Gear4LS = {}
	Gear4LS.id = "4Gear-L-S"
	Gear4LS.ent = "acf_gearbox"
	Gear4LS.type = "Mobility"
	Gear4LS.name = "4-Speed, Inline, Small"
	Gear4LS.desc = "A small, and light 4 speed inline gearbox, with a somewhat limited max torque rating\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear4LS.model = "models/engines/linear_s.mdl"
	Gear4LS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4LS.weight = 50
	Gear4LS.switch = 0.3
	Gear4LS.maxtq = 80
	Gear4LS.gears = 4
	Gear4LS.doubleclutch = false
	Gear4LS.geartable = {}
		Gear4LS.geartable[-1] = 0.5
		Gear4LS.geartable[0] = 0
		Gear4LS.geartable[1] = 0.1
		Gear4LS.geartable[2] = 0.2
		Gear4LS.geartable[3] = 0.4
		Gear4LS.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4LS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4LS.guiupdate = function() return end
	end
MobilityTable["4Gear-L-S"] = Gear4LS

local Gear4LM = {}
	Gear4LM.id = "4Gear-L-M"
	Gear4LM.ent = "acf_gearbox"
	Gear4LM.type = "Mobility"
	Gear4LM.name = "4-Speed, Inline, Medium"
	Gear4LM.desc = "A medium sized, 4 speed inline gearbox"
	Gear4LM.model = "models/engines/linear_m.mdl"
	Gear4LM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4LM.weight = 150
	Gear4LM.switch = 0.4
	Gear4LM.maxtq = 550
	Gear4LM.gears = 4
	Gear4LM.doubleclutch = false
	Gear4LM.geartable = {}
		Gear4LM.geartable[-1] = 0.5
		Gear4LM.geartable[0] = 0
		Gear4LM.geartable[1] = 0.1
		Gear4LM.geartable[2] = 0.2
		Gear4LM.geartable[3] = 0.4
		Gear4LM.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4LM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4LM.guiupdate = function() return end
	end
MobilityTable["4Gear-L-M"] = Gear4LM

local Gear4LL = {}
	Gear4LL.id = "4Gear-L-L"
	Gear4LL.ent = "acf_gearbox"
	Gear4LL.type = "Mobility"
	Gear4LL.name = "4-Speed, Inline, Large"
	Gear4LL.desc = "A large, heavy and sturdy 4 speed inline gearbox"
	Gear4LL.model = "models/engines/linear_l.mdl"
	Gear4LL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4LL.weight = 500
	Gear4LL.switch = 0.6
	Gear4LL.maxtq = 6000
	Gear4LL.gears = 4
	Gear4LL.doubleclutch = false
	Gear4LL.geartable = {}
		Gear4LL.geartable[-1] = 1
		Gear4LL.geartable[0] = 0
		Gear4LL.geartable[1] = 0.1
		Gear4LL.geartable[2] = 0.2
		Gear4LL.geartable[3] = 0.4
		Gear4LL.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4LL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4LL.guiupdate = function() return end
	end
MobilityTable["4Gear-L-L"] = Gear4LL




-- 4 speed inline dual clutch gearboxes
local Gear4TLS = {}
	Gear4TLS.id = "4Gear-LD-S"
	Gear4TLS.ent = "acf_gearbox"
	Gear4TLS.type = "Mobility"
	Gear4TLS.name = "4-Speed, Inline Dual Clutch, Small"
	Gear4TLS.desc = "A small, and light 4 speed inline gearbox, with a somewhat limited max torque rating. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear4TLS.model = "models/engines/linear_s.mdl"
	Gear4TLS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TLS.weight = 65
	Gear4TLS.switch = 0.3
	Gear4TLS.maxtq = 80
	Gear4TLS.gears = 4
	Gear4TLS.doubleclutch = true
	Gear4TLS.geartable = {}
		Gear4TLS.geartable[-1] = 0.5
		Gear4TLS.geartable[0] = 0
		Gear4TLS.geartable[1] = 0.1
		Gear4TLS.geartable[2] = 0.2
		Gear4TLS.geartable[3] = 0.4
		Gear4TLS.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TLS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TLS.guiupdate = function() return end
	end
MobilityTable["4Gear-LD-S"] = Gear4TLS

local Gear4TLM = {}
	Gear4TLM.id = "4Gear-LD-M"
	Gear4TLM.ent = "acf_gearbox"
	Gear4TLM.type = "Mobility"
	Gear4TLM.name = "4-Speed, Inline Dual Clutch, Medium"
	Gear4TLM.desc = "A medium sized, 4 speed inline gearbox. The dual clutch allows you to apply power and brake each side independently"
	Gear4TLM.model = "models/engines/linear_m.mdl"
	Gear4TLM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4TLM.weight = 200
	Gear4TLM.switch = 0.4
	Gear4TLM.maxtq = 550
	Gear4TLM.gears = 4
	Gear4TLM.doubleclutch = true
	Gear4TLM.geartable = {}
		Gear4TLM.geartable[-1] = 0.5
		Gear4TLM.geartable[0] = 0
		Gear4TLM.geartable[1] = 0.1
		Gear4TLM.geartable[2] = 0.2
		Gear4TLM.geartable[3] = 0.4
		Gear4TLM.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4TLM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4TLM.guiupdate = function() return end
	end
MobilityTable["4Gear-LD-M"] = Gear4TLM

local Gear4LDL = {}
	Gear4LDL.id = "4Gear-LD-L"
	Gear4LDL.ent = "acf_gearbox"
	Gear4LDL.type = "Mobility"
	Gear4LDL.name = "4-Speed, Inline Dual Clutch, Large"
	Gear4LDL.desc = "A large, heavy and sturdy 4 speed inline gearbox. The dual clutch allows you to apply power and brake each side independently"
	Gear4LDL.model = "models/engines/linear_l.mdl"
	Gear4LDL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear4LDL.weight = 650
	Gear4LDL.switch = 0.6
	Gear4LDL.maxtq = 6000
	Gear4LDL.gears = 4
	Gear4LDL.doubleclutch = true
	Gear4LDL.geartable = {}
		Gear4LDL.geartable[-1] = 1
		Gear4LDL.geartable[0] = 0
		Gear4LDL.geartable[1] = 0.1
		Gear4LDL.geartable[2] = 0.2
		Gear4LDL.geartable[3] = 0.4
		Gear4LDL.geartable[4] = 0.8
	if ( CLIENT ) then
		Gear4LDL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear4LDL.guiupdate = function() return end
	end
MobilityTable["4Gear-LD-L"] = Gear4LDL




-- 6 speed normal inline gearboxes
local Gear6LS = {}
	Gear6LS.id = "6Gear-L-S"
	Gear6LS.ent = "acf_gearbox"
	Gear6LS.type = "Mobility"
	Gear6LS.name = "6-Speed, Inline, Small"
	Gear6LS.desc = "A small and light 6 speed inline gearbox, with a limited max torque rating."
	Gear6LS.model = "models/engines/linear_s.mdl"
	Gear6LS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6LS.weight = 70
	Gear6LS.switch = 0.3
	Gear6LS.maxtq = 70
	Gear6LS.gears = 6
	Gear6LS.doubleclutch = false
	Gear6LS.geartable = {}
		Gear6LS.geartable[-1] = 0.5
		Gear6LS.geartable[0] = 0
		Gear6LS.geartable[1] = 0.1
		Gear6LS.geartable[2] = 0.2
		Gear6LS.geartable[3] = 0.3
		Gear6LS.geartable[4] = 0.4
		Gear6LS.geartable[5] = 0.5
		Gear6LS.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6LS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6LS.guiupdate = function() return end
	end
MobilityTable["6Gear-L-S"] = Gear6LS

local Gear6LM = {}
	Gear6LM.id = "6Gear-L-M"
	Gear6LM.ent = "acf_gearbox"
	Gear6LM.type = "Mobility"
	Gear6LM.name = "6-Speed, Inline, Medium"
	Gear6LM.desc = "A medium duty 6 speed inline gearbox with a limited torque rating."
	Gear6LM.model = "models/engines/linear_m.mdl"
	Gear6LM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6LM.weight = 250
	Gear6LM.switch = 0.4
	Gear6LM.maxtq = 400
	Gear6LM.gears = 6
	Gear6LM.doubleclutch = false
	Gear6LM.geartable = {}
		Gear6LM.geartable[-1] = 0.5
		Gear6LM.geartable[0] = 0
		Gear6LM.geartable[1] = 0.1
		Gear6LM.geartable[2] = 0.2
		Gear6LM.geartable[3] = 0.3
		Gear6LM.geartable[4] = 0.4
		Gear6LM.geartable[5] = 0.5
		Gear6LM.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6LM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6LM.guiupdate = function() return end
	end
MobilityTable["6Gear-L-M"] = Gear6LM

local Gear6LL = {}
	Gear6LL.id = "6Gear-L-L"
	Gear6LL.ent = "acf_gearbox"
	Gear6LL.type = "Mobility"
	Gear6LL.name = "6-Speed, Inline, Large"
	Gear6LL.desc = "Heavy duty 6 speed inline gearbox, however not as resilient as a 4 speed."
	Gear6LL.model = "models/engines/linear_l.mdl"
	Gear6LL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6LL.weight = 700
	Gear6LL.switch = 0.6
	Gear6LL.maxtq = 6000
	Gear6LL.gears = 6
	Gear6LL.doubleclutch = false
	Gear6LL.geartable = {}
		Gear6LL.geartable[-1] = 1
		Gear6LL.geartable[0] = 0
		Gear6LL.geartable[1] = 0.1
		Gear6LL.geartable[2] = 0.2
		Gear6LL.geartable[3] = 0.3
		Gear6LL.geartable[4] = 0.4
		Gear6LL.geartable[5] = 0.5
		Gear6LL.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6LL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6LL.guiupdate = function() return end
	end
MobilityTable["6Gear-L-L"] = Gear6LL





-- 6 speed dual clutch inline gearboxes
local Gear6LDS = {}
	Gear6LDS.id = "6Gear-LD-S"
	Gear6LDS.ent = "acf_gearbox"
	Gear6LDS.type = "Mobility"
	Gear6LDS.name = "6-Speed, Inline Dual Clutch, Small"
	Gear6LDS.desc = "A small and light 6 speed inline gearbox, with a limited max torque rating. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear6LDS.model = "models/engines/linear_s.mdl"
	Gear6LDS.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6LDS.weight = 100
	Gear6LDS.switch = 0.3
	Gear6LDS.maxtq = 70
	Gear6LDS.gears = 6
	Gear6LDS.doubleclutch = true
	Gear6LDS.geartable = {}
		Gear6LDS.geartable[-1] = 0.5
		Gear6LDS.geartable[0] = 0
		Gear6LDS.geartable[1] = 0.1
		Gear6LDS.geartable[2] = 0.2
		Gear6LDS.geartable[3] = 0.3
		Gear6LDS.geartable[4] = 0.4
		Gear6LDS.geartable[5] = 0.5
		Gear6LDS.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6LDS.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6LDS.guiupdate = function() return end
	end
MobilityTable["6Gear-LD-S"] = Gear6LDS

local Gear6LDM = {}
	Gear6LDM.id = "6Gear-LD-M"
	Gear6LDM.ent = "acf_gearbox"
	Gear6LDM.type = "Mobility"
	Gear6LDM.name = "6-Speed, Inline Dual Clutch, Medium"
	Gear6LDM.desc = "A a medium duty 6 speed inline gearbox. The added gears reduce torque capacity substantially. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear6LDM.model = "models/engines/linear_m.mdl"
	Gear6LDM.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6LDM.weight = 400
	Gear6LDM.switch = 0.4
	Gear6LDM.maxtq = 400
	Gear6LDM.gears = 6
	Gear6LDM.doubleclutch = true
	Gear6LDM.geartable = {}
		Gear6LDM.geartable[-1] = 0.5
		Gear6LDM.geartable[0] = 0
		Gear6LDM.geartable[1] = 0.1
		Gear6LDM.geartable[2] = 0.2
		Gear6LDM.geartable[3] = 0.3
		Gear6LDM.geartable[4] = 0.4
		Gear6LDM.geartable[5] = 0.5
		Gear6LDM.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6LDM.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6LDM.guiupdate = function() return end
	end
MobilityTable["6Gear-LD-M"] = Gear6LDM

local Gear6LDL = {}
	Gear6LDL.id = "6Gear-LD-L"
	Gear6LDL.ent = "acf_gearbox"
	Gear6LDL.type = "Mobility"
	Gear6LDL.name = "6-Speed, Inline Dual Clutch, Large"
	Gear6LDL.desc = "Heavy duty 6 speed inline gearbox, however not as resilient as a 4 speed. The dual clutch allows you to apply power and brake each side independently\n\nThe Final Drive slider is a multiplier applied to all the other gear ratios"
	Gear6LDL.model = "models/engines/linear_l.mdl"
	Gear6LDL.sound = "vehicles/junker/jnk_fourth_cruise_loop2.wav"
	Gear6LDL.weight = 900
	Gear6LDL.switch = 0.6
	Gear6LDL.maxtq = 3500
	Gear6LDL.gears = 6
	Gear6LDL.doubleclutch = true
	Gear6LDL.geartable = {}
		Gear6LDL.geartable[-1] = 1
		Gear6LDL.geartable[0] = 0
		Gear6LDL.geartable[1] = 0.1
		Gear6LDL.geartable[2] = 0.2
		Gear6LDL.geartable[3] = 0.3
		Gear6LDL.geartable[4] = 0.4
		Gear6LDL.geartable[5] = 0.5
		Gear6LDL.geartable[6] = 0.6
	if ( CLIENT ) then
		Gear6LDL.guicreate = (function( Panel, Table ) ACFGearboxGUICreate( Table ) end or nil)
		Gear6LDL.guiupdate = function() return end
	end
MobilityTable["6Gear-LD-L"] = Gear6LDL


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