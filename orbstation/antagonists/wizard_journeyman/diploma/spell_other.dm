/**
 * Spells which have niche or difficult to categorise effects.
 */

/datum/diploma_spell/item/wands
	name = "Bargain Wand Assortment"
	desc = "A random collection of wands picked from the bargain bin which allow for a wide variety of utility. \
		Wands have a limited number of charges, so be conservative with their use. Comes in a handy belt!"
	item_path = /obj/item/storage/belt/wands/discount
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/item/wands/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("\A [to_equip.name] has been summoned [was_equipped ? "on your waist" : "at your feet"]."))

/datum/diploma_spell/item/chaos
	name = "Staff of Chaos"
	desc = "An artifact of intense chaotic power, you never have any idea what this is going to do next."
	item_path = /obj/item/gun/magic/staff/chaos
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_RARE

/datum/diploma_spell/item/staffhealing
	name = "Staff of Healing"
	desc = "An altruistic staff that can heal the sick and raise the dead. Not much use to you unless you can make a friend, or use it as a bribe."
	item_path = /obj/item/gun/magic/staff/healing
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/item/scryingorb
	name = "Scrying Orb"
	desc = "An incandescent orb of crackling energy. Using it will allow you to release your ghost while alive, \
		allowing you to spy upon the station and talk to the deceased. In addition, buying it will permanently grant you X-ray vision."
	item_path = /obj/item/scrying
	category = DIPLOMA_SPELL_OTHER

/datum/diploma_spell/shapeshift
	name = "Wild Shapeshift"
	desc = "Take on the shape of another for a time to use their natural abilities. Once you've made your choice it cannot be changed."
	spell_type = /datum/action/cooldown/spell/shapeshift/wizard
	category = DIPLOMA_SPELL_OTHER

/datum/diploma_spell/shapeshift_monster
	name = "Eldritch Shapeshift"
	desc = "Take on the shape of a creature of darkness for a time to use their unnatural abilities. Once you've made your choice it cannot be changed."
	spell_type = /datum/action/cooldown/spell/shapeshift/eldritch_monster
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_RARE

/datum/diploma_spell/item/soulstones
	name = "Soulstone Shard Kit"
	desc = "Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. \
		The spell 'Summon Construct Shell' allows you to create arcane machines for the captured souls to pilot."
	item_path = /obj/item/storage/belt/soulstone/full
	category = DIPLOMA_SPELL_OTHER
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
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/bees
	name = "Lesser Summon Bees"
	desc = "This spell magically kicks a transdimensional beehive, \
		instantly summoning a swarm of bees to your location. These bees are NOT friendly to anyone."
	spell_type = /datum/action/cooldown/spell/conjure/bee
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_UNCOMMON

/datum/diploma_spell/item/clown_staff
	name = "Staff of the Honkmother"
	desc = "This ancient artifact mostly exists to annoy people. Make sure you keep a firm grip, lest the laugh be upon you."
	item_path = /obj/item/gun/magic/staff/honk
	category = DIPLOMA_SPELL_OTHER

/datum/diploma_spell/command
	name = "The Voice of God"
	desc = "Speak with a voice which cannot be denied. Those who hear will be compelled to obey certain simple instructions such \
		as to Stop, Fall, Flee... or even Burn. A power limited only by your imagination."
	spell_type = /datum/action/cooldown/spell/voice_of_god
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_RARE

/datum/diploma_spell/summon_item
	name = "Instant Summons"
	desc = "Bind an item to yourself, then cast again to retrieve it from wherever it currently happens to be. \
		Not very useful if you don't have an important item you want to make sure to keep hold of."
	spell_type = /datum/action/cooldown/spell/summonitem
	category = DIPLOMA_SPELL_OTHER

/datum/diploma_spell/haunt_objects
	name = "Call Poltergeists"
	desc = "Summons depraved spirits to possess nearby objects, causing them to attack the living. \
		As you are the living, make sure that you have an exit strategy."
	spell_type = /datum/action/cooldown/spell/aoe/haunt_object
	category = DIPLOMA_SPELL_OTHER

/datum/diploma_spell/clown_gear
	name = "Endless Clown Tools"
	desc = "Reach your hand into the clown dimension and pull out some kind of prank-related item. \
		Great for parties, dubiously useful in a life or death situation."
	spell_type = /datum/action/cooldown/spell/clown_pockets
	category = DIPLOMA_SPELL_OTHER

/datum/diploma_spell/item/eldritch_minion
	name = "Demonology 101"
	desc = "Everything you need in order to summon your own eldritch familiar, except for a \
		3x3 area of floorspace and a spirit to twist to your will."
	item_path = /obj/item/demonology_for_dummies
	category = DIPLOMA_SPELL_OTHER
	weight = DIPLOMA_SPELL_RARE
