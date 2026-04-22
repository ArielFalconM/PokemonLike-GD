class_name MoveResource
extends Resource

enum Type {
	NORMAL, FIRE, WATER, ELECTRIC, GRASS, ICE,
	FIGHTING, POISON, GROUND, FLYING, PSYCHIC,
	BUG, ROCK, GHOST, DRAGON, DARK, STEEL, FAIRY
}

enum Category {
	PHYSICAL,
	SPECIAL,
	STATUS
}

enum Effect {
	NONE,
	BURN,
	POISON,
	SLEEP,
	FREEZE,
	PARALYZE,
	STAT_BOOST,
	STAT_DROP,
	DRAIN,
	RECOIL
}

@export var move_name: String = ""
@export var type: Type = Type.NORMAL
@export var category: Category = Category.PHYSICAL
@export var power: int = 0          # 0 si es STATUS
@export var accuracy: int = 100     # 0 = nunca falla
@export var max_pp: int = 10
@export var priority: int = 0       # Quick Attack = 1, etc.
@export var effects: Array[Effect] = []
@export var effect_chance: int = 0  # % de que el efecto secundario ocurra
@export var description: String = ""
