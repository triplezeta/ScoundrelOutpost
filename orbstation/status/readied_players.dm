/// Adds readied player count for non-admin players
/mob/dead/get_status_tab_items()
	. = ..()
	if(SSticker.HasRoundStarted())
		return
	if(client.holder)
		return
	. += "Players Ready: [SSticker.totalPlayersReady]"
