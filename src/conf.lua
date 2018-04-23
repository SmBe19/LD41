function love.conf(t)
    t.window.title = "Shot! Shot!"
    t.window.width = 640
    t.window.height = 480

    local major, minor, revision, codename = love.getVersion()

    if major >= 11 then
        t.version = "11.1"
    elseif major == 0 and minor == 10 then
        t.version = "0.10.2"
    else
        t.version = "11.1"
    end
end