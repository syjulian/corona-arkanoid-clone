local composer = require('composer')
local Arena = require('Arena')
local Panel = require('Panel')
local Ball = require('Ball')
local CountDown = require('CountDown')

local gameScene = composer.newScene()

-- create game components
gameScene.arena = Arena:new()
gameScene.panel = Panel:new()
gameScene.countDown = CountDown

-- create new block
function gameScene:newBlock(blockClass, x, y)
  local block = self.panel:drawBlock(blockClass, x, y)
  self.arena:addShape(block.shape)
end

-- swap display objects
function gameScene:swapRedBlue(event)
  self.arena:swapRedBlueShapes(event.redBlockClass, event.blueBlockClass)
end

-- create a red block. used for hitting blue handler
function gameScene:makeRed(event)
  self:newBlock(event.blockClass, event.x, event.y)
end

-- handler for tapping the arena in editor mode
function gameScene:arenaTap(event)  
  if(self.panel.toggled ~= nil) then
    local blockClass = self.panel.toggled.BlockClass
    local block = self:newBlock(blockClass, event.x, event.y)
  end
end

-- start physics
function gameScene:startGame()
  gameScene.arena:startGame()
end

-- starts a countdown and removes the panel, editor mode
function gameScene:start(event)
  local countDownSec = 4
  gameScene.countDown:init(countDownSec, display.contentCenterX, 0)
  timer.performWithDelay(countDownSec * 1000, function() self:startGame() end, 1)
  gameScene.countDown:start()
  self.panel:teardown()
  self.arena.displayGroup:removeEventListener('tap', self.arena.displayGroup)
  self:removeEventListener('arenaTap', self)
end


-- dispatch tap event for tapping arena
function gameScene.arena.displayGroup:tap(event)
  local arenaTapEvent = {
    name = 'arenaTap',
    x = event.x,
    y = event.y
  }

  gameScene:dispatchEvent(arenaTapEvent)
end

-- handler when ball hist the bottom
function gameScene:bottomCollision()
  gameScene.arena:loseLife()
end

-- win, remove paddle, ball, and display game over
function gameScene:win(event)
  local winText = display.newText(
    'You Win!',
    display.contentCenterX,
    display.contentCenterY,
    native.systemFontBold,
    display.contentWidth / 5
  )
  self.arena:removePaddle()
  self.arena:removeBall()
  self.arena:gameOver()
end

-- initialize components
function gameScene:create(event)
  local sceneGroup = self.view

  self.arena:init()
  self.panel:init()
  self.arena.displayGroup:addEventListener('tap', self.arena.displayGroup)
  self:addEventListener('arenaTap', self)

  sceneGroup:insert(self.arena.displayGroup)
  sceneGroup:insert(self.panel.panelGroup)
end

-- add listeners
function gameScene:show(event)
  if(event.phase == 'will') then
    Runtime:addEventListener('start', gameScene)
    Runtime:addEventListener('win', gameScene)
    Runtime:addEventListener('makeRed', gameScene)
    Runtime:addEventListener('swapRedBlue', gameScene)
    Runtime:addEventListener('bottomCollision', gameScene)
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
