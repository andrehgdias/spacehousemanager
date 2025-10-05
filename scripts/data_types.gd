class_name DataTypes

enum MissionStatus {
	Arriving,
	FailOnArrival,
	GameOver
}

enum Module {
	None,
	SleepingArea,
	Kitchen,
	Gym,
	Lab,
	Hub_Comms,
	Storage
}

static var Data: Dictionary = {
	Module.SleepingArea: {
		"title": "Dormitory",
		"price": 40000,
		"description": "This module has two slepping bags attached to the walls.

Very useful to expand the crew capacity of you habitat.

Width: 7 meters
Hight: 3 meters
Depth: 2.5 meters
Volume: 52,5 m³

+2 Crew size",
	},
	Module.Kitchen: {
		"title": "Kitchen",
		"price": 65000,
		"description": "This module contains multiple utensils for preparing food in space.

Here your crew can hidrate food, prepare and warm it up to enjoy a nice meal with an amazing view.

Width: 5 meters
Hight: 3 meters
Depth: 2.5 meters
Volume: 37,5 m³

+ Food"
	},
	Module.Gym: {
		"title": "Gym",
		"price": 55000,
		"description": "This module contains multiple machines to help your crew stay healthy and entertained.

Here your crew can workout using advanced machines dveloped by scients to work at 0 gravity.

Width: 5 meters
Hight: 3 meters
Depth: 3 meters
Volume: 45 m³

+ Health"
	},
	Module.Hub_Comms: {
		"title": "Hub/Comms",
		"price": 75000,
		"description": "This is the base module for any habitat/space station.

This module is the entry point for the habitat and has a docking station where a mission can arrive with their crew.

Width: 5 meters
Hight: 4 meters
Depth: 3 meters
Volume: 60 m³

Can deploy only one module of this type
+ Hability to receive new crew members"
	},
  Module.Lab: {
		"title": "Laboratory",
		"price": 80000,
		"description": "This module has a glove box and work stations for science work.

This area need to be sterillzed right after being used.
Crew members will work here and generate funds.

Width: 5 meters
Hight: 3 meters
Depth: 3 meters
Volume: 45 m³

+Generate funds from research",
	},
  Module.Storage: {
		"title": "Storage Room",
		"price": 10000,
		"description": "This module is dedicated to store goods, science products and human waste to returns the trash to Earth or burns up in the atmosphere.

This area is important for organization of the Space Station.

Width: 5 meters
Hight: 3 meters
Depth: 3 meters
Volume: 45 m³

+To do: next update",
	}
}

static func get_price(module: Module):
	return Data.get(module).price
