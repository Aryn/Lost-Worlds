

var/footsteps_wood = list('Sounds/Footsteps/Wood1.ogg','Sounds/Footsteps/Wood2.ogg','Sounds/Footsteps/Wood3.ogg',
						  'Sounds/Footsteps/Wood4.ogg','Sounds/Footsteps/Wood5.ogg','Sounds/Footsteps/Wood6.ogg')
var/footsteps_metal = list('Sounds/Footsteps/Metal1.ogg','Sounds/Footsteps/Metal2.ogg','Sounds/Footsteps/Metal3.ogg',
						   'Sounds/Footsteps/Metal4.ogg','Sounds/Footsteps/Metal5.ogg','Sounds/Footsteps/Metal6.ogg')
var/footsteps_support = list('Sounds/Footsteps/Support1.ogg','Sounds/Footsteps/Support2.ogg','Sounds/Footsteps/Support3.ogg',
							 'Sounds/Footsteps/Support4.ogg','Sounds/Footsteps/Support5.ogg','Sounds/Footsteps/Support6.ogg')

tile/proc/Footstep()
	return pick(footsteps_wood)

tile/floor/metal/Footstep()
	return pick(footsteps_metal)