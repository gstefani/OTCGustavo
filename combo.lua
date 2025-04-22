UI.Separator()
local lbT = UI.Label('Combo Spells')
lbT:setColor('orange')

local _combo = {
    spellCount = 6, -- magias para monstros
    spellCountPlayers = 4 -- magias para players
}

storage.uCombo = storage.uCombo or {}
storage.uComboPlayers = storage.uComboPlayers or {}

_combo.logic = function()
    local target = g_game.getAttackingCreature()
    if not target then return end

    if target:isPlayer() then
        for index, spell in ipairs(storage.uComboPlayers) do
            if g_game.isAttacking() then say(spell) end
        end
    else
        for index, spell in ipairs(storage.uCombo) do
            if g_game.isAttacking() then say(spell) end
        end
    end
end

-- Macro principal já é ativado/desativado pelo ícone
comboMacro = macro(100, "Combo", _combo.logic)

-- Criação do ícone para controlar o macro
comboIcon = addIcon("comboToggle", {item = 26747, text = "Combo"}, comboMacro)
comboIcon:breakAnchors()

-- Inputs para combo de monstros
UI.Label("Spells para monstros:"):setColor('orange')
for i = 1, _combo.spellCount do
    addTextEdit("id_monstro"..i, storage.uCombo[i] or "", function(self, text)
        storage.uCombo[i] = text
    end)
end

-- Inputs para combo de players
UI.Label("Spells para players:"):setColor('red')
for i = 1, _combo.spellCountPlayers do
    addTextEdit("id_player"..i, storage.uComboPlayers[i] or "", function(self, text)
        storage.uComboPlayers[i] = text
    end)
end
