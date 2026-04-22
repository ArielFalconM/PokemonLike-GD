class_name ItemResource
extends Resource

enum Category {
	POKEBALL,
	HEALING,        # Pociones, full restore
	STATUS_CURE,    # Antídoto, despertar
	BATTLE,         # X Attack, Guard Spec
	KEY,            # Items de historia, no consumibles
	HELD,           # Items que sostiene el Pokémon
	EVOLUTION,      # Piedras
	FIELD           # Repelente, caña, bici
}

@export var item_name: String = ""
@export var category: Category = Category.HEALING
@export var description: String = ""
@export var sprite: Texture2D
@export var price: int = 0
@export var is_consumable: bool = true

# Solo para POKEBALL
@export_group("Pokeball")
@export var catch_rate_modifier: float = 1.0

# Solo para HEALING / STATUS_CURE
@export_group("Effect")
@export var heal_amount: int = 0        # -1 = cura total
@export var cures_status: MoveResource.Type = MoveResource.Type.NORMAL

## Aplica el efecto sobre un BattlePokemon. Retorna true si tuvo efecto.
## La lógica específica vive en subclases o en el BattleSystem según el tipo.
func apply_to(target: BattlePokemon) -> bool:
	match category:
		Category.HEALING:
			return _apply_healing(target)
		Category.STATUS_CURE:
			return _apply_status_cure(target)
		_:
			return false

func _apply_healing(target: BattlePokemon) -> bool:
	if target.is_fainted():
		return false
	if target.current_hp == target.get_max_hp():
		return false
	var amount := target.get_max_hp() if heal_amount == -1 else heal_amount
	target.heal(amount)
	return true

func _apply_status_cure(target: BattlePokemon) -> bool:
	if target.status == BattlePokemon.StatusCondition.NONE:
		return false
	target.clear_status()
	return true
