Color = require('Color')
Paddle = require('Paddle')
Ball = require('Ball')
physics = require('physics')
physics.start()
physics.setGravity(0, 0)

local Arena = {
  height = display.contentHeight,
  width = display.contentWidth,
  thickness = 20,
  displayGroup = display.newGroup(),
  physics = physics
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

  self.physics.addBody(top, 'static')
  self.physics.addBody(left, 'static')
  self.physics.addBody(right, 'static')
  self.physics.addBody(bottom, 'static')
end

function Arena:addShape(shape)
  self.physics.addBody(shape, { density = 100.0})
  shape.isFixedRotation = true
end

function Arena:drawPaddle()
  paddle = Paddle:new()
  paddle:init()

  self.displayGroup:insert(paddle.shape)
  self.physics.addBody(paddle.shape, 'static')
  self.paddle = paddle
end

function Arena:drawSetup()
  self:drawBg()
  self:drawWalls()
  self:drawPaddle()
end

function Arena:drawBall()
  ball = Ball:new()
  ball:init()

  self.displayGroup:insert(ball.shape)
  self.physics.addBody(
    ball.shape,
    'dynamic',
    {
      bounce = 1,
      radius = ball.radius
    }
  )
  ball.shape:applyForce( 1, 2, ball.x, ball.y);
  self.ball = ball
end

function Arena:init()
  self:drawSetup()
end

function Arena:startGame()
  self.paddle:activate()
  self:drawBall()
  self.ball.shape:applyForce(1,2,self.ball.shape.x,ball.shape.y);
end

return Arena
