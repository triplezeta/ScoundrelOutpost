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
