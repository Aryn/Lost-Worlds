var/data/player/players = new

/data/player
	var/data/hud/hud = new

	var/list/forms = list("male" = /char_form/male, "female" = /char_form/female)
	var/list/beards = 'Icons/Creatures/Players/Beards.dmi'
	var/image/hiding

	var/selection_css = {"<style>
	BODY {
		font:georgia;
		background-color:#CCA467;
		background-image:url('parchment.png');
		color:black;
		}
	SELECT	{
		background: #CCA467;
		color: black;
		}
	</style>"}

	var/list/random_names_male
	var/list/random_names_female
	var/list/random_names_last

/data/player/New()
	. = ..()
	var/list/beard_list = list()
	for(var/beard_type in icon_states(beards))
		beard_list[beard_type] = image(icon=beards,icon_state=beard_type,layer=BEARD_LAYER)
	beards = beard_list

	for(var/form_name in forms)
		var/form_type = forms[form_name]
		var/char_form/form = new form_type
		forms[form_name] = form

	var/name_file = "names.txt"
	if(fexists(name_file))
		var/data = file2text(name_file)
		var/list/splitdata = dd_text2list(data,"\n\n")
		random_names_male = dd_text2list(splitdata[1],"\n")
		random_names_female = dd_text2list(splitdata[2],"\n")
		random_names_last = dd_text2list(splitdata[3],"\n")

obj/display/blank
	name = ""
	icon = null
	mouse_opacity = 2
	layer = 0

data/hud
	var/obj/display/blank/blank
	var/obj/display/drop/drop
	var/obj/display/swap/swap
	var/obj/display/equipment/l_hand
	var/obj/display/equipment/r_hand

	var/display_group/equip_group

	var/obj/display/equipment/hat
	var/obj/display/equipment/goggles
	var/obj/display/equipment/back
	var/obj/display/equipment/shirt
	var/obj/display/equipment/coat
	var/obj/display/equipment/gloves
	var/obj/display/equipment/boots
	var/obj/display/equipment/trousers

	var/obj/display/equipment/keys
	var/obj/display/equipment/belt
	var/obj/display/equipment/coat_pocket

	var/obj/display/equipment/l_pocket
	var/obj/display/equipment/r_pocket

	var/display_group/combat

	var/obj/display/combat/hit/hit
	var/obj/display/combat/stand/stand

/data/hud/New()
	blank = new("1,1 to 15,15")
	l_hand = new("[HANDS_OFFSET]:8,1","L Hand")
	r_hand = new("[HANDS_OFFSET+1]:8,1","R Hand")
	drop = new("[HANDS_OFFSET]:8,2")
	swap = new("[HANDS_OFFSET+1]:8,2")

	equip_group = new

	equip_group.CreateOpenButton("1:8,1:8", "expand")
	equip_group.CreateCloseButton("1:8,1:8", "SW")

	hat = new("1:8,3:8", "Hat", "NW")
	goggles = new("2:8,3:8", "Goggles", "N")
	back = new("3:8,3:8", "Back", "NE")

	shirt = new("1:8,2:8", "Shirt", "W")
	coat = new("2:8,2:8", "Coat", "center")
	gloves = new("3:8,2:8", "Gloves", "E")

	boots = new("2:8,1:8", "Boots", "S")
	trousers = new("3:8,1:8", "Trousers", "SE")

	equip_group.Add(hat)
	equip_group.Add(goggles)
	equip_group.Add(back)

	equip_group.Add(shirt)
	equip_group.Add(coat)
	equip_group.Add(gloves)

	equip_group.Add(boots)
	equip_group.Add(trousers)

	combat = new

	hit = new("[HANDS_OFFSET]:8, 3")
	stand = new("[HANDS_OFFSET+1]:8, 3")

	combat.Add(hit)
	combat.Add(stand)

	/*container = new
	states = list("H<","H","H=","H","H=","H>")
	for(i = 1, i <= 6, i++)
		var/obj/display/equipment/box = new("[3+i]:16,2:8","Container [i]", states[i])
		container.Add(box)

	container.CreateOpenButton("4:16,2:8","expand-H")
	container.CreateCloseButton("10:16,2:8","close-H")*/
