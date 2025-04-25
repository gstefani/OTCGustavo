--[[Esconder MAGIAS(SPRITES)]]--
sprh = macro(100, "Esconde Sprite Magias", function() end)
onAddThing(function(tile, thing)
    if sprh.isOff() then return end
    if thing:isEffect() then
        thing:hide()
    end
end)