extends Node
class_name InventoryManager

signal inventory_changed

var _counts: Dictionary = {}
func get_quantity(item_id: StringName) -> int:
	return int(_counts.get(item_id, 0))

func has_item(item_id: StringName, amount: int = 1) -> bool:
	return get_quantity(item_id) >= amount

func add_item(item_id: StringName, amount: int = 1) -> void:
	if amount <= 0:
		return
	_counts[item_id] = get_quantity(item_id) + amount
	inventory_changed.emit()

func remove_item(item_id: StringName, amount: int = 1) -> bool:
	if amount <= 0:
		return true

	var current := get_quantity(item_id)
	if current < amount:
		return false

	var new_value := current - amount
	if new_value <= 0:
		_counts.erase(item_id)
	else:
		_counts[item_id] = new_value

	inventory_changed.emit()
	return true

func get_entries() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for id in _counts.keys():
		out.append({ "item_id": id, "quantity": int(_counts[id]) })
	return out