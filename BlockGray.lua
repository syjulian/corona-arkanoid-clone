local Block = require('Block')

local BlockGray = Block:new({
  color = 'gray',
  rgb = Color.lightGray
})

-- overwrite gray collision handler to not remove object on collision
function BlockGray:addCollisionHandler()
  self.shape:addEventListener('collision', function() end)
end

return BlockGray
