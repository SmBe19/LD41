--
-- Handle typing to drink
--

local typing = {}

local chars = {}
for i = 97,122 do table.insert(chars, string.char(i)) end

function string.random(length)
    if length > 0 then
        return string.random(length - 1) .. chars[math.random(1, #chars)]
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
    love.graphics.saveColor()
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
    love.graphics.restoreColor()
end

typing.length = 1
typing.text = typing.newstring()
typing.currentpos = 1

return typing