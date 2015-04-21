Color = require('Color')
BlockRed = require('BlockRed')
BlockBlue = require('BlockBlue')
BlockYellow = require('BlockYellow')
BlockGray = require('BlockGray')

local Panel = {
  height = 200,
  width = display.contentWidth,
  xPos = display.contentWidth / 2,
  yPos = display.contentHeight + display.contentWidth / 8,
  toggled = nil,
  panelGroup = display.newGroup(),
  counters = {},
  blocks = {}
}

-- table of different button metadata
local blockButtons = {
    [0] = {color = 'red', rgb = Color.red, BlockClass = BlockRed},
    [1] = {color = 'blue', rgb = Color.blue, BlockClass = BlockBlue},
    [2] = {color = 'yellow', rgb = Color.yellow, BlockClass = BlockYellow},
    [3] = {color = 'gray', rgb = Color.lightGray, BlockClass = BlockGray},
}

function Panel:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- toggle to change outline 
local function toggle(button)
  if(button ~= nil) then
    button:setStrokeColor(unpack(Color.green))
  end
end

local function untoggle(button)
  if(button ~= nil) then
    button:setStrokeColor(unpack(Color.gray))
  end
end

-- toggle of untoggled and vice versa
function Panel:onToggleBlockButton(event)
  if (self.toggled == event.target) then
    untoggle(event.target)
    self.toggled = nil
  else
    untoggle(self.toggled)
    toggle(event.target)
    self.toggled = event.target
  end
end

-- handler for tapping start button
function Panel:onToggleStartButton(event)
  toggle(event.target)

  startEvent = {
    name = "start"
  }
  Runtime:dispatchEvent(startEvent)
end

-- check if all blocks are gone
function Panel:noMoreBlocks()
  local blocksLeft = 0
  local len = #blockButtons
  for i = 0, len do
    color = blockButtons[i].color
    if(color ~= 'gray') then
      blocksLeft = blocksLeft + self.counters[color]
    end
  end

  return blocksLeft <= 0
end

-- draw block
function Panel:drawBlock(blockClass, x, y)
  local block = blockClass:new({xPos = x, yPos = y})
  block:init()
  self.counters[block.color] = self.counters[block.color] + 1
  return block
end

-- draw simple button
local function drawButton(xPos, yPos, height, width, rgb)
  local button = display.newRect(xPos, yPos, height, width)
  button:setStrokeColor(unpack(Color.gray))
  button.strokeWidth = 10
  button:setFillColor(unpack(rgb))

  return button
end

-- draw button for blocks
function Panel:drawBlockButtons(blockButtons, height, width)
  local len = #blockButtons
  for i = 0, len do
    local button = drawButton(
      i * self.width / 5,
      self.width / 5,
      height,
      width,
      blockButtons[i].rgb
    )
    button.BlockClass = blockButtons[i].BlockClass
    button:addEventListener('tap', function(event) self:onToggleBlockButton(event) end)
    self.counters[blockButtons[i].color] = 0
    self.panelGroup:insert(button)

  end
end

-- draw button to start game 
function Panel:drawStartButton(offset, width, height)
  local startButton = drawButton(
    offset * self.width / 5,
    self.width / 5,
    height,
    width,
    Color.black
  )
  startButton:addEventListener('tap', function(event) self:onToggleStartButton(event) end)
  self.panelGroup:insert(startButton)
end

-- draw all buttons
function Panel:drawButtons()
  local height = self.width / 5 * 0.8
  local width = self.width / 5 * 0.8
  local startOffset = #blockButtons + 1

  self:drawBlockButtons(blockButtons, width, height)
  self:drawStartButton(startOffset, width, height)
end

function Panel:draw()
  self.panelGroup.anchorChildren = true
  self.panelGroup.x = self.xPos
  self.panelGroup.y = self.yPos

  self:drawButtons()
end

-- collision handler for yellow 
function Panel:yellowCollision(event)
  self.counters[event.shape.color] = self.counters[event.shape.color] - 1
  if(self:noMoreBlocks()) then 
    local winEvent = {
      name = 'win'
    }
    Runtime:dispatchEvent(winEvent)
  end

  local swapRedBlueEvent = {
    name = 'swapRedBlue',
    shape = event.shape,
    redBlockClass = blockButtons[0].BlockClass,
    blueBlockClass = blockButtons[1].BlockClass
  }
  Runtime:dispatchEvent(swapRedBlueEvent)
end

-- collision handler for blue
function Panel:blueCollision(event)
  self.counters[event.shape.color] = self.counters[event.shape.color] - 1
  makeRedEvent = {
    name = 'makeRed',
    x = event.shape.x,
    y = event.shape.y,
    blockClass = blockButtons[0].BlockClass
  }
  Runtime:dispatchEvent(makeRedEvent)
end

-- collision handler for red
function Panel:redCollision(event)
  self.counters[event.shape.color] = self.counters[event.shape.color] - 1
  if(self:noMoreBlocks()) then
    local winEvent = {
      name = 'win'
    }
    Runtime:dispatchEvent(winEvent)
  end
end

function Panel:addBlockListeners()
  Runtime:addEventListener('yellowCollision', self)
  Runtime:addEventListener('blueCollision', self)
  Runtime:addEventListener('redCollision', self)
end

function Panel:init()
  self:draw()
  self:addBlockListeners()
end

-- remove panel from display
function Panel:teardown()
  self.panelGroup:removeSelf()
end

return Panel
