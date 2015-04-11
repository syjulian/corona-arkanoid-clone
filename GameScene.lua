local composer = require('composer')
local Arena = require('Arena')
local Panel = require('Panel')
local Ball = require('Ball')

local gameScene = composer.newScene()

gameScene.arena = Arena:new()
gameScene.panel = Panel:new()

function gameScene:onBgTouch(event)
  if(self.panel.toggled ~= nil) then
    local block = self.panel:drawBlock(event.x,event.y)
    
    self.arena:addBlock(block)
  end
end

function gameScene:create(event)
  self.arena:init()
  self.panel:init()
end

function gameScene:show(event)
  if(event.phase == 'will') then
    self.arena.displayGroup:addEventListener(
      'tap', function(event) self:onBgTouch(event) end
    )
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
