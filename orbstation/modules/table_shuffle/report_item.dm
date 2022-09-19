/obj/item/folder/shufflelog
	name = "Folder- 'ANOMALY REPORTS'"
	desc = "A folder stamped \"OBSERVATION DUTY ANOMALY REPORTS\""
	icon_state = "folder_red"
	bg_color = "#b5002e"
	var/generated = FALSE

/obj/item/folder/shufflelog/Initialize(mapload)
	if(mapload && config.Get(/datum/config_entry/flag/disable_table_shuffle))
		return INITIALIZE_HINT_QDEL
	. = ..()

/obj/item/folder/shufflelog/update_overlays()
	. = ..()
	if(!generated)
		. += "folder_paper"

/obj/item/folder/shufflelog/proc/populate()
	if(generated) return;
	var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/simple/paper)
	var/cc_stamp_class = sheet.icon_class_name("stamp-centcom")
	for(var/area/A in SStable_shuffle.did_shuffle)
		var/obj/item/paper/P = new(src)
		if(A in SStable_shuffle.high_rollers)
			P.name = "* Anomaly Report: [A] *"
			P.add_raw_text("Dedicated agents on Observation Duty have noted the following anomalies in \the [A] prior to the start of this shift:<br>NOTE: This area appears to be a hotbed of anomalous activity.<hr>[A.shuffle_log]")
			P.add_stamp(cc_stamp_class, rand(0,275), rand(0,65), rand(0,360), "stamp-centcom")
		else
			P.name = "Anomaly Report: [A]"
			P.add_raw_text("Dedicated agents on Observation Duty have noted the following anomalies in \the [A] prior to the start of this shift:<hr>[A.shuffle_log]")
			P.add_stamp(cc_stamp_class, rand(0,275), rand(0,45), rand(-30,30), "stamp-centcom")
		P.update_appearance()
	generated = TRUE

/obj/item/folder/shufflelog/attack_self()
	if(!generated) populate()
	. = ..()
/obj/item/folder/shufflelog/attack_hand()
	if(!generated) populate()
	. = ..()
/obj/item/folder/shufflelog/examine()
	if(!generated) populate()
	. = ..()
