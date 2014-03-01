

var/player_hud/player_hud = new

/player_hud
	var/obj/display/drop/drop
	var/obj/display/swap/swap
	var/obj/display/equipment/l_hand
	var/obj/display/equipment/r_hand

	var/display_group/equip_group

	var/obj/display/equipment/hat
	var/obj/display/equipment/goggles
	var/obj/display/equipment/back
	var/obj/display/equipment/shirt
	var/obj/display/equipment/coat
	var/obj/display/equipment/gloves
	var/obj/display/equipment/boots
	var/obj/display/equipment/trousers

	var/obj/display/equipment/keys
	var/obj/display/equipment/belt
	var/obj/display/equipment/coat_pocket

	var/obj/display/equipment/l_pocket
	var/obj/display/equipment/r_pocket

	//var/display_group/container

/player_hud/New()
	l_hand = new("[HANDS_OFFSET]:8,1","L Hand")
	r_hand = new("[HANDS_OFFSET+1]:8,1","R Hand")
	drop = new("[HANDS_OFFSET]:8,2")
	swap = new("[HANDS_OFFSET+1]:8,2")

	equip_group = new

	equip_group.CreateOpenButton("1:8,1:8", "expand")
	equip_group.CreateCloseButton("1:8,1:8", "SW")

	hat = new("1:8,3:8", "Hat", "NW")
	goggles = new("2:8,3:8", "Goggles", "N")
	back = new("3:8,3:8", "Back", "NE")

	shirt = new("1:8,2:8", "Shirt", "W")
	coat = new("2:8,2:8", "Coat", "center")
	gloves = new("3:8,2:8", "Gloves", "E")

	boots = new("2:8,1:8", "Boots", "S")
	trousers = new("3:8,1:8", "Trousers", "SE")

	equip_group.Add(hat)
	equip_group.Add(goggles)
	equip_group.Add(back)

	equip_group.Add(shirt)
	equip_group.Add(coat)
	equip_group.Add(gloves)

	equip_group.Add(boots)
	equip_group.Add(trousers)

	/*container = new
	states = list("H<","H","H=","H","H=","H>")
	for(i = 1, i <= 6, i++)
		var/obj/display/equipment/box = new("[3+i]:16,2:8","Container [i]", states[i])
		container.Add(box)

	container.CreateOpenButton("4:16,2:8","expand-H")
	container.CreateCloseButton("10:16,2:8","close-H")*/
