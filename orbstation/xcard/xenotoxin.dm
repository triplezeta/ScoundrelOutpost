/datum/reagent/toxin/xenotoxin
    name = "Xenotoxin"
    description = "A powerful venom injected by immature xenomorphs when they fail infect a host. \
                    Lingers in the system for a long time, causing the victim to continuously weaken."
    color = "#1a011c" // not sure the best color, so i went with xeno-ish purple/black
    toxpwr = 0.5 // deals low damage but spends a long, long time in your system
    metabolization_rate = 0.1 * REAGENTS_METABOLISM
    ph = 1
    taste_description = "acrid bile"
    penetrates_skin = TOUCH

/datum/reagent/toxin/xenotoxin/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
    M.adjustStaminaLoss(rand(-1, 7) * REM * delta_time, 0)  // REM is reagent-effects-multiplier
