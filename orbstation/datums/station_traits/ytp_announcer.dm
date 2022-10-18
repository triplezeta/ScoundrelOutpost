/datum/centcom_announcer/ytp
	welcome_sounds = list('sound/ai/ytp/welcome.ogg')
	alert_sounds = list('sound/ai/ytp/attention.ogg')
	command_report_sounds = list('sound/ai/ytp/commandreport.ogg')
	event_sounds = list(ANNOUNCER_AIMALF = 'sound/ai/default/aimalf.ogg',
		ANNOUNCER_ALIENS = 'sound/ai/ytp/aliens.ogg',
		ANNOUNCER_ANIMES = 'sound/ai/ytp/animes.ogg',
		ANNOUNCER_GRANOMALIES = 'sound/ai/ytp/granomalies.ogg',
		ANNOUNCER_INTERCEPT = 'sound/ai/ytp/intercept.ogg',
		ANNOUNCER_IONSTORM = 'sound/ai/ytp/ionstorm.ogg',
		ANNOUNCER_METEORS = 'sound/ai/ytp/meteors.ogg',
		ANNOUNCER_OUTBREAK5 = 'sound/ai/ytp/outbreak5.ogg',
		ANNOUNCER_OUTBREAK7 = 'sound/ai/ytp/outbreak7.ogg',
		ANNOUNCER_POWEROFF = 'sound/ai/ytp/poweroff.ogg',
		ANNOUNCER_POWERON = 'sound/ai/ytp/poweron.ogg',
		ANNOUNCER_RADIATION = 'sound/ai/ytp/radiation.ogg',
		ANNOUNCER_SHUTTLECALLED = 'sound/ai/ytp/shuttlecalled.ogg',
		ANNOUNCER_SHUTTLEDOCK = 'sound/ai/ytp/shuttledock.ogg',
		ANNOUNCER_SHUTTLERECALLED = 'sound/ai/ytp/shuttlerecalled.ogg',
		ANNOUNCER_SPANOMALIES = 'sound/ai/ytp/spanomalies.ogg')


/datum/station_trait/announcement_ytp
	name = "Announcement System Malfunction"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 1
	show_in_report = TRUE
	report_message = "Our announcement system is experiencing technical difficulties. These audio errors should not affect normal station activity."
	blacklist = list(/datum/station_trait/announcement_medbot, /datum/station_trait/announcement_intern)

/datum/station_trait/announcement_ytp/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/ytp
