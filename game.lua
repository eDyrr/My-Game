local game = {}
local love = require("love")

function game:load()
    love.mouse.setVisible(false)
    mouse = {}
    mouse.x, mouse.y = 0, 0
    anim8 = require 'libraries/anim8'

    love.graphics.setDefaultFilter("nearest", "nearest")

    player = {}
    player.x = 400
    player.y = 300
    player.speed = 120
    player.spriteSheet = love.graphics.newImage('sprites/character.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.down

    self.paused = false
    
    print("Game scene loaded successfully!")
end

function game:update(dt)

    if self.paused then
        return
    end

    mouse.x, mouse.y = love.mouse.getPosition()
    local isMoving = false

    if love.keyboard.isDown("right", "d") then
        player.x = player.x + player.speed * dt
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left", "a") then
        player.x = player.x - player.speed * dt
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("up", "w") then
        player.y = player.y - player.speed * dt
        player.anim = player.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("down", "s") then
        player.y = player.y + player.speed * dt
        player.anim = player.animations.down
        isMoving = true
    end

    if not isMoving then
        player.anim:gotoFrame(2)
    end

    player.anim:update(dt)
end

function game:draw()
    -- Draw the player
    player.anim:draw(player.spriteSheet, player.x, player.y, 0, 10)
    
    -- Add some debug text to verify we're in the game scene
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Game Scene - Use WASD to move", 10, 10)
    love.graphics.print("Player position: " .. math.floor(player.x) .. ", " .. math.floor(player.y), 10, 40)

    if self.paused then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("PAUSED - Press ESC to continue", love.graphics.getWidth()/2 - 150, love.graphics.getHeight()/2)
    end
end

function game:mousepressed(x, y, button) end

function game:keypressed(key)
    if key == "escape" then
        self.paused = not self.paused
        love.mouse.setVisible(self.paused)
        -- changeScene("pausemenu")
        return true
    end
    return false
end

return game