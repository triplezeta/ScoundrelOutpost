/**
 * Previously references containing tizirans, we're funnier than that.
 */
/datum/bounty/item/assistant/donkpocket
	description = "Consumer safety recall: Warning. Donk-Pockets manufactured in the past year contain hazardous %SOMETHING% biomatter. Return units to CentCom immediately."

/datum/bounty/item/assistant/donkpocket/New()
	. = ..()
	var/static/list/things_you_dont_want_in_food = list(
		"wizard",
		"space carp",
		"xenomorph",
		"legion",
		"goliath",
		"changeling",)
	description = replacetext(description, "%SOMETHING%", pick(things_you_dont_want_in_food))
