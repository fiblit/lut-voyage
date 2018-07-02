local c_planet = require("planet")
local c_voyager = require("voyager")
local c_star = require("star")
local c_layer = require("layer")
local c_transform = require("transform")
local c_anim = require("anim")

local tracks = {}
local on_track
local volume

local at_title = 1

local planets = {}
local voyager = nil
local stars = {}

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
    Voyager.load()
    Planet.load()
    Star.load()

    -- demo menu voyager
    voyager = Voyager(w/2, h/2, 0, 50)

    -- demo menu planets
    table.insert(planets, Planet(w/2, h/2))

    local nfore = area / 3000
    local glow = lvg.newImage("assets/env/glow.png")
    for i=1,nfore do
        table.insert(stars, Star(0, w, 0, h, 1))
    end
    local nback = area / 500
    for i=1,nback do
        table.insert(stars, Star(0, w, 0, h, 0.4))
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

    voyager:update(dt)

    for _, p in pairs(planets) do
        p:update(dt)
    end

    for _, star in pairs(stars) do
        star:update(dt)
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

    voyager:draw()

    for _, star in pairs(stars) do
        star:draw()
    end

    for _, p in pairs(planets) do
        p:draw()
    end
end

