
mob/login
	var/data/savefile/chars
	var/data/save/selected
	var/selected_index = 1

	var/image/body
	var/image/hair
	var/image/beard

mob/login/Login()
	chars = new(ckey)
	Reload()
	winshow(src,"charselect",1)

mob/login/proc/Reload()
	client.screen.Cut()
	for(var/i = 1, i <= 3, i++)
		if(chars.saves.len < i)
			winset(src,"charselect.Character[i]","text=\"New Character\"")
		else
			var/data/save/char = chars.saves[i]
			winset(src,"charselect.Character[i]","text=\"[char.name]\"")
			client.screen += char.UpdateImage("Icon[i]")
	Select(selected_index)

mob/login/verb/Select(n as num)
	if(n < 1 || n > 3) return
	selected_index = n
	if(chars.saves.len >= selected_index)
		selected = chars.saves[n]
		winset(src,"charselect.edit","text=\"Edit\"")
		winset(src,"charselect.delete", "is-disabled=false")
		winset(src,"charselect.ready", "is-disabled=false")
	else
		selected = null
		winset(src,"charselect.edit","text=\"Create\"")
		winset(src,"charselect.delete", "is-disabled=true")
		winset(src,"charselect.ready", "is-disabled=true")

mob/login/verb/Edit()
	if(!selected)
		selected = new
		selected.Randomize()
		chars.saves.Insert(selected_index,selected)

	winshow(src,"charcreation",1)
	winshow(src,"charedit",0)

	client.screen += selected.UpdateImage("EditIcon")
	selected.WriteToInterface(src)

mob/login/verb/Delete()
	var/answer = sd_Alert(src, "Are you sure you want to delete [selected.name]?", "Delete Character",
		list("Yes","No"),
		"No",0,0,"240x160",,players.selection_css,,0)
	if(answer == "Yes")
		chars.saves -= selected
		chars.Save()
		Reload()

mob/login/verb/ViewMap()
	if(!(src in game.map.viewing_mobs)) game.map.ShowTo(src)
	else game.map.StopShowing(src)

mob/login/CloseMap()
	. = ..()
	winset(src,"ViewMap","is-checked=false")

/*
Unrecognized or inaccessible verb: BeMale
Unrecognized or inaccessible verb: BeFemale
Unrecognized or inaccessible verb: ChangeHair
Unrecognized or inaccessible verb: ChangeColor
Unrecognized or inaccessible verb: ChangeJob
Unrecognized or inaccessible verb: ChangeSkill
Unrecognized or inaccessible verb: Finished
Unrecognized or inaccessible verb: ChangeSeal
*/

mob/login/verb/BeMale()
	selected.form = players.forms["male"]
	selected.UpdateImage("EditIcon")
	winset(src,"facialhair","is-visible=true;text=\"[selected.beard]\"")

mob/login/verb/BeFemale()
	selected.form = players.forms["female"]
	selected.UpdateImage("EditIcon")
	winset(src,"facialhair","is-visible=false")

mob/login/verb/ChangeHair()
	var/list/styles = selected.form.hair_images
	var/selection = sd_Alert(src, "Select a hairstyle.", "Hairstyle", styles, \
		selected.hair_style,0,0,"240x160",,players.selection_css,,1)

	winset(src,"hairstyle","text=\"[selection]\"")
	selected.hair_style = selection
	selected.UpdateImage("EditIcon")

mob/login/verb/ChangeBeard()
	var/list/styles = players.beards
	var/selection = sd_Alert(src, "Select a facial hair style.", "Facial Hair", styles, \
		selected.beard,0,0,"240x160",,players.selection_css,,1)

	winset(src,"facialhair","text=\"[selection]\"")
	selected.beard = selection
	selected.UpdateImage("EditIcon")


mob/login/verb/ChangeColor(cmd as text)
	switch(cmd)
		if("Hair")
			src.getColor("Hair_Color",selected.hair_color)
		if("Text")
			src.getColor("Text_Color",selected.text_color)
		//if("Skin")
		//	src.getColor("Skin_Color",selected.win_color)

mob/login/verb/ChangeSkin()
	var/tone = text2num(winget(src,"skinslider","value"))
	selected.skin_tone = LOG_100TO255(tone)
	winset(src,"skincolor","background-color=[SKINCOLOR(selected.skin_tone)]")
	selected.UpdateImage("EditIcon")

mob/login/verb/Finished()
	chars.Save()
	Reload()
	winshow(src,"charcreation",0)

mob/login/verb/Ready()
	if(game.started)
		game.MakeCharacter(src)
	else if(client.in_game)
		client.in_game = FALSE
		game.players.Remove(client)
	else
		client.in_game = TRUE
		game.players.Add(client)

mob/login/Topic(href,data[])
	var/r=text2num(data["r"])
	var/g=text2num(data["g"])
	var/b=text2num(data["b"])
	var/color = rgb(r,g,b)

	//src << "[color]"

	switch(data["command"])
		if("Hair_Color")
			selected.hair_color = color
			winset(src,"haircolor","background-color=[selected.hair_color]")
			selected.UpdateImage("EditIcon")
		if("Text_Color")
			selected.text_color = color
			winset(src,"textcolor","text-color=[selected.text_color]")

	usr<<browse(null,"window=[data["command"]]")

var/tcolor_mul = 0.25
var/tcolor_bound = 120
proc
	toTextColor(color)
		var
			rgb = inverse_rgb(color)
			r = rgb[1]//*(1-tcolor_mul)
			g = rgb[2]//*(1-tcolor_mul)
			b = rgb[3]//*(1-tcolor_mul)
		var/max = max(r,g,b)
		if(max < tcolor_bound)
			r += tcolor_bound - max
			g += tcolor_bound - max
			b += tcolor_bound - max
		return rgb(r,g,b)

