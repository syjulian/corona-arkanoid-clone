local Color = require('Color')

local CountDown = {
}

-- Displays a countdown
function CountDown:count()
  self.timeLimit = self.timeLimit-1
  self.timeLeft.text = self.timeLimit

  if(self.timeLimit == 0)then
    self.timeLeft.text = "GO!"
    -- flash text
    self.timeLeft:setTextColor(unpack(Color.green))
    timer.performWithDelay(
      200,function()
        self.timeLeft:setTextColor(unpack(Color.yellow))
        end
    )
    timer.performWithDelay(
      400,function()
        self.timeLeft:setTextColor(unpack(Color.red))
        end
    )
    timer.performWithDelay(
      600,function()
        self.timeLeft:setTextColor(unpack(Color.blue))
        end
    )
    timer.performWithDelay(
      800, 
      function() 
        self.timeLeft:removeSelf()
      end
    )
  end

  timer.performWithDelay(
    1000,
    function() self:count() end,
    timeLimit)
end

-- start countdown
function CountDown:start()
  self:count()
end

-- initialize countdown
function CountDown:init(timeLimit, xPos, yPos)
  local timeLeft = display.newText(
    timeLimit,
    xPos,
    yPos,
    native.systemFontBold,
    display.contentWidth / 3
  )
  timeLeft:setTextColor(unpack(Color.white))
  self.timeLeft = timeLeft
  self.timeLimit = timeLimit
end

return CountDown
