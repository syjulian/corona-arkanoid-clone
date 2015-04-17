Color = require('Color')

local Paddle = {
  xPos = display.contentWidth / 2,
  yPos = display.contentHeight * 0.8,
  length = display.contentWidth / 4,
  width = 20
}

function Paddle:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Paddle:init(o)
  self:draw()
end

function Paddle:draw()
  self.shape = display.newRect(self.xPos, self.yPos, self.length, self.width)
  self.shape:setStrokeColor(unpack(Color.black))
  self.shape.strokeWidth = 5
  self.shape:setFillColor(unpack(Color.gray))
  
end

local function move (shape, event)
	 if event.phase == 'began' then		
		shape.markX = shape.x 
	 elseif event.phase == 'moved' then	 	
	 	local x = (event.x - event.xStart) + shape.markX	 	
	 	
	 	if (x <= 20 + shape.width/2) then
		   shape.x = 20+paddle.width/2;
		elseif (x >= display.contentWidth-20-shape.width/2) then
		   shape.x = display.contentWidth-20-shape.width/2
		else
		   shape.x = x
		end
				
	 end
end

function Paddle:activate()
  Runtime:addEventListener(
    'touch', function(event) move(self.shape, event) end)
end

function Paddle:deactivate()
  Runtime:addEventListener(
    'touch', function(event) move(self.shape, event) end)
end

return Paddle
