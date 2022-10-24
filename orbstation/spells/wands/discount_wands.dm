/// A different wand belt with randomised an less obviously useful options.
/obj/item/storage/belt/wands/discount
	/// Things which can appear
	var/static/list/possible_options = list(
		/obj/item/gun/magic/wand/resurrection,
		/obj/item/gun/magic/wand/teleport,
		/obj/item/gun/magic/wand/fireball,
		/obj/item/gun/magic/wand/door,
		/obj/item/gun/magic/wand/animate,
		/obj/item/gun/magic/wand/zap,
		/obj/item/gun/magic/wand/wound,
		/obj/item/gun/magic/wand/freeze,
		/obj/item/gun/magic/wand/prank,
		/obj/item/gun/magic/wand/hallucination,
		/obj/item/gun/magic/wand/pax,
		/obj/item/gun/magic/wand/repulse,
		/obj/item/gun/magic/wand/teleport_rune,
		/obj/item/gun/magic/wand/swap,
		/obj/item/gun/magic/wand/pizza,
		/obj/item/gun/magic/wand/babel,
	)

/obj/item/storage/belt/wands/discount/PopulateContents()
	var/list/available_options = possible_options.Copy()
	for (var/i in 1 to 6)
		if (!length(available_options))
			break
		var/wand_path = pick_n_take(available_options)
		new wand_path(src)

	for (var/obj/item/gun/magic/wand/W in contents) //All wands in this pack come in the best possible condition
		W.max_charges = initial(W.max_charges)
		W.charges = W.max_charges
