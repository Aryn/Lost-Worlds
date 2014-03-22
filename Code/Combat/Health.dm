character/var/skin_damage = 0     //Done by blunt instruments, and a component of burns. Requires bandaging.
character/var/slash_damage = 0    //Done by swords and other sharp things. A component of shrapnel. Requires treatment and stitches.
character/var/shrapnel_damage = 0 //Done by embedded objects such as bullets. Requires pulling out.
character/var/chem_damage = 0     //Done by chemical burns and poisons. Requires antitoxin.

character/var/recovery_damage = 0 //A long lasting form of damage occurring after treatment of serious injury. Goes away over time.
character/var/temp_damage = 0     //Goes away over a far shorter time.

character/var/stun_time = 0    //Seconds stunned for.
character/var/ko_time = 0      //Seconds KO'd for.
character/var/dead = FALSE     //Set when people are killed, which results in death.
character/var/critical = FALSE

character/var/archived_damage
character/var/obj/display/health_meter/health_meter

var/matrix/dead_matrix

character/proc/brute(amt)
	skin_damage += amt

character/proc/slash(amt)
	slash_damage += amt

character/proc/shrapnel(amt)
	shrapnel_damage += amt

character/proc/chem(amt)
	chem_damage += amt

character/proc/ko(n)
	ko_time = max(ko_time,n)
	if(ko_time)
		transform = dead_matrix
		Sound('Sounds/Combat/Collapse.ogg')
		view(src) << "<b>[src]</b> is unconscious!"

character/proc/stun(n)
	stun_time = max(stun_time, n)
	if(stun_time)
		view(src) << "<b>[src]</b> is stunned!"

character/proc/damage()
	return skin_damage + slash_damage + shrapnel_damage + chem_damage + recovery_damage + temp_damage

character/IsStunned()
	return stun_time > 0 || ko_time > 0 || dead

character/proc/Life()
	if(dead) return

	archived_damage = damage()
	if(archived_damage > MAX_HEALTH + 40) Die()
	else if(archived_damage > MAX_HEALTH && !critical)
		critical = TRUE
		ko(20)

	if(temp_damage > 2) temp_damage -= 2
	else temp_damage = 0

	if(recovery_damage > 0.05) recovery_damage -= 0.05
	else recovery_damage = 0

	if(stun_time) stun_time -= 0.5
	if(ko_time)
		ko_time -= 0.5
		if(!ko_time && !dead) transform = new/matrix

character/proc/Die()
	view(src) << "<b>[src]</b> dies!"
	if(!ko_time)
		transform = dead_matrix
		Sound('Sounds/Combat/Collapse.ogg')
	dead = TRUE

character/humanoid/human/Life()
	. = ..()
	if(health_meter.layer < HUD_LAYER && !dead && !ko_time) health_meter.layer = HUD_LAYER+1
	if(critical) move_delay = 6
	else if(archived_damage > MAX_HEALTH*0.6) move_delay = 4
	else move_delay = 2

	if(ko_time || dead)
		health_meter.icon_state = "blind"
		health_meter.layer = HUD_LAYER-1
	else
		switch(100 - (archived_damage * (100/MAX_HEALTH)))
			if(1 to 30)   health_meter.icon_state = "20"
			if(30 to 50)  health_meter.icon_state = "40"
			if(50 to 70)  health_meter.icon_state = "60"
			if(70 to 90)  health_meter.icon_state = "80"
			if(90 to 100) health_meter.icon_state = "100"