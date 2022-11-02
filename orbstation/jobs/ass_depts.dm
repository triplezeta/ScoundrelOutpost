/*
	Orbstation Department Assistants
*/
/// Waiter
/datum/job/assistant/srv
	title = JOB_ASSISTANT_SRV
	description = "Bust tables, work for tips"
	department_head = list(JOB_HEAD_OF_PERSONNEL)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_HOP

	outfit = /datum/outfit/job/assistant_srv

	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_SRV

	department_for_prefs = /datum/job_department/service

	departments_list = list(
		/datum/job_department/service,
		)

	config_tag = "WAITRON"

/datum/outfit/job/assistant_srv
	name = JOB_ASSISTANT_SRV
	jobtype = /datum/job/assistant/srv
	id_trim = /datum/id_trim/job/assistant/srv
	uniform = /obj/item/clothing/under/suit/waiter
	ears = /obj/item/radio/headset/headset_srv

/datum/id_trim/job/assistant/srv
	assignment = "Waitrom"
	subdepartment_color = COLOR_SERVICE_LIME
	minimal_access = list(
		ACCESS_SERVICE,
	)
	extra_access = list(
		ACCESS_BAR,
		ACCESS_HYDROPONICS,
		ACCESS_KITCHEN,
		ACCESS_THEATRE,
		)
	job = /datum/job/assistant/srv

/// Tech Support
/datum/job/assistant/eng
	title = JOB_ASSISTANT_ENG
	description = "Make your own pet projects, get called away to fix every little thing."
	department_head = list(JOB_CHIEF_ENGINEER)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_CE

	outfit = /datum/outfit/job/assistant_eng
	plasmaman_outfit = /datum/outfit/plasmaman/engineering

	paycheck_department = ACCOUNT_ENG
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_ENG

	department_for_prefs = /datum/job_department/engineering

	departments_list = list(
		/datum/job_department/engineering,
		)

	config_tag = "TECH_SUPPORT"

/datum/outfit/job/assistant_eng
	name = JOB_ASSISTANT_ENG
	jobtype = /datum/job/assistant/eng
	id_trim = /datum/id_trim/job/assistant/eng
	uniform = /obj/item/clothing/under/color/yellow
	belt = /obj/item/modular_computer/tablet/pda/engineering
	ears = /obj/item/radio/headset/headset_eng

/datum/id_trim/job/assistant/eng
	assignment = "Tech Support"
	subdepartment_color = COLOR_ENGINEERING_ORANGE
	minimal_access = list(
		ACCESS_ENGINEERING,
		ACCESS_MAINT_TUNNELS,
	)
	extra_access = list(
		ACCESS_CONSTRUCTION,
		ACCESS_ENGINE_EQUIP,
		ACCESS_EXTERNAL_AIRLOCKS,
		ACCESS_MINERAL_STOREROOM,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_CE,
		)
	job = /datum/job/assistant/eng

/// Medical Assistant
/datum/job/assistant/med
	title = JOB_ASSISTANT_MED
	description = "Handle patients coming in and out of medbay,."
	department_head = list(JOB_CHIEF_MEDICAL_OFFICER)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_CMO

	outfit = /datum/outfit/job/assistant_med
	plasmaman_outfit = /datum/outfit/plasmaman/medical

	paycheck_department = ACCOUNT_MED
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_MED

	department_for_prefs = /datum/job_department/medical

	departments_list = list(
		/datum/job_department/medical,
		)

	config_tag = "MEDICAL_ASSISTANT"

/datum/outfit/job/assistant_med
	name = JOB_ASSISTANT_MED
	jobtype = /datum/job/assistant/med
	id_trim = /datum/id_trim/job/assistant/med
	uniform = /obj/item/clothing/under/color/blue
	belt = /obj/item/modular_computer/tablet/pda/medical
	ears = /obj/item/radio/headset/headset_med

/datum/id_trim/job/assistant/med
	assignment = "Medical Assistant"
	subdepartment_color = COLOR_MEDICAL_BLUE
	minimal_access = list(
		ACCESS_MEDICAL,
	)
	extra_access = list(
		ACCESS_MORGUE,
		ACCESS_SURGERY,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_CMO,
		)
	job = /datum/job/assistant/med

/// Lab Assistant
/datum/job/assistant/sci
	title = JOB_ASSISTANT_SCI
	description = "Witness the marvels of modern age technology, and be a test subject for them."
	department_head = list(JOB_RESEARCH_DIRECTOR)
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_RD

	outfit = /datum/outfit/job/assistant_sci
	plasmaman_outfit = /datum/outfit/plasmaman/science

	paycheck_department = ACCOUNT_SCI
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_SCI

	department_for_prefs = /datum/job_department/science

	departments_list = list(
		/datum/job_department/science,
		)

	config_tag = "LAB_ASSISTANT"

/datum/outfit/job/assistant_sci
	name = JOB_ASSISTANT_SCI
	jobtype = /datum/job/assistant/sci
	id_trim = /datum/id_trim/job/assistant/sci
	uniform = /obj/item/clothing/under/color/lightpurple
	belt = /obj/item/modular_computer/tablet/pda/science
	ears = /obj/item/radio/headset/headset_sci

/datum/id_trim/job/assistant/sci
	assignment = "Lab Assistant"
	subdepartment_color = COLOR_SCIENCE_PINK
	minimal_access = list(
		ACCESS_SCIENCE,
	)
	extra_access = list(
		ACCESS_MINERAL_STOREROOM,
		ACCESS_RESEARCH,
		ACCESS_XENOBIOLOGY,
		)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_RD,
		)
	job = /datum/job/assistant/sci

/// Brig Clerk
/datum/job/assistant/sec
	title = JOB_ASSISTANT_SEC
	description = "."
	department_head = list(JOB_HEAD_OF_SECURITY)
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOS

	outfit = /datum/outfit/job/assistant_sec
	plasmaman_outfit = /datum/outfit/plasmaman/security

	paycheck_department = ACCOUNT_SEC
	display_order = JOB_DISPLAY_ORDER_ASSISTANT_SEC

	department_for_prefs = /datum/job_department/security

	departments_list = list(
		/datum/job_department/security,
		)

	config_tag = "BRIG_CLERK"

/datum/outfit/job/assistant_sec
	name = JOB_ASSISTANT_SEC
	jobtype = /datum/job/assistant/sec
	id_trim = /datum/id_trim/job/assistant/sec
	uniform = /obj/item/clothing/under/color/red
	belt = /obj/item/modular_computer/tablet/pda/security
	ears = /obj/item/radio/headset/headset_sec

/datum/id_trim/job/assistant/sec
	assignment = "Brig Clerk"
	subdepartment_color = COLOR_SECURITY_RED
	minimal_access = list(
		ACCESS_BRIG_ENTRANCE,
	)
	template_access = list(
		ACCESS_CAPTAIN,
		ACCESS_CHANGE_IDS,
		ACCESS_HOS,
		)
	job = /datum/job/assistant/sec
