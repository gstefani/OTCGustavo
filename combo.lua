UI.Separator()
setDefaultTab("News")
local lbT = UI.Label('Combo Spells')
lbT:setColor('orange')

local _combo = {
    spellCount = 6, -- magias para monstros
    spellCountPlayers = 4 -- magias para players
}

storage.uCombo = storage.uCombo or {}
storage.uComboPlayers = storage.uComboPlayers or {}

-- Variável de controle do macro (ativa/desativa)
storage.comboMacroActive = storage.comboMacroActive or false

-- Macro principal, roda só se o controle estiver ativo
comboMacro = macro(100, function()
  if not storage.comboMacroActive then return end
  local target = g_game.getAttackingCreature()
  if not target then return end
  if target:isPlayer() then
    for i, spell in ipairs(storage.uComboPlayers) do
      if spell ~= "" and g_game.isAttacking() then say(spell) end
    end
  else
    for i, spell in ipairs(storage.uCombo) do
      if spell ~= "" and g_game.isAttacking() then say(spell) end
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

-- Inputs para spells de players
UI.Label("Spells para players:"):setColor('red')
for i = 1, _combo.spellCountPlayers do
    addTextEdit("id_player"..i, storage.uComboPlayers[i] or "", function(self, text)
        storage.uComboPlayers[i] = text
    end)
end
