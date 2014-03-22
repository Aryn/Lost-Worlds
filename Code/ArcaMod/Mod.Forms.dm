/char_form/var/image/body
/char_form/var/image/example
/char_form/var/icon/hair_icon
/char_form/var/list/hair_images = list()
/char_form/var/bearded = FALSE //You can have bearded ladies, but your beard won't carry over with gender swaps in edit mode.

/char_form/male
	name = "male"
	body = 'Icons/Creatures/Players/Male.dmi'
	hair_icon = 'Icons/Creatures/Players/MaleHair.dmi'
	bearded = TRUE

/char_form/female
	name = "female"
	body = 'Icons/Creatures/Players/Female.dmi'
	hair_icon = 'Icons/Creatures/Players/FemaleHair.dmi'

/char_form/New()
	example = image(body, icon_state="example", layer=MOB_LAYER+0.5)
	body = image(body, layer=MOB_LAYER)
	for(var/state in icon_states(hair_icon))
		hair_images[state] = image(icon = hair_icon, icon_state = state, layer = HAIR_LAYER)