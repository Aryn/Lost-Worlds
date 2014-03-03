proc/get_turf(atom/A)
	var/attempts = 15
	while(!isturf(A) && attempts-- > 0)
		A = A.loc
	return A

/data/screenloc
	var/x = 0
	var/pixel_x = 0
	var/y = 0
	var/pixel_y = 0

var/data/screenloc/_screenloc = new

proc/parse_screenloc(screenloc)
	var/colon = findtext(screenloc,":")
	_screenloc.x = text2num(copytext(screenloc,1,colon))
	var/comma = findtext(screenloc,",",colon)
	_screenloc.pixel_x = text2num(copytext(screenloc,colon+1,comma))
	colon = findtext(screenloc,":",comma)
	_screenloc.y = text2num(copytext(screenloc,comma+1,colon))
	_screenloc.pixel_y = text2num(copytext(screenloc,colon+1))
	return _screenloc
