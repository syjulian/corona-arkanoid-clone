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
  counters = {}
}

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

function Panel:onToggleStartButton(event)
  toggle(event.target)

  startEvent = {
    name = "start"
  }
  Runtime:dispatchEvent(startEvent)
end

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

function Panel:handleBlockCollision(color, shape)
  shape:removeSelf()
  self.counters[color] = self.counters[color] - 1
  print(self.counters[color])

  if(self:noMoreBlocks()) then 
    local winEvent = {
      name = 'win'
    }
    Runtime:dispatchEvent(winEvent)
  end
end


function Panel:drawBlock(x, y)
  local block = self.toggled.BlockClass:new({xPos = x, yPos = y})
  block:init()
  self.counters[block.color] = self.counters[block.color] + 1
  print(self.counters[block.color])
  return block
end

local function drawButton(xPos, yPos, height, width, rgb)
  local button = display.newRect(xPos, yPos, height, width)
  button:setStrokeColor(unpack(Color.gray))
  button.strokeWidth = 10
  button:setFillColor(unpack(rgb))

  return button
end

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

function Panel:init()
  self:draw()
end

function Panel:teardown()
  self.panelGroup:removeSelf()
end

return Panel
