// Collapsing tendrils don't create chasms any more, instead they do a final revenge attack
/obj/effect/collapse/collapse()
	for(var/mob/M in range(7,src))
		shake_camera(M, 15, 1)
	playsound(get_turf(src),'sound/effects/explosionfar.ogg', 200, TRUE)
	visible_message(span_boldannounce("With a last spasm of grasping limbs, the tendril retreats below the ground!"))
	for(var/turf/near_turf in RANGE_TURFS(2,src))
		if(near_turf.density)
			continue
		new /obj/effect/temp_visual/goliath_tentacle/magic(near_turf)
	qdel(src)
