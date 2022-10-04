
/datum/diploma_spell/disabletech
	name = "Disable Tech"
	desc = "Disables all weapons, cameras and most other technology in range."
	spell_type = /datum/action/cooldown/spell/emp/disable_tech
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/repulse
	name = "Repulse"
	desc = "Throws everything around the user away."
	spell_type = /datum/action/cooldown/spell/aoe/repulse/wizard
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/timestop
	name = "Time Stop"
	desc = "Stops time for everyone except for you, allowing you to move freely \
		while your enemies and even projectiles are frozen."
	spell_type = /datum/action/cooldown/spell/timestop
	category = DIPLOMA_SPELL_DEFENSIVE
	weight = DIPLOMA_SPELL_RARE

/datum/diploma_spell/smoke
	name = "Smoke"
	desc = "Spawns a cloud of choking smoke at your location."
	spell_type = /datum/action/cooldown/spell/smoke
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/forcewall
	name = "Force Wall"
	desc = "Create a magical barrier that only you can pass through."
	spell_type = /datum/action/cooldown/spell/forcewall
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/spacetime_dist
	name = "Spacetime Distortion"
	desc = "Entangle the strings of space-time in an area around you, \
		randomizing the layout and making proper movement impossible. The strings vibrate..."
	spell_type = /datum/action/cooldown/spell/spacetime_dist
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/item/lockerstaff
	name = "Staff of the Locker"
	desc = "A staff that shoots lockers. It eats anyone it hits on its way, leaving a welded locker with your victims behind. \
		Remember that any fool can use a stave dropped onto the ground."
	item_path = /obj/item/gun/magic/staff/locker
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/knock
	name = "Knock"
	desc = "Opens nearby doors and closets."
	spell_type = /datum/action/cooldown/spell/aoe/knock
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/blink
	name = "Blink"
	desc = "Randomly teleports you a short distance."
	spell_type = /datum/action/cooldown/spell/teleport/radius_turf/blink
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/mirror_walk
	name = "Mirror Walk"
	desc = "Travel freely through various reflective surfaces such as mirrors and windows."
	spell_type = /datum/action/cooldown/spell/jaunt/mirror_walk/wizard
	category = DIPLOMA_SPELL_DEFENSIVE
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/blood_walk
	name = "Blood Walk"
	desc = "Sink your body into any pool of blood and emerge from any other. \
		Paint the halls red with gore for best effect, or risk being trapped by a simple janitor."
	spell_type = /datum/action/cooldown/spell/jaunt/bloodcrawl/wizard
	category = DIPLOMA_SPELL_DEFENSIVE
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/shadow_walk
	name = "Shadow Walk"
	desc = "Travel freely through darkened areas and heal while intangible. \
		You will be forced into corporeality if you enter the light."
	spell_type = /datum/action/cooldown/spell/jaunt/shadow_walk/wizard
	category = DIPLOMA_SPELL_DEFENSIVE
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/jaunt
	name = "Ethereal Jaunt"
	desc = "Turns your form ethereal, temporarily making you invisible and able to pass through walls."
	spell_type = /datum/action/cooldown/spell/jaunt/ethereal_jaunt
	category = DIPLOMA_SPELL_DEFENSIVE
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/passage
	name = "Ashen Passage"
	desc = "Turn your body to ash for just long enough to pass through nearby walls."
	spell_type = /datum/action/cooldown/spell/jaunt/ethereal_jaunt/ash/wizard
	category = DIPLOMA_SPELL_DEFENSIVE
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/swap
	name = "Swap"
	desc = "Switch places with any living target within nine tiles. Right click to mark a secondary target. You will always swap to your primary target."
	spell_type = /datum/action/cooldown/spell/pointed/swap
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/item/warpwhistle
	name = "Warp Whistle"
	desc = "A strange whistle that will transport you to a distant safe place on the station. There is a window of vulnerability at the beginning of every use."
	item_path = /obj/item/warp_whistle
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/item/staffdoor
	name = "Staff of Door Creation"
	desc = "A particular staff that can mold solid walls into ornate doors. Useful for getting around in the absence of other transportation. \
		Does not work on glass."
	item_path = /obj/item/gun/magic/staff/door
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/item/teleport
	name = "Staff of Teleportation"
	desc = "A staff which sends its victims somewhere else, notably this is usually somewhere that you aren't. Useful for getting some private time."
	item_path = /obj/item/gun/magic/staff/teleport
	category = DIPLOMA_SPELL_DEFENSIVE

/datum/diploma_spell/abyssal_gaze
	name = "Abyssal Gaze"
	desc = "A simple curse which blinds and chills its victim for a short duration."
	spell_type = /datum/action/cooldown/spell/pointed/abyssal_gaze/greater
	category = DIPLOMA_SPELL_DEFENSIVE
