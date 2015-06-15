/nation
	var/name
	var/color
	var/customs_level
	var/contraband
	var/contraband_export
	var/difficult_import
	var/difficult_export

/nation/mountain
	name = "Arrajin"
	customs_level = 3
	contraband = "Drugs"
	contraband_export = "Weapons"
	difficult_import = "Cryo Chemicals"
	difficult_export = "Frozen Fruits"
/nation/desert
	name = "Devteros"
	customs_level = 5
	contraband = "Propaganda"
	contraband_export = "Drugs"
	difficult_import = "Frozen Fruits"
	difficult_export = "Ancient Artifacts"
/nation/plains
	name = "Hirugard"
	customs_level = 1
	contraband = "Weapons"
	contraband_export = "Propaganda"
	difficult_import = "Ancient Artifacts"
	difficult_export = "Cryo Chemicals"

var/list/nations = list(
	"#e9afaf" = new/nation/mountain,
	"#ffeeaa" = new/nation/desert,
	"#dde9af" = new/nation/plains,
)