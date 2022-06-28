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

/mob/living/simple_animal/amoung/Initialize(mapload)
	. = ..()
	set_greyscale(new_config=/datum/greyscale_config/amoung)
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/amoung/bee_friendly()
	return TRUE //why not lol

/mob/living/simple_animal/amoung/red
	greyscale_colors = "#ff0033"

/mob/living/simple_animal/amoung/blue
	greyscale_colors = "#3366ff"

/mob/living/simple_animal/amoung/green
	greyscale_colors = "#10802d"

/mob/living/simple_animal/amoung/pink
	greyscale_colors = "#ee55ba"

/mob/living/simple_animal/amoung/orange
	greyscale_colors = "#f17d0e"

/mob/living/simple_animal/amoung/yellow
	greyscale_colors = "#e9ea53"

/mob/living/simple_animal/amoung/black
	greyscale_colors = "#3f484e"

/mob/living/simple_animal/amoung/white
	greyscale_colors = "#d6e1f0"

/mob/living/simple_animal/amoung/purple
	greyscale_colors = "#6b30bc"

/mob/living/simple_animal/amoung/brown
	greyscale_colors = "#72491e"

/mob/living/simple_animal/amoung/cyan
	greyscale_colors = "#39e2dd"

/mob/living/simple_animal/amoung/lime
	greyscale_colors = "#50f038"

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

/mob/living/simple_animal/amoung/pequeno/red
	greyscale_colors = "#ff0033"

/mob/living/simple_animal/amoung/pequeno/blue
	greyscale_colors = "#3366ff"

/mob/living/simple_animal/amoung/pequeno/green
	greyscale_colors = "#10802d"

/mob/living/simple_animal/amoung/pequeno/pink
	greyscale_colors = "#ee55ba"

/mob/living/simple_animal/amoung/pequeno/orange
	greyscale_colors = "#f17d0e"

/mob/living/simple_animal/amoung/pequeno/yellow
	greyscale_colors = "#e9ea53"

/mob/living/simple_animal/amoung/pequeno/black
	greyscale_colors = "#3f484e"

/mob/living/simple_animal/amoung/pequeno/white
	greyscale_colors = "#d6e1f0"

/mob/living/simple_animal/amoung/pequeno/purple
	greyscale_colors = "#6b30bc"

/mob/living/simple_animal/amoung/pequeno/brown
	greyscale_colors = "#72491e"

/mob/living/simple_animal/amoung/pequeno/cyan
	greyscale_colors = "#39e2dd"

/mob/living/simple_animal/amoung/pequeno/lime
	greyscale_colors = "#50f038"
