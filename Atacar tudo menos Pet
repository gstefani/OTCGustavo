-- Others tab
setDefaultTab("Cave")

local monstrosIgnorados = {
    '[sup] charmander', 
    '[sup] squirtle',
    '[sup] infernape',
    '[sup] bulbasaur',
    '[sup] pochita',
    '[sup] pikachu',
	'[sup] zoroark',
}

local distanciaMaxima = 6 -- Distância máxima para atacar os monstros
local distanciaPrioridade = 2 -- Distância de alta prioridade (monstros mais próximos)
local vidaMinimaPrioridade = 20 -- Vida mínima para priorizar um monstro (opcional)

-- Função para verificar se o nome do monstro está entre os ignorados
local function isMonsterIgnored(monstroName)
    for _, ignoredName in ipairs(monstrosIgnorados) do
        if string.find(monstroName, ignoredName, 1, true) then
            return true
        end
    end
    return false
end

-- Função para atualizar o alvo apenas se necessário e se estiver ao alcance
local function updateTargetIfNecessary(monstro)
    local currentTarget = g_game.getAttackingCreature()
    if currentTarget and currentTarget:getId() == monstro:getId() then
        -- Se o alvo atual é o monstro pretendido e pode atacar, não faz nada
        return true
    end
    if monstro:canShoot() then
        g_game.attack(monstro)
        return true
    end
    return false
end

macro(100, "Atacar de CaveBot", "F1", function()
    local posJogador = g_game.getLocalPlayer():getPosition()
    local monstros = g_map.getSpectators(posJogador, false)
    local monstrosValidos = {}

    -- Cria a lista de monstros válidos
    for _, monstro in ipairs(monstros) do
        local monstroName = monstro:getName():lower()
        -- Verifica se o monstro é válido para ataque
        if monstro:isMonster() 
           and not isMonsterIgnored(monstroName) 
           and getDistanceBetween(posJogador, monstro:getPosition()) <= distanciaMaxima
           and monstro:canShoot() then
            table.insert(monstrosValidos, monstro)
        end
    end

    -- Se não houver monstros válidos, religar o Cavebot e encerrar a função
    if #monstrosValidos == 0 then
        CaveBot.setOn()
        return
    end

    -- Ordena os monstros pela proximidade do jogador
    table.sort(monstrosValidos, function(a, b)
        return getDistanceBetween(posJogador, a:getPosition()) < getDistanceBetween(posJogador, b:getPosition())
    end)

    -- Tenta atacar o monstro prioritário ou mais próximo
    for _, monstro in ipairs(monstrosValidos) do
        local distanciaMonstro = getDistanceBetween(posJogador, monstro:getPosition())

        -- Se o monstro estiver dentro da distância de prioridade, verifica o target
        if distanciaMonstro <= distanciaPrioridade and not isInPz() then
            if updateTargetIfNecessary(monstro) then
                CaveBot.setOff() 
                return
            end
        end
    end

    -- Caso não tenha encontrado nenhum monstro dentro da distância de prioridade, verifica o mais próximo
    if not isInPz() and updateTargetIfNecessary(monstrosValidos[1]) then
        CaveBot.setOff() 
    end
end)


macro(100, "Atacar Tudo", "F2", function()
    local posJogador = g_game.getLocalPlayer():getPosition()
    local monstros = g_map.getSpectators(posJogador, false)
    local monstrosValidos = {}

    -- Cria a lista de monstros válidos
    for _, monstro in ipairs(monstros) do
        local monstroName = monstro:getName():lower()
        -- Verifica se o monstro é válido para ataque
        if monstro:isMonster() 
           and not isMonsterIgnored(monstroName) 
           and getDistanceBetween(posJogador, monstro:getPosition()) <= distanciaMaxima
           and monstro:canShoot() then
            table.insert(monstrosValidos, monstro)
        end
    end

    -- Se não houver monstros válidos, encerra a função
    if #monstrosValidos == 0 then
        return
    end

    -- Ordena os monstros pela proximidade do jogador
    table.sort(monstrosValidos, function(a, b)
        return getDistanceBetween(posJogador, a:getPosition()) < getDistanceBetween(posJogador, b:getPosition())
    end)

    -- Tenta atacar o monstro prioritário ou mais próximo
    for _, monstro in ipairs(monstrosValidos) do
        local distanciaMonstro = getDistanceBetween(posJogador, monstro:getPosition())

        -- Se o monstro estiver dentro da distância de prioridade, verifica o target
        if distanciaMonstro <= distanciaPrioridade and not isInPz() then
            if updateTargetIfNecessary(monstro) then
                return
            end
        end
    end

    -- Caso não tenha encontrado nenhum monstro dentro da distância de prioridade, verifica o mais próximo
    updateTargetIfNecessary(monstrosValidos[1])
end)
