/character/humanoid/ChangeForm(form_name)
	form = players.forms[form_name]
	for(var/slot_name in slots)
		var/inv_slot/slot = slots[slot_name]
		if(slot.item && slot.item.data.form_slots) slot.item.Swap(slot) //Resets any form equip states.

	overlays -= body
	body = form.body
	overlays += body

/character/humanoid/GetContext()
	if(combatant) return BATTLE
	else return NORMAL