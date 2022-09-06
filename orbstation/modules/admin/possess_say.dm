//overrides the normal "dead say" to let ghosts possessing an object speak automatically using "osay"
/mob/dead/observer/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null)
	message = trim(message) //trim now and sanitize after checking for special admin radio keys

	var/list/filter_result = CAN_BYPASS_FILTER(src) ? null : is_ooc_filtered(message)
	if (filter_result)
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		log_filter("OOC", message, filter_result)
		return

	var/list/soft_filter_result = CAN_BYPASS_FILTER(src) ? null : is_soft_ooc_filtered(message)
	if (soft_filter_result)
		if(tgui_alert(usr,"Your message contains \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\". \"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\", Are you sure you want to say it?", "Soft Blocked Word", list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[message]\"")

	if(!message)
		return
	var/list/message_mods = list()
	message = get_message_mods(message, message_mods)
	if(client?.holder && (message_mods[RADIO_EXTENSION] == MODE_ADMIN || message_mods[RADIO_EXTENSION] == MODE_DEADMIN || (message_mods[RADIO_EXTENSION] == MODE_PUPPET && mind?.current)))
		message = trim_left(copytext_char(message, length(message_mods[RADIO_KEY]) + 2))
		switch(message_mods[RADIO_EXTENSION])
			if(MODE_ADMIN)
				client.cmd_admin_say(message)
			if(MODE_DEADMIN)
				client.dsay(message)
			if(MODE_PUPPET)
				if(!mind.current.say(message))
					to_chat(src, span_warning("Your linked body was unable to speak!"))
		return

	message = copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)
	if(message[1] == "*" && check_emote(message, forced))
		return

	if(usr.control_object)
		. = usr.control_object.say(message, sanitize = FALSE)
	else
		. = say_dead(message)
