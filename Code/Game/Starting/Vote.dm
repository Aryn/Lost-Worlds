mob/verb/Vote()
	if(game.started) return
	var/vote = input(src, "Which route do you want?") in list("Standard Linear", "Standard Circular", "Big Linear", "Big Circular", "Grand Tour Linear", "Grand Tour Circular", "Distant Ports")

	switch(vote)
		if("Standard Linear") game.Start(new /route_type/standard/linear)
		if("Standard Circular") game.Start(new /route_type/standard)
		if("Big Linear") game.Start(new /route_type/big/linear)
		if("Big Circular") game.Start(new /route_type/big)
		if("Grand Tour Linear") game.Start(new /route_type/grand_tour/linear)
		if("Grand Tour Circular") game.Start(new /route_type/grand_tour)
		if("Distant Ports") game.Start(new/route_type/distant_ports)
		else world.log << "Invalid Route: [vote]"