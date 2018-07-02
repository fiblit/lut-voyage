local layer = require("layer")
local transform = require("transform")
local anim = require("anim")

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
    local w = lvg.getWidth()
    local h = lvg.getHeight()
    local area = w * h

    local planet = {}
    table.insert(planets, planet)
    planet.layers = {}
    local t = Transform(w/2, h/2, 0, 2)
    table.insert(planet.layers, Layer(lvg.newImage("assets/env/globe.png"), t))
    local t = t:clone()
    table.insert(planet.layers, Layer(lvg.newImage("assets/env/clouds.png"), t))

    voyager.layers = {}
    local t = t:clone()
    t.sx = -t.sx
    table.insert(voyager.layers, Layer(lvg.newImage("assets/voyager/hull_0.png"), t))
    local t = t:clone()
    table.insert(voyager.layers, Layer(lvg.newImage("assets/voyager/decal_0.png"), t))
    local t = t:clone()
    table.insert(voyager.layers, Layer(lvg.newImage("assets/voyager/cockpit_0.png"), t))
    local t = t:clone()
    local a = Anim(0.42, {
        lvg.newImage("assets/voyager/heat_0.png"),
        lvg.newImage("assets/voyager/heat_1.png"),
        lvg.newImage("assets/voyager/heat_2.png"),
        lvg.newImage("assets/voyager/heat_3.png"),
        lvg.newImage("assets/voyager/heat_4.png"),
        lvg.newImage("assets/voyager/heat_5.png"),
        lvg.newImage("assets/voyager/heat_6.png"),
        lvg.newImage("assets/voyager/heat_7.png"),
        lvg.newImage("assets/voyager/heat_8.png"),
        lvg.newImage("assets/voyager/heat_9.png"),
        lvg.newImage("assets/voyager/heat_10.png"),
        lvg.newImage("assets/voyager/heat_11.png"),
    })
    table.insert(voyager.layers, Layer(a, t))
    for i, L in pairs(voyager.layers) do
        L:shift{x=0, y=50}
    end

    local nfore = area / 3000
    local nback = area / 500
    local glow = lvg.newImage("assets/env/glow.png")
    for i=1,nfore do
        local star = {}
        table.insert(stars, star)
        star.layers = {}
        local x, y = math.random(0, w), math.random(0, h)
        local t = Transform(x, y)
        table.insert(star.layers, Layer(glow, t))
    end
    for i=1,nback do
        local star = {}
        table.insert(stars, star)
        star.layers = {}
        local x, y = math.random(0, w), math.random(0, h)
        local t = Transform(x, y, 0, 0.4)
        table.insert(star.layers, Layer(glow, t))
    end

    table.insert(tracks, love.audio.newSource("assets/music/No More Magic.ogg", 'stream'))
    table.insert(tracks, love.audio.newSource("assets/music/Winds Of Stories.ogg", 'stream'))
    table.insert(tracks, love.audio.newSource("assets/music/ObservingTheStar.ogg", 'stream'))
    on_track = 1
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
            print("next_track")
            on_track = (on_track % #tracks) + 1
            tracks[on_track]:play()
            volume = 0.7
        end
    end

    for p, planet in pairs(planets) do
        for i, L in ipairs(planet.layers) do
            L:update(dt)
            L:rotate(2/10000/i)
        end
    end
    for i, L in ipairs(voyager.layers) do
        L:update(dt)
        L:rotate(2/1000)
    end
    local hide = function ()
        local r = love.math.noise(love.timer.getTime())
        local min_b = 0.2
        local max_b = 0.7
        local bright = r * (max_b - min_b) + min_b
        voyager.layers[3].color = {bright-0.2, 0.3, bright+0.2, 0.7}
    end
    hide()

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
        
        local subtext = at_title * 0.5
        love.graphics.setColor{subtext,subtext,subtext,at_title*0.2}
        love.graphics.print("All music credits in assets/CREDIT", 0, h-20, 0)
    end

    love.graphics.setColor{1,0.4,0.4,0.15}
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

