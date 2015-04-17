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
      event.other:removeSelf()
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
end

return Ball

