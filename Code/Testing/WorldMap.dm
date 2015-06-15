mob/verb/PrintTravelTime()
	world << "Total: [parse_time(game.accumulated_time)]"
	world << "([parse_time(STD_CONVERSION(game.accumulated_time))] Standard)"

mob/verb/ClearTravelTime()
	game.accumulated_time = 0
	world << "Time Cleared."