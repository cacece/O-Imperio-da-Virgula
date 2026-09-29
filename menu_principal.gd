extends Control

@onready var label_progresso: Label = %LabelProgresso
@onready var botao_jogar: Button = %BotaoJogar
@onready var botao_tutorial: Button = %BotaoTutorial
@onready var botao_configuracoes: Button = %BotaoConfiguracoes
@onready var botao_creditos: Button = %BotaoCreditos
@onready var botao_resetar: Button = %BotaoResetar
@onready var botao_sair: Button = %BotaoSair

func _ready() -> void:
	GameManager.tocar_musica_menu()
	botao_jogar.pressed.connect(_on_botao_jogar_pressed)
	botao_tutorial.pressed.connect(_on_botao_tutorial_pressed)
	botao_configuracoes.pressed.connect(_on_botao_configuracoes_pressed)
	botao_creditos.pressed.connect(_on_botao_creditos_pressed)
	botao_resetar.pressed.connect(_on_botao_resetar_pressed)
	botao_sair.pressed.connect(_on_botao_sair_pressed)
	
	atualizar_estatisticas()

func atualizar_estatisticas() -> void:
	var descobertos = GameManager.obter_total_finais_descobertos()
	var total = GameManager.obter_total_finais_jogo()
	label_progresso.text = "Finais Descobertos: %d / %d" % [descobertos, total]

func _on_botao_jogar_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://selecao_missoes.tscn")

func _on_botao_tutorial_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_botao_configuracoes_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://configuracoes.tscn")

func _on_botao_creditos_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://creditos.tscn")

func _on_botao_resetar_pressed() -> void:
	GameManager.tocar_som_clique()
	GameManager.resetar_progresso()
	atualizar_estatisticas()

func _on_botao_sair_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().quit()
