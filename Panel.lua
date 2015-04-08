Color = require('Color')

local Panel = {
  height = 200,
  width = display.contentWidth,
  xPos = display.contentWidth / 2,
  yPos = display.contentHeight + display.contentWidth / 8,
  btnInfo = {
    [0] = {btnType = 'red', color = Color.red},
    [1] = {btnType = 'blue', color = Color.blue},
    [2] = {bred = 'yellow', color = Color.yellow},
    [3] = {btnType = 'gray', color = Color.lightGray},
  },
  panelGroup = display.newGroup()
}

function Panel:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Panel:drawButtons()
  for i = 0, 3 do
    local button = display.newRect(
    i * self.width / 5,
    self.width / 5,
    self.width / 5 * 0.8,
    self.width / 5 * 0.8
    )
    button:setFillColor(unpack(self.btnInfo[i].color))
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
