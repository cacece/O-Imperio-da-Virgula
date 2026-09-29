extends Node

const CAMINHO_SALVAMENTO: String = "user://save_data.json"

var missoes: Dictionary = {
	1: {
		"id": 1,
		"titulo": "Missão 01: O Rebelde",
		"subtitulo": "Execução Pública",
		"contexto": "Um líder revolucionário foi capturado e aguarda a confirmação da pena de morte.",
		"post_it": "Pista: O pavio precisa continuar aceso hoje à noite.",
		"texto_base": "Perdão impossível, executar o rebelde.",
		"finais": {
			"Perdão, impossível executar o rebelde.": {
				"tipo": "sucesso",
				"titulo": "EDIÇÃO EXTRAORDINÁRIA: REBELDE LIBERTO!",
				"noticia": "Guarda solta o prisioneiro por erro protocolar; resistência comemora."
			},
			"Perdão impossível, executar o rebelde.": {
				"tipo": "original",
				"titulo": "JUSTIÇA IMPERIAL CUMPRIDA",
				"noticia": "O rebelde é executado; protestos violentos reprimidos."
			},
			"Perdão impossível executar, o rebelde.": {
				"tipo": "caos",
				"titulo": "CRISE NO TRIBUNAL IMPERIAL",
				"noticia": "Crise institucional sobre competência de execução; processo suspenso indefinidamente."
			},
			"Perdão, impossível executar, o rebelde!": {
				"tipo": "caos",
				"titulo": "ANARQUIA NO JULGAMENTO",
				"noticia": "Rebelde se autodeclara juiz do próprio tribunal."
			},
			"Perdão? Impossível! Executar o rebelde.": {
				"tipo": "repressao",
				"titulo": "EXECUÇÃO SUMÁRIA",
				"noticia": "Execução acelerada com transmissão nacional."
			}
		}
	},
	2: {
		"id": 2,
		"titulo": "Missão 02: Tributação Imperial",
		"subtitulo": "Crise Financeira",
		"contexto": "Crise financeira do Império exige novos impostos.",
		"post_it": "Pista: Os cofres dos barões estão cheios demais.",
		"texto_base": "Cobrar imposto sobre os pobres, não sobre o ouro da nobreza.",
		"finais": {
			"Cobrar imposto, sobre os pobres não, sobre o ouro da nobreza.": {
				"tipo": "sucesso",
				"titulo": "PÂNICO ENTRE A NOBREZA",
				"noticia": "Nobreza entra em pânico financeiro; alívio para a plebe."
			},
			"Cobrar imposto sobre os pobres, não sobre o ouro da nobreza.": {
				"tipo": "original",
				"titulo": "REVOLTA NAS RUAS",
				"noticia": "Revolta popular dos famintos na praça central."
			},
			"Cobrar imposto sobre os pobres? Não, sobre o ouro da nobreza!": {
				"tipo": "caos",
				"titulo": "BANQUETE IMPERIAL CANCELADO",
				"noticia": "Banquete imperial cancelado por falta de patrocínio dos duques."
			},
			"Cobrar, imposto sobre os pobres não sobre o ouro, da nobreza.": {
				"tipo": "caos",
				"titulo": "ERRO BUROCRÁTICO HISTÓRICO",
				"noticia": "Burocratas confiscam castelos inteiros por engano de interpretação."
			}
		}
	},
	3: {
		"id": 3,
		"titulo": "Missão 03: Racionamento de Alimentos",
		"subtitulo": "Safra Perdida",
		"contexto": "Safra perdida; a capital precisa de abastecimento urgente.",
		"post_it": "Pista: Os silos do exército guardam mais do que trigo.",
		"texto_base": "Distribuir rações apenas aos soldados, proibir a partilha com os cidadãos.",
		"finais": {
			"Distribuir rações, apenas aos soldados proibir, a partilha com os cidadãos.": {
				"tipo": "sucesso",
				"titulo": "COMIDA PARA O POVO",
				"noticia": "Comida distribuída aos civis; oficiais ficam furiosos."
			},
			"Distribuir rações apenas aos soldados, proibir a partilha com os cidadãos.": {
				"tipo": "original",
				"titulo": "SAQUES AOS ARMAZÉNS",
				"noticia": "Saques em massa aos armazéns imperiais."
			},
			"Distribuir rações apenas, aos soldados proibir a partilha com os cidadãos.": {
				"tipo": "caos",
				"titulo": "DESERÇÃO EM MASSA",
				"noticia": "Soldados comem sozinhos e abandonam postos nas muralhas."
			}
		}
	},
	4: {
		"id": 4,
		"titulo": "Missão 04: A Censura da Imprensa",
		"subtitulo": "Escândalo do Chanceler",
		"contexto": "Jornais clandestinos vazaram escândalos de corrupção do chanceler.",
		"post_it": "Pista: A verdade não pode ser queimada na gráfica.",
		"texto_base": "Fechar gráficas suspeitas imediatamente, punir sem piedade quem denunciar o chanceler.",
		"finais": {
			"Fechar gráficas suspeitas imediatamente? Punir sem piedade quem denunciar, o chanceler!": {
				"tipo": "sucesso",
				"titulo": "CHANCELER PRESO PELA GUARDA",
				"noticia": "Polícia prende o próprio chanceler com base na ordem revisada."
			},
			"Fechar gráficas suspeitas imediatamente, punir sem piedade quem denunciar o chanceler.": {
				"tipo": "original",
				"titulo": "APAGÃO DE NOTÍCIAS",
				"noticia": "Apagão de notícias e caça às bruxas pela polícia secreta."
			},
			"Fechar gráficas, suspeitas imediatamente punir, sem piedade quem denunciar o chanceler.": {
				"tipo": "caos",
				"titulo": "TODAS AS GRÁFICAS FECHADAS",
				"noticia": "Fechamento de todas as gráficas do império, até as estatais."
			}
		}
	},
	5: {
		"id": 5,
		"titulo": "Missão 05: A Ordem de Guerra",
		"subtitulo": "Conflito Iminente",
		"contexto": "Tropas na fronteira prestes a invadir a república vizinha.",
		"post_it": "Pista: Nenhum filho do povo deve morrer por vaidade imperial.",
		"texto_base": "Se marcharem contra nós haverá guerra, nunca paz.",
		"finais": {
			"Se marcharem contra nós haverá guerra? Nunca! Paz.": {
				"tipo": "sucesso",
				"titulo": "TRATADO DE PAZ ASSINADO",
				"noticia": "Cessar-fogo unilateral assinado; tratado de paz celebrado."
			},
			"Se marcharem contra nós haverá guerra, nunca paz.": {
				"tipo": "original",
				"titulo": "GUERRA TOTAL DECLARADA",
				"noticia": "Guerra total declarada na fronteira norte."
			}
		}
	},
	6: {
		"id": 6,
		"titulo": "Missão 06: A Queda do Imperador",
		"subtitulo": "O Julgamento Final",
		"contexto": "O palácio imperial foi cercado pela resistência. O último decreto definirá o futuro da nação.",
		"post_it": "Pista: O ponto final na tirania é você quem escreve.",
		"texto_base": "Reinar com mãos de ferro, jamais perdoar os revoltosos.",
		"finais": {
			"Reinar com mãos de ferro? Jamais! Perdoar os revoltosos.": {
				"tipo": "sucesso",
				"titulo": "REPÚBLICA PROCLAMADA: FIM DA TIRANIA!",
				"noticia": "O imperador abdica pacificamente; o povo celebra o nascimento da república."
			},
			"Reinar com mãos de ferro, jamais perdoar os revoltosos.": {
				"tipo": "original",
				"titulo": "DITADURA PERPÉTUA",
				"noticia": "A resistência é massacrada; o imperador consolida seu poder absoluto."
			},
			"Reinar, com mãos de ferro jamais perdoar, os revoltosos!": {
				"tipo": "caos",
				"titulo": "GUERRA CIVIL PELO PODER",
				"noticia": "Generais disputam o palácio vazio; a capital mergulha no caos total."
			}
		}
	}
}

var missao_atual_id: int = 1
var missoes_desbloqueadas: Array = [1]
var finais_descobertos: Dictionary = {
	1: [],
	2: [],
	3: [],
	4: [],
	5: [],
	6: []
}

var player_musica: AudioStreamPlayer = null
var stream_musica_menu: AudioStream = preload("res://assets/audio/musica_tema.mp3")

var stream_som_clique: AudioStream = preload("res://assets/audio/som_clique_normal.wav")
var stream_som_papel: AudioStream = preload("res://assets/audio/som_papel.wav")
var stream_som_publicar: AudioStream = preload("res://assets/audio/som_publicar.wav")

var player_sfx_clique: AudioStreamPlayer = null
var player_sfx_papel: AudioStreamPlayer = null
var player_sfx_publicar: AudioStreamPlayer = null

var volume_master: float = 1.0
var volume_musica: float = 1.0
var volume_sfx: float = 1.0
var eh_tela_cheia: bool = false
var ai_slop_ativado: bool = false

func _ready() -> void:
	_iniciar_musica()
	_iniciar_sfx()
	carregar_progresso()

func _iniciar_musica() -> void:
	player_musica = AudioStreamPlayer.new()
	player_musica.name = "PlayerMusicaMenu"
	player_musica.stream = stream_musica_menu
	player_musica.bus = &"Musica"
	add_child(player_musica)

func _iniciar_sfx() -> void:
	player_sfx_clique = AudioStreamPlayer.new()
	player_sfx_clique.name = "PlayerSFXClique"
	player_sfx_clique.stream = stream_som_clique
	player_sfx_clique.bus = &"SFX"
	player_sfx_clique.volume_db = -3.0
	add_child(player_sfx_clique)

	player_sfx_papel = AudioStreamPlayer.new()
	player_sfx_papel.name = "PlayerSFXPapel"
	player_sfx_papel.stream = stream_som_papel
	player_sfx_papel.bus = &"SFX"
	player_sfx_papel.volume_db = -1.0
	add_child(player_sfx_papel)

	player_sfx_publicar = AudioStreamPlayer.new()
	player_sfx_publicar.name = "PlayerSFXPublicar"
	player_sfx_publicar.stream = stream_som_publicar
	player_sfx_publicar.bus = &"SFX"
	player_sfx_publicar.volume_db = 0.0
	add_child(player_sfx_publicar)

func aplicar_configuracoes() -> void:
	definir_volume_master(volume_master, false)
	definir_volume_musica(volume_musica, false)
	definir_volume_sfx(volume_sfx, false)
	alternar_tela_cheia(eh_tela_cheia, false)

func definir_volume_master(valor: float, salvar: bool = true) -> void:
	volume_master = clampf(valor, 0.0, 1.0)
	var indice_barramento = AudioServer.get_bus_index("Master")
	if indice_barramento >= 0:
		if volume_master <= 0.001:
			AudioServer.set_bus_mute(indice_barramento, true)
		else:
			AudioServer.set_bus_mute(indice_barramento, false)
			AudioServer.set_bus_volume_db(indice_barramento, linear_to_db(volume_master))
	if salvar:
		salvar_progresso()

func definir_volume_musica(valor: float, salvar: bool = true) -> void:
	volume_musica = clampf(valor, 0.0, 1.0)
	var indice_barramento = AudioServer.get_bus_index("Musica")
	if indice_barramento >= 0:
		if volume_musica <= 0.001:
			AudioServer.set_bus_mute(indice_barramento, true)
		else:
			AudioServer.set_bus_mute(indice_barramento, false)
			AudioServer.set_bus_volume_db(indice_barramento, linear_to_db(volume_musica))
	if salvar:
		salvar_progresso()

func definir_volume_sfx(valor: float, salvar: bool = true) -> void:
	volume_sfx = clampf(valor, 0.0, 1.0)
	var indice_barramento = AudioServer.get_bus_index("SFX")
	if indice_barramento >= 0:
		if volume_sfx <= 0.001:
			AudioServer.set_bus_mute(indice_barramento, true)
		else:
			AudioServer.set_bus_mute(indice_barramento, false)
			AudioServer.set_bus_volume_db(indice_barramento, linear_to_db(volume_sfx))
	if salvar:
		salvar_progresso()

func alternar_tela_cheia(ativar: bool, salvar: bool = true) -> void:
	eh_tela_cheia = ativar
	if ativar:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if salvar:
		salvar_progresso()

func alternar_ai_slop(ativar: bool, salvar: bool = true) -> void:
	ai_slop_ativado = ativar
	if salvar:
		salvar_progresso()

func tocar_som_clique() -> void:
	if player_sfx_clique:
		player_sfx_clique.pitch_scale = randf_range(0.97, 1.03)
		player_sfx_clique.play()

func tocar_som_papel() -> void:
	if player_sfx_papel:
		player_sfx_papel.pitch_scale = randf_range(0.95, 1.05)
		player_sfx_papel.play()

func tocar_som_publicar() -> void:
	if player_sfx_publicar:
		player_sfx_publicar.pitch_scale = randf_range(0.98, 1.02)
		player_sfx_publicar.play()

func tocar_musica_menu() -> void:
	if player_musica and not player_musica.playing:
		player_musica.play()

func parar_musica_menu() -> void:
	if player_musica and player_musica.playing:
		player_musica.stop()

func obter_missao_atual() -> Dictionary:
	return missoes.get(missao_atual_id, missoes[1])

func sincronizar_desbloqueios() -> void:
	if not (1 in missoes_desbloqueadas):
		missoes_desbloqueadas.append(1)
	for id_missao in range(1, 6):
		if eh_objetivo_concluido(id_missao):
			var proxima = id_missao + 1
			if not (proxima in missoes_desbloqueadas):
				missoes_desbloqueadas.append(proxima)

func eh_missao_desbloqueada(id_missao: int) -> bool:
	if id_missao == 1:
		return true
	if eh_objetivo_concluido(id_missao - 1):
		return true
	return id_missao in missoes_desbloqueadas

func eh_objetivo_concluido(id_missao: int) -> bool:
	if not missoes.has(id_missao):
		return false
	var dados_missao = missoes[id_missao]
	var descobertos = finais_descobertos.get(id_missao, [])
	for texto in descobertos:
		if dados_missao["finais"].has(texto):
			if dados_missao["finais"][texto].get("tipo") == "sucesso":
				return true
	return false

func obter_total_finais_missao(id_missao: int) -> int:
	if not missoes.has(id_missao):
		return 0
	return missoes[id_missao]["finais"].size()

func obter_quantidade_finais_descobertos(id_missao: int) -> int:
	var lista = finais_descobertos.get(id_missao, [])
	return lista.size()

func obter_total_finais_descobertos() -> int:
	var total = 0
	for id_missao in missoes:
		total += obter_quantidade_finais_descobertos(id_missao)
	return total

func obter_total_finais_jogo() -> int:
	var total = 0
	for id_missao in missoes:
		total += obter_total_finais_missao(id_missao)
	return total

func registrar_final(id_missao: int, texto_decreto: String) -> Dictionary:
	if not missoes.has(id_missao):
		return {"novo": false, "sucesso": false, "desbloqueou_proxima": false}
		
	var dados_missao = missoes[id_missao]
	var novo: bool = false
	var eh_sucesso: bool = false
	var desbloqueou_proxima: bool = false
	
	if not finais_descobertos.has(id_missao):
		finais_descobertos[id_missao] = []
		
	if not (texto_decreto in finais_descobertos[id_missao]):
		finais_descobertos[id_missao].append(texto_decreto)
		novo = true
		
	if dados_missao["finais"].has(texto_decreto):
		if dados_missao["finais"][texto_decreto].get("tipo") == "sucesso":
			eh_sucesso = true
			var proxima_id = id_missao + 1
			if missoes.has(proxima_id):
				if not (proxima_id in missoes_desbloqueadas):
					missoes_desbloqueadas.append(proxima_id)
					desbloqueou_proxima = true
			sincronizar_desbloqueios()
				
	if novo or desbloqueou_proxima:
		salvar_progresso()
		
	return {
		"novo": novo,
		"sucesso": eh_sucesso,
		"desbloqueou_proxima": desbloqueou_proxima
	}

func salvar_progresso() -> void:
	var dados = {
		"missoes_desbloqueadas": missoes_desbloqueadas,
		"finais_descobertos": {},
		"configuracoes": {
			"tela_cheia": eh_tela_cheia,
			"fullscreen": eh_tela_cheia,
			"volume_master": volume_master,
			"volume_musica": volume_musica,
			"volume_sfx": volume_sfx,
			"ai_slop": ai_slop_ativado
		}
	}
	for chave in finais_descobertos:
		dados["finais_descobertos"][str(chave)] = finais_descobertos[chave]
		
	var texto_json = JSON.stringify(dados, "\t")
	var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.WRITE)
	if arquivo:
		arquivo.store_string(texto_json)
		arquivo.close()

func carregar_progresso() -> void:
	if not FileAccess.file_exists(CAMINHO_SALVAMENTO):
		missoes_desbloqueadas = [1]
		finais_descobertos = { 1: [], 2: [], 3: [], 4: [], 5: [], 6: [] }
		aplicar_configuracoes()
		return
		
	var arquivo = FileAccess.open(CAMINHO_SALVAMENTO, FileAccess.READ)
	if not arquivo:
		aplicar_configuracoes()
		return
	var conteudo = arquivo.get_as_text()
	arquivo.close()
	
	var json = JSON.new()
	var erro = json.parse(conteudo)
	if erro != OK:
		aplicar_configuracoes()
		return
		
	var dados = json.get_data()
	if typeof(dados) == TYPE_DICTIONARY:
		if dados.has("missoes_desbloqueadas") and typeof(dados["missoes_desbloqueadas"]) == TYPE_ARRAY:
			missoes_desbloqueadas.clear()
			for valor_id in dados["missoes_desbloqueadas"]:
				missoes_desbloqueadas.append(int(valor_id))
			if not (1 in missoes_desbloqueadas):
				missoes_desbloqueadas.append(1)
				
		if dados.has("finais_descobertos") and typeof(dados["finais_descobertos"]) == TYPE_DICTIONARY:
			for texto_id in dados["finais_descobertos"]:
				var numero_id = int(texto_id)
				finais_descobertos[numero_id] = []
				for elemento_final in dados["finais_descobertos"][texto_id]:
					if missoes.has(numero_id) and missoes[numero_id]["finais"].has(str(elemento_final)):
						finais_descobertos[numero_id].append(str(elemento_final))
		sincronizar_desbloqueios()

		if dados.has("configuracoes") and typeof(dados["configuracoes"]) == TYPE_DICTIONARY:
			var configuracao = dados["configuracoes"]
			eh_tela_cheia = configuracao.get("tela_cheia", configuracao.get("fullscreen", false))
			volume_master = float(configuracao.get("volume_master", 1.0))
			volume_musica = float(configuracao.get("volume_musica", 1.0))
			volume_sfx = float(configuracao.get("volume_sfx", 1.0))
			ai_slop_ativado = bool(configuracao.get("ai_slop", false))
	aplicar_configuracoes()

func resetar_progresso() -> void:
	missoes_desbloqueadas = [1]
	finais_descobertos = { 1: [], 2: [], 3: [], 4: [], 5: [], 6: [] }
	salvar_progresso()
