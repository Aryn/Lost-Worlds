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

	var/equip_data/equip_data
	var/image/equip_image //Obtained from equip data, current equip overlay.

/item/New()
	. = ..()
	SetEquipData()

//Called when an item goes from a map location to a slot in a mob's inventory.
//Implementation of pickup code can vary between slots.
/item/proc/PickUp(inv_slot/slot)
	slot.Set(src)
	src.ForceMove(slot.user)
	slot.user.UpdateHUD()

//Called when an item drops from a mob's inventory to a map location.
/item/proc/Drop(turf/maploc)
	var/character/user = slot.user
	slot.Clear()
	src.ForceMove(maploc)
	user.UpdateHUD()

//Called when an item is moved from one slot to another without moving to a turf.
/item/proc/Swap(inv_slot/next)
	var/inv_slot/prev = slot
	prev.Clear()
	next.Set(src)
	if(next.user != prev.user)
		prev.user.UpdateHUD()
		src.ForceMove(next.user)
	next.user.UpdateHUD()

/item/proc/OnSlotSet(inv_slot/slot)
	src.slot = slot
	var/equip_state = slot.equip_state
	if(equip_data.form_slots && equip_data.form_slots.Find(slot.name))
		equip_state = "[slot.equip_state]-[slot.user.form]"
	world << "Equip State: [equip_state]"
	equip_image = equip_data.images[equip_state]
	equip_image.color = color
	equip_image.alpha = alpha
	slot.user.overlays += equip_image

/item/proc/OnSlotClear()
	slot.user.overlays -= equip_image
	src.slot = null

/item/proc/SetEquipData()
	if(ispath(equip_data))
		var/equip_data/type_data = equip_data_types[equip_data]
		if(!type_data)
			type_data = new equip_data
			equip_data_types[equip_data] = type_data
		equip_data = type_data
	else
		loc = null
		CRASH("No equip data path for [type]")