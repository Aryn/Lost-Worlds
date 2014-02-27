/*
Things with health, combat capability and the ability to use items.
*/

/character
	parent_type = /mob
	name = "Character"
	layer = 3.5
	var/inv_slot/active_slot

/character/proc/InRangeOf(atom/movable/A)
	return A.loc == src || src.loc == A || get_dist(src,A) <= 1

/character/proc/TryOperate(atom/movable/A)
	if(InRangeOf(A))
		TryRangedOperate(A)
	else if(active_slot.item)
		if(active_slot.item == A)
			A.OperatedBy(src)
		else if(A.AppliedBy(src,active_slot.item) == CONTINUE)
			active_slot.item.ApplyTo(A)
	else
		if(!istype(A,/item)) A.OperatedBy(src)
		else
			var/item/item = A
			if(active_slot.Check(item))
				if(!item.slot)
					item.PickUp(src,active_slot)
				else
					item.Swap(active_slot)

/character/proc/TryRangedOperate(atom/movable/A)
	if(active_slot.item)
		if(A.AppliedLongRange(src,active_slot.item) == CONTINUE)
			active_slot.item.ApplyLongRange(A)

/character/proc/DropItem()
	if(active_slot.item)
		active_slot.item.Drop(loc)