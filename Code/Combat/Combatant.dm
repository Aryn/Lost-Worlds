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

/combatant
	var/character/char
	var/combat_ai/ai

	var/list/enemies = list()

	var/b_deck/deck

	var/list/hand = list()
	var/b_card/hole

	var/total = 0
	var/high_aces = 0

	var/chosen = FALSE
	var/stand = FALSE

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
			stand = FALSE
		chosen = FALSE
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
	chosen = TRUE

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
	chosen = TRUE
	stand = TRUE

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
	chosen = FALSE
	if(stand) Stand()

/combatant/proc/Lose(combatant/atker)
	return atker.char.WinAgainst(char, FALSE)

/combatant/proc/Bust(combatant/atker)
	. = atker.char.WinAgainst(char, TRUE)
	deck.RemoveCombatant(src)
	char.stun(15)
	char << "Your hand:"
	for(var/b_card/card in hand)
		char << " - [card] ([card.value])"