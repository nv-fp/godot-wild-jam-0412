extends Node

enum StartMode {
	NORMAL,
	SINGLE_LEVEL
}

enum ProgressType {
	NEXT_LEVEL,
	RETRY,
	CREDITS,
}

enum TutorialCard {
	SHIELD,
	SWORD,
	STAFF,
}

enum HudFX {
	ORDER_SUCCES,
	ORDER_FAIL,
	MENU_ACCEPT,
	PAGE_TURN,
}


### WIP Stuff
enum StationType {
	RESOURCE, # Crate/Materials
	FURNACE,
	ANVIL,
	TABLE,    # Crafting
	TUB,      # Quenching
	DELIVERY,
	TRASH,
	COUNTER  # Storage
}
