/datum/quirk/door_closer
	name = "Compulsive Door Closer"
	desc = "There is something that troubles you about walking through airlocks and doors. You absolutely must close them behind you."
	icon = "door-closed"
	value = 3
	mob_trait = TRAIT_DOOR_CLOSER
	gain_text = "<span class='danger'>You feel very strongly about passing through doorways.</span>"
	lose_text = "<span class='notice'>You no longer feel very strongly about doorways.</span>"
	medical_record_text = "Patient seems to have superstitions involving doorways."
	mail_goodies = list(/obj/item/clothing/gloves/color/white)

/obj/machinery/door/Initialize(mapload)
	.  = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_EXITED = PROC_REF(on_exited))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/machinery/door/proc/on_exited(datum/source, atom/movable/entered)
	SIGNAL_HANDLER

	if(istype(src, /obj/machinery/door/poddoor))
		return
	if(istype(src, /obj/machinery/door/firedoor))
		return
	if(entered.stat != CONSCIOUS)
		return
	if(!isliving(entered))
		return
	if(!HAS_TRAIT(entered, TRAIT_DOOR_CLOSER))
		return
	INVOKE_ASYNC(src, PROC_REF(close))


