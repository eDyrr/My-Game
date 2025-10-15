BUTTON_HEIGHT = 64
local function newButton(text, fn)
    return {
        text = text,
        fn = fn,

        now = false,
        last = false
    }
end

local buttons = {}
local font = nil

function love.load()
    anim8 = require 'libraries/anim8'
    font = love.graphics.newFont(32)
    table.insert(buttons, newButton(
        "Start Game",
        function()
            print("Starting Game")
        end))
    table.insert(buttons, newButton(
        "Load Game",
        function()
            print("Loading Game")
        end))

    table.insert(buttons, newButton(
        "Settings",
        function()
            print("going to the settings menu")
        end))

    table.insert(buttons, newButton(
        "Exit",
        function()
            love.event.quit(0)
        end))

    love.graphics.setDefaultFilter("nearest", "nearest")
    player = {}
    player.x = 0
    player.y = 0
    player.speed = 3
    player.spriteSheet = love.graphics.newImage('sprites/character.png')
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.down

end

function love.update(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        player.x = player.x + player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        player.y = player.y + player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        player.y = player.y - player.speed
        player.anim = player.animations.up
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(2)
    end
    
    player.anim:update(dt)
end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local buttonWidth = ww * (1/3)
    local margin = 16
    local total_height = (BUTTON_HEIGHT + margin) * #buttons
    local cursor_y = 0
    for i, button in ipairs(buttons) do
        button.last = button.now
        
        local bx = (ww * 0.5) - (buttonWidth * 0.5)
        local by = (wh * 0.5) - (total_height * 0.5) + cursor_y
        
        local color = {0.4, 0.4, 0.5, 1.0}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + buttonWidth and
                    my > by and my < by + BUTTON_HEIGHT

        if hot then
            color = {0.8, 0.8, 0.9, 1}
        end

        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            buttonWidth,
            BUTTON_HEIGHT)

        love.graphics.setColor(0, 0, 0, 1)

        local textWidth = font:getWidth(button.text)
        local textHeight = font:getHeight(button.text)

        love.graphics.print(
            button.text,
            font,
            (ww * 0.5) - textWidth * 0.5,
            by + textHeight * 0.5
        )

        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 10)
        
end