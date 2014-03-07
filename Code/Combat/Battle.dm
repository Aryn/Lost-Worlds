
client/Move(turf/T)
	var/character/C = mob
	if(istype(C) && C.combatant && !C.combatant.acting)
		if(C.combatant.boosts) C.combatant.Select(T, "MoveTo")
		else C << "\red You can't move this turn."
		return 0
	. = ..()

character/TryOperate(atom/A)
	if(combatant && !combatant.acting)
		combatant.Select(A, "Operate")
		return 0
	. = ..()

character/var/combatant/combatant

/battle
	var/list/combatants = list()
	var/list/choosing = list()

/battle/proc/Enter(character/C)
	for(var/combatant/c in combatants) c << "\red [C] has joined the battle."
	C.combatant = new(C,src)
	combatants += C.combatant
	choosing += C.combatant

/battle/proc/Next()
	world << "\red Arbitrary pause to confirm that nobody can just do shit..."
	sleep(20)
	for(var/combatant/combatant in combatants)
		combatant.Act()

	for(var/combatant/combatant in combatants)
		combatant.ProcessAttacks()

	choosing += combatants


/combatant
	var/battle/battle
	var/character/char

	var/boosts = 1

	var/list/combat_images = list()

	var/choosing = true
	var/acting = false
	var/list/attack_buffer = list() //Contains attacks this character has recieved between Act() and ProcessAttacks().

	var/atom/target //The target of an action.
	var/cmd         //The command to perform on the next battle tick. If this is null, the participant has no action yet.

/combatant/New(character/char, battle/battle)
	src.char = char
	src.battle = battle

/combatant/proc/Select(new_target, new_command)
	view(char) << "\green [char] selected [new_target]: [new_command]"
	target = new_target
	cmd = new_command

	if(choosing)
		battle.choosing -= src
		choosing = false
		if(!battle.choosing.len) battle.Next()

/combatant/proc/Act() //Each combatant performs an action,
	var/used_boost = false
	if(char.client) char.client.images -= combat_images
	view(char) << "<font color=yellow>[char] did [cmd] to [target].</font>"
	acting = true
	switch(cmd)
		if("MoveTo")
			char.Move(target)
			used_boost = true
		if("Operate")
			char.TryOperate(target)
		else
			call(target,cmd)()

	acting = false
	if(used_boost && boosts > 0) boosts--
	else if(boosts < 3) boosts++

/combatant/proc/ProcessAttacks()
	view(char) << "\red [char] takes any pending attacks."
	choosing = true

/combatant/proc/Leave()
	for(var/combatant/c in battle.combatants) c << "\red [char] left the battle!"
	battle.combatants -= src
	battle.choosing -= src
	char.combatant = null
	if(!battle.choosing.len) battle.Next()

character/verb/EnterBattle()
	var/battle/battle = new
	battle.Enter(src)

character/verb/LeaveBattle()
	combatant.Leave()