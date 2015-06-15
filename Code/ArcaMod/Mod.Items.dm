/item/OnPickup(item_slot/slot)
	slot.owner.Sound('Sounds/Inventory/Get.ogg')

/item/OnDrop(turf/maploc, character/user)
	Sound('Sounds/Inventory/Drop.ogg')

/item/OnSwap(item_slot/next)
	next.owner.Sound('Sounds/Inventory/Equip.ogg',30)