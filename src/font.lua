--
-- fontsupport
--

local fontcache = {}

function getFont(size)
    if not fontcache[size] then
        fontcache[size] = love.graphics.newFont(size)
    end
    return fontcache[size]
end
