
/character/var/combat_ai/combat_ai
/combat_ai/var/combatant/my_com

/combat_ai/proc/Run()
/combat_ai/proc/SelectAllies()
	for(var/combatant/com in my_com.deck.combatants)
		if(istype(com.char, /character/lizard))
			my_com.enemies -= com
			//view(my_com.char) << "[my_com.char] allied with [com.char]."

/combat_ai/dealer/Run()
	var/prob_of_winning = (21-my_com.total)*(80/21)
	//view(my_com.char) << "\green The Lizard has [my_com.total] and a [round(prob_of_winning)]% chance of a hit."
	if(my_com.total < 17 || (my_com.total == 17 && my_com.high_aces) || prob(prob_of_winning))
		my_com.Hit()
	else
		my_com.Stand()

/combat_ai/stop_on_eleven/Run()
	if(my_com.total < 11)
		my_com.Hit()
	else
		my_com.Stand()