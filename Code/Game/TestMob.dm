mob/map_test/Login()
	game.map.ShowTo(src)
	wind_sound.Play(src)

mob/map_test/verb/CircularRoute()
	game.SelectRoute()
mob/map_test/verb/LinearRoute()
	game.SelectRoute(TRUE)

mob/map_test/verb/GrandSize()
	game.ports_in_route = game.map.ports.len
	world << "All ports selected."

mob/map_test/verb/StandardSize()
	game.ports_in_route = 4
	world << "Four ports selected."

mob/map_test/verb/BigSize()
	game.ports_in_route = 6
	world << "Six ports selected."

mob/map_test/verb/PrintTime()
	world << "Total: [parse_time(game.accumulated_time)]"
	world << "([parse_time(STD_CONVERSION(game.accumulated_time))] Standard)"
mob/map_test/verb/ClearTime()
	game.accumulated_time = 0
	world << "Time Cleared."