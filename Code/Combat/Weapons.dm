
/*item/weapon/ApplyTo(character/C)
	if(istype(C))
		if(C.IsStunned() || C == slot.user)
			slot.user.WinAgainst(C)
		else
			Battle(slot.user, C)

item/weapon/gun/ApplyLongRange(character/C)
	if(istype(C))
		if(C.IsStunned() || C == slot.user)
			slot.user.WinAgainst(C)
		else
			Battle(slot.user, C)*/

item/weapon/var/range = 1

item/weapon/proc/AnimateClash(character/opponent)
	slot.user.Sound(pick(clash_melee_sounds))
	CombatImage('Icons/Combat/CombatHit.dmi', opponent)
	return 1

item/weapon/proc/WinAgainst(character/opponent, by_bust)
	slot.user.Sound(pick(hit_sounds))
	CombatImage('Icons/Combat/CombatHit.dmi', opponent)
	opponent.brute(rand(12,15)*(by_bust+1))
	return 1

item/weapon/gun/range = 8

item/weapon/gun/AnimateClash(character/opponent)
	slot.user.Sound(pick(clash_gun_sounds))
	CombatImage('Icons/Combat/CombatBlock.dmi', opponent)
	return 1

item/weapon/gun/WinAgainst(character/opponent, by_bust)
	slot.user.Sound('Sounds/Combat/RevolverShotCock.ogg')
	CombatImage('Icons/Combat/CombatStab.dmi', opponent)
	opponent.slash(rand(12,15)*(by_bust+1))
	opponent.shrapnel(rand(12,15)*(by_bust+1))
	return 1