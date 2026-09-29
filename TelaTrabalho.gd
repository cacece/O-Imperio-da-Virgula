extends Control

@onready var botao_voltar: Button = %BotaoVoltar
@onready var botao_pasta: Button = %BotaoPasta
@onready var janela_terminal: PanelContainer = %JanelaTerminal
@onready var botao_fechar_janela: Button = %BotaoFecharJanela

@onready var label_titulo_missao: Label = %LabelTituloMissao
@onready var label_contexto: Label = %LabelContexto
@onready var label_progresso_missao: Label = %LabelProgressoMissao
@onready var campo_decreto: LineEdit = %CampoDecreto
@onready var botao_enviar: Button = %BotaoEnviar
@onready var texto_jornal: RichTextLabel = %TextoJornal

@onready var botao_cola: Button = %BotaoCola
@onready var janela_cola: PanelContainer = %JanelaCola
@onready var botao_fechar_cola: Button = %BotaoFecharCola
@onready var container_finais_cola: VBoxContainer = %ContainerFinaisCola

@onready var camada_ai_slop: CanvasLayer = %CamadaAISlop
@onready var fundo_fade: ColorRect = %FundoFade
@onready var tela_tempo_depois: Control = %TelaTempoDepois
@onready var tela_final_cinematica: Control = %TelaFinalCinematica
@onready var label_tipo_final: Label = %LabelTipoFinal
@onready var label_titulo_final: Label = %LabelTituloFinal
@onready var label_descricao_final: Label = %LabelDescricaoFinal
@onready var retangulo_textura_final: TextureRect = %TextureRectFinal
@onready var placeholder_final: CenterContainer = %PlaceholderFinal
@onready var label_placeholder_titulo: Label = %LabelPlaceholderTitulo
@onready var label_placeholder_caminho: Label = %LabelPlaceholderCaminho
@onready var botao_continuar_final: Button = %BotaoContinuarFinal

var dados_missao: Dictionary = {}
var texto_base: String = ""
var esqueletos_permitidos: Array[String] = []

var texto_valido: String = ""
var posicao_cursor_valida: int = 0

var player_som_ambiente: AudioStreamPlayer = null
var stream_som_ambiente: AudioStream = preload("res://assets/audio/som_ambiente.mp3")

func _ready() -> void:
	GameManager.parar_musica_menu()
	_iniciar_som_ambiente()
	dados_missao = GameManager.obter_missao_atual()
	texto_base = dados_missao["texto_base"]
	
	esqueletos_permitidos.clear()
	var esqueleto_base = extrair_letras_puras(texto_base)
	esqueletos_permitidos.append(esqueleto_base)
	for final_texto in dados_missao["finais"].keys():
		var esqueleto_final = extrair_letras_puras(final_texto)
		if not (esqueleto_final in esqueletos_permitidos):
			esqueletos_permitidos.append(esqueleto_final)
			
	label_titulo_missao.text = "%s — %s" % [dados_missao["titulo"], dados_missao["subtitulo"]]
	label_contexto.text = dados_missao["contexto"]
	
	campo_decreto.text = texto_base
	texto_valido = texto_base
	posicao_cursor_valida = texto_base.length()
	
	atualizar_contador_finais()
	
	texto_jornal.text = "[color=gray]Regra: Pontuações livres (! ? , . ;). Apenas 1 letra pode ser apagada por vez para troca de acento.[/color]"
	texto_jornal.bbcode_enabled = true
	
	janela_terminal.visible = false
	janela_cola.visible = false
	
	botao_pasta.pressed.connect(_on_botao_pasta_pressed)
	botao_fechar_janela.pressed.connect(_on_botao_fechar_janela_pressed)
	botao_voltar.pressed.connect(_on_botao_voltar_pressed)
	botao_enviar.pressed.connect(_on_botao_enviar_pressed)
	campo_decreto.text_changed.connect(_on_campo_decreto_text_changed)
	
	botao_cola.pressed.connect(_on_botao_cola_pressed)
	botao_fechar_cola.pressed.connect(_on_botao_fechar_cola_pressed)
	botao_continuar_final.pressed.connect(_on_botao_continuar_final_pressed)
	camada_ai_slop.visible = false

func _on_botao_pasta_pressed() -> void:
	GameManager.tocar_som_papel()
	janela_terminal.visible = true
	campo_decreto.grab_focus()

func _on_botao_fechar_janela_pressed() -> void:
	GameManager.tocar_som_clique()
	janela_terminal.visible = false

func _on_botao_cola_pressed() -> void:
	GameManager.tocar_som_papel()
	janela_cola.visible = not janela_cola.visible
	if janela_cola.visible:
		atualizar_gabarito_cola()

func _on_botao_fechar_cola_pressed() -> void:
	GameManager.tocar_som_clique()
	janela_cola.visible = false

func atualizar_gabarito_cola() -> void:
	for filho in container_finais_cola.get_children():
		filho.queue_free()
		
	var finais = dados_missao.get("finais", {})
	for texto_final in finais.keys():
		var info = finais[texto_final]
		var tipo = info.get("tipo", "original")
		var titulo_manchete = info.get("titulo", "")
		var noticia = info.get("noticia", "")
		
		var painel = PanelContainer.new()
		var margem = MarginContainer.new()
		margem.add_theme_constant_override("margin_left", 14)
		margem.add_theme_constant_override("margin_top", 10)
		margem.add_theme_constant_override("margin_right", 14)
		margem.add_theme_constant_override("margin_bottom", 10)
		painel.add_child(margem)
		
		var vbox = VBoxContainer.new()
		vbox.add_theme_constant_override("separation", 6)
		margem.add_child(vbox)
		
		var caixa_horizontal_topo = HBoxContainer.new()
		caixa_horizontal_topo.add_theme_constant_override("separation", 12)
		vbox.add_child(caixa_horizontal_topo)
		
		var etiqueta = Label.new()
		etiqueta.text = "[%s]" % tipo.to_upper()
		if tipo == "sucesso":
			etiqueta.modulate = Color(0.3, 0.95, 0.4)
		elif tipo == "caos":
			etiqueta.modulate = Color(1.0, 0.7, 0.25)
		elif tipo == "repressao":
			etiqueta.modulate = Color(0.95, 0.4, 0.4)
		else:
			etiqueta.modulate = Color(0.7, 0.75, 0.8)
		etiqueta.add_theme_font_size_override("font_size", 15)
		caixa_horizontal_topo.add_child(etiqueta)
		
		var rotulo_decreto = Label.new()
		rotulo_decreto.text = "\"%s\"" % texto_final
		rotulo_decreto.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rotulo_decreto.add_theme_font_size_override("font_size", 16)
		caixa_horizontal_topo.add_child(rotulo_decreto)
		
		var botao_copiar = Button.new()
		botao_copiar.text = "Usar Este Decreto"
		botao_copiar.custom_minimum_size = Vector2(170, 32)
		botao_copiar.add_theme_font_size_override("font_size", 13)
		botao_copiar.pressed.connect(func():
			GameManager.tocar_som_clique()
			campo_decreto.text = texto_final
			texto_valido = texto_final
			posicao_cursor_valida = texto_final.length()
			janela_cola.visible = false
			janela_terminal.visible = true
			campo_decreto.grab_focus()
		)
		caixa_horizontal_topo.add_child(botao_copiar)
		
		var rotulo_titulo = Label.new()
		rotulo_titulo.text = "Manchete: %s" % titulo_manchete
		rotulo_titulo.modulate = Color(0.95, 0.85, 0.4)
		rotulo_titulo.add_theme_font_size_override("font_size", 14)
		vbox.add_child(rotulo_titulo)
		
		var rotulo_noticia = Label.new()
		rotulo_noticia.text = "Efeito: %s" % noticia
		rotulo_noticia.modulate = Color(0.75, 0.8, 0.85)
		rotulo_noticia.add_theme_font_size_override("font_size", 13)
		rotulo_noticia.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		vbox.add_child(rotulo_noticia)
		
		container_finais_cola.add_child(painel)

func atualizar_contador_finais() -> void:
	var id_missao = dados_missao["id"]
	var achados = GameManager.obter_quantidade_finais_descobertos(id_missao)
	var total = GameManager.obter_total_finais_missao(id_missao)
	label_progresso_missao.text = "Finais Descobertos: %d / %d" % [achados, total]

func extrair_letras_puras(texto: String) -> String:
	var mapa_acentos = {
		"ã": "a", "á": "a", "à": "a", "â": "a",
		"é": "e", "ê": "e",
		"í": "i",
		"õ": "o", "ó": "o", "ô": "o",
		"ú": "u",
		"ç": "c"
	}
	var resultado = texto.to_lower()
	for acentuada in mapa_acentos:
		resultado = resultado.replace(acentuada, mapa_acentos[acentuada])
	
	var regex = RegEx.new()
	regex.compile("[^a-z]") 
	return regex.sub(resultado, "", true)

func eh_subsequencia_com_uma_letra_a_menos(menor: String, maior: String) -> bool:
	if menor.length() != maior.length() - 1:
		return false
	var i = 0
	var j = 0
	var diferencas = 0
	while i < menor.length() and j < maior.length():
		if menor[i] == maior[j]:
			i += 1
			j += 1
		else:
			diferencas += 1
			j += 1
			if diferencas > 1:
				return false
	return true

func validar_modificacao(novo_texto: String) -> bool:
	var letras_digitadas = extrair_letras_puras(novo_texto)
	for esqueleto in esqueletos_permitidos:
		if letras_digitadas == esqueleto:
			return true
		if eh_subsequencia_com_uma_letra_a_menos(letras_digitadas, esqueleto):
			return true
	return false

func _on_campo_decreto_text_changed(novo_texto: String) -> void:
	if validar_modificacao(novo_texto):
		texto_valido = novo_texto
		posicao_cursor_valida = campo_decreto.caret_column
	else:
		var posicao = posicao_cursor_valida
		campo_decreto.text = texto_valido
		campo_decreto.caret_column = clampi(posicao, 0, texto_valido.length())

func _on_botao_enviar_pressed() -> void:
	GameManager.tocar_som_publicar()
	var texto_digitado: String = campo_decreto.text.strip_edges()
	var letras_digitadas = extrair_letras_puras(texto_digitado)
	
	var esqueleto_completo = false
	for esqueleto in esqueletos_permitidos:
		if letras_digitadas == esqueleto:
			esqueleto_completo = true
			break
			
	if not esqueleto_completo:
		texto_jornal.text = "[color=red]Recoloque a letra que você apagou antes de publicar o decreto![/color]"
		return

	validar_decreto(texto_digitado)

func validar_decreto(texto: String) -> void:
	var mapa_finais = dados_missao["finais"]
	if mapa_finais.has(texto):
		var desfecho: Dictionary = mapa_finais[texto]
		var resultado_registro = GameManager.registrar_final(dados_missao["id"], texto)
		
		atualizar_contador_finais()
		
		var mensagem = "[b]" + desfecho["titulo"] + "[/b]\n\n" + desfecho["noticia"]
		
		if desfecho["tipo"] == "sucesso":
			mensagem += "\n\n[color=green]★ [Objetivo Concluído] Sucesso da Resistência![/color]"
			if resultado_registro["desbloqueou_proxima"]:
				mensagem += "\n[color=cyan]✔ Próxima Missão Desbloqueada no Arquivo Imperial![/color]"
		elif desfecho["tipo"] == "original":
			mensagem += "\n\n[color=orange]• O teor imperial foi mantido sem alterações subversivas.[/color]"
		elif desfecho["tipo"] == "caos":
			mensagem += "\n\n[color=yellow]⚠ Crise ou anarquia burocrática instaurada![/color]"
		elif desfecho["tipo"] == "repressao":
			mensagem += "\n\n[color=red]✖ Ação imperial violenta desencadeada.[/color]"
			
		if resultado_registro["novo"]:
			mensagem += "\n[color=yellow][Novo Final Descoberto!][/color]"
			
		texto_jornal.text = mensagem
		
		if GameManager.ai_slop_ativado:
			var chaves_finais = dados_missao["finais"].keys()
			var numero_final = chaves_finais.find(texto) + 1
			executar_cinematica_ai_slop(dados_missao["id"], numero_final, desfecho)
	else:
		texto_jornal.text = "[color=yellow]Essa modificação ainda não possui final.[/color]"

func executar_cinematica_ai_slop(id_missao: int, numero_final: int, desfecho: Dictionary) -> void:
	var tipo = desfecho.get("tipo", "desconhecido")
	label_tipo_final.text = "★ DESFECHO: [%s]" % tipo.to_upper()
	if tipo == "sucesso":
		label_tipo_final.modulate = Color(0.35, 0.95, 0.45)
	elif tipo == "caos":
		label_tipo_final.modulate = Color(1.0, 0.7, 0.25)
	elif tipo == "repressao":
		label_tipo_final.modulate = Color(0.95, 0.45, 0.45)
	else:
		label_tipo_final.modulate = Color(0.75, 0.8, 0.85)
		
	label_titulo_final.text = desfecho.get("titulo", "")
	label_descricao_final.text = desfecho.get("noticia", "")
	
	label_placeholder_titulo.text = "COLOCAR IMAGEM FINAL %d MISSAO %d" % [numero_final, id_missao]
	label_placeholder_caminho.text = "(res://assets/finais/missao_%d_final_%d.png)" % [id_missao, numero_final]
	
	var caminhos_possiveis = [
		"res://assets/finais/missao_%d_final_%d.png" % [id_missao, numero_final],
		"res://assets/finais/missao_%d_final_%d.jpg" % [id_missao, numero_final]
	]
	var textura_carregada: Texture2D = null
	for caminho in caminhos_possiveis:
		if ResourceLoader.exists(caminho):
			var tex = load(caminho)
			if tex:
				textura_carregada = tex
				break
				
	if textura_carregada:
		retangulo_textura_final.texture = textura_carregada
		retangulo_textura_final.visible = true
		placeholder_final.visible = false
	else:
		retangulo_textura_final.visible = false
		placeholder_final.visible = true
		
	camada_ai_slop.visible = true
	tela_tempo_depois.visible = false
	tela_final_cinematica.visible = false
	fundo_fade.modulate.a = 0.0
	
	var tween_fade = create_tween()
	tween_fade.tween_property(fundo_fade, "modulate:a", 1.0, 0.4)
	await tween_fade.finished
	
	tela_tempo_depois.modulate.a = 0.0
	tela_tempo_depois.visible = true
	var tween_tempo = create_tween()
	tween_tempo.tween_property(tela_tempo_depois, "modulate:a", 1.0, 0.35)
	tween_tempo.tween_interval(1.2)
	tween_tempo.tween_property(tela_tempo_depois, "modulate:a", 0.0, 0.35)
	await tween_tempo.finished
	tela_tempo_depois.visible = false
	
	tela_final_cinematica.modulate.a = 0.0
	tela_final_cinematica.visible = true
	var tween_final = create_tween()
	tween_final.tween_property(tela_final_cinematica, "modulate:a", 1.0, 0.4)

func _on_botao_continuar_final_pressed() -> void:
	GameManager.tocar_som_clique()
	var tween = create_tween()
	tween.tween_property(fundo_fade, "modulate:a", 0.0, 0.35)
	tween.parallel().tween_property(tela_final_cinematica, "modulate:a", 0.0, 0.35)
	await tween.finished
	camada_ai_slop.visible = false

func _iniciar_som_ambiente() -> void:
	player_som_ambiente = AudioStreamPlayer.new()
	player_som_ambiente.name = "PlayerSomAmbiente"
	player_som_ambiente.stream = stream_som_ambiente
	player_som_ambiente.bus = &"Master"
	player_som_ambiente.volume_db = -4.0
	add_child(player_som_ambiente)
	player_som_ambiente.play()

func _on_botao_voltar_pressed() -> void:
	GameManager.tocar_som_clique()
	if player_som_ambiente and player_som_ambiente.playing:
		player_som_ambiente.stop()
	get_tree().change_scene_to_file("res://selecao_missoes.tscn")
