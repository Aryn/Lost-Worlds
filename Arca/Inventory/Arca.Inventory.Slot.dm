/*
Defines a slot that can contain one item.
Example: Hands, back, ear, belt.
*/

/inv_slot
	var/name
	var/character/user

	var/equip_state
	var/equip_layer

	var/item/item
	var/original_layer
	var/hidden = FALSE

	var/obj/display/equipment/hud

/inv_slot/New(mob/user, name = "Inventory", obj/display/equipment/hud = null, equip_layer = 0)
	//world << "Made [name] for [user]."
	src.user = user
	src.name = name
	src.hud = hud
	src.equip_layer = equip_layer
	src.equip_state = "equipped-[ckey(name)]"

/inv_slot/proc/Set(item/item)
	//world << "Set [name] to [item]."
	item.SlotSet(src)
	src.item = item

	if(hud && !hidden)
		DisplayItem(0)

/inv_slot/proc/Clear()
	//world << "Unset [name]."
	item.SlotClear()
	if(hud)
		HideItem(0)
	src.item = null

/inv_slot/proc/DisplayItem(set_hidden = 1)
	if(set_hidden) hidden = FALSE
	if(item)
		item.screen_loc = hud.screen_loc
		original_layer = item.layer
		item.layer = HUD_LAYER+1
		user.AddHUD(item)

/inv_slot/proc/HideItem(set_hidden = 1)
	if(set_hidden) hidden = TRUE
	if(item)
		item.layer = original_layer
		user.RemoveHUD(item)

/inv_slot/proc/Check(item/item)
	return !src.item && item.data.equip_slots && item.data.equip_slots.Find(name)

/inv_slot/proc/AssignHUD(hud)
	src.hud = hud

/*
Simple implementation of a grabbing slot such as a hand.
*/

/inv_slot/grabber/Check(item/item)
	return !src.item