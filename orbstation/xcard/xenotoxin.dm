// values concerning stamina loss
#define STAM_DAMAGE_MIN 1
#define STAM_DAMAGE_MAX 5
// note that this is a percent, not a value from 0 to 1
#define STAM_DAMAGE_RATE 2

// values concerning the occasional burst of damage
// how much more damage a damage burst frame does than a normal one. this goes up by one every damage burst
#define DAMAGE_BURST_MUL 10
// again, note that this is a percent chance
#define DAMAGE_BURST_RATE 1
#define JITTER_TIME 10 SECONDS
// note that unlike tox damage, stamina damage, etc, organ damage is NOT multiplied by DAMAGE_BURST_MUL
#define ORGAN_DAMAGE_MIN 1
#define ORGAN_DAMAGE_MAX 5
#define SCREAM_PROB 1

/datum/reagent/toxin/xenotoxin
    name = "Xenotoxin"
    description = "A powerful venom injected by immature xenomorphs when they fail infect a host. \
                    Lingers in the system for a long time, causing the victim to continuously weaken."
    color = "#1a011c" // not sure the best color, so i went with xeno-ish purple/black
    toxpwr = 0.25 // deals low damage but spends a long, long time in your system
    ph = 1
    taste_description = "acrid bile"
    penetrates_skin = TOUCH
    metabolization_rate = 0.1 * REAGENTS_METABOLISM

    // number of times a damage burst has been triggered
    var/damage_spikes = 0

/datum/reagent/toxin/xenotoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)

    ..()

    if (DT_PROB(STAM_DAMAGE_RATE, delta_time))
        M.adjustStaminaLoss(rand(STAM_DAMAGE_MIN, STAM_DAMAGE_MAX) * REM * delta_time, 0)

    // TODO
    // a bunch of lines in this file say "unable to determine offset in proc", the debugger shows really strange behavior, and the code just isnt working like it should
    // maybe it's cursed

    if (DT_PROB(DAMAGE_BURST_RATE, delta_time))
        if (prob(clamp(50 - M.health, 0, 50) + damage_spikes))
            to_chat(M, span_danger("Your heartrate spikes, and it feels like acid is running through your veins!"))
            damage_burst_bad(M, DAMAGE_BURST_MUL + damage_spikes, delta_time)
            damage_burst_normal(M, DAMAGE_BURST_MUL + damage_spikes, delta_time)
        else
            // TODO why isnt this happening?
            to_chat(M, span_danger("Your blood hurts!"))
            damage_burst_normal(M, DAMAGE_BURST_MUL + damage_spikes, delta_time)
    
        damage_spikes++

    return

/datum/reagent/toxin/xenotoxin/damage_burst_normal(mob/living/carbon/M, damage_mul, delta_time)
    M.adjustToxLoss(damage_mul * toxpwr * REM * delta_time, 0)
    M.adjustStaminaLoss(damage_mul * rand(STAM_DAMAGE_MIN, STAM_DAMAGE_MAX) * REM * delta_time, 0)  // REM is reagent-effects-multiplier

    M.losebreath++

    // damage a random organ, weighted heavily towards the liver
    var/obj/item/organ/organ = pick(M.internal_organs) // choose a random organ
    organ = pick(organ, M.getorganslot(ORGAN_SLOT_LIVER)) // choose randomly between that organ and the liver
    organ.applyOrganDamage(rand(ORGAN_DAMAGE_MIN,ORGAN_DAMAGE_MAX)) // deal a small amount of random (non-increasing) damage to that organ
    to_chat(M, "picked organ [organ]") // TODO why isnt this printing?

    return

/datum/reagent/toxin/xenotoxin/damage_burst_bad(mob/living/carbon/M, damage_mul, delta_time)

    M.set_timed_status_effect((JITTER_TIME + damage_spikes) * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
    M.set_timed_status_effect((JITTER_TIME + damage_spikes) * REM * delta_time, /datum/status_effect/jitter, only_if_higher = TRUE)

    if(prob(SCREAM_PROB))
        // TODO why is this happening so much? it should only be called 1% of the time!
        M.emote("scream")

    // do a little extra damage, for funsies
    damage_burst_normal(M, damage_mul/2, delta_time)

    return

#undef STAM_DAMAGE_MIN
#undef STAM_DAMAGE_MAX
#undef STAM_DAMAGE_RATE
#undef DAMAGE_BURST_MUL
#undef DAMAGE_BURST_RATE
#undef JITTER_TIME
#undef ORGAN_DAMAGE_MIN
#undef ORGAN_DAMAGE_MAX
#undef SCREAM_PROB
