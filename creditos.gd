extends Control

@onready var botao_voltar: Button = %BotaoVoltar

func _ready() -> void:
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)

func _on_botao_voltar_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://menu_principal.tscn")
