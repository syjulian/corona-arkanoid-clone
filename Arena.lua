Color = require('Color')
Paddle = require('Paddle')
Ball = require('Ball')
physics = require('physics')
physics.start()
physics.setGravity(0, 0)

local Arena = {
  height = display.contentHeight - 50,
  width = display.contentWidth,
  thickness = 20,
  displayGroup = display.newGroup(),
  physics = physics,
  lives = 2,
  shapes = {}
}

function Arena:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Arena:drawBg()
  local bg =
    display.newRect(0,50,self.width, self.height)
  bg.anchorX = 0
  bg.anchorY = 0

  bg:setFillColor(unpack(Color.teal))
  self.bg = bg
  self.displayGroup:insert(bg)
end

function Arena:drawScoreboard()
  local livesText = display.newText(
    'Lives: ' .. self.lives, 
    self.width / 2, 0, 
    native.systemFontBold, 72)
  self.scoreboard = livesText
end

function Arena:updateScoreboard()
  self.scoreboard.text = 'Lives: ' .. self.lives
end

function Arena:removeScoreboard()
  self.scoreboard:removeSelf()
  self.scoreboard = nil
end

function Arena:swapRedBlueShapes(redBlockClass, blueBlockClass)  
  local len = #self.shapes
  for i = 1, len do
    local x = self.shapes[i].x
    local y = self.shapes[i].y
    if(self.shapes[i].color == 'red') then
      blueBlock = blueBlockClass:new({
          xPos = x,
          yPos = y
      })
      blueBlock:init()
      local shape = blueBlock.shape
      self.shapes[i]:removeSelf()
      self.shapes[i] = nil
      self.shapes[i] = shape
      Arena:addShape(self.shapes[i])
    elseif(self.shapes[i].color == 'blue') then
      redBlock = redBlockClass:new({
          xPos = x,
          yPos = y
      })
      redBlock:init()
      local shape = redBlock.shape
      self.shapes[i]:removeSelf()
      self.shapes[i] = nil
      self.shapes[i] = shape
      Arena:addShape(self.shapes[i])
    end
  end
end

function Arena:drawWalls()
  local top =
    display.newRect(0, 50,self.width, self.thickness)
  local left =
    display.newRect(0, 50,self.thickness, self.height)
  local right =
    display.newRect(self.width-self.thickness, 50,self.thickness,self.height)
  local bottom =
    display.newRect(0,self.height + 50, self.width, self.thickness)
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
  bottom:addEventListener(
    'collision', 
    function()
      event = {
        name = 'bottomCollision'
      }
      Runtime:dispatchEvent(event)
    end
  )
end

function Arena:addBlockShapePhysics(shape)
  self.physics.addBody(shape, 'dynamic', {density = 100.0})
end

function Arena:addShape(shape)
  timer.performWithDelay(100, function()
    self:addBlockShapePhysics(shape)
    shape.isFixedRotation = true
    self.shapes[#self.shapes + 1] = shape
  end)
end

function Arena:drawPaddle()
  paddle = Paddle:new()
  paddle:init()

  self.displayGroup:insert(paddle.shape)
  self.physics.addBody(paddle.shape, 'static')
  self.paddle = paddle
end

function Arena:removePaddle()
  self.paddle.shape:removeSelf()
  self.paddle = nil
end

function Arena:gameOver()
  self.scoreboard.text = "GAME OVER"
end

function Arena:wallHit()
  self.bg:setFillColor(unpack(Color.black))
  timer.performWithDelay(
    50,
    function()
      self.bg:setFillColor(unpack(Color.teal))
    end
  )
end

function Arena:loseLife()
  self:removeBall()
  self.lives = self.lives - 1
  self:wallHit()
  if(self.lives <= 0) then
    self:gameOver()
  else
    self:updateScoreboard()
    timer.performWithDelay(
      5000, 
      function()
        self:drawBall()
    end)
  end
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
  ball.shape:applyForce( 3, 3, ball.shape.x, ball.shape.y);
  self.ball = ball
end

function Arena:removeBall()
  self.ball.shape:removeSelf()
  self.ball = nil
end

function Arena:init()
  self:drawSetup()
end

function Arena:startGame()
  self.paddle:activate()
  self:drawBall()
  self:drawScoreboard()
end

return Arena
