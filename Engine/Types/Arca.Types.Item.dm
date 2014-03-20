/*
Objects which are small enough to be picked up and handled.
Examples: Uniforms, guns, medical kits, backpacks.
*/

/item
	parent_type = /obj
	name = "Item"
	layer = 3
	can_select = true

	//The slot this item is currently equipped to, if any. Only holds a value when inside a mob.
	var/inv_slot/slot

	var/data/item/data
	var/image/equip_image //Obtained from equip data, current equip overlay.

/item/New()
	. = ..()
	SetData()

//Called when an item goes from a map location to a slot in a mob's inventory.
//Implementation of pickup code can vary between slots.
/item/proc/PickUp(inv_slot/slot)
	slot.Set(src)
	src.ForceMove(slot.user)
	slot.user.UpdateHUD()
	Sound('Sounds/Inventory/Get.ogg')
	if(light) light.Reset()

//Called when an item drops from a mob's inventory to a map location.
/item/proc/Drop(turf/maploc)
	var/character/user = slot.user
	slot.Clear()
	src.ForceMove(maploc)
	user.UpdateHUD()
	Sound('Sounds/Inventory/Drop.ogg')
	if(light) light.Reset()

//Called when an item is moved from one slot to another without moving to a turf.
/item/proc/Swap(inv_slot/next)
	var/inv_slot/prev = slot
	prev.Clear()
	next.Set(src)
	if(next.user != prev.user)
		prev.user.UpdateHUD()
		src.ForceMove(next.user)
	next.user.UpdateHUD()
	next.user.Sound('Sounds/Inventory/Equip.ogg',30)

/item/proc/Consume()
	Erase()

/item/Erase()
	if(slot) slot.Clear()
	. = ..()

/item/proc/OnSlotSet(inv_slot/slot)
	src.slot = slot
	var/equip_state = slot.equip_state
	if(data.form_slots && data.form_slots.Find(slot.name))
		equip_state = "[slot.equip_state]-[slot.user.form]"
	world << "Equip State: [equip_state]"
	equip_image = data.images[equip_state]
	equip_image.color = color
	equip_image.alpha = alpha
	slot.user.AddEquipOverlay(equip_image)

/item/proc/OnSlotClear()
	slot.user.RemoveEquipOverlay(equip_image)
	src.slot = null

/item/proc/SetData()
	if(ispath(data))
		var/data/item/type_data = item_data_types[data]
		if(!type_data)
			type_data = new data(src)
			item_data_types[data] = type_data
		data = type_data
	else
		var/data/item/type_data = item_data_types[type]
		if(!type_data)
			type_data = new /data/item(src)
			item_data_types[type] = type_data
		data = type_data