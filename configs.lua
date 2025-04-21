--setDefaultTab("Others")
UI.Separator()

-- Parar CaveBot e TargetBot
local stopTarget = true; -- se estiver true vai parar, se não, não.
local stopCaveBot = true;-- se estiver true vai parar, se não, não.
local sameZ = false; -- se estiver false vai contar players de z diferente, se não, não.

macro(100, "Stop Cave/Target", function()
    local playerPos = player:getPosition();
    for _, spec in ipairs(getSpectators()) do
        if ((spec ~= player) and spec:isPlayer()) then
            local specPos = spec:getPosition();
            if (((playerPos.z == specPos.z) and sameZ) or (not sameZ)) then
                if stopTarget then
                    TargetBot.setOff();
                end
                if stopCaveBot then
                    CaveBot.setOff();
                end
                return;
            end
        end
    end
    TargetBot.setOn();
    CaveBot.setOn();
end);

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
