local _combo = {
    spellCount = 6, -- quantidade de magias
}
storage.uCombo = storage.uCombo or {}

_combo.logic = function()
    for index, spell in ipairs(storage.uCombo) do
        if g_game.isAttacking() then say(spell) end
    end
end

_combo.macro = macro(100, "Combo", _combo.logic)

for i = 1, _combo.spellCount do
    addTextEdit("id"..i, storage.uCombo[i] or "", function(self, text)
        storage.uCombo[i]  = text
     end)
end
