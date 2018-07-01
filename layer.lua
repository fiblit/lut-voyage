local C = require("lib.class")

Layer = class()
function Layer:_new(img, transform, anchor, color)
    self.img = img
    self.transform = transform
    self.anchor = anchor
    set.color = color

    -- default to identity
    if not self.transform then
        self.transform = love.math.newTransform(0, 0)
    end

    if not self.color then
        self.color = {r=1,g=1,b=1,a=1}
    end

    -- default to center anchor
    if not self.anchor then
        self.anchor = love.math.newTransform(0, 0)
        self:reanchor('center')
    end
end

function Layer:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    love.graphics.draw(self.img, self.transform * self.anchor)
end

function Layer:reanchor(point, offset)
    local ox, oy
    if point == 'center' then
        ox, oy = self.img:getWidth()/2, self.img:getHeight()/2
    elseif point == 'topleft' then
        ox, oy = 0, 0
    elseif point == 'topright' then
        ox, oy = self.img:getWidth(), 0
    elseif point == 'top' then
        ox, oy = self.img:getWidth()/2, 0
    elseif point == 'left' then
        ox, oy = 0, self.img:getHeight()/2
    elseif point == 'right' then
        ox, oy = self.img:getWidth(), self.img:getHeight()/2
    elseif point == 'botright' then
        ox, oy = self.img:getWidth(), self.img:getHeight()
    elseif point == 'bot' then
        ox, oy = self.img:getWidth()/2, self.img:getHeight()
    elseif point == 'leftbot' then
        ox, oy = 0, self.img:getHeight()
    end
    if not offset then
        offset = {x=0,y=0}
    end
    x, y = ox + offset.x, oy + offset.y
    self.anchor:setTransformation(0, 0, 0, 1, 1, x, y)
end

function Layer:shift(offset)
    self.anchor:apply(love.math.newTransform(offset.x, offset.y))
end

