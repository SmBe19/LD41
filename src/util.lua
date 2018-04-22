--
-- Utility functions
--

local saved_r, saved_g, saved_b, saved_a

function love.graphics.saveColor()
    saved_r, saved_g, saved_b, saved_a = love.graphics.getColor()
end

function love.graphics.restoreColor()
    love.graphics.setColor({saved_r, saved_g, saved_b, saved_a})
end

function string:get(i)
    return self:sub(i,i)
end

function table.contains(t, el)
    for i = 1,#t do
        if t[i] == el then
            return true
        end
    end
    return false
end

function math.clamp(x, a, b)
    return math.max(a, math.min(b, x))
end