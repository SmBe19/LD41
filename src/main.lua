--
-- Main entry point for game
--

require("combat")
require("util")
require("font")
audio = require("audio")
cheats = require("cheats")
menu = require("menu")
highscore = require("highscore")
typing = require("typing")
crosshair = require("crosshair")
beverage = require("beverage")
weapon = require("weapon")
dude = require("dude")
progress = require("progress")

imgs = {}
consts = {}
vars = {}

function startGame()
    vars.promille = 0
    crosshair.drunk = 0
    weapon.drunk = 0
    typing.length = 4
    typing.newstring()
    vars.state = 2
    vars.weapon.rounds = vars.weapon.roundsfull
    vars.weapon.lastshot = 0
    vars.beverage.progress = 0
    vars.beverage.lastshot = 0
    love.mouse.setPosition(320, 240)
    dude.reset()

    love.mouse.setGrabbed(true)
    audio.delay(audio.srcpouring, 0.5)
end

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)
    love.window.setIcon(love.image.newImageData("assets/logo.png"))

    imgs.bg = love.graphics.newImage("assets/bg.png")
    imgs.bar = love.graphics.newImage("assets/bar.png")

    menu.load()
    highscore.load()
    audio.load()
    typing.load()
    crosshair.load()
    dude.load()

    consts = {
        sx = 2,
        sy = 2,
        width = love.graphics.getWidth(),
        height = love.graphics.getHeight(),
    }
    vars = {
        state = 1,
        xp = 0,
        promille = 0,
        beverage = beverage.new("Wodka", 10, 0.42),
        weapon = weapon.new("Revolver", 6, 1)
    }

    progress.load(dude, vars)
    cheats.load(crosshair, typing, vars.weapon)
end

function update_1(dt)
    menu.update(dt)
end

function update_2(dt)
    cheats.update(dt)
    typing.update(dt)
    crosshair.update(dt)
    vars.weapon:update(dt)
    vars.beverage:update(dt)
    dude.update(dt)
end

function update_3(dt)
    cheats.update(dt)
    typing.update(dt)
    crosshair.update(dt)
    vars.beverage:update(dt)
    dude.update(dt)
end

function update_4(dt)
end

function love.update(dt)
    local update = { update_1, update_2, update_3, update_4 }
    update[vars.state](dt)
    audio.update(dt)
end

function draw_1()
    love.graphics.scale(consts.sx, consts.sy)
    love.graphics.draw(imgs.bg, 0, 0)
    love.graphics.draw(imgs.bar, 0, 0)
    menu.draw(vars.xp)
end

function draw_2()
    love.graphics.scale(consts.sx, consts.sy)
    love.graphics.draw(imgs.bg, 0, 0)
    dude.draw()
    love.graphics.draw(imgs.bar, 0, 0)
    vars.beverage:draw()
    typing.draw()
    vars.weapon:draw(crosshair.x)
    crosshair.draw(vars.state)
    progress.draw()

    if vars.weapon.lastshot > 0.5 then
        love.graphics.pushColor()
        love.graphics.setColor({1, 1, 1, (vars.weapon.lastshot * 2 - 1) * 1})
        love.graphics.rectangle("fill", 0, 0, consts.width, consts.height)
        love.graphics.popColor()
    end
    cheats.draw()
end

function draw_3()
    love.graphics.scale(consts.sx, consts.sy)
    love.graphics.draw(imgs.bg, 0, 0)
    dude.draw()
    love.graphics.draw(imgs.bar, 0, 0)
    vars.weapon:drawReload()
    crosshair.draw(vars.state)
    progress.draw()
    cheats.draw()
end

function draw_4()
    highscore.draw()
end

function love.draw()
    local draw = { draw_1, draw_2, draw_3, draw_4 }
    draw[vars.state]()
end

function keypressed_1(key)
    menu.keypressed(key)
end

function keypressed_2(key)
    typing.keypressed(key)
    beverage.progress = typing.progress
    cheats.keypressed(key)
    if key == "space" and vars.weapon.rounds ~= vars.weapon.roundsfull then
        vars.state = 3
        typing.currentpos = 1
        vars.weapon:prepareReload()
    end
end

function keypressed_3(key)
    cheats.keypressed(key)
    if key == "space" then
        vars.state = 2
    end
end

function keypressed_4(key)
    highscore.keypressed(key)
end

function love.keypressed(key)
    local keypressed = { keypressed_1, keypressed_2, keypressed_3, keypressed_4 }
    keypressed[vars.state](key)
end

function love.textinput(t)
    if vars.state == 4 then
        highscore.textinput(t)
    end
end

function menu.done()
    startGame()
end

function typing.done()
    beverage.lastshot = 1
    typing.timeout = 4
    vars.promille = vars.beverage:newPromille(vars.promille)
    crosshair.drunk = math.log(99*vars.promille+1, 100)
    weapon.drunk = math.log(99*vars.promille+1, 100)
    typing.length = math.ceil(math.pow(vars.promille, 0.3)*42) + 1
    audio.delay(audio.srcslurp, 1)
    audio.delay(audio.srcpouring, 2.5)
    print(string.format("promille %f, drunk %f, length %d", vars.promille, crosshair.drunk, typing.length))
end

function crosshair.shoot()
    if vars.state == 2 then
        local success = vars.weapon:shot()
        if success then
            local success = dude.shoot(crosshair.x, crosshair.y)
            audio.playrandom(audio.srcgunshot)
            if not success then
                if 212 < crosshair.x and crosshair.x < 320 and 16 < crosshair.y and crosshair.y < 90 then
                    audio.delay(audio.srcwoosh, 0.15)
                end
            end
        end
    elseif vars.state == 3 then
        local success = vars.weapon:reload(crosshair.x, crosshair.y)
        if success then
            audio.playrandom(audio.srcreload)
        end
        if vars.weapon.rounds == vars.weapon.roundsfull then
            vars.state = 2
        end
    end
end

function dude.hitglass()
    audio.delay(audio.srcklirr, 0.1)
    audio.delay(audio.srcpouring, 12.8)
end

function dude.drink()
    audio.playrandom(audio.srcslurp)
    audio.delay(audio.srcpouring, 1.7 + dude.drinks * 0.08)
    dude.promille = vars.beverage:newPromille(dude.promille)
end

function dude.toodrunk()
    highscore.score = math.floor(vars.promille * 1000)
    highscore.deduction = 0
    dude.dying = true
end

function dude.dead()
    audio.delay(audio.srcouch, 0.5)
    highscore.score = math.floor(vars.promille * 1000)
    highscore.deduction = math.max(1, math.floor(highscore.score * 0.4))
    highscore.score = highscore.score - highscore.deduction
    dude.dying = true
end

function dude.finishedDying()
    vars.state = 4
    highscore.retrieve()
    love.mouse.setGrabbed(false)
end

function highscore.done()
    vars.state = 1
end
