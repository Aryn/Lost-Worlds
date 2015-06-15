/route_type
	var/num_ports
	var/is_circular = TRUE
	proc/NextPort(list/available_ports)
		QuickSort(available_ports, /proc/Closest)
		return rand(1,min(4,available_ports.len))

/route_type/standard/num_ports = 4
/route_type/standard/linear/is_circular = FALSE

/route_type/big/num_ports = 6
/route_type/big/linear/is_circular = FALSE

/route_type/grand_tour/New()
	num_ports = game.NumberOfPorts()

/route_type/grand_tour/linear/is_circular = FALSE

/route_type/distant_ports/num_ports = 4
/route_type/distant_ports/NextPort(list/available_ports)
	QuickSort(available_ports, /proc/DistantPort)
	return rand(1,min(4,available_ports.len))

/proc/Closest(obj/map_point/port/A, obj/map_point/port/B)
	/*ASSERT(A)
	ASSERT(B)
	ASSERT(game)
	ASSERT(game.selected)*/
	var/distsq_a = DISTSQ(A.map_x - game.selected.map_x, A.map_y - game.selected.map_y)
	var/distsq_b = DISTSQ(B.map_x - game.selected.map_x, B.map_y - game.selected.map_y)

	return distsq_a - distsq_b

/proc/DistantPort(obj/map_point/port/A, obj/map_point/port/B)
	var/distsq_a = DISTSQ(A.map_x - game.selected.map_x, A.map_y - game.selected.map_y)
	var/distsq_b = DISTSQ(B.map_x - game.selected.map_x, B.map_y - game.selected.map_y)

	return abs(distsq_b-300) - abs(distsq_a-300)