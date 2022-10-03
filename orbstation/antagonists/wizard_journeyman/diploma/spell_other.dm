
/datum/diploma_spell/item/wands
	name = "Wand Assortment"
	desc = "A collection of wands that allow for a wide variety of utility. \
		Wands have a limited number of charges, so be conservative with their use. Comes in a handy belt."
	item_path = /obj/item/storage/belt/wands/full
	category = "Other"
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/item/wands/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("\A [to_equip.name] has been summoned [was_equipped ? "on your waist" : "at your feet"]."))

/datum/diploma_spell/item/scryingorb
	name = "Scrying Orb"
	desc = "An incandescent orb of crackling energy. Using it will allow you to release your ghost while alive, \
		allowing you to spy upon the station and talk to the deceased. In addition, buying it will permanently grant you X-ray vision."
	item_path = /obj/item/scrying
	category = "Other"

/datum/diploma_spell/shapeshift
	name = "Wild Shapeshift"
	desc = "Take on the shape of another for a time to use their natural abilities. Once you've made your choice it cannot be changed."
	spell_type = /datum/action/cooldown/spell/shapeshift/wizard
	category = "Other"

/datum/diploma_spell/shapeshift_monster
	name = "Eldritch Shapeshift"
	desc = "Take on the shape of a creature of darkness for a time to use their unnatural abilities. Once you've made your choice it cannot be changed."
	spell_type = /datum/action/cooldown/spell/shapeshift/eldritch_monster
	category = "Other"
	weight = DIPLOMA_SPELL_RARE

/datum/diploma_spell/item/soulstones
	name = "Soulstone Shard Kit"
	desc = "Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. \
		The spell Artificer allows you to create arcane machines for the captured souls to pilot."
	item_path = /obj/item/storage/belt/soulstone/full
	category = "Other"
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/item/soulstones/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("\A [to_equip.name] has been summoned [was_equipped ? "on your waist" : "at your feet"]."))

/datum/diploma_spell/item/soulstones/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book)
	. =..()
	if(!.)
		return

	var/datum/action/cooldown/spell/conjure/construct/bonus_spell = new(user.mind || user)
	bonus_spell.Grant(user)

/datum/diploma_spell/item/necrostone
	name = "A Necromantic Stone"
	desc = "A Necromantic stone is able to resurrect three dead individuals as skeletal thralls for you to command."
	item_path = /obj/item/necromantic_stone
	category = "Other"
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/bees
	name = "Lesser Summon Bees"
	desc = "This spell magically kicks a transdimensional beehive, \
		instantly summoning a swarm of bees to your location. These bees are NOT friendly to anyone."
	spell_type = /datum/action/cooldown/spell/conjure/bee
	category = "Other"
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/item/clown_staff
	name = "Staff of the Honkmother"
	desc = "This ancient artifact mostly exists to annoy people. Make sure you keep a firm grip, lest the laugh be upon you."
	item_path = /obj/item/gun/magic/staff/honk
	category = "Other"

/datum/diploma_spell/item/command
	name = "The Voice of God"
	desc = "Speak with a voice which cannot be denied. Those who hear will be compelled to obey certain simple instructions such \
		as to Stop, Fall, Flee... or even Burn. A power limited only by your imagination."
	spell_type = /datum/action/cooldown/spell/voice_of_god
	category = "Other"
	weight = DIPLOMA_SPELL_RARE
