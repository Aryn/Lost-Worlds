/button/slot_type/var/equip_state
/button/slot_type/var/shows_equipment = 1
/button/slot_type/layer = UI_LAYER

/button/slot_type/proc/Accepts(item/item, character/user)
	return item.equip_slot == name

/button/slot_type/proc/Deactivate(character/owner)
/button/slot_type/proc/Activate(character/owner)

/button/slot_type/Pressed(character/user)
	var/item_slot/myslot = user.ItemSlot(name)
	if(myslot && user.active_slot.item)
		myslot.TryEquip(user.active_slot.item)