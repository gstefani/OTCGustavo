macro(30, "FollowMouseBugMap", function(m)
    --Made By VivoDibra#1182 
    local tile = getTileUnderCursor()
    if not tile then return end
    if tile:getTopThing() == g_game.getLocalPlayer() then
        --return m.setOff() 
    end
    if g_mouse.isPressed(7) then
    g_game.use(tile:getTopUseThing())
    end
end)
