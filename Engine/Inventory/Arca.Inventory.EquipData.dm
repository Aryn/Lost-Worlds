var/list/equip_data_types = list()

/equip_data
	var/icon                   //The icon used for the equipment overlays.
	var/list/images = list()   //All overlay images for this equipment, mapped by icon state.
	var/layer = 0              //The layer of the equip images, added to MOB_LAYER.
	var/list/equip_slots       //Slots this item will fit into.
	var/list/form_slots        //Slots that modify the equipment state based on form. Null: Uses generic equip state for all slots.
	var/list/supported_forms   //Forms the icon has available when using form-fitting states. Null: All forms supported.
	var/default_form           //The default form that is used when a form is unsupported. Null: requires a supported form.

/equip_data/New()
	if(!icon) CRASH("No equip icon for equip data: [type]")
	var/list/states = icon_states(icon)
	for(var/state in states)
		var/image/image = image(icon = icon, icon_state = state, layer = MOB_LAYER+layer)
		image.color = "#FF0000FF"
		images[state] = image