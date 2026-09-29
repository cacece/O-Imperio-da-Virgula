extends Control

@onready var container_centro: CenterContainer = %ContainerCentro
@onready var botao_continuar: Button = %BotaoContinuar
@onready var fundo_fade: ColorRect = %FundoFade

var transicao_em_andamento: bool = false

func _ready() -> void:
	GameManager.parar_musica_menu()
	botao_continuar.pressed.connect(_avancar_para_trabalho)
	botao_continuar.grab_focus()
	
	container_centro.modulate.a = 0.0
	fundo_fade.modulate.a = 1.0
	fundo_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var animacao_entrada = create_tween()
	animacao_entrada.tween_property(container_centro, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	animacao_entrada.parallel().tween_property(fundo_fade, "modulate:a", 0.0, 0.8)

func _unhandled_input(evento: InputEvent) -> void:
	if transicao_em_andamento:
		return
	if evento.is_action_pressed("ui_accept"):
		_avancar_para_trabalho()
	elif evento is InputEventKey and evento.pressed and not evento.echo:
		if evento.keycode == KEY_SPACE or evento.keycode == KEY_ENTER:
			_avancar_para_trabalho()

func _avancar_para_trabalho() -> void:
	if transicao_em_andamento:
		return
	transicao_em_andamento = true
	GameManager.tocar_som_papel()
	
	fundo_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	var animacao_saida = create_tween()
	animacao_saida.tween_property(fundo_fade, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await animacao_saida.finished
	get_tree().change_scene_to_file("res://tela_trabalho.tscn")
