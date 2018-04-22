--
-- Main entry point for game
--

imgs = {}
consts = {}
vars = {}

require("util")
typing = require("typing")
crosshair = require("crosshair")

function typing.done()
    typing.length = typing.length + 1
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    imgs.bar = love.graphics.newImage("assets/bar.png")

    consts.width = love.graphics.getWidth()
    consts.height = love.graphics.getHeight()
    consts.sx = 2
    consts.sy = 2

    typing.load()
    crosshair.load()
end

function love.update(dt)
    typing.update(dt)
    crosshair.update(dt)
end

function love.draw()
    love.graphics.scale(consts.sx, consts.sy)
    love.graphics.draw(imgs.bar, 0, 0)
    typing.draw()
    crosshair.draw()
end

function love.keypressed(key)
    typing.keypressed(key)
    if key == "1" then
        crosshair.drunk = math.min(1, crosshair.drunk + 0.1)
        print(crosshair.drunk)
    elseif key == "2" then
        crosshair.drunk = math.max(0, crosshair.drunk - 0.1)
        print(crosshair.drunk)
    end
end
