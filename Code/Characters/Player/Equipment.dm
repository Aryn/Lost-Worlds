var/list/ITEM_SLOTS_HUMAN = newlist(
	/button/slot_type/hand/left,
	/button/slot_type/hand/right,
	//Group 1
	/button/slot_type/coat,
	/button/slot_type/shirt,
	/button/slot_type/trousers,
	/button/slot_type/goggles,
	/button/slot_type/hat,
	/button/slot_type/boots,
	/button/slot_type/gloves,
	/button/slot_type/back,

	/button/slot_type/keys,
	/button/slot_type/belt
	)

var/list/BUTTONS_HUMAN = newlist(
	/button/drop,
	/button/swap,
	/button/expand_slots
	)

/button/icon = 'Icons/HUD/Equip.dmi'

/button/drop
	name = "Drop Item"
	icon_state = "drop"
	screen_loc = "7:13,2:5"

/button/drop/Pressed(character/user)
	user.active_slot.Drop(user.loc, user)

/button/swap
	name = "Swap Active Hand"
	icon_state = "swap"
	screen_loc = "8:13,2:5"

/button/swap/Pressed(character/user)
	user.ChangeActiveSlot()

/button/expand_slots
	name = "Show/Hide Equipment Slots"
	icon_state = "expand"
	screen_loc = "1:5,1:5"

/button/expand_slots/Pressed(character/user)

	for(var/item_slot/slot in user.item_slots)
		if(slot.slot_type.group == 1)
			if(slot.shown)
				slot.Hide()
				icon_state = "expand"
			else
				slot.Show()
				icon_state = "SW"

/button/slot_type/coat
	name = "Coat"
	icon_state = "center"
	screen_loc = "2:5,2:5"
	equip_state = "Coat"
	group = 1

/button/slot_type/shirt
	name = "Shirt"
	icon_state = "W"
	screen_loc = "1:5,2:5"
	equip_state = "Shirt"
	group = 1

/button/slot_type/trousers
	name = "Trousers"
	icon_state = "SE"
	screen_loc = "3:5,1:5"
	equip_state = "Trousers"
	group = 1

/button/slot_type/goggles
	name = "Goggles"
	icon_state = "N"
	screen_loc = "2:5,3:5"
	equip_state = "Goggles"
	group = 1

/button/slot_type/hat
	name = "Hat"
	icon_state = "NW"
	screen_loc = "1:5,3:5"
	equip_state = "Hat"
	group = 1

/button/slot_type/boots
	name = "Boots"
	icon_state = "S"
	screen_loc = "2:5,1:5"
	equip_state = "Boots"
	group = 1

/button/slot_type/gloves
	name = "Gloves"
	icon_state = "E"
	screen_loc = "3:5,2:5"
	equip_state = "Gloves"
	group = 1

/button/slot_type/back
	name = "Back"
	icon_state = "NE"
	screen_loc = "3:5,3:5"
	equip_state = "Back"
	group = 1

/button/slot_type/keys
	name = "Keys"
	icon_state = "keys"
	screen_loc = "4:12, 1:5"
	equip_state = "Keys"

/button/slot_type/belt
	name = "Belt"
	icon_state = "belt"
	screen_loc = "5:19, 1:5"
	equip_state = "Belt"
	Accepts(item/item)
		return 1

/*
Since active hands have a different icon, and the item slot system uses
one object per slot for all players, an overlay is used.
*/
var/obj/system/active_hand_icon/left/LEFT_HAND_ACTIVE = new
var/obj/system/active_hand_icon/right/RIGHT_HAND_ACTIVE = new

/obj/system/active_hand_icon
	icon = 'Icons/HUD/Equip.dmi'
	layer = UI_LAYER + 1
	mouse_opacity = 0

/obj/system/active_hand_icon/left
	icon_state = "active"
	screen_loc = "8:13,1:5"

/obj/system/active_hand_icon/right
	icon_state = "active"
	screen_loc = "7:13,1:5"

/button/slot_type/hand/Accepts(obj/item/item)
	return 1

/button/slot_type/hand/left
	name = "Left Hand"
	equip_state = "Left Hand"
	screen_loc = "8:13,1:5"

/button/slot_type/hand/left/Activate(mob/owner)
	if(owner.client)
		owner.client.screen += LEFT_HAND_ACTIVE

/button/slot_type/hand/left/Deactivate(mob/owner)
	if(owner.client)
		owner.client.screen -= LEFT_HAND_ACTIVE

/button/slot_type/hand/right
	name = "Right Hand"
	equip_state = "Right Hand"
	screen_loc = "7:13,1:5"

/button/slot_type/hand/right/Activate(mob/owner)
	if(owner.client)
		owner.client.screen += RIGHT_HAND_ACTIVE

/button/slot_type/hand/right/Deactivate(mob/owner)
	if(owner.client)
		owner.client.screen -= RIGHT_HAND_ACTIVE