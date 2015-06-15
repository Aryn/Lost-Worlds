/character/humanoid

	desc = "A personish thing."

	can_select = TRUE
	var/image/body

	var/obj/display/active_overlay
	var/text_color

/character/humanoid/human
	form = "female"
	desc = "A person"

	var/image/hair
	var/image/beard

/character/proc/SetupAppearance()
/character/humanoid/human/SetupAppearance()
	color = "#FFFFFF"
	overlays += body
	overlays += hair
	overlays += beard

/character/humanoid/Login()
	. = ..()
	if(!client.in_game)
		world.log << "Added [client.key] to player list."
		game.players.Add(client)
		client.in_game = TRUE

client/Del()
	if(in_game)
		world.log << "Removed [key] from player list."
		game.players.Remove(src)
	. = ..()

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
		if(slot.slot_type.group) continue
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

/*character/player/ClientMoved()
	. = ..()
	if(client.last_moved > world.time-1)
		var/turf/T = loc
		if(isturf(T) && T.top && !T.top.muted_footstep)
			Sound(T.top.Footstep(),rand(10,25))*/

/*character/humanoid/SetupEquipmentSlots()
	slots = new
	slots["L Hand"] = new/item_slot/grabber(src, "L Hand", players.hud.l_hand)
	slots["R Hand"] = new/item_slot/grabber(src, "R Hand", players.hud.r_hand)

	AddHUD(players.hud.blank)

	AddHUD(players.hud.l_hand)
	AddHUD(players.hud.r_hand)

	AddHUD(players.hud.drop)
	AddHUD(players.hud.swap)

	active_overlay = new(players.hud.l_hand.screen_loc)
	active_overlay.icon_state = "active"
	active_overlay.mouse_opacity = 0

	AddHUD(active_overlay)

	CreateSlot("Hat", players.hud.hat)
	CreateSlot("Goggles", players.hud.goggles)
	CreateSlot("Back", players.hud.back)

	CreateSlot("Shirt", players.hud.shirt)
	CreateSlot("Coat", players.hud.coat)
	CreateSlot("Gloves", players.hud.gloves)

	CreateSlot("Boots", players.hud.boots)
	CreateSlot("Trousers", players.hud.trousers)

	CreateSlot("Keys", players.hud.keys)

	AddHUD(players.hud.keys)

	players.hud.equip_group.Close(src)
	//players.hud.container.Close(src)

	active_slot = slots["L Hand"]

/character/humanoid/SetupDamage()
	health_meter = new("1,1")
	AddHUD(health_meter)

/character/humanoid/SwapActiveSlot()
	if(active_slot == slots["L Hand"])
		active_slot = slots["R Hand"]
		active_overlay.screen_loc = players.hud.r_hand.screen_loc
	else
		active_slot = slots["L Hand"]
		active_overlay.screen_loc = players.hud.l_hand.screen_loc
	//UpdateHUD()

/character/humanoid/proc/CreateSlot(slot_name, obj/hud, equip_layer = 0)
	if(!slots) slots = new
	var/item_slot/slot = new/item_slot(src,slot_name,equip_layer)
	slot.AssignHUD(hud)
	slots.Add(slot_name)
	slots[slot_name] = slot
*/
