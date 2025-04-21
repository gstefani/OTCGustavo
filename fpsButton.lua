UI.Separator()
local lbT = UI.Label('Reduzir FPS');
lbT:setColor('orange');

UI.Button("10 fps", function()
 modules.client_options.setOption("backgroundFrameRate", 10)
end)
UI.Button("150 fps", function()
 modules.client_options.setOption("backgroundFrameRate", 150)
end)
