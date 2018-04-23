--
-- Progress bars
--
--[[
180, 32, 42 rot hell
115, 23, 45 rot dunkel
36, 82, 59 grün
250, 106, 10 orange
--]]

local progress = {}

local dude
local me

function progress.load(dude_, me_)
    dude = dude_
    me = me_
end

function progress.draw()
    local dp = dude.promille / 0.013
    local mp = 1 - math.exp(-me.promille / 0.015)
    local dw = dp * 160
    local mw = mp * 160
    love.graphics.pushColor()
    love.graphics.setColor({0.2, 0.2, 0.2, 0.5})
    love.graphics.rectangle("fill", 0, 0, 320, 9)
    love.graphics.setColor({0.51, 0.1, 0.2, 1})
    love.graphics.rectangle("fill", 160 - dw, 0, dw, 9)
    love.graphics.setColor({0.14, 0.32, 0.23, 1})
    love.graphics.rectangle("fill", 160, 0, mw, 9)
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.push()
    love.graphics.scale(0.5, 0.5)
    love.graphics.setFont(getFont(14))
    love.graphics.printRight(tostring(math.floor(dude.promille * 10000)/10) .. "‰", 300, 2)
    love.graphics.print(tostring(math.floor(me.promille * 10000)/10) .. "‰", 340, 2)
    love.graphics.pop()
    love.graphics.popColor()
end

return progress
