/item/stack
	var/singular_name
	var/plural_name
	var/stacks = 1
	var/max_stacks = 5

/item/stack/Consume()
	world << "Consumed a stack. Remaining: [stacks-1]"
	stacks--
	if(!stacks)
		world << "No stacks, erased."
		Erase()
	else if(stacks == 1)
		world << "One stack, changing to singular item."
		name = singular_name
		icon_state = ""

/item/stack/Applied(character/M, item/stack/I)
	if(I.type == type && I.stacks < I.max_stacks)
		I.stacks++
		if(I.stacks > 1)
			world << "Stacks > 1, Pluralizing."
			I.name = I.plural_name
			I.icon_state = "stack"
		Consume()
		M.Sound('Sounds/Inventory/Get.ogg')
		return TRUE
	else
		. = ..()

/*/item/stack/Swap(item_slot/other)
	if(istype(other,/item_slot/hand))
		var/item/stack/I = new type(other.owner)
		I.stacks = 1
		I.icon_state = ""
		I.name = I.singular_name
		Consume()
		other.Set(I)
		other.user.Sound('Sounds/Inventory/Get.ogg')
	else
		. = ..()*/