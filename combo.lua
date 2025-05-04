UI.Separator()
setDefaultTab("News")
local lbT = UI.Label('Combo Spells')
lbT:setColor('orange')

local _combo = {
    spellCount = 3, -- magias para monstros
    spellCountPlayers = 3 -- magias para players
}

storage.uCombo = storage.uCombo or {}
storage.uComboPlayers = storage.uComboPlayers or {}
storage.areaSpellData = storage.areaSpellData or { spell = "", distance = 2 } -- Armazena a spell de área e distância

-- Variável de controle do macro (ativa/desativa)
storage.comboMacroActive = storage.comboMacroActive or false

-- Função para verificar se há players visíveis na tela
local function hasPlayersOnScreen()
    local spectators = g_map.getSpectators(pos(), false)
    for _, creature in ipairs(spectators) do
        if creature:isPlayer() and creature ~= g_game.getLocalPlayer() then
            return true
        end
    end
    return false
end

-- Função para calcular a distância entre duas posições
local function getDistance(p1, p2)
    return math.max(math.abs(p1.x - p2.x), math.abs(p1.y - p2.y))
end

-- Função para extrair a spell e a distância da entrada do usuário
local function parseAreaSpellInput(input)
    local spell = ""
    local distance = 2 -- valor padrão
    
    -- Separar a string pela vírgula
    local parts = string.split(input, ",")
    if #parts >= 1 then
        spell = parts[1]:trim() -- Remove espaços extras
        if #parts >= 2 then
            -- Tenta converter o segundo valor para número
            local distVal = tonumber(parts[2]:trim())
            if distVal and distVal > 0 then
                distance = distVal
            end
        end
    end
    
    return spell, distance
end

-- Adicionar a função split se não existir
if not string.split then
    function string.split(str, sep)
        local result = {}
        local pattern = string.format("([^%s]+)", sep)
        for segment in string.gmatch(str, pattern) do
            table.insert(result, segment)
        end
        return result
    end
end

-- Adicionar a função trim se não existir
if not string.trim then
    function string.trim(s)
        return s:match("^%s*(.-)%s*$")
    end
end

-- Macro principal, roda só se o controle estiver ativo
comboMacro = macro(100, function()
    if not storage.comboMacroActive then return end
    local target = g_game.getAttackingCreature()
    if not target then return end
    
    if target:isPlayer() then
        -- Combo para players
        for i, spell in ipairs(storage.uComboPlayers) do
            if spell ~= "" and g_game.isAttacking() then say(spell) end
        end
    else
        -- Combo para monstros
        for i, spell in ipairs(storage.uCombo) do
            if spell ~= "" and g_game.isAttacking() then say(spell) end
        end
        
        -- Verificar condições para usar a spell de área
        if storage.areaSpellData.spell ~= "" and g_game.isAttacking() then
            -- Não usar se houver players na tela
            if not hasPlayersOnScreen() then
                -- Verificar distância do monstro
                local playerPos = g_game.getLocalPlayer():getPosition()
                local targetPos = target:getPosition()
                local distance = getDistance(playerPos, targetPos)
                
                -- Usar spell de área se o monstro estiver dentro da distância configurada
                if distance <= storage.areaSpellData.distance then
                    say(storage.areaSpellData.spell)
                end
            end
        end
    end
end)
comboMacro:setOn(storage.comboMacroActive)

-- Ícone moveable e que mantém a posição após relogar
local comboIcon = addIcon("comboToggle", {text="Combo\nSpells", switchable=false, moveable=true}, function()
  storage.comboMacroActive = not storage.comboMacroActive
  comboMacro:setOn(storage.comboMacroActive)
end)

comboIcon:setSize({height=30, width=60})
comboIcon.text:setFont('verdana-11px-rounded')

-- Macro visual: muda a cor do texto ON/verde ou OFF/vermelho
macro(50, function()
  if storage.comboMacroActive then
    comboIcon.text:setColoredText({"Combo\nSpells\n","white","ON","green"})
  else
    comboIcon.text:setColoredText({"Combo\nSpells\n","white","OFF","red"})
  end
end)

-- Inputs para spells de monstros
UI.Label("Spells para monstros:"):setColor('orange')
for i = 1, _combo.spellCount do
    addTextEdit("id_monstro"..i, storage.uCombo[i] or "", function(self, text)
        storage.uCombo[i] = text
    end)
end

-- Input para spell de área com condições especiais
UI.Separator()
UI.Label("Spell de area (formato: 'spell,distancia'):"):setColor('yellow')
local areaSpellText = ""
if storage.areaSpellData.spell ~= "" then
    areaSpellText = storage.areaSpellData.spell .. "," .. tostring(storage.areaSpellData.distance)
end
addTextEdit("id_area_spell", areaSpellText, function(self, text)
    local spell, distance = parseAreaSpellInput(text)
    storage.areaSpellData = {
        spell = spell,
        distance = distance
    }
end)

-- Inputs para spells de players
UI.Separator()
UI.Label("Spells para players:"):setColor('red')
for i = 1, _combo.spellCountPlayers do
    addTextEdit("id_player"..i, storage.uComboPlayers[i] or "", function(self, text)
        storage.uComboPlayers[i] = text
    end)
end