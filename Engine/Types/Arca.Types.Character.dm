/*
Things with health, combat capability and the ability to use items.
*/

/character
	parent_type = /mob
	name = "Character"
	layer = 3.5
	var/inv_slot/active_slot
	var/list/slots
	var/RefSortedList/hud_objects
	var/RefSortedList/equip_images
	var/data/form/form //Allows clothes to fit differently on different characters.

/character/New()
	. = ..()
	SetupAppearance()
	SetupEquipmentSlots()
	SetupDamage()

/character/Login()
	. = ..()
	UpdateHUD()

//Called on startup. A handy way to organize initializers.
/character/proc/SetupEquipmentSlots()
/character/proc/SetupDamage()
/character/proc/SetupAppearance()

//Tries to perform an action with the target, taking into account their positions. Called by Click().
//If the target is out of range, control is passed to TryRangedOperate.
//If an item is equipped, first try the target's AppliedBy proc, then the item's more general ApplyTo.
//If no item is equipped and the target is an item,
// - if the active slot contains the item (using it on itself), operate it.
// - check that the active slot can hold it.
// - if the item is on the ground, pick it up.
// - if the item is equipped elsewhere, swap it to the active slot.
//If no item is equipped, but the target is not an item, operate it.

/character/proc/TryOperate(atom/movable/target)

	if(!InRangeOf(target))
		src << "Out of range."
		TryRangedOperate(target)

	else if(active_slot.item)
		src << "Have an item."
		if(active_slot.item == target)
			src << "Operated."
			target.OperatedBy(src)
		else if(target.AppliedBy(src,active_slot.item) == CONTINUE)
			active_slot.item.ApplyTo(target)

	else
		src << "No item."
		if(!istype(target,/item))
			src << "Target is not an item, operated."
			target.OperatedBy(src)
		else
			var/item/item = target
			if(active_slot.Check(item))
				if(!item.slot)
					item.PickUp(active_slot)
					src << "Picked up with [active_slot]."
				else
					item.Swap(active_slot)
					src << "Swapped to [active_slot]."
			else
				src << "No slot available."

//Performs nothing, AppliedLongRange(), or ApplyLongRange() with the target.
/character/proc/TryRangedOperate(atom/movable/target)
	if(active_slot.item)
		if(target.AppliedLongRange(src,active_slot.item) == CONTINUE)
			active_slot.item.ApplyLongRange(target)

/character/proc/DropItem()
	if(active_slot.item)
		active_slot.item.Drop(loc)

//Returns true if the character is in close range, false if character must use ranged proc variations.
/character/proc/InRangeOf(atom/movable/A)
	return A.loc == src || src.loc == A || get_dist(src,A) <= 1

/character/proc/OperateSlot(slot_name)
	var/inv_slot/operated = slots[slot_name]
	if(operated)
		if(active_slot.item)
			if(operated.Check(active_slot.item))
				active_slot.item.Swap(operated)
			else
				src << "\red You cannot equip this item there."

/character/proc/SwapActiveSlot()

/character/proc/ChangeForm(new_form)
	form = new_form
	for(var/slot_name in slots)
		var/inv_slot/slot = slots[slot_name]
		if(slot.item && slot.item.data.form_slots) slot.item.Swap(slot) //Resets any form equip states.