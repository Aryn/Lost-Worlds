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

	//button/slot_type/keys
	)

var/list/BUTTONS_HUMAN = newlist(
	/button/drop,
	/button/swap,
	/button/expand_slots
	)

/button/icon = 'Icons/HUD/Equip.dmi'

/button/drop
	icon_state = "drop"
	screen_loc = "7:13,2:5"

/button/drop/Pressed(character/user)
	user.active_slot.Drop(user.loc)

/button/swap
	icon_state = "swap"
	screen_loc = "8:13,2:5"

/button/swap/Pressed(character/user)
	user.ChangeActiveSlot()

/button/expand_slots
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
	icon_state = "center"
	screen_loc = "2:5,2:5"
	equip_state = "coat"
	group = 1

/button/slot_type/shirt
	icon_state = "W"
	screen_loc = "1:5,2:5"
	equip_state = "shirt"
	group = 1

/button/slot_type/trousers
	icon_state = "SE"
	screen_loc = "3:5,1:5"
	equip_state = "trousers"
	group = 1

/button/slot_type/goggles
	icon_state = "N"
	screen_loc = "2:5,3:5"
	equip_state = "goggles"
	group = 1

/button/slot_type/hat
	icon_state = "NW"
	screen_loc = "1:5,3:5"
	equip_state = "hat"
	group = 1

/button/slot_type/boots
	icon_state = "S"
	screen_loc = "2:5,1:5"
	equip_state = "boots"
	group = 1

/button/slot_type/gloves
	icon_state = "E"
	screen_loc = "3:5,2:5"
	equip_state = "gloves"
	group = 1

/button/slot_type/back
	icon_state = "NE"
	screen_loc = "3:5,3:5"
	equip_state = "back"
	group = 1

/*
Since active hands have a different icon, and the item slot system uses
one object per slot for all players, an overlay is used.
*/
var/obj/system/active_hand_icon/left/LEFT_HAND_ACTIVE = new
var/obj/system/active_hand_icon/right/RIGHT_HAND_ACTIVE = new

/obj/system/active_hand_icon/icon = 'Icons/HUD/Equip.dmi'
/obj/system/active_hand_icon/layer = UI_LAYER + 1
/obj/system/active_hand_icon/mouse_opacity = 0

/obj/system/active_hand_icon/left/icon_state = "active"
/obj/system/active_hand_icon/left/screen_loc = "8:13,1:5"
/obj/system/active_hand_icon/right/icon_state = "active"
/obj/system/active_hand_icon/right/screen_loc = "7:13,1:5"

/button/slot_type/hand/Accepts(obj/item/item)
	return 1

/button/slot_type/hand/left/equip_state = "left"
/button/slot_type/hand/left/screen_loc = "8:13,1:5"

/button/slot_type/hand/left/Activate(mob/owner)
	if(owner.client)
		owner.client.screen += LEFT_HAND_ACTIVE

/button/slot_type/hand/left/Deactivate(mob/owner)
	if(owner.client)
		owner.client.screen -= LEFT_HAND_ACTIVE

/button/slot_type/hand/right/equip_state = "right"
/button/slot_type/hand/right/screen_loc = "7:13,1:5"

/button/slot_type/hand/right/Activate(mob/owner)
	if(owner.client)
		owner.client.screen += RIGHT_HAND_ACTIVE

/button/slot_type/hand/right/Deactivate(mob/owner)
	if(owner.client)
		owner.client.screen -= RIGHT_HAND_ACTIVE