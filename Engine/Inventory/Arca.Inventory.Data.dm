/*
A data object holds data that would be wasteful for every object to have individually, e.g. equip icons.
It's a flyweight pattern for atoms.
*/

var/list/item_data_types = list()

/data/item
	var/icon                   //The icon used for the overlays. Images are generated at construction, changes have no effect.
	var/list/images = list()   //All overlay images for this equipment, mapped by icon state.
	var/layer = 0              //The layer of the equip images, added to MOB_LAYER.
	var/list/equip_slots       //Slots this item will fit into.
	var/list/form_slots        //Slots that modify the equipment state based on form. Null: Uses generic equip state for all slots.
	var/list/supported_forms   //Forms the icon has available when using form-fitting states. Null: All forms supported.
	var/default_form           //The default form that is used when a form is unsupported. Null: requires a supported form.

/data/item/New()
	if(!icon) CRASH("No equip icon for equip data: [type]")
	var/list/states = icon_states(icon)

	//Images are generated for each icon state besides the default.
	for(var/state in states)
		if(!IsEquipState(state)) continue
		var/image/image = image(icon = icon, icon_state = state, layer = MOB_LAYER+layer)
		images[state] = image

proc/IsEquipState(state)
	return dd_hasprefix(state,"equip")