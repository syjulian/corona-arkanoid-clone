local Color = require('Color')
local Block = {
  length = 100,
  width = 50,
  xPos = 0,
  yPos = 0,
  color = 'white',
  rgb = Color.white
}

function Block:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

-- handler for moving block
local function move(event)
  if event.phase == 'began' then
    event.target.markX = event.target.x
    event.target.markY = event.target.y
  elseif event.phase == 'moved' then
    if (event.target.markX ~= nil) then
      local x = (event.x - event.xStart) + event.target.markX
      event.target.x = x;
    end
    if (event.target.markY ~= nil) then
      local y = (event.y - event.yStart) + event.target.markY
      event.target.y = y;
    end
  end
end

-- adds the collision handler for the physics
function Block:addCollisionHandler()
  self.shape:addEventListener(
    'collision', 
    function(event)
      if(event.phase == 'began') then
        if(event.other.type == 'ball') then
          colorCollisionEvent = {
            name = self.color .. 'Collision',
            shape = self.shape
          }
          Runtime:dispatchEvent(colorCollisionEvent)
          self.shape:removeSelf()
          self.shape.color = nil
        end
      end
  end)
end

-- initialize block
function Block:init()
  self:draw()
  self:addCollisionHandler()
  self.shape:addEventListener('touch', move)
end

-- draw display object
function Block:draw()
  self.shape = display.newRect(self.xPos, self.yPos, self.length, self.width)
  self.shape:setFillColor(unpack(self.rgb))
  self.shape.type = 'block'
  self.shape.color = self.color
  self.shape:setStrokeColor(unpack(Color.black))
  self.shape.strokeWidth = 5
end

return Block
