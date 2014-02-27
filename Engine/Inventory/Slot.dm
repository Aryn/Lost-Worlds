/*
Defines a slot that can contain one item.
Example: Hands, back, ear, belt.
*/

/inv_slot
	var/name = "Inventory"
	var/mob/user
	var/equip_state = ""
	var/equip_layer = 0
	var/item/item

/inv_slot/New(mob/user)
	src.user = user

/inv_slot/proc/Set(item/item)
	item.OnSlotSet(src)
	src.item = item

/inv_slot/proc/Clear()
	item.OnSlotClear()
	src.item = null

/inv_slot/proc/Check(item/item)
	return !src.item && item.equip_slots && item.equip_slots.Find(name)

/*
Simple implementation of a grabbing slot such as a hand.
*/

/inv_slot/grabber/Check(item/item)
	return !src.item