/datum/centcom_announcer/ytp
	welcome_sounds = list('orbstation/sound/ai/ytp/welcome.ogg')
	alert_sounds = list('orbstation/sound/ai/ytp/attention.ogg')
	command_report_sounds = list('orbstation/sound/ai/ytp/commandreport.ogg')
	event_sounds = list(ANNOUNCER_AIMALF = 'orbstation/sound/ai/ytp/aimalf.ogg',
		ANNOUNCER_ALIENS = 'orbstation/sound/ai/ytp/aliens.ogg',
		ANNOUNCER_ANIMES = 'orbstation/sound/ai/ytp/animes.ogg',
		ANNOUNCER_GRANOMALIES = 'orbstation/sound/ai/ytp/granomalies.ogg',
		ANNOUNCER_INTERCEPT = 'orbstation/sound/ai/ytp/intercept.ogg',
		ANNOUNCER_IONSTORM = 'orbstation/sound/ai/ytp/ionstorm.ogg',
		ANNOUNCER_METEORS = 'orbstation/sound/ai/ytp/meteors.ogg',
		ANNOUNCER_OUTBREAK5 = 'orbstation/sound/ai/ytp/outbreak5.ogg',
		ANNOUNCER_OUTBREAK7 = 'orbstation/sound/ai/ytp/outbreak7.ogg',
		ANNOUNCER_POWEROFF = 'orbstation/sound/ai/ytp/poweroff.ogg',
		ANNOUNCER_POWERON = 'orbstation/sound/ai/ytp/poweron.ogg',
		ANNOUNCER_RADIATION = 'orbstation/sound/ai/ytp/radiation.ogg',
		ANNOUNCER_SHUTTLECALLED = 'orbstation/sound/ai/ytp/shuttlecalled.ogg',
		ANNOUNCER_SHUTTLEDOCK = 'orbstation/sound/ai/ytp/shuttledock.ogg',
		ANNOUNCER_SHUTTLERECALLED = 'orbstation/sound/ai/ytp/shuttlerecalled.ogg',
		ANNOUNCER_SPANOMALIES = 'orbstation/sound/ai/ytp/spanomalies.ogg')


/datum/station_trait/announcement_ytp
	name = "Announcement System Malfunction"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 1
	show_in_report = TRUE
	report_message = "Our announcement system is experiencing some... unique... technical difficulties."
	blacklist = list(/datum/station_trait/announcement_medbot, /datum/station_trait/announcement_intern)

/datum/station_trait/announcement_ytp/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/ytp
