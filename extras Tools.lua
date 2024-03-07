setDefaultTab("Tools")

-- Hold target
local targetID = nil
-- escape when attacking will reset hold target
onKeyPress(function(keys)
    if keys == "Escape" and targetID then
        targetID = nil
    end
end)

local macroName = ".:: Use With Delay ::."
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

macro(100, ".:: Hold Target ::.", function()
    -- if attacking then save it as target, but check pos z in case of marking by mistake on other floor
    if target() and target():getPosition().z == posz() and not target():isNpc() then
        targetID = target():getId()
    elseif not target() then
        -- there is no saved data, do nothing
        if not targetID then return end

        -- look for target
        for i, spec in ipairs(getSpectators()) do
            local sameFloor = spec:getPosition().z == posz()
            local oldTarget = spec:getId() == targetID
            
            if sameFloor and oldTarget then
                attack(spec)
            end
        end
    end
end) 

-- Hotkeys parar Target e Cave
hotkey("Insert", ".:: Toggle Target ::.", function()
if TargetBot.isOff() then
TargetBot.setOn()
warn("TargetBot " .. (TargetBot.isOn() and 'On' or 'Off'))
return end
if TargetBot.isOn() then 
TargetBot.setOff()
warn("TargetBot " .. (TargetBot.isOn() and 'On' or 'Off'))
return end
end) 

hotkey("Pageup", ".:: ReturnCave ::.", function()
CaveBot.setOn()
warn("CaveBot ON")
end) 

hotkey("Pagedown", ".:: PauseCave ::.", function()
CaveBot.setOff()
warn("CaveBot OFF")
end)

-- Mystic defense e mystic kai
local castBelowHp = 70
macro(50, ".:: Mystic Defense ::.",  function()
  if (hppercent() <= castBelowHp and not hasManaShield()) then
    say('Mystic Defense')
  end
  if (hppercent() > castBelowHp and hasManaShield()) then
      say('Mystic Kai')
  end
end)

-- Swapar weapon de acordo com a distancia do alvo
macro(10, ".:: Dist/Melee ::.",function()
  if not g_game.isAttacking() then return end
  target = g_game.getAttackingCreature()
    if getDistanceBetween(player:getPosition(), target:getPosition()) > 1 then
        if (getLeft() and getLeft():getId() ~= 13484) or not getLeft() then
            moveToSlot(13484, SlotLeft)
        end
  else
        if (getLeft() and getLeft():getId() ~= 12622) or not getLeft() then
            moveToSlot(12622, SlotLeft)
        end
    end
end)

-- Turn Target Canudo
Turn = {}

Turn.maxDistance = {x = 7, y = 7}
Turn.minDistance = 1
Turn.macro = macro(1, '.:: Turn by Ryan ::.', function()
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

-- Abrir PMs em nova janela
local privateTabs = addSwitch("openPMTabs", ".:: PM Tabs ::.", function(widget) widget:setOn(not widget:isOn()) storage.OpenPrivateTabs = widget:isOn() end, parent)
privateTabs:setOn(storage.OpenPrivateTabs)

onTalk(function(name, level, mode, text, channelId, pos)
    if mode == 4 and privateTabs:isOn() then
        local g_console = modules.game_console
        local privateTab = g_console.getTab(name)
        if privateTab == nil then
            privateTab = g_console.addTab(name, true)
            g_console.addPrivateText(g_console.applyMessagePrefixies(name, level, text), g_console.SpeakTypesSettings['private'], name, false, name)
            playSound("/sounds/Private Message.ogg")
        end
        return
    end
end)

-- Bugmap pelo mouse
macro(1, ".:: Bug Map - Mouse ::.", function(m)
    --Made By VivoDibra#1182 
    local tile = getTileUnderCursor()
    if not tile then return end
    --if tile:getTopThing() == g_game.getLocalPlayer() then
        --return m.setOff()
    --end
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
macro(1, '.:: Bug Map - WASD ::.', "F1", function() 
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
