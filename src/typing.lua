--
-- Handle typing to drink
--

local typing = {}

local chars = {}
for i = 97,122 do table.insert(chars, string.char(i)) end

local vowels = {
    a = 8.167,
    e = 12.702,
    i = 6.966,
    o = 7.507,
    u = 2.758,
}
local consonants = {
    b = 1.492,
    c = 2.782,
    d = 4.253,
    f = 2.228,
    g = 2.015,
    h = 6.094,
    j = 0.153,
    k = 0.772,
    l = 4.025,
    m = 2.406,
    n = 6.749,
    p = 1.929,
    q = 0.095,
    r = 5.987,
    s = 6.327,
    t = 9.056,
    v = 0.978,
    w = 2.360,
    x = 0.150,
    y = 1.974,
    z = 0.074,
}

function string.random(length)
    if length > 0 then
        if length % 2 == 0 then
            return string.random(length - 1) .. math.sample(vowels)
        else
            return string.random(length - 1) .. math.sample(consonants)
        end
    else
        return ""
    end
end

function typing.done()
end

function typing.fail()
end

function typing.load()
    typing.newstring()
end

function typing.newstring()
    typing.text = string.random(typing.length)
    typing.currentpos = 1
end

function typing.update(dt)
end

function typing.keypressed(char)
    if char == typing.text:get(typing.currentpos) then
        typing.currentpos = typing.currentpos + 1
        if typing.currentpos > string.len(typing.text) then
            typing.done()
            typing.newstring()
        end
    elseif table.contains(chars, char) then
        typing.fail()
        typing.currentpos = 1
    end
end

function typing.draw()
    love.graphics.pushColor()
    love.graphics.push()
    love.graphics.scale(0.5, 0.5)
    love.graphics.setNewFont(28)
    local font = love.graphics.getFont()

    love.graphics.setColor({0.9, 0.9, 0.9, 0.5})
    love.graphics.rectangle("fill", 0, 440, 640, 40)
    love.graphics.setColor({0.2, 0, 0, 1})
    love.graphics.print(typing.text:sub(1, typing.currentpos-1), 10, 444)
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.print(typing.text:sub(typing.currentpos, typing.text:len()), 10 + font:getWidth(typing.text:sub(1, typing.currentpos-1)), 444)

    love.graphics.pop()
    love.graphics.popColor()
end

typing.length = 1
typing.text = typing.newstring()
typing.currentpos = 1

return typing