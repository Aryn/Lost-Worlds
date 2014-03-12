item/weapon/sword
	icon = 'Icons/Items/Weapons/Sabre.dmi'
	icon_state = "sword"

item/weapon/sword/AnimateClash(character/opponent)
	slot.user.Sound(pick(clash_melee_sounds))
	CombatImage('Icons/Combat/CombatSlice.dmi', opponent)
	return 1

item/weapon/sword/WinAgainst(character/opponent, by_bust)
	slot.user.Sound(pick(slash_sounds))
	CombatImage('Icons/Combat/CombatSlice.dmi', opponent)
	opponent.brute(rand(8,12)*(by_bust+1))
	opponent.slash(rand(12,15)*(by_bust+1))
	return 1
