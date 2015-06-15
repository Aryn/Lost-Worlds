

proc/shuffle(list/L)
	ASSERT(L)
	for(var/i = 1, i <= L.len, i++)
		var/pos = rand(1,i)
		L.Swap(i,pos)


/b_deck
	var/list/cards = list()
	var/list/combatants = list()
	var/over = FALSE
	var/chosen = 0
	var/pcs = 0

/b_deck/New()
	Shuffle()

/b_deck/proc/Shuffle()
	for(var/suit in list("Swords","Hammers","Spears","Axes"))
		for(var/value = 1, value <= 10, value++)
			var/pos = rand(1,cards.len+1)
			if(pos == cards.len+1)
				cards.Add(new/b_card(suit,value))
			else
				cards.Add(cards[pos])
				cards[pos] = new/b_card(suit,value)

/b_deck/proc/AddCombatant(character/C)
	var/combatant/com = new(C,src)
	for(var/combatant/other in combatants)
		C << "Enemy of [other.char]."
		other.enemies.Add(com)
	combatants.Add(com)
	C.combatant = com
	view(C) << "\red [C] has joined the battle!"
	com.enemies = combatants.Copy() - com //At start, assume everyone is against you.
	if(!com.ai) pcs++
	else com.ai.SelectAllies()
	com.Start()
	//Ace+Ace will evaluate to 11, so no need to handle busting before allies are selected.


/b_deck/proc/RemoveCombatant(combatant/c)
	for(var/combatant/other in combatants)
		other.enemies.Remove(c)
	combatants.Remove(c)
	c.char.combatant = null
	if(!c.ai) pcs--
	c.enemies.Cut()
	if(istype(c.char,/character/humanoid))
		//c.char << "Closed."
		players.hud.combat.Close(c.char)

	//if(combatants.len <= 1)
	//	EndGame()

	//else if(chosen >= pcs)
	//	Next()

/b_deck/proc/Deal(combatant/com, facedown)
	var/b_card/dealt = cards[cards.len]
	cards.Cut(cards.len)

	if(facedown)
		oview(com.char) << " -- [com.char] is dealt a face-down card, \..."
		com.char << "-- [com.char] is dealt \a [dealt.name], \..."
		com.hole = dealt
	else
		view(com.char) << " -- [com.char] is dealt \a [dealt.name], \..."

	com.hand.Add(dealt)

	com.total += dealt.value
	if(dealt.value == 11) com.high_aces++

	while(com.total > 21 && com.high_aces)
		//Convert an ace to 1 instead of 11
		com.high_aces--
		com.total -= 10

	if(com.hole)
		com.char << "making [com.total]."
		oview(com.char) << "making at least [com.total-com.hole.value]"
	else
		view(com.char) << "making [com.total]."

	if(com.total > 21) com.Bust(pick(com.enemies)) //Spontaneously.

/b_deck/proc/AceInTheHole(combatant/com)
	var/b_card/dealt
	for(var/b_card/card in cards)
		if(card.value == 11)
			dealt = card
			break
	if(!dealt)
		dealt = new/b_card(pick("Swords","Hammers","Spears","Axes"),11) //Generate fifth ace.

	oview(com.char) << " -- [com.char] is dealt a face-down card, \..."
	com.char << "-- [com.char] is dealt \a [dealt.name], \..."
	com.hole = dealt

	com.hand.Add(dealt)

	com.total += dealt.value
	if(dealt.value == 11) com.high_aces++

	while(com.total > 21 && com.high_aces)
		//Convert an ace to 1 instead of 11
		com.high_aces--
		com.total -= 10

	if(com.hole)
		com.char << "making [com.total]."
		oview(com.char) << "making at least [com.total-com.hole.value]"
	else
		view(com.char) << "making [com.total]."


/b_deck/proc/Next()
	if(over) return
	var/game_end = TRUE
	for(var/combatant/c in combatants)
		if(c.ai) c.ai.Run()
		if(c.stand) continue
		else
			Deal(c)
			c.Next()
			shuffle(c.enemies)
			for(var/combatant/enemy in c.enemies)
				if(c.char.AnimateClash(enemy.char)) break
			game_end = FALSE

	chosen = 0

	world << "[chosen]/[pcs] ready."

	if(game_end || combatants.len == 1) EndGame()
	else if(chosen >= pcs) Next()

/b_deck/proc/EndGame()
	over = TRUE

	var/combatant/highest
	var/list/ties = list()
	for(var/combatant/c in combatants)
		if(!highest || c.total > highest.total)
			highest = c
			ties.Cut()
		else if(c.total == highest.total)
			ties.Add(c)

	var/next_round = FALSE

	if(!ties.len)
		for(var/combatant/loser in highest.enemies)
			if(!loser.Lose(highest)) next_round = TRUE
			else loser.char.stun(10)
	else
		ties.Add(highest)
		for(var/combatant/winner in ties)
			for(var/combatant/loser in winner.enemies)
				if(loser.total == highest.total)
					next_round = TRUE
					continue
				if(!loser.Lose(winner)) next_round = TRUE
				else loser.char.stun(10)

	world << "<b>Round Over</b>"
	world << "Result: [ties.len?"Tie!":"[highest.char] wins!"]"

	if(next_round)
		over = FALSE
		world << "\green <b>New Round!</b>"
		Shuffle()
		for(var/combatant/c in combatants)
			c.Start()
	else
		for(var/combatant/c in combatants)
			c.enemies.Cut()
			if(istype(c.char,/character/humanoid))
				players.hud.combat.Close(c.char)
			c.char.combatant = null
		combatants.Cut()


/b_card
	var/name
	var/suit
	var/value

/b_card/New(suit,value)
	src.suit = suit

	var/face
	switch(value)
		if(1)
			value = 11
			face = "Ace"
		if(2) face = "Two"
		if(3) face = "Three"
		if(4) face = "Four"
		if(5) face = "Five"
		if(6) face = "Six"
		if(7) face = "Seven"
		if(8) face = "Eight"
		if(9) face = "Nine"
		if(10) face = "Ten"
		if(11)
			value = 10
			face = "Jack"
		if(12)
			value = 10
			face = "Queen"
		if(13)
			value = 10
			face = "King"
		else
			face = "????"

	src.value = value //It is crucial that value be set here, after changing Ace to 11.

	name = "[face] of [suit]"