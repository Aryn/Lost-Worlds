/item/OnPickup(inv_slot/slot)
	slot.user.Sound('Sounds/Inventory/Get.ogg')

/item/OnDrop(turf/maploc, character/user)
	Sound('Sounds/Inventory/Drop.ogg')

/item/OnSwap(inv_slot/next)
	next.user.Sound('Sounds/Inventory/Equip.ogg',30)