/*
Objects which exist in the world but cannot be picked up. Usually can be dragged unless anchored.
Examples: Portable canisters, shelves, machinery.
*/

/structure
	parent_type = /obj
	name = "Structure"
	layer = 2.5
	var/is_anchored = false