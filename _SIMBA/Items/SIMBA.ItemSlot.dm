/item_slot/var/item/item
/item_slot/var/item_layer
/item_slot/var/button/slot_type/slot_type
/item_slot/var/image/equip_image
/item_slot/var/character/owner
/item_slot/var/shown = 0

/item_slot/New(button/slot_type/slot_type, mob/owner)
	src.slot_type = slot_type
	src.owner = owner

/item_slot/proc/Show()
	if(src.owner.client)
		world << "Showing [src.slot_type.equip_state]"
		//src.owner.client.screen += slot_type
		slot_type.Show(src.owner)
		if(item)
			src.owner.client.screen += item
	else
		world << "Failed to show [src.slot_type.equip_state]"
	shown = 1

/item_slot/proc/Hide()
	if(src.owner.client)
		world << "Hiding [src.slot_type.equip_state]"
		slot_type.Hide(src.owner)
		if(item)
			src.owner.client.screen -= item
	else
		world << "Failed to hide [src.slot_type.equip_state]"
	shown = 0

/item_slot/proc/Deactivate()
	slot_type.Deactivate(owner)

/item_slot/proc/Activate()
	if(owner.active_slot) owner.active_slot.Deactivate()
	world << "Activated: [slot_type.equip_state]"
	owner.active_slot = src
	world << "Slot Type: [slot_type.type]"
	slot_type.Activate(owner)

/item_slot/proc/TryEquip(item/item)
	if(slot_type.Accepts(item,owner))
		ForceEquip(item)
		return 1
	else
		return 0

/item_slot/proc/ForceEquip(item/item)
	if(item.slot)
		item.slot._Clear()
		item.OnSwap(src)

	item.slot = src
	item_layer = item.layer
	item.layer = UI_LAYER+2
	item.screen_loc = slot_type.screen_loc

	src.item = item

	OverlayEquipment()

	if(owner.client)
		owner.client.screen += item

/item_slot/proc/_Clear()
	if(!item) return
	if(owner.client)
		owner.client.screen -= item

	item.layer = item_layer
	owner.overlays -= equip_image

	item.slot = null
	item = null

/item_slot/proc/Drop(atom/newloc)
	if(!item) return
	if(item.Move(newloc))
		item.OnDrop(newloc, owner)
		_Clear()

/item_slot/proc/OverlayEquipment()
	if(!item || !slot_type.shows_equipment) return
	if(!equip_image) equip_image = image(layer = MOB_LAYER+1+item.equip_layer/10)
	equip_image.icon = item.icon
	equip_image.icon_state = slot_type.equip_state
	if(item.respects_form && slot_type.name == item.equip_slot)
		equip_image.icon_state += "-[owner.form]"
	equip_image.color = item.color
	owner.overlays += equip_image