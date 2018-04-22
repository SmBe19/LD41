--
-- Utility functions
--

local saved = {}

function love.graphics.pushColor()
    local r, g, b, a = love.graphics.getColor()
    table.insert(saved, {r, g, b, a})
end

function love.graphics.popColor()
    love.graphics.setColor(table.remove(saved))
end

function string:get(i)
    return self:sub(i,i)
end

function string:contains(el)
    for i = 1,#self do
        if self:get(i) == el then
            return true
        end
    end
    return false
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

function math.sample(table)
    local sum = 0
    for k, v in pairs(table) do
        sum = sum + v
    end
    local value = math.random() * sum
    for k, v in pairs(table) do
        if value <= v then
            return k
        end
        value = value - v
    end
    return nil
end

function math.dist(x1, y1, x2, y2)
    return math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
end

function love.graphics.drawCrisp(img, x, y)
    local xx = math.floor(x)
    local yy = math.floor(y)
    love.graphics.draw(img, xx, yy)
end

function love.graphics.printCenter(text, x, y)
    local font = love.graphics.getFont()
    local width = font:getWidth(text)
    local xx = math.floor(x - width / 2)
    local yy = math.floor(y)
    love.graphics.print(text, xx, yy)
end

function love.graphics.printRight(text, x, y)
    local font = love.graphics.getFont()
    local width = font:getWidth(text)
    local xx = math.floor(x - width)
    local yy = math.floor(y)
    love.graphics.print(text, xx, yy)
end