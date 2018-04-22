--
-- Handle aiming
--

local crosshair = {}

function crosshair.load()
    crosshair.img = love.graphics.newImage("assets/crosshair.png")
end

function crosshair.update(dt)
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

function crosshair.draw()
    local x = math.floor(crosshair.x - 7)
    local y = math.floor(crosshair.y - 7)
    love.graphics.draw(crosshair.img, x, y)
end

crosshair.x = 160
crosshair.y = 120
crosshair.vx = 0
crosshair.vy = 0
crosshair.ax = 0
crosshair.ay = 0
crosshair.drunk = 0 -- in [0, 1)

return crosshair
