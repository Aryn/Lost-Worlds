/item/security
	var/code = "00000"
	proc/Check(item/security/other)
		return other.code == src.code

/item/security/lock
	name = "Lock"
	icon = 'Icons/Items/Lock/Lock.dmi'

	proc/CanOpenWith(item/key)
		return istype(key, /item/security/key) && Check(key)

	proc/CanOpen(character/opener)
		if(istype(opener,/character/humanoid))
			var/character/humanoid/human = opener
			if(CanOpenWith(human.left_hand.item)) return TRUE
			if(CanOpenWith(human.right_hand.item)) return TRUE
		else
			if(CanOpenWith(opener.active_slot.item)) return TRUE
		return FALSE

/item/security/key
	name = "Key"
	icon = 'Icons/Items/Lock/Key.dmi'
	equip_slot = "Keys"


/structure/marker/initial/lock
	icon = 'Icons/Markers/Lock.dmi'
	var/code = "00000"

	Initialize()
		var/structure/lockable/structure = locate() in loc
		if(structure)
			var/item/security/lock/lock = new
			lock.code = code
			structure.Lock(lock)

/structure/lockable
	proc/Lock(item/security/lock/lock)