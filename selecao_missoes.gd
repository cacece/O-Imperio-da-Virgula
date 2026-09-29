extends Control

@onready var botao_voltar: Button = %BotaoVoltar
@onready var label_total_finais: Label = %LabelTotalFinais
@onready var container_icones: HBoxContainer = %ContainerIcones

@onready var painel_info: PanelContainer = %PainelInfo
@onready var label_info_titulo: Label = %LabelInfoTitulo
@onready var label_info_status: Label = %LabelInfoStatus
@onready var label_info_contexto: Label = %LabelInfoContexto
@onready var label_info_decreto_base: Label = %LabelInfoDecretoBase
@onready var label_info_finais: Label = %LabelInfoFinais
@onready var vbox_lista_finais: VBoxContainer = %VBoxListaFinais
@onready var label_info_requisito: Label = %LabelInfoRequisito
@onready var botao_acessar: Button = %BotaoAcessar
@onready var fundo_fade: ColorRect = %FundoFade

var textura_pasta: Texture2D = preload("res://assets/icone_pasta_missao.png")
var missao_selecionada_id: int = 1
var icones_cartoes: Dictionary = {}

func _ready() -> void:
	GameManager.tocar_musica_menu()
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_acessar.pressed.connect(_on_botao_acessar_pressed)
	
	GameManager.sincronizar_desbloqueios()
	atualizar_tela()

func atualizar_tela() -> void:
	var descobertos = GameManager.obter_total_finais_descobertos()
	var total = GameManager.obter_total_finais_jogo()
	label_total_finais.text = "Progresso Geral: %d / %d Finais" % [descobertos, total]
	
	for filho in container_icones.get_children():
		filho.queue_free()
	icones_cartoes.clear()
	
	var ultima_desbloqueada: int = 1
	for id_missao in range(1, 7):
		if GameManager.missoes.has(id_missao):
			var dados = GameManager.missoes[id_missao]
			var cartao = criar_icone_missao(dados)
			container_icones.add_child(cartao)
			icones_cartoes[id_missao] = cartao
			if GameManager.eh_missao_desbloqueada(id_missao):
				ultima_desbloqueada = id_missao
	
	if GameManager.eh_missao_desbloqueada(GameManager.missao_atual_id):
		selecionar_missao(GameManager.missao_atual_id)
	else:
		selecionar_missao(ultima_desbloqueada)

func criar_icone_missao(dados: Dictionary) -> Control:
	var id_missao: int = dados["id"]
	var desbloqueada: bool = GameManager.eh_missao_desbloqueada(id_missao)
	var concluida: bool = GameManager.eh_objetivo_concluido(id_missao)
	var finais_achados: int = GameManager.obter_quantidade_finais_descobertos(id_missao)
	var total_finais: int = GameManager.obter_total_finais_missao(id_missao)
	
	var elemento = Control.new()
	elemento.custom_minimum_size = Vector2(250, 300)
	elemento.pivot_offset = Vector2(125, 150)
	elemento.mouse_filter = Control.MOUSE_FILTER_PASS
	elemento.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if desbloqueada else Control.CURSOR_FORBIDDEN
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 8)
	elemento.add_child(vbox)
	
	var label_num = Label.new()
	label_num.text = "MISSÃO %02d" % id_missao
	label_num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_num.add_theme_font_size_override("font_size", 20)
	if concluida:
		label_num.modulate = Color(0.35, 0.95, 0.45)
	elif desbloqueada:
		label_num.modulate = Color(0.92, 0.94, 0.96)
	else:
		label_num.modulate = Color(0.6, 0.6, 0.6)
	vbox.add_child(label_num)
	
	var icone_centro = CenterContainer.new()
	vbox.add_child(icone_centro)
	
	var icone_retangulo = TextureRect.new()
	icone_retangulo.texture = textura_pasta
	icone_retangulo.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icone_retangulo.custom_minimum_size = Vector2(130, 122)
	icone_retangulo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icone_retangulo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not desbloqueada:
		icone_retangulo.modulate = Color(0.45, 0.45, 0.45, 0.65)
	icone_centro.add_child(icone_retangulo)
	
	var label_status = Label.new()
	label_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_status.add_theme_font_size_override("font_size", 15)
	if concluida:
		label_status.text = "★ CONCLUÍDA"
		label_status.modulate = Color(0.3, 0.95, 0.4)
	elif desbloqueada:
		label_status.text = "● DISPONÍVEL"
		label_status.modulate = Color(0.4, 0.75, 1.0)
	else:
		label_status.text = "🔒 BLOQUEADA"
		label_status.modulate = Color(0.9, 0.4, 0.4)
	vbox.add_child(label_status)
	
	var label_finais = Label.new()
	label_finais.text = "%d / %d Finais" % [finais_achados, total_finais]
	label_finais.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_finais.add_theme_font_size_override("font_size", 14)
	if finais_achados > 0:
		label_finais.modulate = Color(0.95, 0.85, 0.35)
	else:
		label_finais.modulate = Color(0.6, 0.6, 0.6)
	vbox.add_child(label_finais)
	
	elemento.mouse_entered.connect(func(): _on_icone_mouse_entered(elemento, id_missao))
	elemento.mouse_exited.connect(func(): _on_icone_mouse_exited(elemento))
	elemento.gui_input.connect(func(evento: InputEvent): _on_icone_gui_input(evento, id_missao))
	
	return elemento

func _on_icone_mouse_entered(elemento: Control, id_missao: int) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(elemento, "scale", Vector2(1.12, 1.12), 0.16)
	selecionar_missao(id_missao)

func _on_icone_mouse_exited(elemento: Control) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(elemento, "scale", Vector2(1.0, 1.0), 0.16)

func _on_icone_gui_input(evento: InputEvent, id_missao: int) -> void:
	if evento is InputEventMouseButton and evento.button_index == MOUSE_BUTTON_LEFT and evento.pressed:
		selecionar_missao(id_missao)
		if GameManager.eh_missao_desbloqueada(id_missao):
			GameManager.tocar_som_papel()
			iniciar_missao(id_missao)
		else:
			GameManager.tocar_som_clique()

func selecionar_missao(id_missao: int) -> void:
	missao_selecionada_id = id_missao
	if not GameManager.missoes.has(id_missao):
		return
		
	var dados = GameManager.missoes[id_missao]
	var desbloqueada: bool = GameManager.eh_missao_desbloqueada(id_missao)
	var concluida: bool = GameManager.eh_objetivo_concluido(id_missao)
	var finais_achados: int = GameManager.obter_quantidade_finais_descobertos(id_missao)
	var total_finais: int = GameManager.obter_total_finais_missao(id_missao)
	
	label_info_titulo.text = "%s — %s" % [dados["titulo"], dados["subtitulo"]]
	
	if concluida:
		label_info_status.text = "[★ Objetivo Principal Concluído]"
		label_info_status.modulate = Color(0.3, 0.95, 0.4)
	elif desbloqueada:
		label_info_status.text = "[● Missão Pronta para Revisão]"
		label_info_status.modulate = Color(0.4, 0.75, 1.0)
	else:
		label_info_status.text = "[🔒 Decreto Bloqueado no Arquivo Imperial]"
		label_info_status.modulate = Color(0.9, 0.4, 0.4)
		
	label_info_contexto.text = dados["contexto"]
	label_info_decreto_base.text = "Decreto Original: \"%s\"" % dados["texto_base"]
	label_info_finais.text = "Finais Descobertos nesta Missão: %d / %d" % [finais_achados, total_finais]
	
	for filho in vbox_lista_finais.get_children():
		filho.queue_free()
		
	var lista_descobertos = GameManager.finais_descobertos.get(id_missao, [])
	if lista_descobertos.is_empty():
		var label_vazio = Label.new()
		label_vazio.text = "Nenhuma publicação registrada ainda. Abra a pasta para começar a revisar."
		label_vazio.modulate = Color(0.55, 0.6, 0.65)
		label_vazio.add_theme_font_size_override("font_size", 14)
		vbox_lista_finais.add_child(label_vazio)
	else:
		for texto in lista_descobertos:
			var info_final = dados["finais"].get(texto, {})
			var elemento_final = Label.new()
			var tipo = info_final.get("tipo", "desconhecido")
			var titulo_manchete = info_final.get("titulo", "Publicação Não Registrada")
			elemento_final.text = "✓ [%s] %s — \"%s\"" % [tipo.to_upper(), titulo_manchete, texto]
			if tipo == "sucesso":
				elemento_final.modulate = Color(0.35, 0.95, 0.45)
			elif tipo == "caos":
				elemento_final.modulate = Color(1.0, 0.7, 0.25)
			elif tipo == "repressao":
				elemento_final.modulate = Color(0.95, 0.45, 0.45)
			else:
				elemento_final.modulate = Color(0.75, 0.8, 0.85)
			elemento_final.add_theme_font_size_override("font_size", 13)
			vbox_lista_finais.add_child(elemento_final)
			
	if desbloqueada:
		label_info_requisito.text = ""
		botao_acessar.disabled = false
		if concluida:
			botao_acessar.text = "REVISITAR DECRETO"
		else:
			botao_acessar.text = "REVISAR DECRETO"
	else:
		label_info_requisito.text = "Requisito: Conclua o objetivo principal da Missão %02d para desbloquear." % (id_missao - 1)
		botao_acessar.text = "🔒 MISSÃO BLOQUEADA"
		botao_acessar.disabled = true

func _on_botao_acessar_pressed() -> void:
	if GameManager.eh_missao_desbloqueada(missao_selecionada_id):
		GameManager.tocar_som_papel()
		iniciar_missao(missao_selecionada_id)
	else:
		GameManager.tocar_som_clique()

func iniciar_missao(id_missao: int) -> void:
	GameManager.missao_atual_id = id_missao
	var proxima_cena = "res://intro_lore.tscn" if id_missao == 1 else "res://tela_trabalho.tscn"
	transicionar_para_cena(proxima_cena)

func transicionar_para_cena(caminho: String) -> void:
	fundo_fade.mouse_filter = Control.MOUSE_FILTER_STOP
	var animacao = create_tween()
	animacao.tween_property(fundo_fade, "modulate:a", 1.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await animacao.finished
	get_tree().change_scene_to_file(caminho)

func _on_botao_voltar_pressed() -> void:
	GameManager.tocar_som_clique()
	get_tree().change_scene_to_file("res://menu_principal.tscn")
