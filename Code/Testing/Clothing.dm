
item/clothing/New()
	. = ..()
	color = rgb(rand(0,255),rand(0,255),rand(0,255))

item/clothing/coat
	name = "Coat"
	icon = 'Icons/Items/Clothes/Jacket.dmi'
	equip_data = /equip_data/coat

item/clothing/coat/transparent
	name = "Weird Transparent Coat"
	alpha = 128

equip_data/coat
	icon = 'Icons/Items/Clothes/Jacket.dmi'
	equip_slots = list("Coat","Trousers","Hat","Goggles","Belt","Gloves","Back")
	form_slots = list("Coat")
	layer = 0.2

item/clothing/shirt
	name = "Shirt"
	icon = 'Icons/Items/Clothes/Shirt.dmi'
	equip_data = /equip_data/shirt

equip_data/shirt
	icon = 'Icons/Items/Clothes/Shirt.dmi'
	equip_slots = list("Shirt","Trousers","Hat","Goggles","Belt","Gloves","Back")
	form_slots = list("Shirt")
	layer = 0.1

item/clothing/trousers
	name = "Trousers"
	icon = 'Icons/Items/Clothes/Trousers.dmi'
	equip_data = /equip_data/trousers

equip_data/trousers
	icon = 'Icons/Items/Clothes/Trousers.dmi'
	equip_slots = list("Trousers")
	form_slots = list("Trousers")