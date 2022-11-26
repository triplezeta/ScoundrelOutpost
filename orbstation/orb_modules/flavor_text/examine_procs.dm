// Handles the hyperlink to display the "close examine" box in chat
/mob/living/carbon/human/Topic(href, href_list)
	. = ..()

	if(href_list["show_flavor_text"])
		var/mob/living/carbon/human/target = locate(href_list["show_flavor_text"])
		if(target) //code here copied from "run_examinate()" in mob.dm. might be ugly.
			var/list/result = target.examine_more(usr)
			if(result.len) //add proper linebreaks
				for(var/i in 1 to (length(result) - 1))
					result[i] += "\n"
			to_chat(usr, examine_block("<span class='infoplain'>[result.Join()]</span>"))

// Handles the hyperlink to display the "close examine" box in chat (silicon this time)
/mob/living/silicon/robot/Topic(href, href_list)
	. = ..()

	if(href_list["show_flavor_text"])
		var/mob/living/silicon/robot/target = locate(href_list["show_flavor_text"])
		if(target) //code here copied from "run_examinate()" in mob.dm. might be ugly.
			var/list/result = target.examine_more(usr)
			if(result.len) //add proper linebreaks
				for(var/i in 1 to (length(result) - 1))
					result[i] += "\n"
			to_chat(src, examine_block("<span class='infoplain'>[result.Join()]</span>"))

// Switches off scar descriptions - to make space for flavor text on the same panel
/datum/scar/get_examine_description(mob/viewer)
	return

// Display flavor text when examining closely
/mob/living/carbon/human/examine_more(mob/user)
	. = ..()

	var/obscured = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	. += obscured ? span_warning("\nTheir face is hidden! You can't see any details.") : "\n" + dna.features["flavor_text"]

/mob/living/silicon/robot/examine_more(mob/user)
	. = ..()
	. += span_notice("<i>You examine [src] closer, and note the following...</i>")
	if(client)
		. += client.prefs.read_preference(/datum/preference/text/silicon_flavor_text)

	return .
