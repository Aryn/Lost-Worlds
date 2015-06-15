#define EVERY(X) if(!(event_time % (X)))

var/event_time = 0
var/data/ticks/ticks = new
data/ticks/var
	life = TRUE
	map = TRUE
	ship_sway = TRUE
	steam = TRUE
	lizard = TRUE
	weather = TRUE
	turbulence = TRUE

mob/verb/TickStop(tick_name as text)
	ticks.vars[tick_name] = FALSE
	world << "Stopped [tick_name]."

hook/game_start/proc/StartEvents()
	spawn
		for()
			sleep(1)
			RunEvents()
	return TRUE

proc/RunEvents()
	event_time++
	if(event_time > 100) event_time = 0
	if(ticks.life)
		EVERY(LIFE_TICK_SPEED) game.TickCharacters()
	if(ticks.map)
		EVERY(MAP_TICK_SPEED)  game.TickMap()

	if(ticks.ship_sway)
		EVERY(3) ShipSway()

	EVERY(5)
		if(ticks.steam) steam_controller.Tick()
		//if(ticks.lizard) RunLizards()

	if(ticks.weather) EVERY(rand(8,12)) weather.Tick()
	if(ticks.turbulence) EVERY(rand(8,12)) TurbulenceLoop()

#undef EVERY