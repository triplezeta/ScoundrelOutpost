// checks if the victim has the x-card trait that prevents rev conversion
// if they do, deals damage to them, knocks them unconscious, and returns TRUE
// otherwise does nothing and returns FALSE
/datum/antagonist/rev/proc/check_xcard_and_apply_if_necessary(datum/mind/victim_mind, mob/aggressor)

    if (!iscarbon(victim_mind.current)) // redundant check (theres another one later one) but whatever
        return FALSE

    var/mob/living/carbon/victim = victim_mind.current

    if(HAS_TRAIT(victim_mind, TRAIT_XCARD_REV_IMMUNE))
        to_chat(aggressor, span_warning("[victim] manages to resist your influence, but reels in pain from the psychic blast!"))

        to_chat(victim, span_hypnophrase("A wave of psychic influence rolls over you!"))
        to_chat(victim, span_hypnophrase("You reel in pain from \the [src]'s psychic blast!"))

        victim.apply_damage(40, BRUTE, BODY_ZONE_HEAD)
        victim.adjustOrganLoss(ORGAN_SLOT_BRAIN, 20)

        to_chat(victim, span_hypnophrase("You successfully shield your brain from conversion, \
										  but feel darkness encroaching as the identity of your attacker fades from your memory..."))
        victim.Unconscious(60 SECONDS)

        return TRUE

    return FALSE
