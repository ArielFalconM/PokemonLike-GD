class_name BattlePokemon


const MAX_MOVES: int = 4
const MAX_LEVEL: int = 100
const MAX_IV: int = 31
const MAX_EV_TOTAL: int = 510
const MAX_EV_STAT: int = 252


enum StatusCondition {
	NONE,
	BURN,
	POISON,
	BADLY_POISON,
	SLEEP,
	FREEZE,
	PARALYZE
}

#Dato puro (inmutable en combate)
var species: PokemonResource

# Identidad
var nickname: String = ""
var level: int = 1
var experience: int = 0
var is_shiny: bool = false

# IVs (0–31, aleatorios al capturar)
var iv_hp: int = 0
var iv_attack: int = 0
var iv_defense: int = 0
var iv_sp_attack: int = 0
var iv_sp_defense: int = 0
var iv_speed: int = 0

#EVs (0–252 por stat, 510 total)
var ev_hp: int = 0
var ev_attack: int = 0
var ev_defense: int = 0
var ev_sp_attack: int = 0
var ev_sp_defense: int = 0
var ev_speed: int = 0

# Estado variable de combate
var current_hp: int = 0
var status: StatusCondition = StatusCondition.NONE
var sleep_turns_remaining: int = 0
var toxic_counter: int = 0 


var moves: Array[Dictionary] = []

# Modificadores de stat en combate (−6 a +6)
var stat_stages: Dictionary = {
	"attack": 0, "defense": 0,
	"sp_attack": 0, "sp_defense": 0,
	"speed": 0, "accuracy": 0, "evasion": 0
}

# Constructor
func _init(p_species: PokemonResource, p_level: int, p_ivs: Dictionary = {}) -> void:
	species = p_species
	level = clampi(p_level, 1, MAX_LEVEL)
	_assign_ivs(p_ivs)
	current_hp = get_max_hp()

func _assign_ivs(ivs: Dictionary) -> void:
	iv_hp         = ivs.get("hp",         randi() % (MAX_IV + 1))
	iv_attack     = ivs.get("attack",     randi() % (MAX_IV + 1))
	iv_defense    = ivs.get("defense",    randi() % (MAX_IV + 1))
	iv_sp_attack  = ivs.get("sp_attack",  randi() % (MAX_IV + 1))
	iv_sp_defense = ivs.get("sp_defense", randi() % (MAX_IV + 1))
	iv_speed      = ivs.get("speed",      randi() % (MAX_IV + 1))

#Fórmulas de stats (Gen 3+)
func get_max_hp() -> int:
	if level == 0:
		return 1
	return _calculate_hp_stat(species.base_hp, iv_hp, ev_hp)

func get_attack() -> int:
	return _apply_stage(_calculate_stat(species.base_attack, iv_attack, ev_attack), stat_stages["attack"])

func get_defense() -> int:
	return _apply_stage(_calculate_stat(species.base_defense, iv_defense, ev_defense), stat_stages["defense"])

func get_sp_attack() -> int:
	return _apply_stage(_calculate_stat(species.base_sp_attack, iv_sp_attack, ev_sp_attack), stat_stages["sp_attack"])

func get_sp_defense() -> int:
	return _apply_stage(_calculate_stat(species.base_sp_defense, iv_sp_defense, ev_sp_defense), stat_stages["sp_defense"])

func get_speed() -> int:
	var speed := _apply_stage(_calculate_stat(species.base_speed, iv_speed, ev_speed), stat_stages["speed"])
	if status == StatusCondition.PARALYZE:
		speed = speed / 2
	return speed

func _calculate_hp_stat(base: int, iv: int, ev: int) -> int:
	return ((2 * base + iv + ev / 4) * level) / 100 + level + 10

func _calculate_stat(base: int, iv: int, ev: int) -> int:
	return (((2 * base + iv + ev / 4) * level) / 100 + 5)

func _apply_stage(stat: int, stage: int) -> int:
	# Tabla oficial Gen III: multiplicadores para stages -6 a +6
	const STAGE_MULTIPLIERS: Array[float] = [
		0.25, 0.285, 0.333, 0.4, 0.5, 0.666,
		1.0,
		1.5, 2.0, 2.5, 3.0, 3.5, 4.0
	]
	var index := clampi(stage + 6, 0, 12)
	return int(stat * STAGE_MULTIPLIERS[index])

#Estado y HP
func is_fainted() -> bool:
	return current_hp <= 0

func take_damage(amount: int) -> void:
	current_hp = clampi(current_hp - amount, 0, get_max_hp())

func heal(amount: int) -> void:
	current_hp = clampi(current_hp + amount, 0, get_max_hp())

func apply_status(new_status: StatusCondition) -> bool:
	if status != StatusCondition.NONE:
		return false
	status = new_status
	if new_status == StatusCondition.SLEEP:
		sleep_turns_remaining = randi_range(1, 3)
	return true

func clear_status() -> void:
	status = StatusCondition.NONE
	sleep_turns_remaining = 0
	toxic_counter = 0

# Movimientos:
func learn_move(move: MoveResource) -> bool:
	if moves.size() >= MAX_MOVES:
		return false
	moves.append({ "move": move, "current_pp": move.max_pp })
	return true

func replace_move(index: int, move: MoveResource) -> void:
	if index < 0 or index >= moves.size():
		return
	moves[index] = { "move": move, "current_pp": move.max_pp }

func use_pp(move_index: int) -> void:
	if move_index < 0 or move_index >= moves.size():
		return
	moves[move_index]["current_pp"] = max(0, moves[move_index]["current_pp"] - 1)

func get_display_name() -> String:
	return nickname if not nickname.is_empty() else species.species_name

# Stat stages:
func modify_stat_stage(stat: String, delta: int) -> int:
	if not stat_stages.has(stat):
		return 0
	var previous := stat_stages[stat]
	stat_stages[stat] = clampi(stat_stages[stat] + delta, -6, 6)
	return stat_stages[stat] - previous     # Cambio real aplicado

func reset_stat_stages() -> void:
	for key in stat_stages:
		stat_stages[key] = 0
