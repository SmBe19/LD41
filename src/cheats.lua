--
-- cheats
--

local cheats = {}

local crosshair
local typing

local drawCursor = false

function cheats.load(crosshair_, typing_)
    crosshair = crosshair_
    typing = typing_
end

function cheats.draw()
    if drawCursor then
        love.graphics.pushColor()
        love.graphics.circle("fill", love.mouse.getX()/2, love.mouse.getY()/2, 3)
        love.graphics.popColor()
    end
end

function cheats.update(dt)
end

function cheats.keypressed(char)
    if char == "1" then
        crosshair.drunk = math.min(1, crosshair.drunk + 0.1)
        print("drunk " .. crosshair.drunk)
    elseif char == "2" then
        crosshair.drunk = math.max(0, crosshair.drunk - 0.1)
        print("drunk " .. crosshair.drunk)
    elseif char == "9" then
        typing.done()
        typing.newstring()
    elseif char == "0" then
        drawCursor = not drawCursor
        print("cursor " .. tostring(drawCursor))
    end
end

return cheats