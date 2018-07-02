local libclass = require("lib.class")

Transform = class()
function Transform:_new(x, y, r, sx, sy, ox, oy, kx, ky)
    if x then self.x = x else self.x = 0 end
    if y then self.y = y else self.y = 0 end
    if r then self.r = r else self.r = 0 end
    if sx then self.sx = sx else self.sx = 1 end
    if sy then self.sy = sy else self.sy = sx end
    if ox then self.ox = ox else self.ox = 0 end
    if oy then self.oy = oy else self.oy = 0 end
    if kx then self.kx = kx else self.kx = 0 end
    if ky then self.ky = ky else self.ky = 0 end
end

function Transform:clone()
    local cp = Transform()
    for k, v in pairs(self) do
        cp[k] = v
    end
    return cp
end

function Transform:asmat()
    -- for the record; information is lost. r~kx+ky and ox~x oy~y
    return love.math.newTransform(
        self.x, self.y, self.r, self.sx, self.sy,
        self.ox, self.oy,
        self.kx, self.ky
    )
end

function Transform:frommat(mat)
    -- will intentionally crash as unindexable; love transforms don't do that :/
    -- only x, y, and r will be retrieved
    return mat.crash
end

