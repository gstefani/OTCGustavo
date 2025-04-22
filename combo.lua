UI.Separator()
local lbT = UI.Label('Combo Spells');
lbT:setColor('orange');

local _combo = {
    spellCount = 6, -- quantidade de magias para monstros
    spellCountPlayers = 4 -- quantidade de magias para players
}

storage.uCombo = storage.uCombo or {}
storage.uComboPlayers = storage.uComboPlayers or {}
storage.uComboEnabled = storage.uComboEnabled or false

-- Icone para ativar/desativar combo
local comboIcon = addIcon("comboToggle", {icon="option.png", text="Combo", hotkey="Ctrl+K"})
comboIcon:setOn(storage.uComboEnabled)
comboIcon.onClick = function(widget)
    storage.uComboEnabled = not storage.uComboEnabled
    comboIcon:setOn(storage.uComboEnabled)
    if storage.uComboEnabled then
        comboIcon:setTooltip("Macro do combo ATIVADO")
    else
        comboIcon:setTooltip("Macro do combo DESATIVADO")
    end
end

_combo.logic = function()
    if not storage.uComboEnabled then return end -- só executa se estiver ativado

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
