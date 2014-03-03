
/data/player/var/list/forms = list("male" = /data/form/male, "female" = /data/form/female)
/data/player/var/list/beards = 'Icons/Creatures/Players/Beards.dmi'
/data/player/var/image/eyebrows

/data/player/New()
	. = ..()
	var/list/beard_list = list()
	for(var/beard_type in icon_states(beards))
		beard_list[beard_type] = image(icon=beards,icon_state=beard_type,layer=MOB_LAYER+1.5)
	beards = beard_list

	for(var/form_name in forms)
		var/form_type = forms[form_name]
		var/data/form/form = new form_type
		forms[form_name] = form

	eyebrows = image('Icons/Creatures/Players/Features.dmi',icon_state="eyebrows",layer=MOB_LAYER+1.4)

/data/form
	var/name
	var/image/body
	var/icon/hair_icon
	var/list/hair_images = list()

/data/form/male
	name = "male"
	body = 'Icons/Creatures/Players/Male.dmi'
	hair_icon = 'Icons/Creatures/Players/MaleHair.dmi'

/data/form/female
	name = "female"
	body = 'Icons/Creatures/Players/Female.dmi'
	hair_icon = 'Icons/Creatures/Players/FemaleHair.dmi'

/data/form/New()
	if(!istype(body)) body = image(body, layer=MOB_LAYER+1)
	for(var/state in icon_states(hair_icon))
		hair_images[state] = image(icon = hair_icon, icon_state = state, layer = MOB_LAYER+1)

/character/player/ChangeForm(form_name)
	form = players.forms[form_name]
	for(var/slot_name in slots)
		var/inv_slot/slot = slots[slot_name]
		if(slot.item && slot.item.data.form_slots) slot.item.Swap(slot) //Resets any form equip states.

	overlays -= body
	body = form.body
	overlays += body