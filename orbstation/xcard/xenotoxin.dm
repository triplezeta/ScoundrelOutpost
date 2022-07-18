// values concerning stamina loss
#define STAM_DAMAGE_MIN 1
#define STAM_DAMAGE_MAX 5
// note that this is a percent, not a value from 0 to 1
#define STAM_DAMAGE_RATE 15

// values concerning the occasional burst of damage
// how much more damage a damage burst frame does than a normal one. this goes up by one every damage burst
#define DAMAGE_BURST_MUL 7
// again, note that this is a percent chance
#define DAMAGE_BURST_RATE 5
#define JITTER_TIME 10 SECONDS
// note that unlike tox damage, stamina damage, etc, organ damage is NOT multiplied by DAMAGE_BURST_MUL or increased by damage_spikes
#define ORGAN_DAMAGE_MIN 3
#define ORGAN_DAMAGE_MAX 10
// chance to scream on a bad damage burst
#define SCREAM_PROB 50

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

/datum/reagent/toxin/xenotoxin/on_mob_life(mob/living/carbon/victim, delta_time, times_fired)

    ..()

    if (DT_PROB(STAM_DAMAGE_RATE, delta_time))
        victim.adjustStaminaLoss(rand(STAM_DAMAGE_MIN, STAM_DAMAGE_MAX) * REM * delta_time, 0)

    if (DT_PROB(DAMAGE_BURST_RATE, delta_time))
        // chance to have a bad spike starts at ten percent, and increases as you lose health and have more spikes
        // once 40% health is reached, further health loss no longer increases the chances, creating a softcap in that respect
        if (prob(clamp(50 - victim.health, 10, 60) + damage_spikes)) 
            to_chat(victim, span_danger("Your heartrate spikes, and it feels like acid is running through your veins!"))
            damage_burst_bad(victim, DAMAGE_BURST_MUL + damage_spikes, delta_time)
        else
            to_chat(victim, span_danger("Your blood hurts!"))
            damage_burst_normal(victim, DAMAGE_BURST_MUL + damage_spikes, delta_time)
    
        damage_spikes++

    return

/datum/reagent/toxin/xenotoxin/proc/damage_burst_normal(mob/living/carbon/victim, damage_mul, delta_time)
    victim.adjustToxLoss(damage_mul * toxpwr * REM * delta_time, 0)
    victim.adjustStaminaLoss(damage_mul * rand(STAM_DAMAGE_MIN, STAM_DAMAGE_MAX) * REM * delta_time, 0)  // REM is reagent-effects-multiplier

    victim.losebreath++

    // damage a random organ, weighted heavily towards the liver
    var/obj/item/organ/organ = pick(victim.internal_organs) // choose a random organ
    organ = pick(organ, victim.getorganslot(ORGAN_SLOT_LIVER)) // choose randomly between that organ and the liver
    organ.applyOrganDamage(rand(ORGAN_DAMAGE_MIN,ORGAN_DAMAGE_MAX)) // deal a small amount of random (non-increasing) damage to that organ

    return

/datum/reagent/toxin/xenotoxin/proc/damage_burst_bad(mob/living/carbon/victim, damage_mul, delta_time)

    victim.set_timed_status_effect((JITTER_TIME + damage_spikes) * REM * delta_time, /datum/status_effect/dizziness, only_if_higher = TRUE)
    victim.set_timed_status_effect((JITTER_TIME + damage_spikes) * REM * delta_time, /datum/status_effect/jitter, only_if_higher = TRUE)

    if(prob(SCREAM_PROB))
        victim.emote("scream")

    // do the normal amount of damage
    damage_burst_normal(victim, damage_mul, delta_time)
    // do a little extra damage, for funsies
    damage_burst_normal(victim, damage_mul/2, delta_time)

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
