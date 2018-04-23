--
-- Compatibility
--

major, minor, revision, codename = love.getVersion()

if major >= 11 then -- already new enough
    return
end

print("Apply Compatibility Fixes!")

-- Combat stuff for Löve 0.10.2

local orig = {
    setColor = love.graphics.setColor,
    getColor = love.graphics.getColor,
}

function love.graphics.setColor(r, g, b, a)
    if type(r) == "table" then
        a = r[4]
        b = r[3]
        g = r[2]
        r = r[1]
    end
    orig.setColor(r*255, g*255, b*255, a*255)
end

function love.graphics.getColor()
    local r, g, b, a = orig.getColor()
    return r/255, g/255, b/255, a/255
end
