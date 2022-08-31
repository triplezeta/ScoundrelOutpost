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

/datum/controller/subsystem/table_shuffle/Initialize()
	if(config.Get(/datum/config_entry/flag/disable_table_shuffle))
		return
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
	// note that "affected areas" does not count anything that cannot or is configured not to shuffle
	// and also ignores those that are skipped immediately by the flat prob() at the beginning.
	// It only averages areas actually shuffled.
	var/msg = "Table shuffle averaged [round(event_total / affected_area_amt)] events among [affected_area_amt] affected areas, [high_rollers.len] being high rollers."
	to_chat(world, span_boldannounce("[msg]"))
	log_world(msg)
	return ..()

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
	// Each list is formatted as [current_obj,original_loc,original_object,consume_amt,dest_reference]
	// dest_reference exists so if it's knocked on the floor we know what it's near.
	var/list/all_moves = list()

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
				var/list/journey = list(I,V,I,0,V)
				all_moves[I]=journey
				if(opt & SHUFFLE_FROM_BOXES)
					if(istype(I,/obj/item/storage) && I.contents.len)
						boxes += I
				shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,journey,1)
				if(journey[1] != I) // transformed
					all_moves -= I
					all_moves[journey[1]] = journey

	// Unlocked closets might have objects moved or removed
	if(opt & SHUFFLE_FROM_CLOSETS)
		for(var/obj/structure/closet/C in unlocked_closets.len)
			// Some places have a lot of full closets, lower probability
			var/closet_prob = min(prob_max,prob_min + C.contents.len * prob_add) / 2
			if(opt & SHUFFLE_EXTRA_MOVING)
				closet_prob *= 2 // was already halved
			while(C.contents.len && prob(closet_prob))
				var/obj/I = pick(C.contents)
				if(opt & SHUFFLE_FROM_BOXES)
					if(istype(I,/obj/item/storage) && I.contents.len)
						boxes += I
				I.loc = C.loc
				var/list/journey = list(I,C,I,0,C)
				all_moves[I]=journey
				closet_prob -= prob_sub
				move_prob -= prob_sub / 2 // This counts as half a move because we used a different seed to get there
				shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,journey)
				if(journey[1] != I) // transformed
					all_moves -= I
					all_moves[journey[1]] = journey

	// Box contents might be removed
	if(opt & SHUFFLE_FROM_BOXES)
		for(var/obj/item/storage/B in boxes)
			// Some places have a lot of full boxes, lower probability
			var/box_prob = min(prob_max,prob_min + B.contents.len * prob_add) / 2
			while(B.contents.len && prob(box_prob))
				var/obj/I = pick(B.contents)
				I.loc = get_turf(B)
				// We are trying to get a narrative reference point for the box's location for describe_journey
				var/atom/bloc = B.loc
				if(isturf(B))
					if(bloc in table_turfs)
						bloc = table_turfs[bloc]
					else if(bloc in destinations)
						bloc = destinations[bloc]
				var/list/journey = list(I,B,I,0,bloc)
				all_moves[I] = journey
				box_prob -= prob_sub
				move_prob -= prob_sub / 2
				shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,journey)
				if(journey[1] != I) // transformed
					all_moves -= I
					all_moves[journey[1]] = journey

	// Anything on a table or rack might be placed elsewhere, or fall off randomly
	var/list/candidate_items = list()
	if(opt & (SHUFFLE_FROM_TABLES|SHUFFLE_FROM_RACKS|SHUFFLE_VISUAL))
		for(var/turf/T in table_turfs)
			for(var/obj/item/I in T)
				if(I.anchored || I.density) continue
				if(opt & SHUFFLE_VISUAL)
					if(prob(prob_visual))
						I.loc = null
						I.loc = T //change position in turf contents list (over/under other items)
					if(prob(prob_visual))
						I.pixel_x += rand(-8,8) // shift appearance on table/rack
						I.pixel_y += rand(-8,8)
				candidate_items += I

	// The process above created the list but also jostled things, so this is a separate logic check
	if(opt & (SHUFFLE_FROM_TABLES|SHUFFLE_FROM_RACKS))
		while(candidate_items.len && prob(move_prob))
			var/obj/item/I = pick(candidate_items)
			move_prob -= prob_sub
			var/list/journey
			if(!(I in all_moves))
				journey = all_moves[I] = list(I,I.loc,I,0,table_turfs[I.loc])
			else
				journey = all_moves[I]
			shuffle_decay_item(opt,A,I,table_turfs,destinations,unlocked_closets,journey)
			if(journey[1] != I) // transformed
				all_moves -= I
				all_moves[journey[1]] = journey
	var/vends = 0
	var/moves = 0
	var/decays = 0
	for(var/obj/item/I in all_moves)
		var/stats = describe_journey(A,I,all_moves[I],table_turfs,destinations)
		if(stats & 1) vends++
		if(stats & 2) moves++
		if(stats & 4) decays++
	A.shuffle_log += "<p><b>In total, [vends] free items and [decays] consumed items out of [all_moves.len] events.</b></p>"
	if(!manual)
		total_vends += vends
		total_moves += moves
		total_decays += decays

	return all_moves.len

/datum/controller/subsystem/table_shuffle/proc/shuffle_decay_item(var/opt,var/area/A, var/obj/item/I, var/list/source_turfs,var/list/candidate_turfs, var/list/candidate_closets,var/list/item_log,var/deferred=0)
	if(opt & SHUFFLE_DECAY)
		if(istype(I,/obj/item/food))
			if(ispath(I:trash_type) && prob(prob_eat))
				var/J = new I:trash_type(I.loc)
				item_log[1]=J
				item_log[4]=200 // item has transformed, will be qdel'd in describe_journey
				I = J
		// For the most part we are being careful to do nothing bad here.
		// Mostly we affect drinks and condiments (salt, pepper, and ketchup, not bags of flour which share a common type)
		// We will also snack on pills, which shouldn't end up being a huge problem.
		if(istype(I,/obj/item/reagent_containers) && I.reagents?.total_volume && prob(prob_eat))
			if(istype(I,/obj/item/reagent_containers/cup/glass))
				var/removal_amt = pick(0.25,0.5,0.5,0.5,0.75,1,1,1)
				item_log[4]=100*removal_amt // drink
				removal_amt = round(removal_amt * I.reagents.total_volume)
				I.reagents.remove_any(removal_amt)
				I.update_icon()
			if(istype(I,/obj/item/reagent_containers/cup/soda_cans))
				// Pop open a can
				I.reagents.flags |= OPENCONTAINER
				I:spillable = TRUE
				var/removal_amt = pick(0.25,0.5,0.5,0.5,0.75,1,1,1)
				if(removal_amt == 1 && prob(prob_max)) // Crush de can
					var/obj/item/trash/can/crushed_can = new /obj/item/trash/can(I.loc)
					crushed_can.icon_state = I.icon_state
					item_log[1]=crushed_can  // item has transformed, will be qdel'd in describe_journey
					item_log[4]=200 // item has transformed, will be qdel'd in describe_journey
					I = crushed_can
				else
					item_log[4]=100*removal_amt // drink
					removal_amt = round(removal_amt * I.reagents.total_volume)
					I.reagents.remove_any(removal_amt)
			if(istype(I,/obj/item/reagent_containers/pill))
				item_log[4]=200// item will be qdel'd in describe_journey
				return
			if(istype(I,/obj/item/reagent_containers/condiment))
				if(I:amount_per_transfer_from_this == 1) // should only be salt and pepper shakers
					var/removal_amt = min(pick(1,1,2,2,4,6,8,10,I:volume),I.reagents.total_volume)
					var/pct = round(100 * removal_amt / I.reagents.total_volume)
					item_log[4]=pct // drink
					I.reagents.remove_any(removal_amt)
				if(istype(I,/obj/item/reagent_containers/condiment/pack))
					item_log[4]=100 // apply directly to the forehead
					I.reagents.remove_all() // condiment packs should update their icon automatically when reagents are deleted.

	switch(pick(1,1,2,2,2,3))
		if(3)
			if(candidate_closets.len && (opt & SHUFFLE_TO_CLOSETS) )
				var/obj/O = pick(candidate_closets)
				I.loc = O
				I.pixel_x = 0
				I.pixel_y = 0
				item_log[5]=O
				return
			// otherwise fall through
		if(2)
			if(candidate_turfs.len) // This will only be full if you can shuffle to tables/racks
				var/turf/T = pick(candidate_turfs)
				if(T != I.loc)
					I.loc = T
					I.pixel_x = rand(-8,8)
					I.pixel_y = rand(-8,8)
					item_log[5] = candidate_turfs[T]
					return
			// otherwise fall through
	var/turf/T = I.loc
	var/attempts = 2
	while(I.loc == T && attempts-- > 0) // step_rand doesn't care if it would run into a wall and fail
		step_rand(I)
	if(I.loc != T)
		I.pixel_x = rand(-8,8)
		I.pixel_y = rand(-8,8)
		if(I.loc in candidate_turfs)
			item_log[5] = candidate_turfs[I.loc]
		else if(I.loc in source_turfs)
			item_log[5] = source_turfs[I.loc]


/datum/controller/subsystem/table_shuffle/proc/describe_journey(var/area/A, var/obj/item/I, var/list/journey,var/list/table_turfs,var/list/destinations)
	// journey list: [current_item, original_loc, original_item, consume_amt,dest_reference]
	// We can ignore current_item now (we needed it to track the effects of decay earlier)
	var/atom/oloc = journey[2]
	var/obj/item/oitem = journey[3]
	var/eat_amt = journey[4]
	var/atom/destination_reference = journey[5]
	var/atom/start_reference = null

	var/story = "<p>"
	. = 2 // we are also returning a micro-bitfield 1:vend 2:move 4:decay

	if(istype(oloc,/obj/machinery/vending))
		story += "[oitem] was vended from \the [oloc]. "
		. = 3
	else if(istype(oloc,/obj/item))
		if(istype(oloc.loc,/obj/structure))
			story += "[oitem] was removed from \the [oloc] in \the [oloc.loc]. "
		else
			story += "[oitem] was removed from \the [oloc]. "
	else if(istype(oloc,/obj/structure)) // coming out of a closet or crate
		story += "[oitem] was removed from \the [oloc]. "
	else if(isturf(oloc))
		if(oloc in table_turfs)
			start_reference = table_turfs[oloc]
			story += "[oitem] started atop \the [start_reference]. "
		else
			story += "[oitem] had a mysterious beginning on \the [oloc]. "
	else
		story += "[oitem] had a confusing beginning on \the [oloc]. "

	if(eat_amt > 0)
		. += 4
		if(eat_amt <= 100)
			story += "It was [eat_amt]% consumed. "
		else // flag value of 200 indicating the item was replaced / should be destroyed
			if(oitem != I)
				story += "It was consumed, leaving trash behind. "
				qdel(oitem) // we kept the original until now
			else // this happens when we eat a pill or apply a patch, we don't want to deal with nulls in the lists
				story += "It was consumed entirely."
				qdel(oitem)
				A.shuffle_log += story
				return

	var/turf/T = I.loc
	if(!istype(T))
		story += "It got hidden in \the [T].</p>"
	else if(T != get_turf(destination_reference)) // was knocked onto the floor from wherever it last was
		if(get_turf(destination_reference) != get_turf(oloc))
			story += "It was moved to \the [destination_reference] and then knocked onto \the [I.loc].</p>"
		else
			story += "It was knocked onto \the [I.loc].</p>"
	else
		if(isturf(destination_reference)) // this shouldn't be, we should set this variable to a known thing
			story += "It mysteriously ended up on \the [destination_reference].</p>"
		else if(T != get_turf(oloc))
			if(start_reference && (start_reference.name == destination_reference.name))
				story += "It was moved to another [destination_reference].</p>"
			else
				story += "It was moved to \the [destination_reference].</p>"
		else if(!isnull(T)) // probably vended and not moved
			story += "It was left there.</p>"
			. -= 2
			if(. == 0) // Non-event: this can happen if an item is randomly decided to move to its own location or failed to fall off a table
				return
		else
			story += "It ended up in nullspace for some reason.</p>"
	A.shuffle_log += story
