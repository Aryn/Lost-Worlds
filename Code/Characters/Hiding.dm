#define POORLY 1
#define WELL 2

character/var/is_hiding = false
character/var/last_spotted = 0

character/var/perceptive_mark

character/proc/Hide()
	layer = 2
	is_hiding = true

character/proc/UnHide()
	layer = MOB_LAYER
	is_hiding = false

character/Move()
	. = ..()
	if(. && is_hiding)
		if(!locate(/structure/table) in loc)
			UnHide()
		else
			var/turf/T = loc
			if(is_hiding > 1 && T.lit_value >= 2)
				for(var/client/C in game.players.contents)
					C.images += perceptive_mark
				is_hiding = POORLY
			else if(T.lit_value < 2)
				for(var/client/C in game.players.contents)
					C.images -= perceptive_mark
				is_hiding = WELL


character/player/Hide()
	world << "Hiding..."
	if(!perceptive_mark)
		perceptive_mark = image('Icons/Markers/Perception.dmi',src,layer=MOB_LAYER)
	overlays -= body
	overlays -= hair
	overlays -= beard
	for(var/item/item in src)
		overlays -= item.equip_image

	var/turf/T = loc
	if(T.lit_value >= 2)
		for(var/client/C in game.players.contents)
			C.images += perceptive_mark
		is_hiding = POORLY
	else
		is_hiding = WELL
character/player/UnHide()
	world << "Unhiding..."
	overlays += body
	overlays += hair
	overlays += beard
	if(is_hiding == POORLY)
		for(var/client/C in game.players.contents)
			C.images -= perceptive_mark
	is_hiding = false
	for(var/item/item in src)
		item.OnSlotSet(item.slot)

character/player/AddEquipOverlay(img)
	if(!is_hiding)
		. = ..()