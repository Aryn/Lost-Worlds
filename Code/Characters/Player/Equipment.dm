var/list/ITEM_SLOTS_HUMAN = newlist(
	/button/slot_type/hand/left,
	/button/slot_type/hand/right,
	/*button/slot_type/coat,
	/button/slot_type/shirt,
	/button/slot_type/goggles,
	/button/slot_type/hat,
	/button/slot_type/boots,
	/button/slot_type/gloves,
	/button/slot_type/trousers,
	/button/slot_type/keys,
	/button/slot_type/back,*/
	)

var/list/BUTTONS_HUMAN = newlist(
	/button/drop,
	/button/swap,
	/button/expand_slots
	)

/button/icon = 'Icons/HUD/Equip.dmi'
/button/drop/icon_state = "drop"
/button/drop/screen_loc = "7:13,2:5"
/button/drop/Pressed(character/user)
	user.active_slot.Drop(user.loc)

/button/swap/icon_state = "swap"
/button/swap/screen_loc = "8:13,2:5"
/button/swap/Pressed(character/user)
	user.ChangeActiveSlot()

/button/expand_slots/icon_state = "expand"
/button/expand_slots/screen_loc = "1:5,1:5"
/button/expand_slots/Pressed(character/user)

	for(var/item_slot/slot in user.item_slots)
		if(slot.slot_type.group == 1)
			if(slot.shown)
				slot.Hide()
				icon_state = "expand"
			else
				slot.Show()
				icon_state = "SW"

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

/character/humanoid/var/item_slot/left_hand
/character/humanoid/var/item_slot/right_hand

/character/humanoid/human/New()
	. = ..()
	item_slots = list()
	for(var/button/slot_type/slot_type in ITEM_SLOTS_HUMAN)
		var/item_slot/slot = new(slot_type, src)
		if(slot_type.name == "left") left_hand = slot
		else if(slot_type.name == "right") right_hand = slot

		item_slots.Add(slot)

/character/humanoid/human/Login()
	. = ..()
	for(var/item_slot/slot in item_slots)
		slot.Show()
	for(var/button/button in BUTTONS_HUMAN)
		button.Show(src)
	if(!active_slot)
		left_hand.Activate()

/character/humanoid/ItemSlot(slot_name)
	for(var/item_slot/slot in item_slots)
		if(slot.slot_type.name == slot_name) return slot

/character/humanoid/ChangeActiveSlot()
	if(active_slot == left_hand) right_hand.Activate()
	else left_hand.Activate()