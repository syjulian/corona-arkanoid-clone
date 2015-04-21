-- CS371 HW 5
-- Author: Julian Sy & Mark Bobo
-- Arkanoid Game with Editor

-- There is a gameScene that modularizes the game in a scene.
-- Within it is an arena and a panel object. The arena object handles
-- most of the physics an environment of the game. The panel is 
-- responsible for instantiating the blocks and buttons. Colored
-- blocks are subclasses of a block class. When buttons are clicked
-- or collisions occur, custom events are typically dispatched so
-- that specific components can stick to their roles. 

-- At the start of the game, there are five buttons at the bottom of
-- the screen. When the start button is clicked, a countdown starts
-- before the ball, paddle, and physics are created. Besides the gray 
-- block, when a block gets hit, it gets removed, as well as a handler.
-- When all the blocks are removed the paddle is removed and a game over
-- message is shown. When the ball hits the bottom floor, the player
-- loses a life. The game is over when all lives are lost

local composer = require('composer')
local block = require('Block')

composer.gotoScene('gameScene', {
  effect = 'fade',
  time = 1000
})
