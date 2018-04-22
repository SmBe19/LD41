--
-- Weapons
--

local weapon = {
    lastshot = 0,
    drunk = 0, -- in [0, 1)
}

function weapon.new(name_, rounds_, rate_)
    local w = {
        name = name_,
        roundsfull = rounds_,
        rounds = rounds_,
        rate = rate_,
        lastshot = 0,
        timesinceshot = rate_,
        cx = 260,
        cy = 200,
        x = 260,
        y = 195,
        vx = 0,
        vy = 0,
    }

    w.img = {}
    for i = 1,7 do
        w.img[i] = love.graphics.newImage(string.format("assets/gun%d.png", i))
    end

    function w:update(dt)
        if self.lastshot > 0.9 then
            self.vy = -0.8 * 50
        elseif self.lastshot > 0 then
            self.vy = 0.1 * 50
        else
            self.vy = 0
        end

        self.x = self.x + dt * self.vx
        self.y = self.y + dt * self.vy

        self.x = math.clamp(self.x, self.cx - 30, self.cx + 30)
        self.y = math.clamp(self.y, self.cy - 10, self.cy + 10)

        self.lastshot = math.max(0, self.lastshot - dt)
        self.timesinceshot = self.timesinceshot + dt
    end

    function w:draw(cx)
        local addx = (cx - 180) / 180 * 10
        local offx = self.x - 157 + addx
        local offy = self.y - 188
        if math.abs(cx - self.x) < 60 then
            offy = offy + (cx - self.x + 60) / 7
            offx = offx + (cx - self.x + 60) / 5
        end
        local img = 2
        local middle = self.lastshot > 0.3 and self.lastshot <= 0.7
        local rounds = self.lastshot > 0.7 and self.rounds + 1 or self.rounds
        if rounds < 3 then
            img = 8 - rounds * 2
        end
        if middle then
            img = img - 1
        end
        if rounds == 0 then
            img = middle and 7 or 6
        end
        love.graphics.drawCrisp(self.img[img], offx, offy)
    end

    function w:shot()
        if self.timesinceshot > self.rate and self.rounds > 0 then
            self.lastshot = 1
            self.timesinceshot = 0
            self.rounds = self.rounds - 1
        end
    end

    return w
end

return weapon