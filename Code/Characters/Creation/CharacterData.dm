#define CHECK_FILE_ERRORS if(f.error()) {CRASH("I/O: [f.error_string()]")}
#define SKINCOLOR(X) rgb(LOG_RED(X)*0.9,(X)*0.7,(X)*0.5)

/data/savefile
	var/ckey
	var/list/saves = list()
	var/binfile/f = new
	var/first_login = false

	New(ckey)
		src.ckey = ckey
		world << "New savefile created for [ckey]"
		if(!fexists("Saves/[ckey]"))
			first_login = true
			world << "First Login."
			return

		f.open("Saves/[ckey]")

		var/total_saves = f.getword()
		world << "Saves: [total_saves]"

		for(var/i = 1, i <= total_saves, i++)
			var/data/save/char = new
			char.Load(f)
			saves.Add(char)
			world << "Loaded [char.name]"

		f.close()

	proc/Save()
		f.create("Saves/[ckey]")

		world << "Saving [saves.len] characters for [ckey]"

		f.putword(saves.len)

		for(var/data/save/char in saves)
			char.Save(f)
			world << "[char.name] saved."

		f.close()

/data/save
	var/name       //string
	var/data/form/form  //list-index
	var/age        //word

	var/hair_style //list-index
	var/beard      //list-index
	var/hair_color //string
	var/text_color //string
	var/skin_tone  //word

	var/alt_skill  //word
	var/job1       //list-index
	var/job2       //list-index
	var/job3       //list-index

	var/notes
	var/creation_date

	var/tmp/obj/img

	proc/Save(binfile/f)

		f.putword(length(name))
		f.putstring(name)
		f.putword(players.forms.Find(form.name))
		f.putword(age)
		CHECK_FILE_ERRORS

		f.putword(form.hair_images.Find(hair_style))
		f.putword(players.beards.Find(beard))
		f.putstring(hair_color)
		f.putstring(text_color)
		f.putword(skin_tone)
		CHECK_FILE_ERRORS

		f.putword(alt_skill)
		f.putword(0) //job1
		f.putword(0) //job2
		f.putword(0) //job3
		CHECK_FILE_ERRORS

		f.putword(length(notes))
		f.putstring(dd_replacetext(notes,"\n","|"))
		f.putstring(creation_date)
		CHECK_FILE_ERRORS

	proc/Load(binfile/f)

		var/strlen = f.getword()
		name = f.getstring(strlen+1)
		world << "Name: [name]"
		form = f.getword()
		world << "Form ID: [form] \..."
		form = players.forms[players.forms[form]]
		world << "([form.name])"
		age = f.getword()
		world << "Age: [age]"
		CHECK_FILE_ERRORS

		hair_style = form.hair_images[f.getword()]
		world << "Hair: [hair_style]"
		beard = players.beards[f.getword()]
		world << "Beard: [beard]"
		hair_color = f.getstring(8)
		world << "Hair Color: <font color=[hair_color]>[hair_color]</font>"
		text_color = f.getstring(8)
		world << "Text Color: <font color=[text_color]>[text_color]</font>"
		skin_tone = f.getword()
		world << "Skin Tone: [skin_tone]"
		CHECK_FILE_ERRORS

		alt_skill = f.getword()
		f.getword()
		f.getword()
		f.getword()
		CHECK_FILE_ERRORS

		strlen = f.getword()
		notes = dd_replacetext(f.getstring(strlen+1),"|","\n")
		creation_date = f.getstring(11)
		CHECK_FILE_ERRORS

	proc/WriteToPlayer(character/player/P)
		var/image/i_body = form.body
		var/image/i_hair = form.hair_images[hair_style]
		var/image/i_beard = players.beards[beard]

		i_body.color = rgb(LOG_RED(skin_tone),skin_tone,skin_tone)
		i_hair.color = hair_color
		i_beard.color = hair_color

		P.name = name
		P.text_color = text_color
		P.form = form
		P.body = i_body
		P.hair = i_hair
		P.beard = i_beard
		P.SetupAppearance()

	proc/WriteToInterface(mob/M)
		winset(M,"name","text=\"[name]\"")
		if(form.name == "male")
			winset(M,"male","is-checked=true")
			winset(M,"facialhair","is-visible=true;text=\"[beard]\"")
		else
			winset(M,"female","is-checked=true")
			winset(M,"facialhair","is-visible=false")
		winset(M,"age","text=\"[age]\"")
		winset(M,"hairstyle","text=\"[hair_style]\"")
		winset(M,"haircolor","background-color=[hair_color]")
		winset(M,"textcolor","text-color=[text_color]")
		winset(M,"skincolor","background-color=[SKINCOLOR(skin_tone)]")
		world << "INV([skin_tone]) = [INV_255TO100(skin_tone)]"
		winset(M,"skinslider","value=[INV_255TO100(skin_tone)]")
		for(var/n = 1 to 3)
			winset(M,"job[n]","text=\"[vars["job[n]"]]\"")
		winset(M,"notes","text=\"[notes]\"")
		winset(M,"date","text=\"Date: [creation_date]\"")

		/*if(seal)
			winset(M,"sealicon","image=[seal.icon]")
			winset(M,"sealname","text=\"Seal: [seal.name]\"")
		else
			winset(M,"sealicon","image=")
			winset(M,"sealname","text=\"Seal: Not Selected\"")*/

	proc/UpdateImage(map)
		var/image/i_body = form.body
		var/image/i_hair = form.hair_images[hair_style]
		var/image/i_beard = players.beards[beard]
		var/image/i_suit = form.example

		i_body.color = rgb(LOG_RED(skin_tone),skin_tone,skin_tone)
		i_hair.color = hair_color
		i_beard.color = hair_color

		if(!img) img = new
		img.overlays = list(i_body,i_suit,i_hair,i_beard)
		img.screen_loc = "[map]:1,1"
		return img

	proc/Randomize()
		form = players.forms[pick(players.forms)]
		if(form.name == "female")
			name = "[pick(players.random_names_female)] [pick(players.random_names_last)]"
		else
			name = "[pick(players.random_names_male)] [pick(players.random_names_last)]"
		age = rand(25,75)
		hair_style = pick(form.hair_images)
		if(form.bearded && prob(50)) beard = pick(players.beards)
		else beard = "None"
		hair_color = rgb(rand(0,255),rand(0,255),rand(0,255))
		text_color = rgb(rand(0,255),rand(0,255),rand(0,255))
		skin_tone = LOG_100TO255(rand(0,100))
		creation_date = time2text(world.time,"DD/MM/YYYY")