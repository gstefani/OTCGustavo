UI.Separator()
local lbT = UI.Label('Combo Spells');
lbT:setColor('orange');

local _combo = {
    spellCount = 6, -- quantidade de magias para monstros
    spellCountPlayers = 4 -- quantidade de magias para players
}

storage.uCombo = storage.uCombo or {}
storage.uComboPlayers = storage.uComboPlayers or {}

_combo.logic = function()
    local target = g_game.getAttackingCreature()
    if not target then return end

    -- Verifica se o alvo é um player
    if target:isPlayer() then
        -- Combo para players
        for index, spell in ipairs(storage.uComboPlayers) do
            if g_game.isAttacking() then say(spell) end
        end
    else
        -- Combo para monstros
        for index, spell in ipairs(storage.uCombo) do
            if g_game.isAttacking() then say(spell) end
        end
    end
end

_combo.macro = macro(100, "Combo", _combo.logic)

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
