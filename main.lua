local menu = require("menu")
local game = require("game")
local love = require("love")
local pausemenu = require("pausemenu")

local scenes = {
    menu = menu,
    game = game,
    pausemenu = pausemenu
}

currentScene = scenes.menu

function love.load()
    camera = require 'libraries/camera'
    cam = camera()

    currentScene:load()
end

function love.update(dt)
    if currentScene and currentScene.update then
        currentScene:update(dt)
    end
end

function love.draw()
    cam:attach()
        if currentScene and currentScene.draw then
            currentScene:draw()
        end
    cam:detach()
end

function love.mousepressed(x, y, button)
    if currentScene and currentScene.mousepressed then
        currentScene:mousepressed(x, y, button)
    end
end

function love.keypressed(key)
    if currentScene and currentScene.keypressed then
        currentScene:keypressed(key)
    end
end

-- Add a function to change scenes properly
function changeScene(sceneName)
    if scenes[sceneName] then
        currentScene = scenes[sceneName]
        if currentScene.load then
            currentScene:load()
        end
    else
        print("Error: scene'" .. sceneName .. "'not found")
    end
end