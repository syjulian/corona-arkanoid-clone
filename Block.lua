local Block = {
  length = 40,
  width = 20,
  xPos = 0,
  yPos = 0
}

local function move(event)
  if event.phase == "began" then
    event.target.markX = event.taget.x
    event.target.markY = event.target.y
  elseif even.phase == "moved" then
    local x = (event.x - event.xStart) + event.target.markX
    local y = (event.y - event.yStart) + event.target.markY
    event.target.x = x;
		event.target.y = y;
  end
end

function Block:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Block:init(o)
  self:draw()
  self.shape:addEventListener("touch", move)
end

function Block:draw()
  self.shape = display.newRect(self.xPos, self.yPos, self.length, self.width)
end

return Block
