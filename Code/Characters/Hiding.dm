#define POORLY 1
#define WELL 2

character/var/is_hiding = FALSE
character/var/last_spotted = 0

character/var/perceptive_mark

character/proc/Hide()
	layer = 2
	is_hiding = TRUE

character/proc/UnHide()
	layer = MOB_LAYER
	is_hiding = FALSE

character/Move()
	. = ..()
	if(. && is_hiding)
		if(!locate(/structure/joining/table) in loc)
			UnHide()
		else
			var/turf/T = loc
			if(is_hiding > 1 && T.lit_value >= 2)
				for(var/client/C in game.players)
					C.images += perceptive_mark
				is_hiding = POORLY
			else if(T.lit_value < 2)
				for(var/client/C in game.players)
					C.images -= perceptive_mark
				is_hiding = WELL


character/humanoid/human/Hide()
	world << "Hiding..."
	if(!perceptive_mark)
		perceptive_mark = image('Icons/Markers/Perception.dmi',src,layer=MOB_LAYER)
	overlays -= body
	overlays -= hair
	overlays -= beard
	for(var/item/item in src)
		overlays -= item.slot.equip_image

	var/turf/T = loc
	if(T.lit_value >= 2)
		for(var/client/C in game.players)
			C.images += perceptive_mark
		is_hiding = POORLY
	else
		is_hiding = WELL

character/humanoid/human/UnHide()
	world << "Unhiding..."
	overlays += body
	overlays += hair
	overlays += beard
	if(is_hiding == POORLY)
		for(var/client/C in game.players)
			C.images -= perceptive_mark
	is_hiding = FALSE
	for(var/item/item in src)
		item.slot.OverlayEquipment()

//character/humanoid/AddEquipOverlay(img)
//	if(!is_hiding)
//		. = ..()