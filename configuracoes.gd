extends Control

@onready var botao_voltar: Button = %BotaoVoltar
@onready var botao_tela_cheia: Button = %BotaoTelaCheia
@onready var label_tela_cheia_status: Label = %LabelTelaCheiaStatus

@onready var botao_ai_slop: Button = %BotaoAISlop
@onready var label_ai_slop_status: Label = %LabelAISlopStatus

@onready var slider_master: HSlider = %SliderMaster
@onready var botao_master_menos: Button = %BtnMasterMenos
@onready var botao_master_mais: Button = %BtnMasterMais
@onready var label_master_porcentagem: Label = %LabelMasterPct

@onready var slider_musica: HSlider = %SliderMusica
@onready var botao_musica_menos: Button = %BtnMusicaMenos
@onready var botao_musica_mais: Button = %BtnMusicaMais
@onready var label_musica_porcentagem: Label = %LabelMusicaPct

@onready var slider_sfx: HSlider = %SliderSFX
@onready var botao_sfx_menos: Button = %BtnSFXMenos
@onready var botao_sfx_mais: Button = %BtnSFXMais
@onready var label_sfx_porcentagem: Label = %LabelSFXPct

@onready var botao_restaurar_padrao: Button = %BotaoRestaurarPadrao

var atualizando_interface: bool = false

func _ready() -> void:
	GameManager.tocar_musica_menu()
	
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_tela_cheia.pressed.connect(_on_botao_tela_cheia_pressed)
	botao_ai_slop.pressed.connect(_on_botao_ai_slop_pressed)
	
	slider_master.value_changed.connect(_on_slider_master_changed)
	botao_master_menos.pressed.connect(func(): _ajustar_slider(slider_master, -5))
	botao_master_mais.pressed.connect(func(): _ajustar_slider(slider_master, 5))
	
	slider_musica.value_changed.connect(_on_slider_musica_changed)
	botao_musica_menos.pressed.connect(func(): _ajustar_slider(slider_musica, -5))
	botao_musica_mais.pressed.connect(func(): _ajustar_slider(slider_musica, 5))
	
	slider_sfx.value_changed.connect(_on_slider_sfx_changed)
	botao_sfx_menos.pressed.connect(func(): _ajustar_slider(slider_sfx, -5))
	botao_sfx_mais.pressed.connect(func(): _ajustar_slider(slider_sfx, 5))
	
	botao_restaurar_padrao.pressed.connect(_on_botao_restaurar_padrao_pressed)
	
	sincronizar_interface()

func sincronizar_interface() -> void:
	atualizando_interface = true
	
	_atualizar_botao_tela_cheia()
	_atualizar_botao_ai_slop()
	
	var valor_master = roundi(GameManager.volume_master * 100.0)
	slider_master.value = valor_master
	label_master_porcentagem.text = "%d%%" % valor_master
	
	var valor_musica = roundi(GameManager.volume_musica * 100.0)
	slider_musica.value = valor_musica
	label_musica_porcentagem.text = "%d%%" % valor_musica
	
	var valor_sfx = roundi(GameManager.volume_sfx * 100.0)
	slider_sfx.value = valor_sfx
	label_sfx_porcentagem.text = "%d%%" % valor_sfx
	
	atualizando_interface = false

func _atualizar_botao_tela_cheia() -> void:
	var tela_cheia_ativa = GameManager.eh_tela_cheia
	if tela_cheia_ativa:
		botao_tela_cheia.text = "TELA CHEIA: [ ATIVADO ]"
		label_tela_cheia_status.text = "O jogo está em modo Tela Cheia exclusiva."
		label_tela_cheia_status.modulate = Color(0.35, 0.95, 0.45)
	else:
		botao_tela_cheia.text = "TELA CHEIA: [ DESATIVADO ]"
		label_tela_cheia_status.text = "O jogo está em modo Janela (1920x1080)."
		label_tela_cheia_status.modulate = Color(0.7, 0.75, 0.8)

func _on_botao_tela_cheia_pressed() -> void:
	GameManager.tocar_som_clique()
	var novo_estado = not GameManager.eh_tela_cheia
	GameManager.alternar_tela_cheia(novo_estado)
	_atualizar_botao_tela_cheia()

func _atualizar_botao_ai_slop() -> void:
	var ativo = GameManager.ai_slop_ativado
	if ativo:
		botao_ai_slop.text = "AI SLOP: [ ATIVADO ]"
		label_ai_slop_status.text = "Ativado: Finais exibirão tela 'Um tempo depois...' com imagem e história."
		label_ai_slop_status.modulate = Color(0.35, 0.95, 0.45)
	else:
		botao_ai_slop.text = "AI SLOP: [ DESATIVADO ]"
		label_ai_slop_status.text = "Desativado: Finais serão exibidos diretamente no jornal da mesa."
		label_ai_slop_status.modulate = Color(0.7, 0.75, 0.8)

func _on_botao_ai_slop_pressed() -> void:
	GameManager.tocar_som_clique()
	var novo_estado = not GameManager.ai_slop_ativado
	GameManager.alternar_ai_slop(novo_estado)
	_atualizar_botao_ai_slop()

func _ajustar_slider(slider: HSlider, variacao: int) -> void:
	GameManager.tocar_som_clique()
	slider.value = clampf(slider.value + variacao, slider.min_value, slider.max_value)

func _on_slider_master_changed(novo_valor: float) -> void:
	label_master_porcentagem.text = "%d%%" % int(novo_valor)
	if not atualizando_interface:
		GameManager.definir_volume_master(novo_valor / 100.0)

func _on_slider_musica_changed(novo_valor: float) -> void:
	label_musica_porcentagem.text = "%d%%" % int(novo_valor)
	if not atualizando_interface:
		GameManager.definir_volume_musica(novo_valor / 100.0)

func _on_slider_sfx_changed(novo_valor: float) -> void:
	label_sfx_porcentagem.text = "%d%%" % int(novo_valor)
	if not atualizando_interface:
		GameManager.definir_volume_sfx(novo_valor / 100.0)

func _on_botao_restaurar_padrao_pressed() -> void:
	GameManager.tocar_som_clique()
	GameManager.alternar_tela_cheia(false)
	GameManager.alternar_ai_slop(false)
	GameManager.definir_volume_master(1.0)
	GameManager.definir_volume_musica(1.0)
	GameManager.definir_volume_sfx(1.0)
	sincronizar_interface()

func _on_botao_voltar_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://menu_principal.tscn")
