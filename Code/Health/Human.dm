mob/human
	var
		max_health = 100
		blunt_damage = 0
		piercing_damage = 0
		projectile_damage = 0
		toxic_damage = 0
		internal_damage = 0
		permanent_damage = 0

		last_damage = 0
		list/stun_list = new
		list/ko_list = new
		is_stunned = 0
		is_down = 0
		is_dazed = 0
		stamina = 100

	HealthUpdate()
		if(GetStamina() < 100) Stamina(-1)
		if(blunt_damage > 0 && last_damage < world.time - 80) Healing("Blunt",0.5)

	StunChanged()
		setIconState(GetStunState())
		hair.icon_state = GetStunState()
		var/item/I
		if(!CanClick())
			dbg("[src] is down.")
			Sound('Sounds/Combat/Collapse.ogg')
			ExitFight(1)
			I = equipment.GetItem()
			if(I)
				I.Drop(src,loc)
				if(prob(50))
					step_rand(I)
			I = equipment.GetSupportItem()
			if(I)
				I.Drop(src,loc)
				if(prob(50))
					step_rand(I)
		for(I in src)
			I.UpdateEquipOverlay(src)
			dbg("Updated [I]")

	HealthChanged()
		if(client)
			winset(src,"Health","value=[GetHealth()]")
			winset(src,"Stamina","value=[GetStamina()]")

	GetHealth()
		return max_health - (blunt_damage + piercing_damage + projectile_damage + toxic_damage + internal_damage + permanent_damage)

	//#################

	Damage(dtype,amount)
		ASSERT(isnum(amount) && amount > 0)
		var/v = getDamageVariable(dtype)
		vars[v] += amount
		. = amount
		last_damage = world.time
		HealthChanged()

	Healing(dtype,amount)
		ASSERT(isnum(amount) && amount > 0)
		var/v = getDamageVariable(dtype)
		if(vars[v] >= amount)
			vars[v] -= amount
			. = amount
		else
			. = vars[v]
			vars[v] = 0
		HealthChanged()

	proc/getDamageVariable(dtype)
		var/variable_name = "[lowertext(dtype)]_damage"
		if(variable_name in vars)
			return variable_name
		else
			CRASH("Invalid damage type: "+dtype)

	//#################

	GetStamina()
		return 100

	Stamina(n)
		HealthChanged()

	Stun(source, time = 0)
		stun_list.Add(source)
		if(time > 0)
			spawn(time) UnStun(source)
		is_stunned = 1
		StunChanged()

	UnStun(source)
		stun_list.Remove(source)
		if(stun_list.len == 0)
			is_stunned = 0
		StunChanged()

	Down(source, time = 0)
		ko_list.Add(source)
		if(time > 0)
			spawn(time) Up(source)
		is_down = 1
		StunChanged()

	Up(source)
		ko_list.Remove(source)
		if(ko_list.len == 0)
			is_down = 0
		StunChanged()


	IsDown()
		return is_down
	IsStunned()
		return is_stunned

	GetStunState()
		if(is_down || is_stunned)
			return "down"
		else
			return ""

		//################

	CanClick()
		return !(is_stunned || is_down)
	CanMove()
		return !(is_stunned || is_down)

		//################

	CombatDaze(time = 10)
		Sound('Sounds/Combat/Dizzy.ogg',0)
		is_dazed++
		spawn(time)
			is_dazed--

	CombatIsDazed()
		return is_dazed