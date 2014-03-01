
var/data/player/players = new
data/player/var/list/online = list()

/character/player
	form = "female"
	var/image/body
	var/obj/display/active_overlay
	var/skin_tone
	var/hair_color
	var/text_color

/character/player/SetupAppearance()

	form = players.forms[pick(players.forms)]

	body = form.body
	skin_tone = rand(40,200)
	body.color = rgb(skin_tone*1.2, skin_tone, skin_tone)
	body.layer = layer
	overlays += body

	var/image/hair = form.hair_images[pick(form.hair_images)]
	hair_color = rgb(rand(0,255), rand(0,255), rand(0,255))
	hair.color = hair_color
	overlays += hair

	text_color = rgb(rand(120,255), rand(120,255), rand(120,255))

	if(form.name == "male")
		var/image/beard = players.beards[pick(players.beards)]
		beard.color = hair.color
		overlays += beard

/character/player/SetupEquipmentSlots()
	AddHUD(players.hud.blank)

	slots = new
	slots["L Hand"] = new/inv_slot/grabber(src, "L Hand", players.hud.l_hand)
	slots["R Hand"] = new/inv_slot/grabber(src, "R Hand", players.hud.r_hand)

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

	players.hud.equip_group.Close(src)
	//players.hud.container.Close(src)

	active_slot = slots["L Hand"]

/character/player/SwapActiveSlot()
	if(active_slot == slots["L Hand"])
		active_slot = slots["R Hand"]
		active_overlay.screen_loc = players.hud.r_hand.screen_loc
	else
		active_slot = slots["L Hand"]
		active_overlay.screen_loc = players.hud.l_hand.screen_loc
	//UpdateHUD()

/character/player/proc/CreateSlot(slot_name, obj/hud, equip_layer = 0)
	if(!slots) slots = new
	var/inv_slot/slot = new/inv_slot(src,slot_name,equip_layer)
	slot.AssignHUD(hud)
	slots.Add(slot_name)
	slots[slot_name] = slot

/character/player/Login()
	. = ..()
	players.online.Add(client)

/character/player/Logout()
	players.online.Remove(client)

/character/player/ClientMoved()
	. = ..()
	if(client.last_moved > world.time-1)
		var/turf/T = loc
		if(isturf(T) && T.exposed_tile)
			Sound(T.exposed_tile.Footstep(),50)