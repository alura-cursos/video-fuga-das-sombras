Constantes = {
	LARGURA_DA_TELA = 240,
    ALTURA_DA_TELA =138,
    PERSONAGEM = 'Personagem',
    INIMIGO = 'Inimigo',
    SPRITE_PERSONAGEM = 260,
    SPRITE_INIMIGO = 292,
}

function posicaoNoMapa(posicao)
    return posicao * 8 + 8
end


function criaPersonagem (coluna, linha) 
    local personagem={
        tipo= Constantes.PERSONAGEM,
        sprite=260,
        x=posicaoNoMapa(coluna),
        y=posicaoNoMapa(linha),
        quadroDeAnimacao=1,
        corDeFundo=6
    }
    function personagem.desenha()
        sprite(
            personagem.sprite,
            personagem.x,
            personagem.y,
            personagem.corDeFundo,
            1,
            0,
            0,
            2,
            2
        )	
    end
    function personagem.atualiza ()
        local animacaoDaPersonagem = {
            {256, 258},  -- item 1/ cima
            {260, 262}, -- item 2/ baixo
            {264, 266}, -- item 3/ esquerda
            {268, 270} -- item 4/ direita
        }

        local DirecaoDoPersonagem = {
            {deltaX = 0, deltaY = -1},
            {deltaX = 0, deltaY = 1},
            {deltaX = -1, deltaY = 0},
            {deltaX = 1, deltaY = 0}
        }

        if btn(0) then -- cima
            local tecla = 0
            local direcao = tecla + 1
            local quadros = animacaoDaPersonagem[direcao]
            local quadro = math.floor(personagem.quadroDeAnimacao)
            personagem.sprite=quadros[quadro]
            tentaMoverPara(personagem, DirecaoDoPersonagem[direcao], direcao)
        end

        if btn(1) then -- baixo
            local tecla = 1
            local direcao = tecla + 1
            local quadros = animacaoDaPersonagem[direcao]
            local quadro = math.floor(personagem.quadroDeAnimacao)
            personagem.sprite=quadros[quadro]
            tentaMoverPara(personagem, DirecaoDoPersonagem[direcao], direcao)
        end

        if btn (2) then -- esquerda
            local tecla = 2
            local direcao = tecla + 1
            local quadros = animacaoDaPersonagem[direcao]
            local quadro = math.floor(personagem.quadroDeAnimacao)
            personagem.sprite=quadros[quadro]
            tentaMoverPara(personagem, DirecaoDoPersonagem[direcao], direcao)
        end

        if btn (3) then -- direita
            local tecla = 3
            local direcao = tecla + 1
            local quadros = animacaoDaPersonagem[direcao]
            local quadro = math.floor(personagem.quadroDeAnimacao)
            personagem.sprite=quadros[quadro]
            tentaMoverPara(personagem, DirecaoDoPersonagem[direcao], direcao)
        end
    end

    return personagem
end



-- INIMIGO --
function criaInimigo(coluna, linha)      
    local colisoes = {}
    colisoes[Constantes.PERSONAGEM] = fazColisaoDoJogadorComOInimigo
    -- colisoes[Constantes.ESPADA] = fazColisaoDaEspadaComOInimigo
 
	local inimigo = {
        tipo = Constantes.INIMIGO,
        estado = Constantes.ESTADOS.PARADO,
		sprite = Constantes.SPRITE_INIMIGO,
		x = posicaoNoMapa(coluna),
        y = posicaoNoMapa(linha),
        visivel = true,
        corDeFundo = 14,
        quadroDeAnimacao = 1,
        colisoes = colisoes,
	}
 
	return inimigo
end


function fazColisaoDoJogadorComOInimigo(indice)
	inicializaVariaveisDoJogo()
    -- mudaParaTela(Tela.JOGO, 1)
	return true
end


-- ----------------------------------------------------------------------------------------------------------------------

----------------------------------------------
-- ######################################
-- # [ENGINE Caseira]
-- ######################################
----------------------------------------------
Constantes.DIRECAO = {
    CIMA = 1,
    BAIXO = 2,
    ESQUERDA = 3,
    DIREITA = 4
}

Constantes.ESTADOS = {
    PARADO = 'parado',
    PERSEGUINDO = 'perseguindo',
}
objetos = {}

------------------------------ 
-- ## [Mapa/Camera]
------------------------------
camera = {
    x = 0,
    y = 0,
}
function camera.atualiza()
    camera.x = (personagem.x // 240) * 240
    camera.y = (personagem.y // 136) * 136
end 

mapa = {
	x = 0,
	y = 0,	
}
function mapa.desenha()
    local blocoX = camera.x / 8
    local blocoY = camera.y / 8
    
    map(
		blocoX, --posicao x do mapa
		blocoY, --posicao y do mapa
		Constantes.LARGURA_DA_TELA, -- quanto desenhar em x
		Constantes.ALTURA_DA_TELA, -- quanto desenhar em y
		0, -- ???
        0) -- ???
end	



function temColisaoComMapa(ponto)
    blocoX = ponto.x / 8
    blocoY = ponto.y /8
    blocoId = mget(blocoX, blocoY)
    if blocoId >= 128 then
       return true
    else 
       return false
    end
 end

-- ==============================================
-- ==============================================

------------------------------ 
-- ## [Utilitarios de Sprites]
------------------------------

function sprite(numeroSprite, mapX, mapY, bg, escala, espelhar, rotacionar, blocosLargura, blocosAltura) 
    spr(
       numeroSprite,
       mapX - 8 - camera.x,
       mapY - 8 - camera.y, 
       bg, -- cor de fundo
       1, -- escala
       0, -- espelhar
       0, -- rotacionar
       blocosLargura, -- blocos para direita
       blocosAltura) -- blocos para baixo
end


function desenhaObjetos()
    for indice, objeto in pairs(objetos) do
        if objeto.visivel then
            sprite(
                objeto.sprite,
                objeto.x,
                objeto.y, 
                objeto.corDeFundo,
                1,
                0,
                0,
                2,
                2)
        end
    end
end
-- ==============================================
-- ==============================================

------------------------------ 
-- ## [Funcoes de colisão Genéricas]
------------------------------
function deixaPassar()
    return false
end

function tentaMoverPara(personagem, delta, direcao)
	local novaPosicao = {
        x = personagem.x + delta.deltaX,
        y = personagem.y + delta.deltaY
	}

	if verificaColisaoComObjetos(personagem, novaPosicao) then
		return
	end

	local superiorEsquerdo = {
		x = personagem.x - 8 + delta.deltaX,
		y = personagem.y - 8 + delta.deltaY
	}
	local superiorDireito = {
		x = personagem.x + 7 + delta.deltaX,
		y = personagem.y - 8 + delta.deltaY
	}
	local inferiorDireito = {
		x = personagem.x + 7 + delta.deltaX,
		y = personagem.y + 7 + delta.deltaY
	}
	local inferiorEsquerdo = {
		x = personagem.x - 8 + delta.deltaX,
		y = personagem.y + 7 + delta.deltaY
	}

	if not (temColisaoComMapa(inferiorDireito) or
		temColisaoComMapa(inferiorEsquerdo) or
		temColisaoComMapa(superiorDireito) or
		temColisaoComMapa(superiorEsquerdo)) then

        personagem.quadroDeAnimacao = personagem.quadroDeAnimacao + 0.1

		if personagem.quadroDeAnimacao >= 3 then
			personagem.quadroDeAnimacao = 1
		end

		personagem.y = personagem.y + delta.deltaY
		personagem.x = personagem.x + delta.deltaX
		personagem.direcao = direcao
	end
end

function temColisao(objetoA, objetoB)

    local direitaDeA = objetoA.x + 7
    local esquerdaDeA = objetoA.x - 8
    local baixoDeA = objetoA.y +7
    local cimaDeA = objetoA.y - 8

    local esquerdaDeB = objetoB.x - 8
    local direitaDeB = objetoB.x + 7
    local baixoDeB = objetoB.y + 7
    local cimaDeB = objetoB.y - 8


    if esquerdaDeB > direitaDeA or
        direitaDeB < esquerdaDeA or
        baixoDeA < cimaDeB or
        cimaDeA > baixoDeB then
        return false
    end

    return true
end


function distancia(inimigo, personagem) 
    local distanciaX = inimigo.x - personagem.x
    local distanciaY = inimigo.y - personagem.y
    local distancia = distanciaX * distanciaX + distanciaY * distanciaY

    return math.sqrt(distancia)
end

function verificaColisaoComObjetos(personagem, novaPosicao)
	for indice, objeto in pairs(objetos) do
  if temColisao(novaPosicao, objeto) then			
    local funcaoDeColisao = objeto.colisoes[personagem.tipo]
    if funcaoDeColisao then
        return funcaoDeColisao(indice)
    end 
    return deixaPassar()
		end
	end
	return false
end

function atualizaObjetos ()
    for indice, objeto in pairs(objetos) do
        if objeto.tipo == Constantes.INIMIGO then
            atualizaInimigo(objeto)
        end
    end
end

function atualizaInimigo(inimigo)
    local VISAO_DO_INIMIGO = 40
    if distancia(inimigo, personagem) < VISAO_DO_INIMIGO then
            inimigo.estado = Constantes.ESTADOS.PERSEGUINDO				
    else
            inimigo.estado = Constantes.ESTADOS.PARADO				
    end

    if inimigo.estado == Constantes.ESTADOS.PERSEGUINDO then
        local VELOCIDADE_INIMIGO = 0.5
        local delta = {
            deltaY = 0,
            deltaX = 0
        }
        if personagem.y > inimigo.y then
            delta.deltaY = VELOCIDADE_INIMIGO
            inimigo.direcao = Constantes.DIRECAO.BAIXO
        elseif personagem.y < inimigo.y then
            delta.deltaY = -VELOCIDADE_INIMIGO
            inimigo.direcao = Constantes.DIRECAO.CIMA
        end
        tentaMoverPara(inimigo, delta, inimigo.direcao)

        delta = {
            deltaY = 0,
            deltaX = 0
        }
        if personagem.x > inimigo.x then
            delta.deltaX = VELOCIDADE_INIMIGO
            inimigo.direcao = Constantes.DIRECAO.DIREITA
        elseif personagem.x < inimigo.x then
            delta.deltaX = -VELOCIDADE_INIMIGO
            inimigo.direcao = Constantes.DIRECAO.ESQUERDA
        end
        
        tentaMoverPara(inimigo, delta, inimigo.direcao)

        local AnimacaoInimigo = {
            {288,290},
            {292,294},
            {296,298},
            {300,302}
        }
        local quadros = AnimacaoInimigo[inimigo.direcao]
        local quadro = math.floor(inimigo.quadroDeAnimacao)
        inimigo.sprite = quadros[quadro]
    end
end

-- ==============================================
-- ==============================================

----------------------------------------------
-- ######################################
-- ######################################
----------------------------------------------

-- ----------------------------------------------------------------------------------------------------------------------


function inicializaVariaveisDoJogo ()
    objetos={}


    personagem = criaPersonagem(3,7)

    table.insert(objetos, criaInimigo(20, 4))
end

function TIC ()
    cls ()
    
    -- [atualiza]
    personagem.atualiza()
    atualizaObjetos()

    -- [desenha]
    mapa.desenha()
    desenhaObjetos()
    personagem.desenha()	
end

inicializaVariaveisDoJogo()