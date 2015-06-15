structure/steam/powered/binary
	var/pipenet/net_A
	var/pipenet/net_B
	var/delta_A = 0
	var/delta_B = 0

structure/steam/powered/binary/connect(structure/steam/pipe/pipe, pipe_dir)
	var/pipenet/net
	var/delta
	if(connect_dir != 0 && !(connect_dir & pipe_dir)) return 0

	if(src.dir & pipe_dir)
		if(!net_B)
			net_B = pipe.net
			net = net_B
			delta = delta_B
	else
		if(!net_A)
			net_A = pipe.net
			net = net_A
			delta = delta_A

	if(!net) return

	net.machines.Add(src)
	if(delta > 0) net.PushPower(delta)
	else net.PullPower(-delta)

	return 1

structure/steam/powered/binary/disconnect(pipenet/oldnet)
	var/delta

	if(oldnet == net_A)
		delta = delta_A
		net_A = null
	else if(oldnet == net_B)
		delta = delta_B
		net_B = null
	else
		return

	if(!oldnet.invalid)
		oldnet.machines.Remove(src)
		if(delta > 0) oldnet.PushPower(-delta)
		else oldnet.PullPower(delta)

structure/steam/powered/binary/swap(pipenet/A, pipenet/B)
	var/delta

	if(net_A == A)
		net_A = B
		delta = delta_A
	else if(net_B == A)
		net_B = B
		delta = delta_B
	else
		return

	B.machines.Add(src)
	if(delta > 0) B.PushPower(delta)
	else B.PullPower(-delta)

structure/steam/powered/binary/proc/setdelta_A(newdelta)
	if(delta_A > 0) net_A.PushPower(-delta_A)
	else net_A.PullPower(delta_A)
	delta_A = newdelta
	if(delta_A > 0) net_A.PushPower(delta_A)
	else net_A.PullPower(-delta_A)

structure/steam/powered/binary/proc/setdelta_B(newdelta)
	if(delta_B > 0) net_B.PushPower(-delta_B)
	else net_B.PullPower(delta_B)
	delta_B = newdelta
	if(delta_B > 0) net_B.PushPower(delta_B)
	else net_B.PullPower(-delta_B)