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
  panelGroup = display.newGroup()
}

local buttons = {
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

function Panel:onToggleButton(event)
  if (self.toggled == event.target) then
    untoggle(event.target)
    self.toggled = nil
  else
    untoggle(self.toggled)
    toggle(event.target)
    self.toggled = event.target
  end
end

function Panel:drawBlock(x, y)
  local block = self.toggled.BlockClass:new({xPos = x, yPos = y})
  block:init()
  return block
end

function Panel:drawButtons()
  for i = 0, 3 do
    local button = display.newRect(
      i * self.width / 5,
      self.width / 5,
      self.width / 5 * 0.8,
      self.width / 5 * 0.8
    )

    button:setStrokeColor(unpack(Color.gray))
    button.strokeWidth = 10
    button:setFillColor(unpack(buttons[i].rgb))
    button.color = buttons[i].color
    button.BlockClass = buttons[i].BlockClass
    button:addEventListener('tap', function(event) self:onToggleButton(event) end)
    self.panelGroup:insert(button)
  end
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

return Panel
