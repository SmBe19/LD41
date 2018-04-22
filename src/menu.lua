--
-- Menu
--

local menu = {
    active = 1
}

function menu.done()
end

function menu.update(dt)
end

function menu.draw(xp)
    love.graphics.pushColor()
    love.graphics.push()
    love.graphics.scale(0.5, 0.5)

    love.graphics.setFont(getFont(42))
    love.graphics.printCenter("Shot! Shot!", 320, 40)

    love.graphics.setFont(getFont(28))
    love.graphics.setColor({1, 0, 0, 1})
    love.graphics.printCenter("[ENTER] to start game!", 320, 170)

    love.graphics.setFont(getFont(14))
    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.printCenter("Benjamin Schmid", 320, 390)
    love.graphics.printCenter("Matteo Signer", 320, 415)

    love.graphics.setFont(getFont(10))
    love.graphics.printCenter("Music by Kevin MacLeod (incompetech.com)", 320, 450)

    love.graphics.pop()
    love.graphics.popColor()
end

function menu.keypressed(char)
    if char == "return" then
        menu.done()
    end
end

return menu
