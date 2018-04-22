--
-- Dude
--

local dude = {
    drinks = 0,
    maxdrinks = 20,
    drinkprogress = 0,
}

function dude.load()
    dude.imgdata = love.image.newImageData("assets/dude.png")
    dude.img = love.graphics.newImage(dude.imgdata)
end

function dude.update(dt)
    local drunk = dude.drinks / dude.maxdrinks
    local drinkspeed = (1 - drunk * 0.7) * 0.2
    dude.drinkprogress = dude.drinkprogress + drinkspeed * dt
    if dude.drinkprogress >= 1 then
        dude.drinkprogress = 0
        dude.drinks = dude.drinks + 1
        print("dude drink", dude.drinks)
        if dude.drinks >= dude.maxdrinks then
            dude.toodrunk()
        end
    end
end

function dude.shoot(x, y)
    if 0 < x and x < dude.img:getWidth() and 0 < y and y < dude.img:getHeight() then
        local r, g, b, a = dude.imgdata:getPixel(x, y)
        if a > 0.1 then
            dude.dead()
        end
    end
end

function dude.draw()
    love.graphics.draw(dude.img, 0, 0)
end

function dude.toodrunk()
end

function dude.dead()
end

return dude