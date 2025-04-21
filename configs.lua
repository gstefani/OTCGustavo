--setDefaultTab("Others")
UI.Separator()

-- Mana treiner hunt
local config = {
    regen_mana_by_spell = false, -- se o teu regen de mana for por spell, deixe true, se n, false
    regen_mana_spell = '', -- spell p regenerar mana
    regen_mana_by_item = false, -- se o teu regen de mana for por item, deixe true, se n, false
    regen_mana_id_item = 11863, -- item p regenerar mana
    percent_train_ml = 90, -- porcentagem que irá intercalar entre regenerar e treinar, < regen > train
    spell_train = '', -- spell de treino
}

macro(100, "Mana Trainer Hunt", function()
    if manapercent() <= config.percent_train_ml then
        if config.regen_mana_by_item then
            useWith(config.regen_mana_id_item, player)
        elseif config.regen_mana_by_spell then
            say(config.regen_mana_spell)
        end
    else
        if not g_game.isAttacking() then
            say(config.spell_train)
        end
    end
end)

-- ICON Ligar e Desligar CaveBot/TargetBot
local cIcon = addIcon("cI",{text="Cave\nBot",switchable=false,moveable=true}, function()
  if CaveBot.isOff() then 
    CaveBot.setOn()
  else 
    CaveBot.setOff()
  end
end)
cIcon:setSize({height=30,width=50})
cIcon.text:setFont('verdana-11px-rounded')

local tIcon = addIcon("tI",{text="Target\nBot",switchable=false,moveable=true}, function()
  if TargetBot.isOff() then 
    TargetBot.setOn()
  else 
    TargetBot.setOff()
  end
end)
tIcon:setSize({height=30,width=50})
tIcon.text:setFont('verdana-11px-rounded')

macro(50,function()
  if CaveBot.isOn() then
    cIcon.text:setColoredText({"CaveBot\n","white","ON","green"})
  else
    cIcon.text:setColoredText({"CaveBot\n","white","OFF","red"})
  end
  if TargetBot.isOn() then
    tIcon.text:setColoredText({"Target\n","white","ON","green"})
  else
    tIcon.text:setColoredText({"Target\n","white","OFF","red"})
  end
end)

-- Abrir BP principal
macro(200, "Abrir Main BP", function()
    if not getContainers()[0] and getBack() then
        g_game.open(getBack())
    end
end)

-- Spy Level
local keyUp = "="
local keyDown = "-"
local lockedLevel = pos().z

onPlayerPositionChange(function(newPos, oldPos)
    lockedLevel = pos().z
    modules.game_interface.getMapPanel():unlockVisibleFloor()
end)

onKeyPress(function(keys)
    if keys == keyDown then
        lockedLevel = lockedLevel + 1
        modules.game_interface.getMapPanel():lockVisibleFloor(lockedLevel)
    elseif keys == keyUp then
        lockedLevel = lockedLevel - 1
        modules.game_interface.getMapPanel():lockVisibleFloor(lockedLevel)
    end
end)

-- Turn Target Canudo
Turn = {}

Turn.maxDistance = {x = 7, y = 7}
Turn.minDistance = 1
Turn.macro = macro(1, 'Turn by Ryan', function()
    local target = g_game.getAttackingCreature()
    if target then
        local targetPos = target:getPosition()
        if targetPos then
            local pos = pos()
            local targetDistance = {x = math.abs(pos.x - targetPos.x), y = math.abs(pos.y - targetPos.y)}
            if not (targetDistance.x > Turn.minDistance and targetDistance.y > Turn.minDistance) then
                if targetDistance.x <= Turn.maxDistance.x and targetDistance.y <= Turn.maxDistance.y then
                    local playerDir = player:getDirection()
                    if targetDistance.y >= targetDistance.x then
                        if targetPos.y > pos.y then
                            return playerDir ~= 2 and turn(2)
                        else
                            return playerDir ~= 0 and turn(0)
                        end
                    else
                        if targetPos.x > pos.x then
                            return playerDir ~= 1 and turn(1)
                        else
                            return playerDir ~= 3 and turn(3)
                        end
                    end
                end
            end
        end
    end
end)

-- Comprar Bless
if player:getBlessings() == 0 then
    say("!bless")
    schedule(2000, function()
        if player:getBlessings() == 0 then
            error("!! Blessings not bought !!")
        end
    end)
end

-- Bugmap pelo mouse
macro(20, "Bug Map - Mouse", function(m)
    --Made By VivoDibra#1182 
    local tile = getTileUnderCursor()
    if not tile then return end
	if g_mouse.isPressed(7) then
    g_game.use(tile:getTopUseThing())
	end
end)

-- Bugmap WASD
local function checkPos(x, y)
 xyz = g_game.getLocalPlayer():getPosition()
 xyz.x = xyz.x + x
 xyz.y = xyz.y + y
 tile = g_map.getTile(xyz)
 if tile then
  return g_game.use(tile:getTopUseThing())  
 else
  return false
 end
end

consoleModule = modules.game_console
macro(1, 'Bug Map - WASD', function() 
 if modules.corelib.g_keyboard.isKeyPressed('w') and not consoleModule:isChatEnabled() then
  checkPos(0, -5)
 elseif modules.corelib.g_keyboard.isKeyPressed('e') and not consoleModule:isChatEnabled() then
  checkPos(3, -3)
 elseif modules.corelib.g_keyboard.isKeyPressed('d') and not consoleModule:isChatEnabled() then
  checkPos(5, 0)
 elseif modules.corelib.g_keyboard.isKeyPressed('c') and not consoleModule:isChatEnabled() then
  checkPos(3, 3)
 elseif modules.corelib.g_keyboard.isKeyPressed('s') and not consoleModule:isChatEnabled() then
  checkPos(0, 5)
 elseif modules.corelib.g_keyboard.isKeyPressed('z') and not consoleModule:isChatEnabled() then
  checkPos(-3, 3)
 elseif modules.corelib.g_keyboard.isKeyPressed('a') and not consoleModule:isChatEnabled() then
  checkPos(-5, 0)
 elseif modules.corelib.g_keyboard.isKeyPressed('q') and not consoleModule:isChatEnabled() then
  checkPos(-3, -3)
 end
end)
