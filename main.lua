local layer = require("layer")

planets = {}
voyager = {}
stars = {}

function love.load()
    local lvg = love.graphics
    lvg.setBackgroundColor(10/255, 10/255, 20/255)
    lvg.setDefaultFilter("nearest", "nearest", 1)

    local planet = {}
    table.insert(planets, planet)
    planet.layers = {}
    local t = love.math.newTransform(640, 360, 0, 2)
    table.insert(planet.layers, Layer(lvg.newImage("assets/globe.png"), t))
    local t = love.math.newTransform(640, 360, 0, 2)
    table.insert(planet.layers, Layer(lvg.newImage("assets/clouds.png"), t))

    voyager.layers = {}
    local t = love.math.newTransform(640, 360, 0, -2, 2)
    table.insert(voyager.layers, Layer(lvg.newImage("assets/voyager_0.png"), t))
    for i, L in pairs(voyager.layers) do
        L:shift{x=0, y=-50}
    end

    local nstars = (1280 * 720 / 3t000)
    for i=1,nstars do
        local star = {}
        table.insert(stars, star)
        star.layers = {}
        local x, y = math.random(0, 1280), math.random(0, 720)
        local t = love.math.newTransform(x, y)
        table.insert(star.layers, Layer(lvg.newImage("assets/glow.png"), t))
    end
end

function love.update()
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    for p, planet in pairs(planets) do
        for i, L in ipairs(planet.layers) do
            L.transform:rotate(0.001/i)
        end
    end
    for i, L in ipairs(voyager.layers) do
        L.transform:rotate(-0.01)
    end
end

function love.draw()
    love.graphics.print("L.U.T. Voyage", 480, 50, 0, 4)

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

