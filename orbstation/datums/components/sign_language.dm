/proc/punctuation_to_periods(message)
	// Is there a !
	var/exclamation_found = findtext(message, "!")
	// Is there a ?
	var/question_found = findtext(message, "?")
	if(exclamation_found)
		message = replacetext(message, "!", ".")
	if(question_found)
		message = replacetext(message, "?", ".")
	return message

//Overrides talk_into to check if the user is using sign language and only remove their punctuation if so.
//For simplicity, and because it mostly just sucks, radio gloves will no longer garble speech when you only have one hand free.
/obj/item/radio/talk_into(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/living/carbon/mute = talking_movable
	if(istype(mute) && HAS_TRAIT(mute, TRAIT_SIGN_LANG)) //check for speaking with sign language
		message = punctuation_to_periods(message) //signing doesn't communicate tone over radio

	return ..()
