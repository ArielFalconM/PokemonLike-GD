class_name PokemonResource
extends Resource

const PokemonType = MoveResource.Type

## Asociacion entre un movimiento y un nivel de aprendizaje
class LearnableMove:
	var level: int
	var move: MoveResource

	func _init(p_level: int, p_move: MoveResource) -> void:
		level = p_level
		move = p_move

@export var species_id: int = 0
@export var species_name: String = ""
@export var primary_type: MoveResource.Type = MoveResource.Type.NORMAL
@export var secondary_type: MoveResource.Type = MoveResource.Type.NORMAL
@export var has_secondary_type: bool = false

# Stats base (sin IVs/EVs ni nivel)
@export_group("Base Stats")
@export var base_hp: int = 1
@export var base_attack: int = 1
@export var base_defense: int = 1
@export var base_sp_attack: int = 1
@export var base_sp_defense: int = 1
@export var base_speed: int = 1

# Datos de progresión
@export_group("Progression")
@export var base_exp_yield: int = 50
@export var catch_rate: int = 45       # 255 = muy fácil, 3 = legendario
@export var growth_rate: GrowthRate = GrowthRate.MEDIUM_FAST

# Sprites
@export_group("Visuals")
@export var sprite_front: Texture2D
@export var sprite_back: Texture2D
@export var cry: AudioStream

# Movimientos aprendibles por nivel
var learnable_moves: Array[LearnableMove] = []

enum GrowthRate {
	ERRATIC,
	FAST,
	MEDIUM_FAST,
	MEDIUM_SLOW,
	SLOW,
	FLUCTUATING
}

## Devuelve los movimientos que se aprenden exactamente en este nivel
func get_moves_at_level(level: int) -> Array[MoveResource]:
	var result: Array[MoveResource] = []
	for entry in learnable_moves:
		if entry.level == level:
			result.append(entry.move)
	return result
