/data/form
	var/name
	var/image/body
	var/image/example
	var/icon/hair_icon
	var/list/hair_images = list()
	var/bearded = false //You can have bearded ladies, but your beard won't carry over with gender swaps in edit mode.

/data/form/male
	name = "male"
	body = 'Icons/Creatures/Players/Male.dmi'
	hair_icon = 'Icons/Creatures/Players/MaleHair.dmi'
	bearded = true

/data/form/female
	name = "female"
	body = 'Icons/Creatures/Players/Female.dmi'
	hair_icon = 'Icons/Creatures/Players/FemaleHair.dmi'

/data/form/New()
	example = image(body, icon_state="example", layer=MOB_LAYER+0.5)
	body = image(body, layer=MOB_LAYER)
	for(var/state in icon_states(hair_icon))
		hair_images[state] = image(icon = hair_icon, icon_state = state, layer = HAIR_LAYER)

/character/player/ChangeForm(form_name)
	form = players.forms[form_name]
	for(var/slot_name in slots)
		var/inv_slot/slot = slots[slot_name]
		if(slot.item && slot.item.data.form_slots) slot.item.Swap(slot) //Resets any form equip states.

	overlays -= body
	body = form.body
	overlays += body