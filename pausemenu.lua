local pausemenu = {}
local love = require("love")
local BUTTON_HEIGHT = 64

local buttons = {}
local font = nil

local function newButton(text, fn)
    return {
        text = text,
        fn = fn,
        now = false,
        last = false
    }
end

function pausemenu:load()
    buttons = {}
    font = love.graphics.newFont(32)

    table.insert(buttons, newButton("Resume", function()
        changeScene("game")
    end))

    table.insert(buttons, newButton("Main menu", function()
        changeScene("menu")
    end))
end

function pausemenu:update(dt)
    for i, button in ipairs(buttons) do
        button.last = button.now
        button.now = false
    end
end

function pausemenu:draw()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    local buttonWidth = windowWidth * (1/3)
    local margin = 16
    local totalHeight = (BUTTON_HEIGHT + margin) * #buttons
    local cursor_y = 0

    for i, button in ipairs(buttons) do
        local bx = (windowWidth * 0.5) - (buttonWidth * 0.5)
        local by = (windowHeight * 0.5) - (totalHeight * 0.5) + cursor_y

        local color = {0.4, 0.4, 0.5, 1.0}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + buttonWidth and
                    my > by and by < by + BUTTON_HEIGHT

        if hot then
            color = {0.8, 0.8, 0.9, 1.0}
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", bx, by, buttonWidth, BUTTON_HEIGHT)

        love.graphics.setColor(0, 0, 0, 1)
        local textWidth = font:getWidth(button.text)
        local textHeight = font:getHeight(button.text)

        love.graphics.print(button.text, font, (windowWidth * 0.5) - textWidth * 0.5, by + textHeight * 0.5)
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
end

function pausemenu:mousepressed(x, y, button)
    if button == 1 then
        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()
        local buttonWidth = windowWidth * (1/3)
        local margin = 16
        local totalHeight = (BUTTON_HEIGHT + margin) * #buttons

        for i, buttons in ipairs(buttons) do
            local cursor_y = (BUTTON_HEIGHT + margin) * (i-1)
            local bx = (windowWidth * 0.5) - (buttonWidth * 0.5)
            local by = (windowHeight * 0.5) - (totalHeight * 0.5) + cursor_y

            if x > bx and x < bx + buttonWidth and y > by and y < by + BUTTON_HEIGHT then
                button.fn()
                break
            end
        end
    end
end