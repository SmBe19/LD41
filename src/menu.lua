--
-- Menu
--

local menu = {
    active = 1,
    coverimg = false,
}

function menu.done()
end

function menu.load()
    menu.logo = love.graphics.newImage("assets/logo.png")
end

function menu.update(dt)
end

function menu.draw(xp)
    love.graphics.pushColor()

    love.graphics.draw(menu.logo, 78, 10)

    love.graphics.push()
    love.graphics.scale(0.5, 0.5)

    love.graphics.setFont(getFont(42))
    love.graphics.printCenter("Shot!           Shot!", 220, 40)

    if not menu.coverimg then
        love.graphics.setFont(getFont(28))
        love.graphics.setColor({0.7, 0.12, 0.16, 1})
        love.graphics.printCenter("[space] to START!", 320, 200)

        love.graphics.setFont(getFont(14))
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.printCenter("Benjamin Schmid", 320, 390)
        love.graphics.printCenter("Matteo Signer", 320, 415)

        love.graphics.setFont(getFont(10))
        love.graphics.printCenter("Music by Kevin MacLeod (incompetech.com)", 320, 450)
        love.graphics.printCenter("[tab] to mute music", 320, 464)
    end

    if menu.coverimg then
        love.graphics.setFont(getFont(28))
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.printCenter("Benjamin Schmid", 220, 180)
        love.graphics.printCenter("Matteo Signer", 220, 220)
    end

    love.graphics.pop()
    love.graphics.popColor()
end

function menu.keypressed(char)
    if char == "return" or char == "space" then
        menu.done()
    elseif char == "escape" then
        love.event.quit()
    end
end

return menu
