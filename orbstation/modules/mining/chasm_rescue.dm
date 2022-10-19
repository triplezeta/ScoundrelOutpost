/**
 * Adds a higher chance to fish up dead players than anything else.
 */
/obj/effect/abstract/chasm_storage
	/// List of mobs controlled by players who have fallen in here
	var/list/player_mobs = list()

/// Don't get boiled by ash while down there
/obj/effect/abstract/chasm_storage/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_WEATHER_IMMUNE, ROUNDSTART_TRAIT)

/// Add fallen mobs with ckeys to a high priority list
/obj/effect/abstract/chasm_storage/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if (!ismob(arrived))
		return
	var/mob/fallen_mob = arrived
	if (!fallen_mob.ckey)
		return
	if (fallen_mob in player_mobs)
		return
	player_mobs += fallen_mob

/obj/effect/abstract/chasm_storage/Exited(atom/movable/gone, direction)
	. = ..()
	player_mobs -= gone

/// 40% of the time fish up a player corpse if one exists
/obj/item/chasm_detritus/Initialize(mapload)
	if (prob(40) && retrieve_player_body())
		return INITIALIZE_HINT_QDEL
	return ..()

/// Retrieves a corpse if there is one
/obj/item/chasm_detritus/proc/retrieve_player_body()
	if (!GLOB.chasm_storage.len)
		return FALSE

	var/list/chasm_contents = list()
	var/list/chasm_storage_resolved = recursive_list_resolve(GLOB.chasm_storage)
	for (var/obj/effect/abstract/chasm_storage/storage as anything in chasm_storage_resolved)
		for (var/thing as anything in storage.player_mobs)
			chasm_contents += thing

	if (!length(chasm_contents))
		return FALSE

	var/atom/movable/body = pick(chasm_contents)
	body.forceMove(get_turf(src))
	return TRUE
