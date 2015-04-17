local Color = require('Color')

local CountDown = {
}

function CountDown:count()
  self.timeLimit = self.timeLimit-1
  self.timeLeft.text = self.timeLimit

  if(self.timeLimit == 0)then
    self.timeLeft.text = "GO!"                             
    timer.performWithDelay(
      500, 
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

function CountDown:start()
  self:count()
end

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
