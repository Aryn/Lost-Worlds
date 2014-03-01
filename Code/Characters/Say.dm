character/player/verb/Say(msg as text)
	Speak("said",msg)

character/verb/Occlude(msg as text)
	src << OccludeMsg(msg, 60)

character/player/proc/Speak(said, msg, occlusion=60)
	//Immediate (mob can see sound source)
	var/list/hearers = Viewers(src)
	for(var/mob/M in hearers)
		if(!M.client) continue
		M << "<font color=[text_color]><b>[src]</b> [said] \"[msg]\"</font>"

	//Obscured (source is in range but not visible)
	var/occluded = OccludeMsg(msg, occlusion)
	for(var/client/C in players.online)
		if(C.mob in hearers) continue
		if(get_dist(C.eye,src) <= world.view)
			C << occluded

proc/OccludeMsg(msg, amt)
	var/list/word_list = dd_text2list(msg," ")
	for(var/i = 1, i <= word_list.len, i++)
		if(prob(amt))
			word_list.Cut(i,i+1)
			word_list.Insert(i,"...")
	return dd_list2text(word_list," ")

