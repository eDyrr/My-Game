local love = require("love")

function love.conf(app)
    app.window.width = 1600
    app.window.height = 900
    app.window.title = "My Game"
    app.window.display = 1
end