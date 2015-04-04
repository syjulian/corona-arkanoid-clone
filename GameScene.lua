local composer = require('composer');
local gameScene = composer.newScene()

function gameScene:create(event)
end

function gameScene:show(event)
  if(event.phase == 'will') then
    --
  elseif(event.phase == 'did') then
   -- 
  end
end

function gameScene:hide(event)
  if(event.phase == 'will') then
    --
  elseif(event.phase == 'did') then
   -- 
  end
end

gameScene:addEventListener('create', scene)
gameScene:addEventListener('show', scene)
gameScene:addEventListener('hide', scene)

return gameScene
