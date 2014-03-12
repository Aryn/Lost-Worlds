structure/controls
	icon = 'Icons/Ship/Equipment/Helm.dmi'
	icon_state = "controls"

	OperatedBy(character/humanoid/H)
		game.map.ShowTo(H, true)