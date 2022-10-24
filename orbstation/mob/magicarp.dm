// Removes some disruptive spells from the chaos magicarp
/mob/living/simple_animal/hostile/carp/ranged
	allowed_projectile_types = list(
		/obj/projectile/magic/animate,
		/obj/projectile/magic/arcane_barrage,
		/obj/projectile/magic/door,
		/obj/projectile/magic/fireball,
		/obj/projectile/magic/resurrection,
		/obj/projectile/magic/spellblade,
		/obj/projectile/magic/teleport,
		/obj/projectile/magic/babel,
		/obj/projectile/magic/wound,
		/obj/projectile/magic/freeze,
		/obj/projectile/magic/hallucination,
		/obj/projectile/magic/repulse,
		/obj/projectile/magic/swap,
	)
