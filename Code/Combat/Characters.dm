

character/Click()
	var/character/C = usr
	if(C.combatant && combatant && (C.combatant.deck == combatant.deck))
		C.combatant.ToggleEnemy(combatant)
	else
		. = ..()

//Opponent is who this character is attacking.
character/proc/AnimateClash(character/opponent)
	if(get_dist(src, opponent) <= 1)
		Sound(pick(clash_melee_sounds))
		CombatImage('Icons/Combat/CombatHit.dmi', opponent)
		return 1
	return 0

character/proc/WinAgainst(character/opponent, by_bust)
	if(get_dist(src, opponent) <= 1)
		Sound(pick(slash_sounds))
		CombatImage('Icons/Combat/CombatSlice.dmi', opponent)
		opponent.slash(rand(5,10) * (1 + by_bust))
		opponent.brute(rand(10,15) * (1 + by_bust))
		return 1

	for(var/i = 1, i <= 8, i++)
		step_to(src,opponent)
		sleep(1)

	if(by_bust)
		return WinAgainst(opponent,by_bust)
	else
		return 0

character/humanoid/human/AnimateClash(character/opponent)
	var/item/weapon/weapon = active_slot.item
	if(istype(weapon))
		if(get_dist(src, opponent) <= weapon.range)
			return weapon.AnimateClash(opponent)
	else
		if(get_dist(src, opponent) <= 1)
			if(!weapon)
				Sound(pick(clash_punch_sounds))
				CombatImage('Icons/Combat/CombatStrike.dmi', opponent)
				return 1
			else
				Sound(pick(clash_melee_sounds))
				CombatImage('Icons/Combat/CombatHit.dmi', opponent)
				return 1
	return 0

character/humanoid/human/WinAgainst(character/opponent, by_bust)
	var/item/weapon/weapon = active_slot.item
	if(istype(weapon))
		if(get_dist(src, opponent) <= weapon.range)
			return weapon.WinAgainst(opponent, by_bust)
	else
		if(get_dist(src, opponent) <= 1)
			if(!weapon)
				Sound(pick(fist_sounds))
				CombatImage('Icons/Combat/CombatStrike.dmi', opponent)
				opponent.brute(rand(5,8)*(by_bust+1))
				return 1
			else
				Sound(pick(hit_sounds))
				CombatImage('Icons/Combat/CombatHit.dmi', opponent)
				opponent.brute(rand(12,15)*(by_bust+1))
				return 1

	if(by_bust)
		return WinAgainst(opponent,by_bust)
	else
		return 0

proc/CombatImage(icon, targ)
	var/time = 1
	var/image/I = image(icon,targ,layer=101)
	world << I
	spawn
		while(time < 4)
			I.icon_state = "[time]"
			sleep(1)
			time++
		I.loc = null