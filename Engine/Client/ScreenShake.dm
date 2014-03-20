client/proc/HShake(n, pow = 32)
	var/original_n = n
	var/multiplier = pow
	while(n > 0)
		pixel_x = rand() * multiplier
		sleep(1)
		n -= 1
		multiplier *= -n/original_n
	pixel_x = 0

client/proc/VShake(n, pow = 32)
	var/original_n = n
	var/multiplier = pow
	while(n > 0)
		pixel_y = rand() * multiplier
		sleep(1)
		n -= 1
		multiplier *= -n/original_n
	pixel_y = 0

mob/verb/HShake()
	client.HShake(10)

mob/verb/VShake()
	client.VShake(3, 32)