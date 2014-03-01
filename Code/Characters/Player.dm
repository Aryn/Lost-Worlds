
/character/player
	form = "female"
	var/image/body
	var/obj/display/active_overlay

/character/player/SetupEquipmentSlots()
	slots = new
	slots["L Hand"] = new/inv_slot/grabber(src, "L Hand", player_hud.l_hand)
	slots["R Hand"] = new/inv_slot/grabber(src, "R Hand", player_hud.r_hand)

	AddHUD(player_hud.l_hand)
	AddHUD(player_hud.r_hand)

	AddHUD(player_hud.drop)
	AddHUD(player_hud.swap)

	active_overlay = new(player_hud.l_hand.screen_loc)
	active_overlay.icon_state = "active"
	active_overlay.mouse_opacity = 0

	AddHUD(active_overlay)

	CreateSlot("Hat", player_hud.hat)
	CreateSlot("Goggles", player_hud.goggles)
	CreateSlot("Back", player_hud.back)

	CreateSlot("Shirt", player_hud.shirt)
	CreateSlot("Coat", player_hud.coat)
	CreateSlot("Gloves", player_hud.gloves)

	CreateSlot("Boots", player_hud.boots)
	CreateSlot("Trousers", player_hud.trousers)

	player_hud.equip_group.Close(src)
	//player_hud.container.Close(src)

	active_slot = slots["L Hand"]

	body = image('Icons/Creatures/Players/Female.dmi',src)
	var/tone = rand(0,255)
	body.color = rgb(tone + rand(-25,25), tone, tone)
	body.layer = layer
	overlays += body

	var/image/hair = image('Icons/Creatures/Players/FemaleHair.dmi')
	hair.icon_state = pick(icon_states('Icons/Creatures/Players/FemaleHair.dmi'))
	hair.color = rgb(rand(0,255), rand(0,255), rand(0,255))
	hair.layer = layer+1
	overlays += hair

/character/player/SwapActiveSlot()
	if(active_slot == slots["L Hand"])
		active_slot = slots["R Hand"]
		active_overlay.screen_loc = player_hud.r_hand.screen_loc
	else
		active_slot = slots["L Hand"]
		active_overlay.screen_loc = player_hud.l_hand.screen_loc
	//UpdateHUD()

/character/player/proc/CreateSlot(slot_name, obj/hud, equip_layer = 0)
	if(!slots) slots = new
	var/inv_slot/slot = new/inv_slot(src,slot_name,equip_layer)
	slot.AssignHUD(hud)
	slots.Add(slot_name)
	slots[slot_name] = slot