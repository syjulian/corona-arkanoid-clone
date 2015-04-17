local composer = require('composer')
local Arena = require('Arena')
local Panel = require('Panel')
local Ball = require('Ball')
local CountDown = require('CountDown')

local gameScene = composer.newScene()

gameScene.arena = Arena:new()
gameScene.panel = Panel:new()
gameScene.countDown = CountDown

function gameScene:newBlock(blockClass, x, y)
  local block = self.panel:drawBlock(blockClass, x, y)
  self.arena:addShape(block.shape)
end

function gameScene:swapRedBlue(event)
  
end

function gameScene:makeRed(event)
  self:newBlock(event.blockClass, event.x, event.y)
end

function gameScene:arenaTap(event)  
  if(self.panel.toggled ~= nil) then
    local blockClass = self.panel.toggled.BlockClass
    local block = self:newBlock(blockClass, event.x, event.y)
  end
end

function gameScene:startGame()
  gameScene.arena:startGame()
end

function gameScene:start(event)
  local countDownSec = 4
  gameScene.countDown:init(countDownSec, display.contentCenterX, 0)
  timer.performWithDelay(countDownSec * 1000, function() self:startGame() end, 1)
  gameScene.countDown:start()
  self.panel:teardown()
  self.arena.displayGroup:removeEventListener('tap', self.arena.displayGroup)
  self:removeEventListener('arenaTap', self)
end

function gameScene.arena.displayGroup:tap(event)
  local arenaTapEvent = {
    name = 'arenaTap',
    x = event.x,
    y = event.y
  }

  gameScene:dispatchEvent(arenaTapEvent)
end

function gameScene:win(event)
  local winText = display.newText(
    'You Win!',
    display.contentCenterX,
    0,
    native.systemFontBold,
    display.contentWidth / 5
  )
  self.arena:endGame()
end

function gameScene:create(event)
  local sceneGroup = self.view

  self.arena:init()
  self.panel:init()
  self.arena.displayGroup:addEventListener('tap', self.arena.displayGroup)
  self:addEventListener('arenaTap', self)

  sceneGroup:insert(self.arena.displayGroup)
  sceneGroup:insert(self.panel.panelGroup)
end

function gameScene:show(event)
  if(event.phase == 'will') then
    Runtime:addEventListener('start', gameScene)
    Runtime:addEventListener('win', gameScene)
    Runtime:addEventListener('makeRed', gameScene)
    Runtime:addEventListener('swapRedBlue', gameScene)
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
