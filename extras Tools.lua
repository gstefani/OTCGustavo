setDefaultTab("Tools")

-- Combo pot exp
local macroName = "Use With Delay"
local items = {7439} -- always inside {}
local wait = 1 -- minutes
setDefaultTab("tools")

macro(2000,macroName,function()
  local time = 0
  for i=1,#items do
    local id = items[i]
    if findItem(id) then
      schedule(time,function()
        g_game.use(findItem(id))
      end)
      time = time + 250
    end
  end
  delay((wait*2*1000))
end)

-- Hotkeys parar Target e Cave
hotkey("Insert", "Toggle Target", function()
if TargetBot.isOff() then
TargetBot.setOn()
warn("TargetBot " .. (TargetBot.isOn() and 'On' or 'Off'))
return end
if TargetBot.isOn() then 
TargetBot.setOff()
warn("TargetBot " .. (TargetBot.isOn() and 'On' or 'Off'))
return end
end) 

hotkey("Pageup", "ReturnCave", function()
CaveBot.setOn()
warn("CaveBot ON")
end) 

hotkey("Pagedown", "PauseCave", function()
CaveBot.setOff()
warn("CaveBot OFF")
end)

-- Swapar weapon de acordo com a distancia do alvo
macro(10, "Dist/Melee",function()
  if not g_game.isAttacking() then return end
  target = g_game.getAttackingCreature()
    if getDistanceBetween(player:getPosition(), target:getPosition()) > 1 then
        if (getLeft() and getLeft():getId() ~= 13484) or not getLeft() then
            moveToSlot(13484, SlotLeft)
        end
  else
        if (getLeft() and getLeft():getId() ~= 21687) or not getLeft() then
            moveToSlot(21687, SlotLeft)
        end
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
