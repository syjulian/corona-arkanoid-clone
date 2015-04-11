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

local function move(event)
  if event.phase == 'began' then
    event.target.markX = event.target.x
    event.target.markY = event.target.y
  elseif event.phase == 'moved' then
    local x = (event.x - event.xStart) + event.target.markX
    local y = (event.y - event.yStart) + event.target.markY
    event.target.x = x;
		event.target.y = y;
  end
end

function Block:init()
  self:draw()
  self.shape:addEventListener('touch', move)
end

function Block:draw()
  self.shape = display.newRect(self.xPos, self.yPos, self.length, self.width)
  self.shape:setFillColor(unpack(self.rgb))
end

return Block
