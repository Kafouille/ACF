
-- Electric motors

ACF_DefineEngine( "Electric-Small", {
	name = "Electric motor, Small",
	desc = "A small electric motor, loads of torque, but low power\n\nElectric motors provide huge amounts of torque, but are very heavy",
	model = "models/engines/emotorsmall2.mdl",
	sound = "acf_engines/electric_small.wav",
	category = "Electric",
	weight = 250,
	torque = 400,
	flywheelmass = 0.25,
	idlerpm = 10,
	peakminrpm = 10,
	peakmaxrpm = 10,
	limitrpm = 10000,
	iselec = true,
	elecpower = 98,
	flywheeloverride = 5000
} )

ACF_DefineEngine( "Electric-Medium", {
	name = "Electric motor, Medium",
	desc = "A medium electric motor, loads of torque, but low power\n\nElectric motors provide huge amounts of torque, but are very heavy",
	model = "models/engines/emotormed.mdl",
	sound = "acf_engines/electric_medium.wav",
	category = "Electric",
	weight = 850,
	torque = 1200,
	flywheelmass = 1.2,
	idlerpm = 10,
	peakminrpm = 10,
	peakmaxrpm = 10,
	limitrpm = 7000,
	iselec = true,
	elecpower = 208,
	flywheeloverride = 8000
} )

ACF_DefineEngine( "Electric-Large", {
	name = "Electric motor, Large",
	desc = "A huge electric motor, loads of torque, but low power\n\nElectric motors provide huge amounts of torque, but are very heavy",
	model = "models/engines/emotorlarge.mdl",
	sound = "acf_engines/electric_large.wav",
	category = "Electric",
	weight = 1900,
	torque = 3000,
	flywheelmass = 8,
	idlerpm = 10,
	peakminrpm = 10,
	peakmaxrpm = 10,
	limitrpm = 4500,
	iselec = true,
	elecpower = 340,
	flywheeloverride = 6000
} )
