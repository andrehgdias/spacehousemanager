class_name DataTypes

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
		"price": 50000,
		"description": "This module has two slepping bags attached to the walls.

Very useful to expand the crew capacity of you habitat.

+2 Crew size",
	},
	Module.Kitchen: {
		"title": "Kitchen",
		"price": 75000,
		"description": "This module contains multiple utensils for preparing food in space.

Here your crew can hidrate food, prepare and warm it up to enjoy a nice meal with an amazing view.

+ Food"
	},
	Module.Gym: {
		"title": "Gym",
		"price": 60000,
		"description": "This module contains multiple machines to help your crew stay healthy and entertained.

Here your crew can workout using advanced machines dveloped by scients to work at 0 gravity.

+ Health"
	}
}

static func get_price(module: Module):
	return Data.get(module).price
