client/proc/HShake(n, pow = 32)
	var/original_n = n
	var/multiplier = pow
	var/px = 0
	while(n > 0)
		pixel_x -= px
		px = rand() * multiplier
		pixel_x += px
		sleep(1)
		n -= 1
		multiplier *= -n/original_n
	pixel_x -= px

client/proc/VShake(n, pow = 32)
	var/original_n = n
	var/multiplier = pow
	var/py = 0
	while(n > 0)
		pixel_y -= py
		py = rand() * multiplier
		pixel_y += py
		sleep(1)
		n -= 1
		multiplier *= -n/original_n
	pixel_y -= py

client/proc/SlowShake(n)
	var/on = n
	var/multiplier = pick(-16,16)
	var/px = 0
	var/py = 0
	while(n > 0)
		pixel_x -= px
		px = min(max(-64*(n/on), px + rand() * multiplier), 64*(n/on))
		pixel_x += px
		pixel_y -= py
		if(prob(30)) py = pick(2,1,-1,-2)
		else py = 0
		pixel_y += py
		sleep(1)
		n -= 1
		multiplier *= -0.95
	pixel_x -= px
	pixel_y -= py