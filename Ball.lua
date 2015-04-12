local Ball = {
  radius = 20,
  x = 0,
  y = 0
}

function Ball:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Ball:init(o)
  self:draw()
end

function Ball:draw()
  self.shape = display.newCircle(self.xPos, self.yPos, self.radius)
end

return Ball

