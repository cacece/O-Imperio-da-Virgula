extends Control

@onready var label_post_it: Label = $VBoxContainer/LabelPostIt
@onready var campo_decreto: LineEdit = $VBoxContainer/CampoDecreto
@onready var botao_enviar: Button = $VBoxContainer/BotaoEnviar
@onready var texto_jornal: RichTextLabel = $VBoxContainer/TextoJornal

const TEXTO_BASE: String = "Perdão impossível, executar o rebelde."

# Esqueleto puro de letras da frase original (sem espaços nem pontuação)
var esqueleto_original: String = ""

# Histórico para reverter caso tente apagar mais de 1 letra
var texto_valido: String = ""
var caret_valido: int = 0

var finais_missao_1: Dictionary = {
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

func _ready() -> void:
	esqueleto_original = extrair_letras_puras(TEXTO_BASE)
	
	label_post_it.text = "Pista: O pavio precisa continuar aceso hoje à noite."
	campo_decreto.text = TEXTO_BASE
	texto_valido = TEXTO_BASE
	caret_valido = TEXTO_BASE.length()
	
	botao_enviar.text = "Publicar Decreto"
	texto_jornal.text = "[color=gray]Regra: Pontuações livres. Apenas 1 letra pode ser apagada por vez para troca de acento.[/color]"
	texto_jornal.bbcode_enabled = true
	
	botao_enviar.pressed.connect(_on_botao_enviar_pressed)
	campo_decreto.text_changed.connect(_on_campo_decreto_text_changed)

# Transforma qualquer letra com acento na letra base e descarta pontuações/espaços
func extrair_letras_puras(texto: String) -> String:
	var mapa_acentos = {
		"ã": "a", "á": "a", "à": "a", "â": "a",
		"é": "e", "ê": "e",
		"í": "i",
		"õ": "o", "ó": "o", "ô": "o",
		"ú": "u",
		"ç": "c"
	}
	var res = texto.to_lower()
	for acentuada in mapa_acentos:
		res = res.replace(acentuada, mapa_acentos[acentuada])
	
	var regex = RegEx.new()
	regex.compile("[^a-z]") # Mantém estritamente letras de 'a' a 'z'
	return regex.sub(res, "", true)

# Checa se 'menor' é subsequência exata de 'maior' com exatamente 1 caractere a menos
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
	
	# CASO 1: Todas as letras estão presentes e na ordem correta
	if letras_digitadas == esqueleto_original:
		return true
	
	# CASO 2: Exatamente UMA letra foi apagada para ser trocada/recolocada
	if eh_subsequencia_com_uma_letra_a_menos(letras_digitadas, esqueleto_original):
		return true
		
	# Qualquer outra coisa (apagar 2 letras, letras a mais ou letras fora de ordem) é proibida
	return false

func _on_campo_decreto_text_changed(novo_texto: String) -> void:
	if validar_modificacao(novo_texto):
		texto_valido = novo_texto
		caret_valido = campo_decreto.caret_column
	else:
		# Trava e reverte na hora
		var pos = caret_valido
		campo_decreto.text = texto_valido
		campo_decreto.caret_column = clampi(pos, 0, texto_valido.length())

func _on_botao_enviar_pressed() -> void:
	var texto_digitado: String = campo_decreto.text.strip_edges()
	var letras_digitadas = extrair_letras_puras(texto_digitado)
	
	# Não permite publicar se houver letra faltando
	if letras_digitadas != esqueleto_original:
		texto_jornal.text = "[color=red]Recoloque a letra que você apagou antes de publicar o decreto![/color]"
		return

	validar_decreto(texto_digitado)

func validar_decreto(texto: String) -> void:
	if finais_missao_1.has(texto):
		var desfecho: Dictionary = finais_missao_1[texto]
		texto_jornal.text = "[b]" + desfecho["titulo"] + "[/b]\n\n" + desfecho["noticia"]
		
		if desfecho["tipo"] == "sucesso":
			texto_jornal.text += "\n\n[color=green]★ [Objetivo Concluído] Sucesso da Resistência![/color]"
	else:
		texto_jornal.text = "[color=yellow]Essa modificação ainda não possui final.[/color]"
