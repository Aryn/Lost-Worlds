/*
Objects which are small enough to be picked up and handled.
Examples: Uniforms, guns, medical kits, backpacks.
*/

/item
	parent_type = /obj
	name = "Item"
	layer = 3

	//The slot this item is currently equipped to, if any. Only holds a value when inside a mob.
	var/inv_slot/slot

	//By default, a list containing the names of slots this item can be equipped in.
	//Does not need to contain slots whose Check() procs don't use this list, such as hands.
	var/list/equip_slots

	//Contains the icon with overlays for equip states.
	var/image/equip_icon
	var/equip_icon_initialized = false

//Called when an item goes from a map location to a slot in a mob's inventory.
//Implementation of pickup code can vary between slots.
/item/proc/PickUp(inv_slot/slot)
	slot.Set(src)
	src.ForceMove(slot.user)

//Called when an item drops from a mob's inventory to a map location.
/item/proc/Drop(turf/maploc)
	slot.Clear()
	src.ForceMove(maploc)

//Called when an item is moved from one slot to another without moving to a turf.
/item/proc/Swap(inv_slot/next)
	var/inv_slot/prev = slot
	prev.Clear()
	next.Set(src)
	if(next.user != prev.user) src.ForceMove(next.user)

/item/proc/OnSlotSet(inv_slot/slot)
	src.slot = slot
	if(!equip_icon_initialized)
		equip_icon = image(equip_icon, slot.user, icon_state = slot.equip_state, dir = slot.user.dir, layer = slot.equip_layer)
		equip_icon_initialized = true
	else
		equip_icon.icon_state = slot.equip_state
		equip_icon.layer = slot.equip_layer
	slot.user.overlays += equip_icon

/item/proc/OnSlotClear()
	slot.user.overlays -= equip_icon
	src.slot = null