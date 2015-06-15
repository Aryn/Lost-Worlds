structure/steam/powered/unary
	var/pipenet/net
	var/delta = 0

structure/steam/powered/unary/connect(structure/steam/pipe/pipe, pipe_dir)
	if(connect_dir != 0 && !(connect_dir & pipe_dir)) return 0
	if(!net)
		net = pipe.net
		net.machines.Add(src)
		if(delta > 0) net.PushPower(delta)
		else net.PullPower(-delta)
	return 1

structure/steam/powered/unary/disconnect(pipenet/oldnet)
	if(oldnet != net) return
	net = null
	if(!oldnet.invalid)
		oldnet.machines.Remove(src)
		if(delta > 0) oldnet.PushPower(-delta)
		else oldnet.PullPower(delta)
	power_update()

structure/steam/powered/unary/swap(pipenet/A, pipenet/B)
	if(net != A) return
	net = B
	net.machines.Add(src)
	if(delta > 0) net.PushPower(delta)
	else net.PullPower(-delta)

structure/steam/powered/unary/proc/setdelta(newdelta)
	if(delta > 0) net.PushPower(-delta)
	else net.PullPower(delta)
	delta = newdelta
	if(delta > 0) net.PushPower(delta)
	else net.PullPower(-delta)