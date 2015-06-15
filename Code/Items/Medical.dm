var/process/process_bandage = new/process(/character/humanoid/human, "BandageHeal", /item/stack/bandages, 20,
"/user is wrapping /target in bandages...")

var/process/process_sutures = new/process(/character/humanoid/human, "SutureHeal", /item/medical/sutures, 60,
"/user is stitching /target's wounds...")

var/process/process_tweezers = new/process(/character/humanoid/human, "TweezerHeal", /item/medical/tweezers, 60,
"/user is pulling shrapnel out of /target...")

/item/stack/bandages
	name = "Bandages"
	icon_state = "stack"
	icon = 'Icons/Items/Medical/Bandages.dmi'
	max_stacks = 5
	stacks = 5


	ApplyTo(character/humanoid/human/injured)
		if(istype(injured) && process_bandage.Try(injured, slot.owner, src))
			return TRUE
		else
			. = ..()

/item/medical/sutures
	name = "Sutures"
	icon = 'Icons/Items/Medical/Sutures.dmi'
	var/character/blood

	ApplyTo(character/humanoid/human/injured)
		if(istype(injured) && process_sutures.Try(injured, slot.owner, src))
			return TRUE
		else
			. = ..()

/item/medical/tweezers
	name = "Tweezers"
	icon = 'Icons/Items/Medical/Tweezers.dmi'
	var/character/blood

	ApplyTo(character/humanoid/human/injured)
		if(istype(injured) && process_tweezers.Try(injured, slot.owner, src))
			return TRUE
		else
			. = ..()

character/humanoid/human/Examine()
	. = ..()
	if(temp_damage || recovery_damage) usr << "\blue [src] is wrapped in bandages."
	if(skin_damage) usr << "\red [src] looks scratched up."
	if(slash_damage) usr << "\red [src] has several serious cuts."
	if(shrapnel_damage) usr << "\red [src] is covered in puncture wounds."


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
	if(slash_damage > 15)
		slash_damage -= 15
		skin_damage += 5
		recovery_damage += 10
	else
		skin_damage += slash_damage / 3
		recovery_damage += slash_damage * 2 / 3
		slash_damage = 0

character/humanoid/human/proc/TweezerHeal(character/healer, item/medical/tweezers/tweezers)
	view(src) << "\green [src] is healed!"
	tweezers.icon_state = "blood"
	tweezers.blood = src
	if(shrapnel_damage > 15)
		shrapnel_damage -= 15
		slash_damage += 5
		recovery_damage += 10
	else
		slash_damage += shrapnel_damage / 3
		recovery_damage += shrapnel_damage * 2 / 3
		shrapnel_damage = 0