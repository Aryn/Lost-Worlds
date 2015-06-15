var/no_weight_log = "Logs/ItemsWithoutWeight.txt"

/atom/movable/var/weight = 20
/item/weight = 0

var/list/items_without_weight

/item/New()
	. = ..()
	if(!weight)
		if(!items_without_weight) items_without_weight = list()
		items_without_weight |= type
		log_warning("[type] has no associated weight.")



world/Del()
	. = ..()
	if(items_without_weight)
		if(fexists(no_weight_log)) fdel(no_weight_log)
		for(var/item_type in items_without_weight)
			text2file("[item_type]",no_weight_log)