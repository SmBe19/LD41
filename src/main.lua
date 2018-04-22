--
-- Main entry point for game
--

imgs = {}
consts = {}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    imgs.bar = love.graphics.newImage("assets/bar.png")

    consts.width = love.graphics.getWidth()
    consts.height = love.graphics.getHeight()
    consts.sx = 2
    consts.sy = 2
end

function love.update()
end

function love.draw()
    love.graphics.scale(consts.sx, consts.sy)
    love.graphics.draw(imgs.bar, 0, 0)
end
