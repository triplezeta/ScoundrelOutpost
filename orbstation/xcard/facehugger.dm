/obj/item/clothing/mask/facehugger/proc/VenomousBite(mob/living/carbon/target)
    target.visible_message(span_danger("[src] bites [target]'s face, injecting acidic venom!"), \
                        span_userdanger("[src] bites your face, injecting acidic venom!"))

    // initial bite damage
    target.reagents?.add_reagent(/datum/reagent/toxin/acid/, 5)
    target.reagents?.add_reagent(/datum/reagent/toxin/curare/, 2.5)
    target.reagents?.add_reagent(/datum/reagent/toxin/venom/, 5)

    target.apply_damage(strength, BRUTE, BODY_ZONE_HEAD)

    // lingering venom
    target.reagents?.add_reagent(/datum/reagent/toxin/xenotoxin, 10)

    Die()
