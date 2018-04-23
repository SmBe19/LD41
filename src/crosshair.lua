--
-- Handle aiming
--

local crosshair = {
    x = 160,
    y = 120,
    dx = 160,
    dy = 120,
    vx = 0,
    vy = 0,
    ax = 0,
    ay = 0,
    drunk = 0, -- in [0, 1)
}

function crosshair.load()
    crosshair.aimimg = love.graphics.newImage("assets/crosshair.png")
    crosshair.reloadimg = love.graphics.newImage("assets/round.png")
end

function crosshair.updatePosition(dt)
    local mx = love.mouse.getX() / 2
    local my = love.mouse.getY() / 2

    local dirx = mx - crosshair.dx
    local diry = my - crosshair.dy
    local dirl = math.sqrt(dirx * dirx + diry * diry)

    -- local alpha = 0.001 + (math.exp(crosshair.drunk * 10) - 1) / 10
    local alpha = 0.001 + math.pow(crosshair.drunk, 2.5) * 7
    -- local beta = (math.exp(crosshair.drunk) - 1) * 1000
    local beta = math.pow(crosshair.drunk, 0.7) * 1000
    local tt = math.max(0.1, 1 - math.exp(alpha * -dirl))

    crosshair.ax = dirx / (tt*tt) - crosshair.vx / tt + (math.random() - 0.5) * beta
    crosshair.ay = diry / (tt*tt) - crosshair.vy / tt + (math.random() - 0.5) * beta

    crosshair.vx = crosshair.vx + dt * crosshair.ax
    crosshair.vy = crosshair.vy + dt * crosshair.ay
    crosshair.dx = crosshair.dx + dt * crosshair.vx
    crosshair.dy = crosshair.dy + dt * crosshair.vy

    crosshair.dx = math.clamp(crosshair.dx, 0, 320)
    crosshair.dy = math.clamp(crosshair.dy, 0, 240)

    -- crosshair.x = (1 - crosshair.drunk) * mx + crosshair.drunk * crosshair.dx
    -- crosshair.y = (1 - crosshair.drunk) * my + crosshair.drunk * crosshair.dy
    crosshair.x = crosshair.dx
    crosshair.y = crosshair.dy
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

function crosshair.draw(state)
    local imgs = { nil, crosshair.aimimg, crosshair.reloadimg, nil }
    local img = imgs[state or 2]
    love.graphics.drawCrisp(img, crosshair.x - img:getWidth()/2, crosshair.y - img:getHeight()/2)
end

function crosshair.shoot()
end

return crosshair
