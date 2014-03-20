/quadrant
	var/minx = 0
	var/maxx = 48
	var/miny = 0
	var/maxy = 48

/quadrant/upper
	miny = 48
	maxy = 96

/quadrant/right
	minx = 48
	maxx = 96

/quadrant/upper_right
	minx = 48
	maxx = 96
	miny = 48
	maxy = 96

/raindrop
	var/x = 0
	var/y = 0
	var/state
	var/speed

/raindrop/New(x,y)
	src.x = x
	src.y = y
	state = pick("drop1","drop2","drop2","drop3","drop4","drop4")
	speed = pick(4,6,8,12,12)

/raindrop/proc/Next()
	x -= speed
	y -= speed
	if(x < 0) x += 96
	if(y < 0) y += 96
	var/icon/drop_icon = icon('Icons/Area/Weather96.dmi', state)
	drop_icon.Shift(EAST, x, 1)
	drop_icon.Shift(NORTH, y, 1)
	return drop_icon

/raindrop/dust/New(x,y)
	src.x = x
	src.y = y
	state = pick("particle1","particle1","particle2")
	speed = pick(8,12,12,16,16,18)

/raindrop/dust/Next()
	y -= speed
	if(y < 0) y += 96
	var/icon/drop_icon = icon('Icons/Area/Weather96.dmi', state)
	drop_icon.Shift(EAST, x, 1)
	drop_icon.Shift(NORTH, y, 1)
	return drop_icon

/*mob/verb/MakeRainIcon()
	var/list/drops = list()
	for(var/quadrant/quad in newlist(/quadrant,/quadrant/upper,/quadrant/right,/quadrant/upper_right))
		for(var/i = 1, i <= 64, i++)
			var/raindrop/drop = new(rand(quad.minx,quad.maxx), rand(quad.miny,quad.maxy))
			drops.Add(drop)

	var/icon/base = icon('Icons/Area/Weather96.dmi', "blank")
	for(var/fnum = 1, fnum <= 24, fnum++)
		var/icon/frame = icon('Icons/Area/Weather96.dmi',"blank")
		for(var/d = 1, d <= drops.len, d++)
			var/raindrop/drop = drops[d]
			frame.Blend(drop.Next(),ICON_OVERLAY)

		base.Insert(frame, icon_state = "", frame=fnum)

	src << ftp(base, "Rain.dmi")*/

mob/verb/MakeDustIcon()
	var/list/drops = list()
	for(var/quadrant/quad in newlist(/quadrant,/quadrant/upper,/quadrant/right,/quadrant/upper_right))
		for(var/i = 1, i <= 32, i++)
			var/raindrop/dust/drop = new(rand(quad.minx,quad.maxx), rand(quad.miny,quad.maxy))
			drops.Add(drop)

	var/icon/base = icon('Icons/Area/Weather96.dmi', "blank")
	for(var/fnum = 1, fnum <= 16, fnum++)
		var/icon/frame = icon('Icons/Area/Weather96.dmi',"blank")
		for(var/d = 1, d <= drops.len, d++)
			var/raindrop/drop = drops[d]
			frame.Blend(drop.Next(),ICON_OVERLAY)

		base.Insert(frame, icon_state = "", frame=fnum)

	src << ftp(base, "Dust.dmi")