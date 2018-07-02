local layer = require("layer")
local transform = require("transform")

local tracks = {}
local on_track
local volume

local at_title = 1

planets = {}
voyager = {}
stars = {}

function love.load()
    local seed = tonumber(tostring(os.time()):reverse():sub(1,6))
    print("seed: "..seed)
    math.randomseed(seed)
    love.math.setRandomSeed(seed)

    local lvg = love.graphics
    lvg.setBackgroundColor(10/255, 10/255, 20/255)
    lvg.setDefaultFilter("nearest", "nearest", 1)

    local planet = {}
    table.insert(planets, planet)
    planet.layers = {}
    local t = Transform(640, 360, 0, 2)
    table.insert(planet.layers, Layer(lvg.newImage("assets/globe.png"), t))
    local t = t:clone()
    table.insert(planet.layers, Layer(lvg.newImage("assets/clouds.png"), t))

    voyager.layers = {}
    local t = t:clone()
    t.sx = -t.sx
    table.insert(voyager.layers, Layer(lvg.newImage("assets/voyager_0.png"), t))
    for i, L in pairs(voyager.layers) do
        L:shift{x=0, y=50}
    end

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local area = w * h
    local nfore = area / 3000
    local nback = area / 500
    for i=1,nfore do
        local star = {}
        table.insert(stars, star)
        star.layers = {}
        local x, y = math.random(0, w), math.random(0, h)
        local t = Transform(x, y)
        table.insert(star.layers, Layer(lvg.newImage("assets/glow.png"), t))
    end
    for i=1,nback do
        local star = {}
        table.insert(stars, star)
        star.layers = {}
        local x, y = math.random(0, w), math.random(0, h)
        local t = Transform(x, y, 0, 0.4)
        table.insert(star.layers, Layer(lvg.newImage("assets/glow.png"), t))
    end

    table.insert(tracks, love.audio.newSource("assets/No More Magic.ogg", 'stream'))
    table.insert(tracks, love.audio.newSource("assets/Winds Of Stories.ogg", 'stream'))
    table.insert(tracks, love.audio.newSource("assets/ObservingTheStar.ogg", 'stream'))
    on_track = math.random(#tracks)
    volume = 0
    tracks[on_track]:play()
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    if at_title == 1 then
        if volume < 1 then
            volume = volume + dt/10
            if volume > 1 then
                volume = 1
            end
            tracks[on_track]:setVolume(volume)
        end

        if not tracks[on_track]:isPlaying() then
            print("!!")
            on_track = (ontrack % #tracks) + 1
            tracks[on_track]:play()
            volume = 0.7
        end
    end

    for p, planet in pairs(planets) do
        for i, L in ipairs(planet.layers) do
            L:rotate(0.001/i)
        end
    end
    for i, L in ipairs(voyager.layers) do
        L:rotate(0.01)
    end

    for i, star in pairs(stars) do
        local t = star.layers[1].transform
        local r = love.math.noise(love.timer.getTime() + t.x + t.y)
        local min_b = 0.3
        local max_b = 1
        local bright = r * (max_b - min_b) + min_b
        star.layers[1].color = {bright,bright,bright,bright}
    end
end

function love.draw()
    local w = love.graphics:getWidth()
    local h = love.graphics:getHeight()

    if at_title > 0 then
        love.graphics.setColor{at_title,at_title,at_title}
        love.graphics.print("L.U.T. Voyage", w/2-160, 50, 0, 4)
    end

    love.graphics.setColor{0.5,0.5,0.5,0.7}
    love.graphics.print("ALPHA v0", w-60, h-20, -math.pi/4)

    for j, star in pairs(stars) do
        for i, L in ipairs(star.layers) do
            L:draw()
        end
    end

    for p, planet in pairs(planets) do
        for i, L in ipairs(planet.layers) do
            L:draw()
        end
    end

    for i, L in ipairs(voyager.layers) do
        L:draw()
    end
end

