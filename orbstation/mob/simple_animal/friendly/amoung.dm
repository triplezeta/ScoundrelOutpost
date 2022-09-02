//" Among Us Promise "
//I promise you, in full not part
//That Among Us Creatures come first in my heart
//Whether it be night or day
//A game of Among Us, I'd love to play!
//Recite this promise if you would drop everything to play a game of "Among Us" - no matter the costs.

/mob/living/simple_animal/amoung //default color is red, others are defined below
	name = "amoung"
	desc = "What a fascinating and strange little creature. Probably harmless?"
	icon = 'orbstation/icons/mob/amoung.dmi'
	icon_state = "amoung"
	icon_living = "amoung"
	icon_dead = "amoung_dead"
	turns_per_move = 3
	response_help_continuous = "bumps"
	response_help_simple = "bump"
	response_disarm_continuous = "pushes aside"
	response_disarm_simple = "push aside"
	response_harm_continuous = "attacks"
	response_harm_simple = "attack"
	speak_emote = list("communicates")
	maxHealth = 25
	health = 25
	harm_intent_damage = 1
	friendly_verb_continuous = "nudges"
	friendly_verb_simple = "nudge"
	density = FALSE
	mob_biotypes = MOB_ORGANIC
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "communicates"
	verb_ask = "communicates"
	verb_exclaim = "communicates"
	verb_yell = "communicates"
	dextrous = TRUE
	gender = NEUTER
	footstep_type = FOOTSTEP_MOB_SHOE
	held_items = list(null, null)
	greyscale_colors = "#ffffff"
	/// List of possible amongus colours.
	var/static/list/amoung_colors = list(
		"red" = "#ff0033",
		"blue" = "#3366ff",
		"green" = "#10802d",
		"pink" = "#ee55ba",
		"yellow" = "#e9ea53",
		"black" = "#3f484e",
		"white" = "#d6e1f0",
		"purple" = "#6b30bc",
		"brown" = "#72491e",
		"cyan" = "#39e2dd",
		"lime" = "#50f038"
	)

/mob/living/simple_animal/amoung/Initialize(mapload)
	. = ..()
	random_colour()
	set_greyscale(new_config=/datum/greyscale_config/amoung)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

///picks a random colour for our amoung
/mob/living/simple_animal/amoung/proc/random_colour()
	var/our_color = pick(amoung_colors)
	set_greyscale(colors=list(amoung_colors[our_color]))

/mob/living/simple_animal/amoung/bee_friendly()
	return TRUE //why not lol

//amoung pequeño amoung pequeño amoung pequeño amoung pequeño amoung pequeño
//amoung pequeño amoung pequeño amoung pequeño amoung pequeño amoung pequeño

/mob/living/simple_animal/amoung/pequeno
	name = "amoung pequeño"
	desc = "What a sooooo small creature. Probably harmless?"
	icon_state = "amoung_pequeno"
	icon_living = "amoung_pequeno"
	icon_dead = "amoung_pequeno_dead"

/mob/living/simple_animal/amoung/pequeno/Initialize(mapload)
	. = ..()
	set_greyscale(new_config=/datum/greyscale_config/amoung_pequeno)

// corpse spawners, you monster

/obj/effect/mob_spawn/corpse/amoung
	mob_type = /mob/living/simple_animal/amoung

/obj/effect/mob_spawn/corpse/amoung/pequeno
	mob_type = /mob/living/simple_animal/amoung/pequeno

// amoung... surgeon??
// doesn't actually inherit from amoung because amoungs are not hostile and lack code for attacking people
// Can probably be replaced when I do my future 'among us content expansion', if that ever happens

/mob/living/simple_animal/hostile/amoung/surgeon
	name = "suspicious surgeon"
	desc = "Hey! What's this guy up to?"
	icon = 'orbstation/icons/mob/amoung.dmi'
	icon_state = "amoung"
	icon_living = "amoung"
	icon_dead = "amoung_dead"
	turns_per_move = 5
	speed = 0
	robust_searching = 1
	maxHealth = 100
	health = 100
	speak = list("Meow!", "Esp!", "Purr!", "HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows.", "mews.")
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes at"
	attack_verb_simple = "slash at"
	attack_sound = 'sound/weapons/circsawhit.ogg'
	combat_mode = TRUE
	mob_biotypes = MOB_ORGANIC
	sentience_type = SENTIENCE_HUMANOID
	loot = list(/mob/living/simple_animal/pet/cat/kitten/surgeon, /obj/item/stack/cable_coil, /obj/item/stack/sheet/cloth, /obj/item/stock_parts/manipulator, /obj/item/circular_saw)
	faction = list("hostile")
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = 1

/mob/living/simple_animal/hostile/amoung/surgeon/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

// Meow when attacking
/mob/living/simple_animal/hostile/amoung/surgeon/AttackingTarget()
	. = ..()
	if(. && prob(35))
		say(pick(speak))

// Shock twist!
/mob/living/simple_animal/hostile/amoung/surgeon/death(gibbed)
	var/obj/effect/particle_effect/fluid/smoke/poof = new(get_turf(src))
	poof.lifetime = 2 SECONDS
	do_sparks(3, TRUE, src)
	visible_message(span_notice("[src] collapses to the ground! ...and something crawls out of its empty suit?"))
	..(TRUE)

/mob/living/simple_animal/pet/cat/kitten/surgeon
	name = "suspicious kitten"
	desc = "You don't think this cat was... no... it couldn't be, could it?"
	gold_core_spawnable = NO_SPAWN
