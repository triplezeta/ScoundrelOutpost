//
// Per-area table-shuffle options
// See code/__DEFINES/orb/table_shuffle.dm
//
/area
	var/shuffle_options = SHUFFLE_STANDARD
	var/shuffle_log = "" // string that can be viewed with the "Local shuffle log" debug verb

// These get extra
/area/station/maintenance/shuffle_options = SHUFFLE_ALL
/area/station/hallway/shuffle_options = SHUFFLE_ALL
/area/station/service/shuffle_options = SHUFFLE_ALL // these people are a lot less strict than say security and medical
/area/station/service/hydroponics/shuffle_options = SHUFFLE_ALL & ~SHUFFLE_DECAY // granted some vegetables at roundstart that should remain
/area/station/cargo/warehouse/shuffle_options = SHUFFLE_ALL // crate storage

// These areas have something or other that should not be screwed with
/area/station/maintenance/solars/shuffle_options = SHUFFLE_CRATE_STORAGE // some have solar packs in them
/area/station/medical/surgery/shuffle_options = SHUFFLE_SENSITIVE // everyone asked agrees surgeon tools should not be shuffled
/area/station/medical/morgue/shuffle_options = SHUFFLE_SENSITIVE // in some maps this has surgery as well
/area/station/medical/storage/shuffle_options = SHUFFLE_SENSITIVE // a little stricter about this stuff
/area/station/science/robotics/shuffle_options = SHUFFLE_SENSITIVE // also surgery
/area/station/engineering/shuffle_options = SHUFFLE_CRATE_STORAGE | SHUFFLE_EXTRA_VENDING // some crates are used for specific things here
/area/station/security/lockers/shuffle_options = SHUFFLE_STANDARD & ~SHUFFLE_FROM_BOXES

// The way the tech storage boards are stored it would be more irritating than average for something to be in the wrong place, so let's not.
// Also in some versions of the tech storage room, the secure tech storage is not a separate area, so shuffling would be insecure.
/area/station/engineering/storage/shuffle_options = SHUFFLE_RACK_STORAGE

// metastation has an inaccessible rack as part of the captain's quarters, do not move the nuke disk there (hilarious as that would be)
/area/station/command/heads_quarters/captain/shuffle_options = SHUFFLE_STANDARD & ~SHUFFLE_TO_RACKS

/area/station/engineering/supermatter/shuffle_options = SHUFFLE_NOTHING // This is probably okay but I don't want to screw with any of it
/area/station/science/server/shuffle_options = SHUFFLE_NOTHING
/area/station/ai_monitored/shuffle_options = SHUFFLE_NOTHING // this wouldn't cause problems, but it makes canonical sense to turn off - armory, vault, ai satellite, etc
