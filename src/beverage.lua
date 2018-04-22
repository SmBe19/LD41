--
-- Beverages
--

local beverage = {
    progress = 0,
    lastshot = 0,
}

function beverage.new(name_, vol_, alc_)
    local b = {
        name = name_,
        alc = alc_,
        vol = vol_,
    }

    b.img = {
        love.graphics.newImage("assets/shot1.png"),
        love.graphics.newImage("assets/shot2.png"),
        love.graphics.newImage("assets/shot3.png"),
    }

    function b:newPromille(old)
        return (6000 * old + self.vol * self.alc) / (6000 + self.vol)
    end

    function b:update(dt)
        beverage.lastshot = math.max(0, beverage.lastshot - dt * 0.25)
    end

    function b:draw()
        if beverage.lastshot > 0 then
            love.graphics.draw(b.img[beverage.lastshot > 0.85 and 2 or 3], -40, 260 - beverage.lastshot * 200)
        else
            love.graphics.draw(b.img[1], -40, 100 - beverage.progress * 40)
        end
    end

    return b
end

return beverage
