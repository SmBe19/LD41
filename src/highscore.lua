--
-- Highscores
--

local utf8 = require("utf8")
local http = require("socket.http")
local httpurl = require("socket.url")

local highscore = {
    server = "http://ludumdare.games.smeanox.com/LD41/highserver",
    usernameallowed = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_ ",
    username = "Usernäme",
    defaultusernames = { "Alice", "Bob", "Carol", "Eve", "Mallory", "Oscar", "Trudy", "Trent" },
    highscore = {},
    score = 0,
    deduction = 0,
}

function highscore.done()
end

function highscore.load()
    highscore.logo = love.graphics.newImage("assets/logo.png")
end

function highscore.draw()
    love.graphics.pushColor()

    love.graphics.push()
    love.graphics.scale(2, 2)
    love.graphics.draw(menu.logo, 128, 10)
    love.graphics.pop()

    love.graphics.setFont(getFont(42))
    love.graphics.printCenter("Shot!           Shot!", 320, 40)

    love.graphics.setFont(getFont(28))
    love.graphics.setColor({1, 1, 1, 1})

    local top = 240
    local right = 340

    love.graphics.printCenter("Score for " .. highscore.username, 192, 190)
    love.graphics.rectangle("fill", 35, 235, 320, 2)

    love.graphics.printRight("drunkenness:", right - 100, top)
    love.graphics.printRight(tostring(highscore.score + highscore.deduction) .. "‰", right, top)

    if highscore.deduction > 0 then
        love.graphics.setColor({0.7, 0.12, 0.16, 1})
        love.graphics.printRight("kill:", right - 100, top + 40)
        love.graphics.printRight(tostring(-highscore.deduction) .. "‰", right, top + 40)
    else
        love.graphics.printRight("no kill:", right - 100, top + 40)
        love.graphics.printRight("0‰", right, top + 40)
    end

    love.graphics.setColor({1, 1, 1, 1})
    love.graphics.rectangle("fill", 35, top + 80 - 3, 320, 2)
    love.graphics.printRight("total:", right - 100, top + 85)
    love.graphics.printRight(tostring(math.max(0, highscore.score)) .. "‰", right, top + 85)

    love.graphics.setFont(getFont(16))
    top = 180
    right = 600
    for i, entry in ipairs(highscore.highscore) do
        local name = entry[1]
        if name == "#You" then
            love.graphics.setColor({0.7, 0.12, 0.16, 1})
            name = highscore.username
        else
            love.graphics.setColor({1, 1, 1, 1})
        end
        love.graphics.printRight(string.format("%s %4d‰", name, math.max(0, tonumber(entry[2]))), right, top + i * 20)
    end

    love.graphics.setFont(getFont(14))
    love.graphics.printRight("Edit your username, submit with enter.", 620, 450)

    love.graphics.popColor()
end

function highscore.textinput(t)
    if highscore.usernameallowed:contains(t) then
        highscore.username = highscore.username .. t
    end
end

function highscore.keypressed(char)
    if char == "backspace" then
        local byteoffset = utf8.offset(highscore.username, -1)
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            highscore.username = string.sub(highscore.username, 1, byteoffset - 1)
        end
    end
    if char == "return" then
        highscore.submit()
        highscore.done()
    end
    if char == "escape" then
        highscore.done()
    end
end

function highscore.submit()
    -- please don't submit fake scores, would be sad to take down the high score system
    local score = highscore.score
    local magic = score % 17 * highscore.username:len() + math.floor(score / 17)
    local niceusername = httpurl.escape(highscore.username)
    local body, code = http.request(highscore.server .. "/submit.php?username=" .. niceusername .. "&score=" .. math.floor(score) .. "&magic=" .. magic)
end

function highscore.retrieve()
    local score = highscore.score
    local body, code = http.request(highscore.server .. "/get.php?format=lua")
    local found = false
    highscore.highscore = {}
    if code == 200 then
        local idx = 1
        local nxt
        for line in body:gmatch("[^\n]+") do
            if idx % 2 == 1 then
                nxt = {line}
            else
                nxt[2] = line
                if not found and score >= tonumber(line) then
                    highscore.highscore[#highscore.highscore+1] = {"#You", score}
                    found = true
                end
                highscore.highscore[#highscore.highscore+1] = nxt
            end
            idx = idx + 1
        end
    else
        for idx, name in ipairs(highscore.defaultusernames) do
            if not found and score > 95 - idx * 9 then
                highscore.highscore[#highscore.highscore+1] = {"#You", score}
                found = true
            end
            highscore.highscore[#highscore.highscore+1] = {name, 95 - idx * 9}
        end
    end
    if not found then
        highscore.highscore[#highscore.highscore+1] = {"#You", score}
    end
    while #highscore.highscore > 10 do
        highscore.highscore[#highscore.highscore] = nil
    end
end

return highscore
