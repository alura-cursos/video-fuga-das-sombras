
Constantes = {
	LARGURA_DA_TELA = 240,
	ALTURA_DA_TELA =138
}



personagem={
	sprite=260,
	x=3*8,
	y=3*8,
	corDeFundo=6
}

function personagem.atualiza ()
		if btn(0) then -- cima
		personagem.y=personagem.y-1
	end
	
	if btn(1) then -- baixo
		personagem.y=personagem.y+1
	end
	
	if btn (2) then -- esquerda
	 personagem.x=personagem.x-1
	end
	
		if btn (3) then -- direita
	 personagem.x=personagem.x+1
	end
	
end

mapa = {
	x=0,
	y=0
}
function mapa.desenha ()
	map (
		mapa.x,
		mapa.y,
		Constantes.LARGURA_DA_TELA,
		Constantes.ALTURA_DA_TELA,
		0,
		0
	)
end

function TIC ()
	cls ()
	
	mapa.desenha()
	personagem.atualiza()

		
	
 spr (
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