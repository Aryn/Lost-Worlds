/data/item/stack
	var/singular_name
	var/plural_name

/data/item/stack/New(item/stack/from)
	. = ..()
	if(from.stacks == 1)
		if(!singular_name) singular_name = from.name
		if(!plural_name) plural_name = from.name + "s"
	else
		if(!plural_name) plural_name = from.name
		if(!singular_name) singular_name = copytext(from.name,1,length(from.name))

/item/stack
	var/stacks = 1
	var/max_stacks = 5

/item/stack/Consume()
	world << "Consumed a stack. Remaining: [stacks-1]"
	stacks--
	var/data/item/stack/stack_data = data
	if(!stacks)
		world << "No stacks, erased."
		Erase()
	else if(stacks == 1)
		world << "One stack, changing to singular item."
		name = stack_data.singular_name
		icon_state = ""

/item/stack/AppliedBy(character/M, item/stack/I)
	if(I.type == type && I.stacks < I.max_stacks)
		var/data/item/stack/stack_data = data
		I.stacks++
		if(I.stacks > 1)
			world << "Stacks > 1, Pluralizing."
			I.name = stack_data.plural_name
			I.icon_state = "stack"
		Consume()
		M.Sound('Sounds/Inventory/Get.ogg')
		M.UpdateHUD()
		return TRUE
	else
		. = ..()

/item/stack/Swap(inv_slot/other)
	if(istype(other,/inv_slot/grabber))
		var/item/stack/I = new type(other.user)
		I.stacks = 1
		I.icon_state = ""
		var/data/item/stack/stack_data = data
		I.name = stack_data.singular_name
		Consume()
		other.Set(I)
		other.user.Sound('Sounds/Inventory/Get.ogg')
		other.user.UpdateHUD()
	else
		. = ..()