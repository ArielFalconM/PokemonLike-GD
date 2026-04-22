class_name PlayerData

const MAX_PARTY_SIZE: int = 6

var trainer_name: String = ""
var money: int = 0
var play_time_seconds: float = 0.0

# Party actual
var party: Array[BattlePokemon] = []

# Posición en el mundo (Para obtener ultima pocision para el guardado)
var current_map: String = ""
var position: Vector2 = Vector2.ZERO

# Flags de eventos completados
var completed_events: Array[String] = []

# Inventario: { item_id (String) -> quantity (int) }
var inventory: Dictionary = {}

# Party
func add_to_party(pokemon: BattlePokemon) -> bool:
	if party.size() >= MAX_PARTY_SIZE:
		return false
	party.append(pokemon)
	return true

func remove_from_party(index: int) -> BattlePokemon:
	if index < 0 or index >= party.size():
		return null
	return party.pop_at(index)

func get_first_able_pokemon() -> BattlePokemon:
	for pokemon in party:
		if not pokemon.is_fainted():
			return pokemon
	return null

func has_any_pokemon_able() -> bool:
	return get_first_able_pokemon() != null

# Inventario
func add_item(item_id: String, quantity: int = 1) -> void:
	inventory[item_id] = inventory.get(item_id, 0) + quantity

func remove_item(item_id: String, quantity: int = 1) -> bool:
	if not has_item(item_id, quantity):
		return false
	inventory[item_id] -= quantity
	if inventory[item_id] <= 0:
		inventory.erase(item_id)
	return true

func has_item(item_id: String, quantity: int = 1) -> bool:
	return inventory.get(item_id, 0) >= quantity


# Eventos:
func complete_event(event_id: String) -> void:
	if event_id not in completed_events:
		completed_events.append(event_id)

func has_completed_event(event_id: String) -> bool:
	return event_id in completed_events

# Serialización (base para guardado):
func to_dict() -> Dictionary:
	return {
		"trainer_name": trainer_name,
		"money": money,
		"play_time_seconds": play_time_seconds,
		"current_map": current_map,
		"position": { "x": position.x, "y": position.y },
		"completed_events": completed_events,
		"inventory": inventory,
		# party se serializa aparte (requiere BattlePokemon.to_dict())
	}
