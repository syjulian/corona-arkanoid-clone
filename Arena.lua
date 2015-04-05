local Arena = {
  height = display.contentHeight,
  width = display.contentWidth,
  thickness = 20,
  wallGroup = display.newGroup()
}

function Arena:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
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

  self.wallGroup:insert(top)
  self.wallGroup:insert(left)
  self.wallGroup:insert(right)
  self.wallGroup:insert(bottom)
end

function Arena:drawPaddle()
  local paddle = 
    display.newRect(
      self.width / 2, 
      self.height * 0.8, 
      self.width * 0.25, 
      self.thickness / 2
    )

  self.wallGroup:insert(paddle)
end

function Arena:draw()
  self:drawWalls()
  self:drawPaddle()
end

function Arena:init()
  self:draw()
end

return Arena
