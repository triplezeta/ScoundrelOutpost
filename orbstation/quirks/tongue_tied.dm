/obj/item/organ/internal/tongue/tied/modify_speech(datum/source, list/speech_args)
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.get_face_name() != "Unknown") // if your face is visible, your punctuation is still communicated
			return

	speech_args[SPEECH_MESSAGE] = punctuation_to_periods(speech_args[SPEECH_MESSAGE])

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

//Overrides talk_into to check if the user has the "tied tongue" and only remove their punctuation if so.
//For simplicity, and because it mostly just sucks, radio gloves will no longer garble speech when you only have one hand free.
/obj/item/radio/talk_into(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	var/mob/living/carbon/mute = talking_movable
	var/obj/item/organ/internal/tongue/tied/T = locate(/obj/item/organ/internal/tongue/tied) in mute.internal_organs
	if(istype(mute) && T) //check for the "tied tongue" and modify text if present
		message = punctuation_to_periods(message) //signing doesn't communicate tone over radio

	return ..()
