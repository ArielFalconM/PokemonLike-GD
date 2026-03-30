extends StaticBody2D
class_name Interactive

# Esta variable busca un nodo llamado "Icon" en el objeto que use este script.
@onready var Icon = get_node_or_null("Icon")

func _ready():
	#Si el objeto tiene un icono se esconde
	if Icon:
		Icon.hide()

# El jugador activa o desactiva el icono al ver el objeto.
func highlight():
	if Icon:
		Icon.show()

func unhighlight():
	if Icon:
		Icon.hide()

# El jugador interactua con el objeto
func interact():
	print("Soy un objeto interactuable genérico")
