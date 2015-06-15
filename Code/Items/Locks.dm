/item/security
	var/code = "00000"
	proc/Check(item/security/other)
		return other.code == src.code

/item/security/lock
	name = "Lock"
	icon = 'Icons/Items/Lock/Lock.dmi'

/item/security/key
	name = "Key"
	icon = 'Icons/Items/Lock/Key.dmi'