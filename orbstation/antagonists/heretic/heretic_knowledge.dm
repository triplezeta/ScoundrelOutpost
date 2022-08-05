// GENERAL

/datum/heretic_knowledge/limited_amount/starting
	cost = 0

// ASH

/datum/heretic_knowledge/ashen_grasp
	next_knowledge = list(
		/datum/heretic_knowledge/spell/ash_passage,
		/datum/heretic_knowledge/essence,
		/datum/heretic_knowledge/medallion,
	)

/datum/heretic_knowledge/knowledge_ritual/ash
	next_knowledge = list(
		/datum/heretic_knowledge/mad_mask,
		/datum/heretic_knowledge/curse/corrosion,
		/datum/heretic_knowledge/curse/paralysis,
	)

/datum/heretic_knowledge/blade_upgrade/ash
	next_knowledge = list(
		/datum/heretic_knowledge/spell/flame_birth,
		/datum/heretic_knowledge/summon/ashy,
		/datum/heretic_knowledge/summon/rusty,
	)

// SIDE: ASH - FLESH

/datum/heretic_knowledge/medallion
	next_knowledge = list(
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/spell/ash_passage,
		/datum/heretic_knowledge/limited_amount/flesh_ghoul,
		/datum/heretic_knowledge/mark/ash_mark,
		/datum/heretic_knowledge/mark/flesh_mark,
	)

/datum/heretic_knowledge/curse/paralysis
	next_knowledge = list(
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/mad_mask,
		/datum/heretic_knowledge/summon/raw_prophet,
		/datum/heretic_knowledge/blade_upgrade/ash,
		/datum/heretic_knowledge/blade_upgrade/flesh,
	)

// FLESH

/datum/heretic_knowledge/limited_amount/flesh_grasp
	next_knowledge = list(
		/datum/heretic_knowledge/limited_amount/flesh_ghoul,
		/datum/heretic_knowledge/void_cloak,
		/datum/heretic_knowledge/medallion,
	)

/datum/heretic_knowledge/knowledge_ritual/flesh
	next_knowledge = list(
		/datum/heretic_knowledge/summon/raw_prophet,
		/datum/heretic_knowledge/spell/blood_siphon,
		/datum/heretic_knowledge/curse/paralysis,
	)

/datum/heretic_knowledge/blade_upgrade/flesh
	next_knowledge = list(
		/datum/heretic_knowledge/summon/stalker,
		/datum/heretic_knowledge/summon/ashy,
		/datum/heretic_knowledge/spell/cleave,
	)

// SIDE: FLESH - VOID

/datum/heretic_knowledge/void_cloak
	next_knowledge = list(
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/limited_amount/flesh_ghoul,
		/datum/heretic_knowledge/cold_snap,
		/datum/heretic_knowledge/mark/flesh_mark,
		/datum/heretic_knowledge/mark/void_mark,
	)

/datum/heretic_knowledge/spell/blood_siphon
	next_knowledge = list(
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/summon/raw_prophet,
		/datum/heretic_knowledge/blade_upgrade/flesh,
		/datum/heretic_knowledge/blade_upgrade/void,
	)

// VOID

/datum/heretic_knowledge/void_grasp
	next_knowledge = list(
		/datum/heretic_knowledge/cold_snap,
		/datum/heretic_knowledge/void_cloak,
		/datum/heretic_knowledge/limited_amount/risen_corpse,
	)

/datum/heretic_knowledge/knowledge_ritual/void
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/spell/blood_siphon,
		/datum/heretic_knowledge/rune_carver,
	)

/datum/heretic_knowledge/blade_upgrade/void
	next_knowledge = list(
		/datum/heretic_knowledge/spell/void_pull,
		/datum/heretic_knowledge/spell/cleave,
		/datum/heretic_knowledge/summon/maid_in_mirror,
	)

// SIDE: VOID - BLADE

/datum/heretic_knowledge/limited_amount/risen_corpse
	next_knowledge = list(
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/cold_snap,
		/datum/heretic_knowledge/blade_dance,
		/datum/heretic_knowledge/mark/void_mark,
		/datum/heretic_knowledge/mark/blade_mark,
	)

/datum/heretic_knowledge/rune_carver
	next_knowledge = list(
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/spell/void_phase,
		/datum/heretic_knowledge/duel_stance,
		/datum/heretic_knowledge/blade_upgrade/void,
		/datum/heretic_knowledge/blade_upgrade/blade,
	)

// BLADE

/datum/heretic_knowledge/blade_grasp
	next_knowledge = list(
		/datum/heretic_knowledge/blade_dance,
		/datum/heretic_knowledge/limited_amount/risen_corpse,
		/datum/heretic_knowledge/armor,
	)

/datum/heretic_knowledge/knowledge_ritual/blade
	next_knowledge = list(
		/datum/heretic_knowledge/duel_stance,
		/datum/heretic_knowledge/rune_carver,
		/datum/heretic_knowledge/crucible,
	)

/datum/heretic_knowledge/blade_upgrade/blade
	next_knowledge = list(
		/datum/heretic_knowledge/spell/furious_steel,
		/datum/heretic_knowledge/summon/maid_in_mirror,
		/datum/heretic_knowledge/rifle,
	)

// SIDE: BLADE - RUST

/datum/heretic_knowledge/armor
	next_knowledge = list(
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/blade_dance,
		/datum/heretic_knowledge/mark/blade_mark,
		/datum/heretic_knowledge/mark/rust_mark,
	)

/datum/heretic_knowledge/crucible
	next_knowledge = list(
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/duel_stance,
		/datum/heretic_knowledge/spell/area_conversion,
		/datum/heretic_knowledge/blade_upgrade/blade,
		/datum/heretic_knowledge/blade_upgrade/rust,
	)

// RUST

/datum/heretic_knowledge/rust_fist
	next_knowledge = list(
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/armor,
		/datum/heretic_knowledge/essence,
	)

/datum/heretic_knowledge/knowledge_ritual/rust
	next_knowledge = list(
		/datum/heretic_knowledge/spell/area_conversion,
		/datum/heretic_knowledge/curse/corrosion,
		/datum/heretic_knowledge/crucible,
	)

/datum/heretic_knowledge/blade_upgrade/rust
	next_knowledge = list(
		/datum/heretic_knowledge/spell/entropic_plume,
		/datum/heretic_knowledge/rifle,
		/datum/heretic_knowledge/summon/rusty,
	)

// SIDE: RUST - ASH

/datum/heretic_knowledge/essence
	next_knowledge = list(
		/datum/heretic_knowledge/codex_cicatrix,
		/datum/heretic_knowledge/rust_regen,
		/datum/heretic_knowledge/spell/ash_passage,
		/datum/heretic_knowledge/mark/rust_mark,
		/datum/heretic_knowledge/mark/ash_mark,
	)

/datum/heretic_knowledge/curse/corrosion
	next_knowledge = list(
		/datum/heretic_knowledge/reroll_targets,
		/datum/heretic_knowledge/mad_mask,
		/datum/heretic_knowledge/spell/area_conversion,
		/datum/heretic_knowledge/blade_upgrade/rust,
		/datum/heretic_knowledge/blade_upgrade/ash,
	)
