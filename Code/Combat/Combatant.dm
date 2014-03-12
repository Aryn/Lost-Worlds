/*
To initialize an empty array a to a randomly shuffled copy of source whose length is not known:
  while source.moreDataAvailable
      j ? random integer with 0 ? j ? a.length
      if j = a.length
          a.append(source.next)
      else
          a.append(a[j])
          a[j] ? source.next
*/
#define FACE_DOWN 1

/combatant
	var/character/char
	var/combat_ai/ai

	var/list/enemies = list()

	var/b_deck/deck

	var/list/hand = list()
	var/b_card/hole

	var/total = 0
	var/high_aces = 0

	var/chosen = false
	var/stand = false

/combatant/New(character/char, b_deck/deck)
	src.char = char
	if(char.combat_ai)
		ai = char.combat_ai
		ai.my_com = src
	src.deck = deck

/combatant/proc/ToggleEnemy(combatant/com)
	if(com in enemies)
		enemies -= com
		char << "<b>[com.char] is now an <font color=green>Ally</font>."
	else
		enemies += com
		char << "<b>[com.char] is now an <font color=red>Enemy</font>."

/combatant/proc/Start()
	//Reinitialize the game as part of a new round.
	if(hand.len)
		hand.Cut()
		total = 0
		high_aces = 0
		if(stand)
			char << "Unstood."
			if(istype(char,/character/humanoid))
				deck.pcs++
				players.hud.combat.Open(char)
			stand = false
		chosen = false
		hole = null

	//if(!istype(char, /character/lizard))
	deck.Deal(src)
	deck.Deal(src, FACE_DOWN)
	if(istype(char,/character/humanoid)) players.hud.combat.Open(char)
	//else
	//	deck.Deal(src)
	//	deck.Deal(src)

	shuffle(enemies)
	for(var/combatant/enemy in enemies)
		if(enemy.total < total)
			if(char.AnimateClash(enemy.char)) break

/combatant/proc/Hit()
	if(chosen) return
	view(char) << "\red [char] hits!"

	deck.chosen++
	chosen = true

	if(istype(char,/character/humanoid)) players.hud.combat.Close(char)
	if(deck.chosen >= deck.pcs && !ai)
		char << "All characters have chosen. Next round starting."
		deck.Next()
	else
		char << "[deck.chosen] / [deck.pcs] chosen."

/combatant/proc/Stand()
	if(chosen) return
	view(char) << "\blue [char] stands!"

	deck.chosen++
	chosen = true
	stand = true

	if(istype(char,/character/humanoid))
		players.hud.combat.Close(char)
		deck.pcs--
	if(deck.chosen >= deck.pcs && !ai)
		char << "All characters have chosen. Next round starting."
		deck.Next()
	else
		char << "[deck.chosen] / [deck.pcs] chosen."

/combatant/proc/Next()
	if(istype(char,/character/humanoid)) players.hud.combat.Open(char)
	chosen = false
	if(stand) Stand()

/combatant/proc/Lose(combatant/atker)
	return atker.char.WinAgainst(char, false)

/combatant/proc/Bust(combatant/atker)
	. = atker.char.WinAgainst(char, true)
	deck.RemoveCombatant(src)
	char.stun(15)
	char << "Your hand:"
	for(var/b_card/card in hand)
		char << " - [card] ([card.value])"