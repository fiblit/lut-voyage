local libclass = require("lib.class")

Anim = class()
function Anim:_new(tick, imgs)
    self.ticking = false
    self.tick = tick
    self.duration = #imgs * self.tick
    self.tock = 0
    self.time = 0
    self.onframe = 1
    self.imgs = imgs
end

function Anim:frame()
    return self.imgs[self.onframe]
end

function Anim:play()
    self.ticking = true
end

function Anim:pause()
    self.ticking = false
end

function Anim:stop()
    self.ticking = false
    self.time = 0
    self.tock = 0
    self.onframe = 1
end

function Anim:update(dt)
    if not self.ticking then
        return false
    end

    self.time = self.time + dt
    self.tock = self.tock + dt
    local updated = false
    while self.time > self.duration do
        self.time = self.time - self.duration
        self.tock = self.time
        self.onframe = 1
        updated = true
    end
    while self.tock > self.tick do
        self.tock = self.tock - self.tick
        self.onframe = self.onframe + 1
        updated = true
    end
    return updated
end

