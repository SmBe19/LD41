--
-- Main entry point for game
--

require("util")
cheats = require("cheats")
typing = require("typing")
crosshair = require("crosshair")
beverage = require("beverage")
weapon = require("weapon")

imgs = {}
consts = {}
vars = {}

function startGame()
    vars.promille = 0
    typing.length = 2
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)

    imgs.bar = love.graphics.newImage("assets/bar.png")

    typing.load()
    crosshair.load()
    cheats.load(crosshair, typing)

    consts = {
        sx = 2,
        sy = 2,
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    }
    vars = {
        xp = 0,
        promille = 0,
        beverage = beverage.new("Wodka", 10, 0.4),
        weapon = weapon.new("Revolver", 6, 2)
    }
end

function love.update(dt)
    cheats.update(dt)
    typing.update(dt)
    crosshair.update(dt)
    vars.weapon:update(dt)
end

function love.draw()
    love.graphics.scale(consts.sx, consts.sy)
    love.graphics.draw(imgs.bar, 0, 0)
    vars.beverage:draw()
    vars.weapon:draw(crosshair.x)
    typing.draw()
    crosshair.draw()

    if vars.weapon.lastshot > 0.5 then
        love.graphics.pushColor()
        love.graphics.setColor({1, 1, 1, (vars.weapon.lastshot * 2 - 1) * 1})
        love.graphics.rectangle("fill", 0, 0, consts.width, consts.height)
        love.graphics.popColor()
    end
    cheats.draw()
end

function love.keypressed(key)
    typing.keypressed(key)
    cheats.keypressed(key)
end


function typing.done()
    vars.promille = vars.beverage:newPromille(vars.promille)
    crosshair.drunk = math.pow(vars.promille, 0.3)
    weapon.drunk = math.pow(vars.promille, 0.3)
    typing.length = math.ceil(math.pow(vars.promille, 0.3)*42) + 1
    print(string.format("promille %f, drunk %f, length %d", vars.promille, crosshair.drunk, typing.length))
end

function crosshair.shoot()
    vars.weapon:shot()
end

startGame()