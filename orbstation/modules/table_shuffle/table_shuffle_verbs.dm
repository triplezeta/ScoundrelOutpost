
/client/proc/display_shuffle_log()
	set name = "Local Shuffle Log"
	set category = "Debug"
	var/area/A = get_area(usr)
	if(length(A.shuffle_log) == 0)
		if(config.Get(/datum/config_entry/flag/disable_table_shuffle))
			A.shuffle_log = "The table shuffle subsystem is disabled."
		else
			A.shuffle_log = "No events.  This may be because the probabilities are turned down, because there is nothing to shuffle or valid places to shuffle to and from, or just sheer bad luck."
	usr << browse("<u title='[A.type]'>[A]</u> Shuffle Log<br><div style='padding-left:3px;border-left:2px solid black;'>[A.shuffle_log]</div>","window=[A.type]_shuffle")

/client/proc/manual_table_shuffle()
	set name = "Shuffle Local Area"
	set category = "Debug"
	var/area/A = get_area(usr)
	var/tv = SStable_shuffle.total_vends
	var/tm = SStable_shuffle.total_moves
	var/td = SStable_shuffle.total_decays
	var/H = ""

	SStable_shuffle.shuffle_area(A,1)
	tv = SStable_shuffle.total_vends - tv
	tm = SStable_shuffle.total_moves - tm
	td = SStable_shuffle.total_decays - td

	if((tv + tm + td) > SStable_shuffle.high_roller_amt)
		H = "Got a high roller!  "

	if(tv > 0)
		tv = "Vended [SStable_shuffle.total_vends-tv] items. "
	else
		tv = ""
	if(tm > 0)
		tm = "Moved [SStable_shuffle.total_moves-tm] items. "
	else
		tm = ""
	if(td > 0)
		td = "[SStable_shuffle.total_decays-td] food items decayed. "
	else
		td = ""
	to_chat(usr,"Shuffled the local area. [H][tv][tm][td]")

// this overrides the shuffle_options bitfield
// depending on your probability scaling it may still underwhelm
/client/proc/extreme_table_shuffle()
	set name = "Shuffle Local Area (Max)"
	set category = "Debug"
	var/area/A = get_area(usr)
	var/tv = SStable_shuffle.total_vends
	var/tm = SStable_shuffle.total_moves
	var/td = SStable_shuffle.total_decays
	var/H = ""

	SStable_shuffle.shuffle_area(A,2)
	tv = SStable_shuffle.total_vends - tv
	tm = SStable_shuffle.total_moves - tm
	td = SStable_shuffle.total_decays - td

	if((tv + tm + td) > SStable_shuffle.high_roller_amt)
		H = "Got a high roller!  "

	if(tv > 0)
		tv = "Vended [SStable_shuffle.total_vends-tv] items. "
	else
		tv = ""
	if(tm > 0)
		tm = "Moved [SStable_shuffle.total_moves-tm] items. "
	else
		tm = ""
	if(td > 0)
		td = "[SStable_shuffle.total_decays-td] food items decayed. "
	else
		td = ""
	to_chat(usr,"Shuffled the local area. [H][tv][tm][td]")

/client/proc/show_high_rollers()
	set name = "Display table shuffle high rollers"
	set category = "Debug"
	if(config.Get(/datum/config_entry/flag/disable_table_shuffle))
		to_chat(usr,"Table shuffling subsystem is disabled.")
		return
	SStable_shuffle.display_high_rollers(usr)

/datum/controller/subsystem/table_shuffle/proc/display_high_rollers(var/mob/user)
	var/high_rollers_total = 0
	var/dat = "Probability values:<br>[prob_min] min - [prob_max] max<br>Add [prob_add], sub [prob_sub]<br>High roller threshold [high_roller_amt].<hr>"
	for(var/area/A in high_rollers)
		var/total = high_rollers[A]
		high_rollers_total += total
		dat += "<a href='?\ref[src];[A.type]'>[A.name]</a>: [total] events<br>"
	user << browse("<h3>High Rollers List</h3><br>High rollers accounted for [high_rollers_total] of the [event_total] roundstart events.<hr>[dat]","window=tshuf_high_rollers")

/datum/controller/subsystem/table_shuffle/Topic(href,href_list)
	for(var/area_type in href_list)
		var/area/A = text2path(area_type)
		if(ispath(A) && (A in GLOB.areas_by_type))
			A = GLOB.areas_by_type[A]
			usr << browse("<u title='[A.type]'>[A]</u> Shuffle Log<br><div style='padding-left:3px;border-left:2px solid black;'>[A.shuffle_log]</div>","window=[A.type]_shuffle")
			return
	return ..()
