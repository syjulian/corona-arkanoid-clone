local Color = require('Color')

local Ball = {
  radius = 20,
  xPos = display.contentCenterX - 100,
  yPos = display.contentCenterY + 100
}

function Ball:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

local function ballCollision (event)
  if(event.phase == 'began') then
    if(event.other.type == 'block') then
      blockCollisionEvent = {
        name = 'blockCollision',
        color = event.other.color,
        shape = event.other
      }
      Runtime:dispatchEvent(blockCollisionEvent)
    end
  end
end

function Ball:init(o)
  self:draw()
  self.shape:addEventListener('collision', ballCollision)
end

function Ball:draw()
  self.shape = display.newCircle(
    self.xPos,
    self.yPos,
    self.radius
  )
  self.shape:setStrokeColor(unpack(Color.black))
  self.shape.strokeWidth = 5
  self.shape:setFillColor(unpack(Color.green))
end

return Ball
