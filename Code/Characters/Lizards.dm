
var/list/active_lizards = list()
var/running_lizards = FALSE

proc/RunLizards()
	running_lizards = TRUE
	while(active_lizards.len)
		sleep(6)
		for(var/character/lizard/lizard in active_lizards)
			spawn(rand(0,2)) lizard.Run()

character/lizard
	name = "\improper Lizard"
	icon = 'Icons/Creatures/Lizards/Lizard.dmi'
	icon_state = "underbelly"

	var/coat_color = "#555555"
	var/image/coat

	var/character/target
	var/delay = 0

character/lizard/proc/Run()
	if(IsStunned())
		delay = 0 //Prevents combined stun+delay time.
		return
	if(delay)
		delay--
		return

	if(combatant)
		return

	if(!target)
		var/list/targets = list()
		for(var/character/humanoid/player in view(src,5))
			if(!istype(player, /character/lizard)) targets.Add(player)

		if(targets.len)
			target = pick(targets)
		else delay = 5

	else
		if(get_dist(src,target) > 5 || target.IsStunned())
			target = null
			return
		step_to(src,target)
		if(get_dist(src,target) <= 1)
			if(target.combatant)
				target.combatant.deck.AddCombatant(src)
			else
				var/b_deck/battle = new
				battle.AddCombatant(src)
				battle.AddCombatant(target)

character/lizard/New()
	. = ..()
	coat = image('Icons/Creatures/Lizards/Lizard.dmi', icon_state="coat", layer=MOB_LAYER)
	coat.color = coat_color
	overlays += coat
	combat_ai = new combat_ai
	active_lizards += src
	if(!running_lizards) RunLizards()

character/lizard/blue
	coat_color = "#00AAAA"
	combat_ai = /combat_ai/stop_on_eleven

character/lizard/green
	coat_color = "#00AA00"
	combat_ai = /combat_ai/dealer

character/lizard/Life()
	if(dead) return
	archived_damage = damage()
	if(slash_damage > 15 || archived_damage > 30) Die()

	if(temp_damage > 2) temp_damage -= 2
	else temp_damage = 0

	if(recovery_damage > 0.1) recovery_damage -= 0.1
	else recovery_damage = 0

	if(stun_time) stun_time -= 0.5
	if(ko_time)
		ko_time -= 0.5
		if(!ko_time && !dead) transform = new/matrix