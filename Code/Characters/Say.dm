character/humanoid/verb/Say(msg as text)
	Speak("says",msg)

character/humanoid/verb/Whisper(msg as text)
	Speak("whispers",msg,1,80,2,"i")

character/humanoid/verb/Shout(msg as text)
	Speak("shouts",msg,-1,20,30,"font size=4")

character/humanoid/proc/Speak(says, msg, volume = -1, occlusion=60, occluded_volume = 3, tag="a")
	//Immediate (mob can see sound source)
	var/list/hearers = Viewers(src, volume>=0 ? volume : null)
	for(var/mob/M in hearers)
		if(!M.client) continue
		M << "<[tag]><font color=[text_color]><b>[src]</b> [says], \"[msg]\"</font></[tag]>"

	//Obscured (source is in range but not visible)
	for(var/client/C in game.players.contents)
		if(C.mob in hearers) continue
		if(istype(C.mob,/mob/ghost))
			C << "<[tag]><font color=[text_color]><b>[src]</b> [says], \"[msg]\"</font></[tag]>"
		else if(get_dist(C.eye,src) <= occluded_volume)
			C << "<[tag]><small><font color=[text_color]><b>Someone</b> [says], \"[OccludeMsg(msg,occlusion)]\"</font></small></[tag]>"

proc/OccludeMsg(msg, amt)
	var/list/word_list = dd_text2list(msg," ")
	for(var/i = 1, i <= word_list.len, i++)
		if(prob(amt))
			word_list.Cut(i,i+1)
			word_list.Insert(i,"...")
	return dd_list2text(word_list," ")

