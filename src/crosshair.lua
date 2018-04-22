--
-- Handle aiming
--

local crosshair = {
    x = 160,
    y = 120,
    vx = 0,
    vy = 0,
    ax = 0,
    ay = 0,
    drunk = 0, -- in [0, 1)
}

function crosshair.load()
    crosshair.img = love.graphics.newImage("assets/crosshair.png")
end

function crosshair.updatePosition(dt)
    local mx = love.mouse.getX() / 2
    local my = love.mouse.getY() / 2

    local dirx = mx - crosshair.x
    local diry = my - crosshair.y
    local dirl = math.sqrt(dirx * dirx + diry * diry)

    local alpha = 0.01 + (math.exp(crosshair.drunk * 10) - 1)
    local beta = (math.exp(crosshair.drunk) - 1) * 1000
    local tt = math.max(0.1, 1 - math.exp(alpha * -dirl))

    crosshair.ax = dirx / (tt*tt) - crosshair.vx / tt + (math.random() - 0.5) * beta
    crosshair.ay = diry / (tt*tt) - crosshair.vy / tt + (math.random() - 0.5) * beta

    crosshair.vx = crosshair.vx + dt * crosshair.ax
    crosshair.vy = crosshair.vy + dt * crosshair.ay
    crosshair.x = crosshair.x + dt * crosshair.vx
    crosshair.y = crosshair.y + dt * crosshair.vy

    crosshair.x = math.clamp(crosshair.x, 0, 320)
    crosshair.y = math.clamp(crosshair.y, 0, 240)
end

local wasDown = { false, false, false }

function crosshair.update(dt)
    crosshair.updatePosition(dt)

    if love.mouse.isDown(1) and not wasDown[1] then
        crosshair.shoot()
    end

    for i = 1,3 do
        wasDown[i] = love.mouse.isDown(i)
    end
end

function crosshair.draw()
    love.graphics.drawCrisp(crosshair.img, crosshair.x - 7, crosshair.y - 7)
end

function crosshair.shoot()
end

return crosshair
