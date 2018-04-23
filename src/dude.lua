--
-- Dude
--

local dude = {
    drinks = 0,
    maxdrinks = 20,
    drinkprogress = 0,
    dieprogress = 0,
    dying = false,
    promille = 0,
    reversing = 0,
    angry = 0,
    angrytext = "",
    frame = 0,
    offx = 0,
    offy = 0,
    glasspos = {
        { -1, -1 },   --  1
        { 93, 125 },  --  2
        { 107, 118 }, --  3
        { 113, 106 }, --  4
        { 120, 92 },  --  5
        { 124, 82 },  --  6
        { 126, 71 },  --  7
        { -1, -1 },   --  8
        { -1, -1 },   --  9
        { -1, -1 },   -- 10
        { -1, -1 },   -- 11
        { -1, -1 },   -- 12
        { -1, -1 },   -- 13
        { -1, -1 },   -- 14
        { -1, -1 },   -- 15
        { 93, 125 },  -- 16
        { 93, 125 },  -- 17
        { 93, 125 },  -- 18
        { 93, 125 },  -- 19
        { 93, 125 },  -- 20
    }
}

function dude.reset()
    dude.drinks = 0
    dude.drinkprogress = 0
    dude.reversing = 0
    dude.angry = 0
    dude.angrytext = ""
    dude.offx = 0
    dude.offy = 0
    dude.promille = 0
    dude.dieprogress = 0
    dude.dying = false
end

function dude.load()
    dude.imgdata = {}
    dude.img = {}
    for i = 0,19 do
        dude.imgdata[i+1] = love.image.newImageData(string.format("assets/dude%d.png", i))
        dude.img[i+1] = love.graphics.newImage(dude.imgdata[i+1])
    end
end

function dude.update(dt)
    if dude.dying then
        dude.dieprogress = dude.dieprogress + dt
        if dude.dieprogress < 0.6 then
        elseif dude.dieprogress < 4.2 then
            dude.frame = math.floor((dude.dieprogress - 0.6) / 3.6 * 6) + 9
        elseif dude.dieprogress < 5 then
            dude.frame = -1
        elseif dude.dieprogress < 6 then
            dude.frame = 15
        else
            dude.frame = -1
        end
        if dude.dieprogress > 7 then
            dude.finishedDying()
        end
    elseif dude.reversing > 0 then
        dude.reversing = math.max(0, dude.reversing - dt)
        dude.frame = math.max(2, math.ceil(dude.reversing * 6) + 1)
    elseif dude.angry > 0 then
        dude.angry = math.max(0, dude.angry - dt)
        if dude.angry > 11 then
        elseif dude.angry > 10 then
            dude.frame = 1
        elseif dude.angry > 2 then
            dude.frame = 8
            if dude.angry > 6 then
                dude.offx = -(1 - (dude.angry - 6)/4) * 200
            else
                dude.offx = -((dude.angry - 2)/4) * 200
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
        if dude.drinkprogress < 0.4 then
            dude.frame = math.floor((dude.drinkprogress/0.4) * 5) + 16
        else
            dude.frame = math.floor(((dude.drinkprogress - 0.4)/0.6) * 5) + 2
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
end

function dude.shoot(x, y)
    if dude.dying then
        return false
    end
    local xx = math.floor(x - dude.offx)
    if 2 <= dude.frame and dude.frame <= 7 or 16 <= dude.frame and dude.frame <= 20 then
        local dist = math.dist(xx, y, dude.glasspos[dude.frame][1], dude.glasspos[dude.frame][2])
        if dist < 10 then
            dude.angry = 12
            dude.angrytext = string.random(love.math.random(4, 8), string.toList("!?$@#*&%"))
            dude.drinkprogress = 0
            dude.hitglass()
            return true
        end
    end
    if 0 < xx and xx < dude.img[dude.frame]:getWidth() and 0 < y and y < dude.img[dude.frame]:getHeight() then
        local r, g, b, a = dude.imgdata[dude.frame]:getPixel(xx, y)
        if a > 0.1 then
            dude.angrytext = ""
            dude.dead()
            return true
        end
    end
    return false
end

function dude.draw()
    if dude.frame > 0 then
        love.graphics.drawCrisp(dude.img[dude.frame], 0 + dude.offx, 0 + dude.offy)
    end

    if 6 < dude.angry and dude.angry < 11 then
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

function dude.finishedDying()
end

return dude