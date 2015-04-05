local Panel = {
  height = 200,
  width = display.contentWidth,
  xPos = display.contentWidth / 2,
  yPos = display.contentHeight + display.contentWidth / 8,
  buttons = {
    [0] = {btnType = "red"},
    [1] = {btnType = "blue"},
    [2] = {bred = "yellow"},
    [3] = {btnType = "gray"},
    [4] = {btnType = "start"}
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
  for i = 0, 4 do
    local button = display.newRect(
    i * self.width / 5,
    self.width / 5,
    self.width / 5 * 0.8,
    self.width / 5 * 0.8
    )
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
