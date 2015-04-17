local Block = require('Block')

local BlockGray = Block:new({
  color = 'gray',
  rgb = Color.lightGray
})

function BlockGray:addCollisionHandler()
  self.shape:addEventListener('collision', function() end)
end

return BlockGray
