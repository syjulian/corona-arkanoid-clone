local composer = require('composer')
local gameScene = composer.newScene()
local Arena = require('Arena')
local Panel = require('Panel')
local Block = require('Block')
local Ball = require('Ball')

arena = Arena:new()
arena:init()

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

gameScene:addEventListener('create', gameScene)
gameScene:addEventListener('show', gameScene)
gameScene:addEventListener('hide', gameScene)

return gameScene