// quirks that apply traits to the mind of the mob theyre applied to, instead of or as well as traits applied to the mob itself
// lightweight enough that it COULD just be added to existing quirk datum instead of inheriting, but this keeps code nicely separated
/datum/quirk/mind_quirk
    var/mind_trait // the trait to add to the targets mind. to add one to the targets body as well, define var/mob_trait

    abstract_parent_type = /datum/quirk/mind_quirk // marks this type as abstract and prevents it from being added to the roundstart list

/datum/quirk/mind_quirk/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE)
    . = ..(new_holder, quirk_transfer) // call super, return its value (should be TRUE)
    
    if (mind_trait)

        if (!new_holder.mind)
            . = FALSE   // will be returned post-crash (byond fuckery)
            CRASH("Attempted to add mind-based quirk to mindless mob!")
        
        ADD_TRAIT(new_holder.mind, mind_trait, QUIRK_TRAIT) // for some reason this is not actually adding the trait. why....

/datum/quirk/mind_quirk/remove_from_current_holder(quirk_transfer = FALSE)
    ..(quirk_transfer)

    if(mind_trait)

        if (!quirk_holder.mind)
            CRASH("Attempted to remove mind-based quirk from mindless mob!")
        
        REMOVE_TRAIT(quirk_holder.mind, mind_trait, QUIRK_TRAIT)
