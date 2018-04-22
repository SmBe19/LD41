--
-- Dude
--

local dude = {
    drinks = 0,
    maxdrinks = 20,
    drinkprogress = 0,
    reversing = 0,
    angry = 0,
    frame = 0,
    offx = 0,
    glasspos = {
        { -1, -1 },
        { 93, 125 },
        { 107, 118 },
        { 113, 106 },
        { 120, 92 },
        { 124, 82 },
        { 126, 71 },
        { -1, -1 },
    }
}

function dude.load()
    dude.imgdata = {}
    dude.img = {}
    for i = 0,7 do
        dude.imgdata[i+1] = love.image.newImageData(string.format("assets/dude%d.png", i))
        dude.img[i+1] = love.graphics.newImage(dude.imgdata[i+1])
    end
end

function dude.update(dt)
    if dude.reversing > 0 then
        dude.reversing = math.max(0, dude.reversing - dt)
        dude.frame = math.ceil(dude.reversing * 5) + 2
    elseif dude.angry > 0 then
        dude.angry = math.max(0, dude.angry - dt)
        if dude.angry > 9 then
        elseif dude.angry > 8 then
            dude.frame = 1
        else
            dude.frame = 8
            if dude.angry > 4 then
                dude.offx = -(1 - (dude.angry - 4)/4) * 200
            else
                dude.offx = -(dude.angry/4) * 200
            end
        end
    else
        local drunk = dude.drinks / dude.maxdrinks
        local drinkspeed = (1 - drunk * 0.7) * 0.2
        dude.drinkprogress = dude.drinkprogress + drinkspeed * dt
        dude.frame = math.floor(dude.drinkprogress * 5) + 2
        if dude.drinkprogress >= 1 then
            dude.frame = 7
            dude.drinkprogress = 0
            dude.drinks = dude.drinks + 1
            dude.drink()
            dude.reversing = 1
            print("dude drink", dude.drinks)
            if dude.drinks >= dude.maxdrinks then
                dude.toodrunk()
            end
        end
    end
end

function dude.shoot(x, y)
    local xx = math.floor(x - dude.offx)
    if 2 <= dude.frame and dude.frame <= 7 then
        local dist = math.dist(xx, y, dude.glasspos[dude.frame][1], dude.glasspos[dude.frame][2])
        if dist < 12 then
            dude.angry = 10
            dude.drinkprogress = 0
            dude.hitglass()
            return true
        end
    end
    if 0 < xx and xx < dude.img[dude.frame]:getWidth() and 0 < y and y < dude.img[dude.frame]:getHeight() then
        local r, g, b, a = dude.imgdata[dude.frame]:getPixel(xx, y)
        if a > 0.1 then
            dude.dead()
            return true
        end
    end
    return false
end

function dude.draw()
    love.graphics.draw(dude.img[dude.frame], 0 + dude.offx, 0)
end

function dude.drink()
end

function dude.hitglass()
end

function dude.toodrunk()
end

function dude.dead()
end

return dude