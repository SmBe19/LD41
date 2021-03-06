--
-- Play audio
--

local audio = {
    delayed = {},
    nomusic = false,
}

function audio.load()
    audio.srcgunshot = {}
    for i = 1,5 do
        audio.srcgunshot[i] = love.audio.newSource(string.format("assets/gunshot%d.wav", i), "static")
    end
    audio.srcklirr = {}
    for i = 1,5 do
        audio.srcklirr[i] = love.audio.newSource(string.format("assets/klirr%d.wav", i), "static")
    end
    audio.srcpouring = {}
    for i = 1,2 do
        audio.srcpouring[i] = love.audio.newSource(string.format("assets/pouring%d.wav", i), "static")
    end
    audio.srcslurp = {}
    for i = 1,4 do
        audio.srcslurp[i] = love.audio.newSource(string.format("assets/slurp%d.wav", i), "static")
    end
    audio.srcwoosh = {}
    for i = 1,7 do
        audio.srcwoosh[i] = love.audio.newSource(string.format("assets/woosh%d.wav", i), "static")
    end
    audio.srcreload = {}
    for i = 1,2 do
        audio.srcreload[i] = love.audio.newSource(string.format("assets/reload%d.wav", i), "static")
    end
    audio.srcouch = {}
    for i = 1,5 do
        audio.srcouch[i] = love.audio.newSource(string.format("assets/ouch%d.wav", i), "static")
    end
    audio.srcbackground = {}
    for i = 1,3 do
        audio.srcbackground[i] = love.audio.newSource(string.format("assets/music/background%d.mp3", i), "stream")
    end
    startBackground()
end

function startBackground()
    if audio.background and audio.background:isPlaying() then
        audio.background:stop()
    end
    audio.background = math.choice(audio.srcbackground)
    if not audio.nomusic then
        audio.background:play() -- TODO enable
    end
end

function audio.update(dt)
    for i = #audio.delayed,1,-1 do
        audio.delayed[i][2] = audio.delayed[i][2] - dt
        if audio.delayed[i][2] <= 0 then
            audio.playrandom(audio.delayed[i][1])
            table.remove(audio.delayed, i)
        end
    end
    if not audio.background:isPlaying() and not audio.nomusic then
        startBackground()
    end
end

function audio.delay(what, delay)
    audio.delayed[#audio.delayed+1] = {what, delay}
end

function audio.playrandom(what)
    what[love.math.random(#what)]:play()
end

function audio.toggleMusic()
    audio.nomusic = not audio.nomusic
    if audio.nomusic then
        audio.background:pause()
    else
        audio.background:play()
    end
end

return audio

