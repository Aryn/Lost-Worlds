character/var/combatant/combatant

var/list/clash_melee_sounds = list('Sounds/Combat/Miss1.ogg','Sounds/Combat/Miss2.ogg','Sounds/Combat/Miss3.ogg','Sounds/Combat/Miss4.ogg',
'Sounds/Combat/BlockMetal1.ogg','Sounds/Combat/BlockMetal2.ogg','Sounds/Combat/BlockMetal3.ogg','Sounds/Combat/BlockMetal4.ogg',
'Sounds/Combat/BlockSword1.ogg','Sounds/Combat/BlockSword2.ogg')

var/list/clash_gun_sounds = list('Sounds/Combat/DodgeBullet1.ogg','Sounds/Combat/DodgeBullet2.ogg','Sounds/Combat/DodgeBullet3.ogg',
'Sounds/Combat/Ricochet1.ogg','Sounds/Combat/Ricochet2.ogg','Sounds/Combat/Ricochet3.ogg','Sounds/Combat/Ricochet4.ogg')

var/list/clash_punch_sounds = list('Sounds/Combat/Punch1.ogg','Sounds/Combat/Punch2.ogg','Sounds/Combat/BlockPunch.ogg')

var/hit_sounds = list('Sounds/Combat/Blunt1.ogg','Sounds/Combat/Blunt2.ogg','Sounds/Combat/Blunt3.ogg','Sounds/Combat/Blunt4.ogg')

var/slash_sounds = list('Sounds/Combat/Sword1.ogg','Sounds/Combat/Sword2.ogg','Sounds/Combat/Sword3.ogg')

var/fist_sounds = list('Sounds/Combat/Punch1.ogg','Sounds/Combat/Punch2.ogg')


proc/Battle(character/A, character/B)
	ASSERT(istype(A))
	ASSERT(istype(B))
	if(A == B) return
	if(A.combatant) A.combatant.deck.AddCombatant(B)
	else if(B.combatant) B.combatant.deck.AddCombatant(A)
	else
		var/b_deck/battle = new
		battle.AddCombatant(A)
		battle.AddCombatant(B)


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