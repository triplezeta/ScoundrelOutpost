/// Non-exploding flux anomaly. This subtype should be how the supermatter handles it probably, but isn't.
/obj/effect/anomaly/flux/minor
	explosive = FLUX_NO_EXPLOSION

/obj/effect/anomaly/flux/minor/Initialize(mapload, new_lifespan, drops_core = TRUE, explosive = FLUX_NO_EXPLOSION)
	return ..()
