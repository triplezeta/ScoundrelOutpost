// How likely is a given spell to appear in draft?
#define DIPLOMA_SPELL_RARE 1
#define DIPLOMA_SPELL_UNCOMMON 3
#define DIPLOMA_SPELL_COMMON 5

// Diploma spell categories
#define DIPLOMA_SPELL_OFFENSIVE "offensive"
#define DIPLOMA_SPELL_DEFENSIVE "defensive"
#define DIPLOMA_SPELL_OTHER "other"

/// Number of times you need to perform the grand ritual to complete it
#define GRAND_RITUAL_FINALE_COUNT 7

/// The crew will start being warned every time a rune is created after this many invocations.
#define GRAND_RITUAL_RUNES_WARNING_POTENCY 3
/// The crew will get a louder warning when this level of rune is created, and the next one will be special
#define GRAND_RITUAL_IMMINENT_FINALE_POTENCY 6

/// Signal sent when we finish invoking a rune
#define COMSIG_GRAND_RUNE_COMPLETE "grand rune complete"
/// Signal sent when we finish 7 grand rituals
#define COMSIG_GRAND_RITUAL_FINAL_COMPLETE "grand ritual finale complete"
