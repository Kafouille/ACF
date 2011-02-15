local function HandleACFSeatAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

local function HandleACFPodAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER ) 
end

local Category = "Armoured Combat Framework"

-- local V =  {
				-- Name = "Standard Driver Pod", 
				-- Class = "prop_vehicle_prisoner_pod",
				-- Category = Category,

				-- Author = "Lazermaniac",
				-- Information = "Modified prisonpod for more realistic player damage",
				-- Model = "models/vehicles/driver_pod.mdl",
				-- KeyValues = {
								-- vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								-- limitview		=	"0"
							-- }
				-- Members = {
								-- HandleAnimation = HandleACFPodAnimation,
				-- }
-- }
-- list.Set( "Vehicles", "acf_pod", V )

-- local V = { 	
				-- // Required information
				-- Name = "Standard Pilot Seat", 
				-- Class = "prop_vehicle_prisoner_pod",
				-- Category = Category,

				-- // Optional information
				-- Author = "Lazermaniac",
				-- Information = "A generic seat for accurate damage modelling.",
				-- Model = "models/vehicles/pilot_seat.mdl",
				-- KeyValues = {
								-- vehiclescript	=	"scripts/vehicles/prisoner_pod.txt",
								-- limitview		=	"0"
							-- }
				-- Members = {
								-- HandleAnimation = HandleACFSeatAnimation,
							-- }
-- }
-- list.Set( "Vehicles", "acf_pilotseat", V )

local V = { 	
				// Required information
				Name = "Airboat Seat", 
				Class = "acf_battlepod",
				Category = Category,
				
				// Optional information
				Author = "Kafouille",
				Information = "A generic seat for accurate damage modelling.",
				Model = "models/vehicles/pilot_seat.mdl",

				KeyValues = {
					model = "models/vehicles/pilot_seat.mdl",
				}
}

list.Set( "Vehicles", "acf_battleseat", V )
