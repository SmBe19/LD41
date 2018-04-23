--
-- Dude
--

local dude = {
    drinks = 0,
    maxdrinks = 20,
    drinkprogress = 0,
    promille = 0,
    reversing = 0,
    angry = 0,
    angrytext = "",
    frame = 0,
    offx = 0,
    offy = 0,
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
        if dude.angry > 15 then
        elseif dude.angry > 14 then
            dude.frame = 1
        elseif dude.angry > 6 then
            dude.frame = 8
            if dude.angry > 10 then
                dude.offx = -(1 - (dude.angry - 10)/4) * 200
            else
                dude.offx = -((dude.angry - 6)/4) * 200
            end
            dude.offy = (math.sin(dude.offx * 0.2) + 1) * 1
        else
            dude.frame = 1
            dude.offx = 0
            dude.offy = 0
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
            dude.angry = 16
            dude.angrytext = string.random(math.random(4, 8), string.toList("!?$@#*&%"))
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
    love.graphics.drawCrisp(dude.img[dude.frame], 0 + dude.offx, 0 + dude.offy)

    if 10 < dude.angry and dude.angry < 15 then
        love.graphics.pushColor()
        love.graphics.push()
        love.graphics.scale(0.5, 0.5)
        love.graphics.setFont(getFont(18))
        love.graphics.setColor({0.98, 0.42, 0.03, 1})
        love.graphics.printCenter(dude.angrytext, 255 + dude.offx*2, 50 + dude.offy*2)
        love.graphics.pop()
        love.graphics.popColor()
    end
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