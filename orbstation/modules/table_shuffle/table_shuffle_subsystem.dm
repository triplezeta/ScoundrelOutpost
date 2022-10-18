/*
	Table Shuffle Code - Sayu

	Inserts a small amount of roundstart chaos to make things just a little less "same as always"
	There is a hard cap on how much chaos can be inserted per area, determined by the probability curves.
	Areas can be exempted from chaos entirely or have certain types of chaos removed.
	A few things can be "extra random" but even that is capped.

	Functionally, this file does none, some, or all of the following per area:
	* Finds all the vending machines, tables, racks, and unlocked cabinets and crates in an area, and
	* Vends some free products
	* Goes through the vended items, and items in tables, racks, and cabinets/crates, and:
		* May takes contents out of unlocked storage items (boxes, bags, belts, etc)
		* May turn food and flowers into appropriate trash
		* May drain drinks and table condiments (salt and pepper, anything in packs)
		* May disappear pills (individually)
		* May moves items onto another table or rack, or hide them in an unlocked cabinet or crate, or place them on chairs, beds, sinks, or toilets
		* May bumps items into an adjacent space, if they are still in the open (on a table, rack, vending machine, or outside a closet/crate)
		* May screw with where an item is placed on a table or rack (pixel_x/y, which items are on top, etc)
	* Logs all actions taken in "shuffle_log" area var, which can be read with the "local shuffle log" admin verb

	These options can be disabled per-area with the shuffle_options area var.
	Popular variations include "Don't screw with what's on tables or in storage", "Don't hide things in closets",
	"Don't screw with closets/crates at all", "Don't screw with racks (eg, Engineering Tech Storage)"
	Note that the code to put objects on toilets never hides objects in toilets, because nobody would think to look there ever.

	Other files of note related to this system:
	* __DEFINES/orb/table_shuffle.dm
	* table_shuffle_areas.dm
	* table_shuffle_verbs.dm
	* modules/admin/admin_verbs.dm (adding the above verbs)
*/

SUBSYSTEM_DEF(table_shuffle)
	name = "Table Shuffle"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT // No hurry

	var/total_vends = 0
	var/total_moves = 0
	var/total_decays= 0
	// These will be read from configuration
	var/vend_only = FALSE
	var/prob_min = 7.5
	var/prob_max = 77.5
	var/prob_add = 7.5
	var/prob_sub = 15
	var/prob_eat = 55
	var/prob_visual = 5
	var/vender_budget = 150

	var/high_roller_amt = 5
	var/affected_area_amt = 0 // used to compute an average later
	var/event_total = 0

	var/list/high_rollers = list()
	var/list/did_shuffle = list()

/datum/controller/subsystem/table_shuffle/Initialize()
	if(config.Get(/datum/config_entry/flag/disable_table_shuffle))
		return SS_INIT_NO_NEED
	vend_only = config.Get(/datum/config_entry/flag/shuffle_vend_only)

	prob_min = config.Get(/datum/config_entry/number/shuffle_min_prob)
	prob_max = config.Get(/datum/config_entry/number/shuffle_max_prob)
	prob_add = config.Get(/datum/config_entry/number/shuffle_add_prob)
	prob_sub = config.Get(/datum/config_entry/number/shuffle_sub_prob)
	prob_eat = config.Get(/datum/config_entry/number/shuffle_eat_prob)
	prob_visual = config.Get(/datum/config_entry/number/shuffle_visual_prob)
	vender_budget = config.Get(/datum/config_entry/number/shuffle_vend_budget)
	high_roller_amt = config.Get(/datum/config_entry/number/shuffle_high_roller_threshold)

	for(var/area/A)
		var/e = shuffle_area(A,manual=0)
		if(e >= high_roller_amt)
			high_rollers[A] = e
		event_total += e

	// If you're looking at this line to understand what the average means,
	// note that "affected areas" only counts areas where events happened.
	// There are going to be several areas either immediately skipped or which
	// have nothing happen.
	var/msg
	if(affected_area_amt > 0)
		msg = "Table shuffle averaged [round(event_total / affected_area_amt)] events among [affected_area_amt] affected areas, [high_rollers.len] being high rollers."
	else
		if(event_total > 0) // shouldn't happen if the above doesn't
			msg = "Table shuffle had [event_total] phantom events this round."
		else
			msg = "Table shuffle had no events this round."
	to_chat(world, span_boldannounce("[msg]"))
	log_world(msg)

	// It would be better to map this in but I have zero doubts people will forget to
	// honestly it would ideally be in the librarian's protected room
	// secret occult stuff you know
	var/area/library = GLOB.areas_by_type[/area/station/service/library]
	if(library)
		var/list/candidate_tables = list()
		for(var/obj/structure/table/T in library)
			candidate_tables += T
		if(candidate_tables.len)
			new /obj/item/folder/shufflelog(pick(candidate_tables):loc)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/table_shuffle/proc/shuffle_area(var/area/A,var/manual = 0)
	if(!is_station_level(A.z) || (A.shuffle_options == 0)) return
	if(!manual && !prob(prob_max)) return // Leave places pristine, sometimes

	var/list/table_turfs = list()
	var/list/unlocked_closets = list()
	var/list/boxes = list()
	var/list/vending = list()
	var/list/destinations = list()
	var/opt = A.shuffle_options

	var/static/list/machine_plumbing_types = list(/obj/machinery/atmospherics/components/unary/vent_scrubber,/obj/machinery/shower)
	// Machine furniture is anything that looks like you could set an object down on it, even if you can't (ie, it's flat on top)
	var/static/list/machine_furniture_types = list(/obj/machinery/biogenerator,/obj/machinery/bookbinder,/obj/machinery/chem_master,
		/obj/machinery/food_cart,/obj/machinery/icecream_vat,/obj/machinery/pdapainter,/obj/machinery/photocopier,
		/obj/machinery/pipedispenser,/obj/machinery/stasis,/obj/machinery/washing_machine,/obj/machinery/rnd/production)

	var/vend_prob = prob_min
	var/move_prob = prob_min

	if(vend_only) opt &= SHUFFLE_VEND_ONLY_MASK

	if(manual == 1)
		A.shuffle_log += "<hr>Manually started:<br>"
	else if(manual == 2)
		A.shuffle_log += "<hr>Manual Full-Shuffle:<br>"
		opt = SHUFFLE_ALL

	for(var/obj/structure/S in A)
		if(istype(S,/obj/structure/table) || istype(S,/obj/structure/dresser))
			if(opt & SHUFFLE_FROM_TABLES)
				table_turfs[S.loc] = S
			if(opt & SHUFFLE_TO_TABLES)
				destinations[S.loc]= S
			if(opt & (SHUFFLE_FROM_TABLES+SHUFFLE_TO_TABLES))
				move_prob += prob_add
			if(opt & SHUFFLE_FROM_BOXES)
				for(var/obj/item/storage/B in S.loc)
					if(istype(B,/obj/item/storage/secure) || istype(B,/obj/item/storage/lockbox)) continue
					boxes += B
		else if(istype(S,/obj/structure/rack))
			if(opt & SHUFFLE_FROM_RACKS)
				table_turfs[S.loc]= S
			if(opt & SHUFFLE_TO_RACKS)
				destinations[S.loc] = S
			if(opt & (SHUFFLE_FROM_RACKS + SHUFFLE_TO_RACKS))
				move_prob += prob_add
			if(opt & SHUFFLE_FROM_BOXES)
				for(var/obj/item/storage/B in S.loc)
					if(istype(B,/obj/item/storage/secure) || istype(B,/obj/item/storage/lockbox)) continue
					boxes += B
		else if(istype(S,/obj/structure/closet))
			if(istype(S,/obj/structure/closet/body_bag) || S:opened || S:secure || S:welded || S:locked)
				continue // oh man it would be funny if I let the contents of body bags be moved to tables, racks, or other closets
			if(opt & (SHUFFLE_FROM_CLOSETS | SHUFFLE_TO_CLOSETS))
				unlocked_closets += S
				move_prob += prob_add
			if(opt & SHUFFLE_FROM_BOXES && (opt & SHUFFLE_FROM_CLOSETS))
				if(!S:contents_initialized) // so glad they delayed doing this so that I could be the one to tear the shrink wrap.  sigh.
					S:PopulateContents()
				for(var/obj/item/storage/B in S)
					if(istype(B,/obj/item/storage/secure) || istype(B,/obj/item/storage/lockbox)) continue
					boxes += B
		else if(istype(S,/obj/structure/chair)) // dropped it while resting.  I'd add beds except bedsheets cover a lot.
			if(opt & SHUFFLE_TO_FURNITURE)
				move_prob += prob_add / 4 // some places have a whole lot of chairs
				destinations[S.loc] = S
		else if(istype(S,/obj/structure/sink) || istype(S,/obj/structure/toilet)) // dropped it while doing important work
			if(opt & SHUFFLE_TO_PLUMBING)
				move_prob += prob_add / 4 // not exactly a first-choice
				destinations[S.loc] = S
		else
			continue
	for(var/obj/machinery/M in A)
		if(istype(M,/obj/machinery/vending))
			vending += M
			vend_prob += prob_add
			continue
		if(opt & SHUFFLE_TO_PLUMBING)
			var/found = 0
			for(var/t in machine_plumbing_types)
				if(istype(M,t))
					move_prob += prob_add / 4 // not exactly a first-choice location
					destinations[M.loc] = M
					found = 1
					break
			if(found) continue
		if(opt & SHUFFLE_TO_FURNITURE)
			for(var/t in machine_furniture_types)
				if(istype(M,t))
					move_prob += prob_add / 4 // not exactly a first-choice location
					destinations[M.loc] = M
					break

	if(!destinations.len)
		return // Boring area

	if(!manual)
		affected_area_amt++

	if(opt & SHUFFLE_EXTRA_MOVING)
		move_prob = min(prob_max,2*move_prob)

	if(opt & SHUFFLE_EXTRA_VENDING)
		vend_prob = min(prob_max,2*vend_prob)
	else
		vend_prob = min(prob_max,vend_prob)

	// I'm using a decaying probability scale to make it more likely to get anthing and less likely to get a lot
	// That means we want our lists to not be in predictable map-order or else the effect will be predictable.
	if(destinations.len > 1)
		shuffle_inplace(destinations)
	if(unlocked_closets.len > 1)
		shuffle_inplace(unlocked_closets)
	if(boxes.len > 1)
		shuffle_inplace(boxes)
	if(vending.len > 1)
		shuffle_inplace(vending)

	// A list of lists
	// Each list is formatted as [ITEMLOG_CURRENT_ITEM,ITEMLOG_ORIGINAL_LOC,ITEMLOG_ORIGINAL_ITEM,ITEMLOG_PERCENT_CONSUMED,ITEMLOG_DESTINATION_STRUCTURE]
	// dest_reference exists so if it's knocked on the floor we know what it's near.
	var/list/all_item_logs = list()

	// Cheap things in vending machines may have been bought and set down on a table or dropped next to the machine.
	if(opt & SHUFFLE_FROM_VENDING)
		for(var/obj/machinery/vending/V in vending)
			var/list/candidate_products = list()
			for(var/datum/data/vending_product/candy in V.product_records)
				if((candy.amount == 0) || (candy.custom_price > vender_budget) || !prob(prob_max)) continue
				candidate_products += candy

			while(candidate_products.len && prob(vend_prob))
				var/datum/data/vending_product/candy = pick(candidate_products)
				if(candy.amount<=0) continue
				if(opt & SHUFFLE_EXTRA_VENDING)
					vend_prob -= prob_sub / 2
				else
					vend_prob -= prob_sub
				candy.amount--
				V.products[candy.product_path]--
				if(candy.amount == 0)
					candidate_products -= candy // in case we continue
				var/obj/item/I = new candy.product_path(V.loc)
				// [ITEMLOG_CURRENT_ITEM, ITEMLOG_ORIGINAL_LOC, ITEMLOG_ORIGINAL_ITEM, ITEMLOG_PERCENT_CONSUMED, ITEMLOG_DESTINATION_STRUCTURE]
				var/list/item_log = list(I,V,I,0,V)
				all_item_logs[I]=item_log
				if(opt & SHUFFLE_FROM_BOXES)
					if(istype(I,/obj/item/storage) && I.contents.len)
						boxes += I
				shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,item_log)
				if(item_log[ITEMLOG_CURRENT_ITEM] != I) // transformed
					all_item_logs -= I
					all_item_logs[item_log[ITEMLOG_CURRENT_ITEM]] = item_log

	// Unlocked closets might have objects moved or removed
	if(opt & SHUFFLE_FROM_CLOSETS)
		for(var/obj/structure/closet/C in unlocked_closets.len)
			// Some places have a lot of full closets, lower probability
			var/closet_prob = min(prob_max,prob_min + C.contents.len * prob_add) / 2
			if(opt & SHUFFLE_EXTRA_MOVING)
				closet_prob *= 2 // was already halved

			if(!C.contents_initialized) // so glad they delayed doing this so that I could be the one to tear the shrink wrap.  sigh.
				C.PopulateContents()

			while(C.contents.len && prob(closet_prob))
				var/obj/I = pick(C.contents)
				if(opt & SHUFFLE_FROM_BOXES)
					if(istype(I,/obj/item/storage) && I.contents.len)
						boxes += I
				I.forceMove(C.loc)
				// [ITEMLOG_CURRENT_ITEM, ITEMLOG_ORIGINAL_LOC, ITEMLOG_ORIGINAL_ITEM, ITEMLOG_PERCENT_CONSUMED, ITEMLOG_DESTINATION_STRUCTURE]
				var/list/item_log = list(I,C,I,0,C)
				all_item_logs[I]=item_log
				closet_prob -= prob_sub
				move_prob -= prob_sub / 2 // This counts as half a move because we used a different seed to get there
				shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,item_log)
				if(item_log[ITEMLOG_CURRENT_ITEM] != I) // transformed
					all_item_logs -= I
					all_item_logs[item_log[ITEMLOG_CURRENT_ITEM]] = item_log

	// Box contents might be removed
	if(opt & SHUFFLE_FROM_BOXES)
		for(var/obj/item/storage/B in boxes)
			// Some places have a lot of full boxes, lower probability
			var/box_prob = min(prob_max,prob_min + B.contents.len * prob_add) / 2
			while(B.contents.len && prob(box_prob))
				var/obj/I = pick(B.contents)
				I.forceMove(get_turf(B))
				// We are trying to get a narrative reference point for the box's location for describe_journey
				var/atom/bloc = B.loc
				if(isturf(bloc))
					if(bloc in table_turfs)
						bloc = table_turfs[bloc]
					else if(bloc in destinations)
						bloc = destinations[bloc]
				// [ITEMLOG_CURRENT_ITEM, ITEMLOG_ORIGINAL_LOC, ITEMLOG_ORIGINAL_ITEM, ITEMLOG_PERCENT_CONSUMED, ITEMLOG_DESTINATION_STRUCTURE]
				var/list/item_log = list(I,B,I,0,bloc)
				all_item_logs[I] = item_log
				box_prob -= prob_sub
				move_prob -= prob_sub / 2
				shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,item_log)
				if(item_log[ITEMLOG_CURRENT_ITEM] != I) // transformed
					all_item_logs -= I
					all_item_logs[item_log[ITEMLOG_CURRENT_ITEM]] = item_log

	// Anything on a table or rack might be placed elsewhere, or fall off randomly
	var/list/candidate_items = list()
	if(opt & (SHUFFLE_FROM_TABLES|SHUFFLE_FROM_RACKS|SHUFFLE_VISUAL))
		for(var/turf/T in table_turfs)
			for(var/obj/item/I in T)
				if(I.anchored || I.density) continue
				if(opt & SHUFFLE_VISUAL)
					if(prob(prob_visual))
						I.moveToNullspace()
						I.forceMove(T) //change position in turf contents list (over/under other items)
					if(prob(prob_visual))
						I.pixel_x += rand(-8,8) // shift appearance on table/rack
						I.pixel_y += rand(-8,8)
				candidate_items += I

	// The process above created the list but also jostled things, so this is a separate logic check
	if(opt & (SHUFFLE_FROM_TABLES|SHUFFLE_FROM_RACKS))
		while(candidate_items.len && prob(move_prob))
			var/obj/item/I = pick(candidate_items)
			move_prob -= prob_sub
			var/list/item_log
			if(!(I in all_item_logs))
				// [ITEMLOG_CURRENT_ITEM, ITEMLOG_ORIGINAL_LOC, ITEMLOG_ORIGINAL_ITEM, ITEMLOG_PERCENT_CONSUMED, ITEMLOG_DESTINATION_STRUCTURE]
				item_log = all_item_logs[I] = list(I,I.loc,I,0,table_turfs[I.loc])
			else
				item_log = all_item_logs[I]
			shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,item_log)
			if(item_log[ITEMLOG_CURRENT_ITEM] != I) // transformed
				all_item_logs -= I
				all_item_logs[item_log[ITEMLOG_CURRENT_ITEM]] = item_log
	var/vends = 0
	var/moves = 0
	var/decays = 0
	var/non_events = 0
	for(var/obj/item/I in all_item_logs)
		var/stats = describe_journey(A,I,all_item_logs[I],table_turfs,destinations)
		if(!stats)
			non_events++
			continue
		if(stats & JOURNEY_WAS_VENDED) vends++
		if(stats & JOURNEY_DID_MOVE) moves++
		if(stats & JOURNEY_WAS_CONSUMED) decays++
	. = all_item_logs.len - non_events
	if(. > 0)
		did_shuffle += A
		A.shuffle_log += "<p><b>In total, [vends] free items and [decays] consumed items out of [all_item_logs.len - non_events] events.</b></p>"
	if(!manual)
		total_vends += vends
		total_moves += moves
		total_decays += decays
		if(. == 0)
			affected_area_amt-- // we included it but nothing happened, don't contribute to total

/datum/controller/subsystem/table_shuffle/proc/shuffle_decay_item(var/opt,var/area/A, var/obj/item/I, var/list/source_turfs,var/list/candidate_turfs, var/list/candidate_closets,var/list/item_log)
	var/obj/effect/decal/cleanable/extra_dirt = null
	if((opt & SHUFFLE_DECAY) && prob(prob_eat))
		if(istype(I,/obj/item/food) && ispath(I:trash_type))
			var/J = new I:trash_type(I.loc)
			item_log[ITEMLOG_CURRENT_ITEM]=J
			item_log[ITEMLOG_PERCENT_CONSUMED]=ITEMLOG_CONSUMED_AND_TRANSFORMED // item has transformed, will be qdel'd in describe_journey
			I = J
			if(prob(prob_min))
				extra_dirt = pick(/obj/effect/decal/cleanable/ants,/obj/effect/decal/cleanable/dirt)

		if(istype(I,/obj/item/match))
			I:lit = 1
			I:matchburnout()
			item_log[ITEMLOG_PERCENT_CONSUMED]=100
			if(prob(prob_min))
				extra_dirt = /obj/effect/decal/cleanable/ash

		// The isnull type_butt check is a sanity I added to pipes so that they don't get used up
		// Really who takes a cigarette out and doesn't smoke it I ought to make it 100%
		if(istype(I,/obj/item/clothing/mask/cigarette) && !isnull(I:type_butt))
			var/J = new I:type_butt(I.loc)
			item_log[ITEMLOG_CURRENT_ITEM] = J
			item_log[ITEMLOG_PERCENT_CONSUMED] = ITEMLOG_CONSUMED_AND_TRANSFORMED
			I = J
			if(prob(prob_min))
				extra_dirt = /obj/effect/decal/cleanable/ash

		// For the most part we are being careful to do nothing bad here.
		// Mostly we affect drinks and condiments (salt, pepper, and ketchup, not bags of flour which share a common type)
		// We will also snack on pills, which shouldn't end up being a huge problem.
		if(istype(I,/obj/item/reagent_containers) && I.reagents?.total_volume)

			// Drinking glasses
			if(istype(I,/obj/item/reagent_containers/cup/glass))
				var/removal_amt = pick(0.25,0.5,0.5,0.5,0.75,1,1,1)
				item_log[ITEMLOG_PERCENT_CONSUMED]=100*removal_amt // drink
				removal_amt = round(removal_amt * I.reagents.total_volume)
				I.reagents.remove_any(removal_amt)
				I.update_icon()

			// Soh-dah cans
			if(istype(I,/obj/item/reagent_containers/cup/soda_cans))
				// Pop it open
				I.reagents.flags |= OPENCONTAINER
				I:spillable = TRUE
				var/removal_amt = pick(0.25,0.5,0.5,0.5,0.75,1,1,1)
				if(removal_amt == 1 && prob(prob_max)) // Crush de can
					var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(I.loc)
					crushed_can.icon_state = I.icon_state
					item_log[ITEMLOG_CURRENT_ITEM]=crushed_can  // item has transformed, will be qdel'd in describe_journey
					item_log[ITEMLOG_PERCENT_CONSUMED]=ITEMLOG_CONSUMED_AND_TRANSFORMED // item has transformed, will be qdel'd in describe_journey
					I = crushed_can
				else
					item_log[ITEMLOG_PERCENT_CONSUMED]=100*removal_amt // drink
					removal_amt = round(removal_amt * I.reagents.total_volume)
					I.reagents.remove_any(removal_amt)
			// Pills and also patches
			if(istype(I,/obj/item/reagent_containers/pill))
				item_log[ITEMLOG_PERCENT_CONSUMED]=ITEMLOG_CONSUMED_AND_TRANSFORMED// item will be qdel'd in describe_journey
				return
			//have to be alittle careful here
			if(istype(I,/obj/item/reagent_containers/condiment))
				if(I:amount_per_transfer_from_this == 1) // should only be salt and pepper shakers
					var/removal_amt = min(pick(1,1,2,2,4,6,8,10,I:volume),I.reagents.total_volume)
					var/pct = round(100 * removal_amt / I.reagents.total_volume)
					item_log[ITEMLOG_PERCENT_CONSUMED]=pct // drink
					I.reagents.remove_any(removal_amt)
				if(istype(I,/obj/item/reagent_containers/condiment/pack))
					item_log[ITEMLOG_PERCENT_CONSUMED]=100 // apply directly to the forehead
					I.reagents.remove_all() // condiment packs should update their icon automatically when reagents are deleted.

	switch(pick(1,1,2,2,2,3))
		if(3)
			if(candidate_closets.len && (opt & SHUFFLE_TO_CLOSETS) )
				var/obj/O = pick(candidate_closets)
				I.forceMove(O)
				I.pixel_x = 0
				I.pixel_y = 0
				item_log[5]=O
				if(ispath(extra_dirt))
					extra_dirt = new extra_dirt(O.loc)
					step_rand(extra_dirt)
				return
			// otherwise fall through
		if(2)
			if(candidate_turfs.len) // This will only be full if you can shuffle to tables/racks
				var/turf/T = pick(candidate_turfs)
				if(T != I.loc)
					I.forceMove(T)
					I.pixel_x = rand(-8,8)
					I.pixel_y = rand(-8,8)
					item_log[5] = candidate_turfs[T]
					if(ispath(extra_dirt))
						extra_dirt = new extra_dirt(T)
						step_rand(extra_dirt)
					return
			// otherwise fall through
	var/turf/T = I.loc
	var/attempts = 2
	while(I.loc == T && attempts-- > 0) // step_rand doesn't care if it would run into a wall and fail
		step_rand(I)
	if(I.loc != T)
		I.pixel_x = rand(-8,8)
		I.pixel_y = rand(-8,8)
		if(ispath(extra_dirt))
			extra_dirt = new extra_dirt(I.loc)
		if(I.loc in candidate_turfs)
			item_log[ITEMLOG_DESTINATION_STRUCTURE] = candidate_turfs[I.loc]
			if(extra_dirt)
				step_rand(extra_dirt)
		else if(I.loc in source_turfs)
			item_log[ITEMLOG_DESTINATION_STRUCTURE] = source_turfs[I.loc]
			if(extra_dirt)
				step_rand(extra_dirt)


/datum/controller/subsystem/table_shuffle/proc/describe_journey(var/area/A, var/obj/item/I, var/list/item_log,var/list/table_turfs,var/list/destinations)
	// journey list: [current_item, original_loc, original_item, consume_amt,dest_reference]
	// We can ignore current_item now (we needed it to track the effects of decay earlier)
	var/atom/oloc = item_log[ITEMLOG_ORIGINAL_LOC]
	var/obj/item/oitem = item_log[ITEMLOG_ORIGINAL_ITEM]
	var/eat_amt = item_log[ITEMLOG_PERCENT_CONSUMED]
	var/atom/destination_reference = item_log[ITEMLOG_DESTINATION_STRUCTURE]
	var/atom/start_reference = null

	var/story = "<p>"
	. = JOURNEY_DID_MOVE

	// Easy start: vending
	if(istype(oloc,/obj/machinery/vending))
		story += "<u title='[oitem?.type]'>[oitem]</u> was vended from <u title='[oloc?.type]'>\the [oloc]</u>. "
		. = JOURNEY_DID_MOVE | JOURNEY_WAS_VENDED
	// Complicated: Out of a box
	else if(istype(oloc,/obj/item))
		// box was in closet/crate?
		if(istype(oloc.loc,/obj/structure))
			story += "<u title='[oitem?.type]'>[oitem]</u> was removed from <u title='[oloc?.type]'>\the [oloc]</u> in <u title='[oloc?.loc?.type]'>\the [oloc?.loc]</u>. "
		// box was on a table/rack/etc?
		else if(isturf(oloc.loc))
			if(oloc.loc in table_turfs)
				start_reference = table_turfs[oloc.loc]
				story += "<u title='[oitem?.type]'>[oitem]</u> was removed from <u title='[oloc?.type]'>\the [oloc]</u> on <u title='[start_reference?.type]'>\the [start_reference]</u>. "
			else // possibly started on something else or was vended?  May never occur
				story += "<u title='[oitem?.type]'>[oitem]</u> was removed from <u title='[oloc?.type]'>\the [oloc]</u>. "
		// ???
		else
			story += "<u title='[oitem?.type]'>[oitem]</u> had <u title='Not turf or recognized container'>a confusing beginning</u> on <u title='[oloc?.type]'>\the [oloc]</u>. "
	//Simpler: came out of a closet
	else if(istype(oloc,/obj/structure)) // coming out of a closet or crate
		story += "<u title='[oitem?.type]'>[oitem]</u> was removed from <u title='[oloc?.type]'>\the [oloc]</u>. "
	// mostly simple: Probably started on a table/rack/etc
	else if(isturf(oloc))
		if(oloc in table_turfs)
			start_reference = table_turfs[oloc]
			story += "<u title='[oitem?.type]'>[oitem]</u> started atop <u title='[start_reference?.type]'>\the [start_reference]</u>. "
		else
			story += "<u title='[oitem?.type]'>[oitem]</u> had <u title='Turf starting location, no reference structure'>a mysterious beginning</u> on <u title='[oloc?.type]'>\the [oloc]</u>. "
	else if(isnull(oloc)) // this hasn't happened yet, but it's worth putting in
		story += "It turns out that <u title='[oitem?.type]'>\the [oitem]</u> was a destined hero brought here from <u title='Object started in nullspace'>another world</u>. "
	else
		story += "<u title='[oitem?.type]'>[oitem]</u> had <u title='Not turf or recognized container'>a confusing beginning</u> on <u title='[oloc?.type]'>\the [oloc]</u>. "

	if(eat_amt > 0)
		. += JOURNEY_WAS_CONSUMED
		if(eat_amt <= 100)
			story += "It was [eat_amt]% consumed. "
		else // value of ITEMLOG_CONSUMED_AND_TRANSFORMED (200) indicating the item was replaced / should be destroyed

			if(oitem != I)
				story += "It was consumed, leaving <u title='[I] ([I?.type])'>trash</u> behind. "
				qdel(oitem) // we kept the original until now

			else // Using the sentry value without changing the item means it disappears, we don't want to deal with nulls
				story += "It was consumed entirely."
				qdel(oitem)
				A.shuffle_log += story
				return

	// I'm not implementing it right this minute but some things might mutate without being consumed, eg, latex gloves into balloons
	else if(oitem != I)
		story += "It was turned into <u title='[I?.type]'>\an [I]</u>. "
		qdel(oitem)

	var/turf/T = I.loc
	// Not on a turf - probably in a closet
	if(!istype(T))
		if(isnull(T))
			var/agent = pick("choir of angels","band of demons","posse of clowns","syndicate operative","Nanotrasen Death Squad","flying spaghetti monster","telekientic butt")
			var/safety = pick("heaven","hell","clown school","the syndicate","lavaland","the icemoon","nullspace","my butt","candy mountain")
			story += "\An [agent] whisked it away to <u title='Entity ended up in nullspace?'>[safety]</u> when nobody was looking.</p>"
		else
			story += "It got hidden in <u title='[T?.type]'>\the [T]</u>.</p>"
	// Was on a table and then knocked on the floor
	else if(T != get_turf(destination_reference))
		// It was moved to a different table before it was knocked down
		if(get_turf(destination_reference) != get_turf(oloc))
			story += "It was moved to \the [destination_reference] and then knocked onto \the [I.loc].</p>"
		else // or it wasn't
			story += "It was knocked onto \the [I.loc].</p>"

	else // Still on the destination reference's turf

		// this shouldn't be, the destination reference should be set to an object
		if(isturf(destination_reference))
			story += "It <u title='reference object is a turf'>mysteriously</u> ended up on <u title='[destination_reference?.type]'>\the [destination_reference]</u>.</p>"

		// Not at the original location
		else if(T != get_turf(oloc))
			if(start_reference && (start_reference.name == destination_reference.name)) // Notice if they are named the same thing
				story += "It was moved to another <u title='[destination_reference?.type]'>[destination_reference]</u>.</p>"
			else
				story += "It was moved to <u title='[destination_reference?.type]'>\the [destination_reference]</u>.</p>"

		else if(!isnull(T)) // probably vended and not moved
			story += "It was left there.</p>"
			. -= JOURNEY_DID_MOVE
			if(. == 0) // Non-event: this can happen if an item is randomly decided to move to its own location or failed to fall off a table
				return

		else // Can happen if the same item gets picked to move a second time after undergoing a destructive transformation
			var/agent = pick("choir of angels","band of demons","posse of clowns","syndicate operative","Nanotrasen Death Squad","flying spaghetti monster","telekientic butt")
			var/safety = pick("heaven","hell","clown school","the syndicate","lavaland","the icemoon","nullspace","my butt","candy mountain")
			story += "\An [agent] whisked it away to <u title='Entity ended up in nullspace?'>[safety]</u> when nobody was looking.</p>"
	A.shuffle_log += story
