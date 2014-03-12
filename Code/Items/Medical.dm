var/process/process_bandage = new/process(/character/humanoid/human, "BandageHeal", /item/stack/bandages, 20,
"/user is wrapping /target in bandages...")

var/process/process_sutures = new/process(/character/humanoid/human, "SutureHeal", /item/medical/sutures, 60,
"/user is stitching /target's wounds...")

/item/stack/bandages
	name = "Bandages"
	icon_state = "stack"
	icon = 'Icons/Items/Medical/Bandages.dmi'
	max_stacks = 5
	stacks = 5


	ApplyTo(character/humanoid/human/injured)
		if(istype(injured) && process_bandage.Try(injured, slot.user, src))
			return SUCCESS
		else
			. = ..()

/item/medical/sutures
	name = "Sutures"
	icon = 'Icons/Items/Medical/Sutures.dmi'
	var/character/blood

	ApplyTo(character/humanoid/human/injured)
		if(istype(injured) && process_sutures.Try(injured, slot.user, src))
			return SUCCESS
		else
			. = ..()

character/humanoid/human/Examine()
	. = ..()
	if(temp_damage || recovery_damage) usr << "\blue [src] is wrapped in bandages."
	if(skin_damage) usr << "\red [src] looks scratched up."
	if(slash_damage) usr << "\red [src] has several serious cuts."


character/humanoid/human/proc/BandageHeal(character/healer, item/stack/bandages/bandages)
	view(src) << "\green [src] is healed!"
	bandages.Consume()
	healer.Sound('Sounds/Inventory/Bandage.ogg')
	if(skin_damage > 30)
		skin_damage -= 30
		temp_damage += 30
	else
		temp_damage += skin_damage
		skin_damage = 0

character/humanoid/human/proc/SutureHeal(character/healer, item/medical/sutures/sutures)
	view(src) << "\green [src] is healed!"
	sutures.icon_state = "blood"
	sutures.blood = src
	if(slash_damage > 10)
		slash_damage -= 10
		skin_damage += 10
		recovery_damage += 5
	else
		skin_damage += slash_damage
		recovery_damage += slash_damage/2
		slash_damage = 0