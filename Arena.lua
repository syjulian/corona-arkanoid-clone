Color = require('Color')
Block = require('Block') 

local Arena = {
  height = display.contentHeight,
  width = display.contentWidth,
  thickness = 20,
  displayGroup = display.newGroup(),
  blocks = {}
}

function Arena:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Arena:drawBg()
  local bg =
    display.newRect(0,0,self.width, self.height)
  bg.anchorX = 0
  bg.anchorY = 0

  bg:setFillColor(unpack(Color.teal))
  self.displayGroup:insert(bg)
end

function Arena:drawWalls()
  local top =
    display.newRect(0, 0,self.width, self.thickness)
  local left =
    display.newRect(0,0,self.thickness, self.height)
  local right =
    display.newRect(self.width-self.thickness,0,self.thickness,self.height)
  local bottom =
    display.newRect(0,self.height, self.width, self.thickness)
  top.anchorX = 0
  top.anchorY = 0
  left.anchorX = 0
  left.anchorY = 0
  right.anchorX = 0
  right.anchorY = 0
  bottom.anchorX = 0
  bottom.anchorY = 0

  top:setFillColor(unpack(Color.gray))
  left:setFillColor(unpack(Color.gray))
  right:setFillColor(unpack(Color.gray))
  bottom:setFillColor(unpack(Color.gray))
  self.displayGroup:insert(top)
  self.displayGroup:insert(left)
  self.displayGroup:insert(right)
  self.displayGroup:insert(bottom)
end

function Arena:addBlock(x, y)
  self:drawBlock(x, y)
end

function Arena:drawPaddle()
  local paddle = 
    display.newRect(
      self.width / 2, 
      self.height * 0.8, 
      self.width / 4, 
      self.thickness
    )

  paddle:setFillColor(unpack(Color.gray))
  self.displayGroup:insert(paddle)
end

function Arena:draw()
  self:drawBg()
  self:drawWalls()
  self:drawPaddle()
end

function Arena:init()
  self:draw()
end

return Arena
