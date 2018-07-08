local libclass = require("lib.class")

Transform = class()
function Transform:_new(x, y, r, sx, sy, ox, oy, kx, ky)
    if x then self.x = x else self.x = 0 end
    if y then self.y = y else self.y = 0 end
    if r then self.r = r else self.r = 0 end
    if sx then self.sx = sx else self.sx = 1 end
    if sy then self.sy = sy else self.sy = sx end
    if ox then self.ox = ox else self.ox = 0 end -- best not to use
    if oy then self.oy = oy else self.oy = 0 end -- best not to use
    if kx then self.kx = kx else self.kx = 0 end -- best not to use
    if ky then self.ky = ky else self.ky = 0 end -- best not to use
end

function Transform:clone()
    local cp = Transform()
    for k, v in pairs(self) do
        cp[k] = v
    end
    return cp
end

function Transform:asmat()
    -- information is lost. r~kx+ky and ox~x oy~y
    return love.math.newTransform(
        self.x, self.y,
        self.r,
        self.sx, self.sy,
        self.ox, self.oy,
        self.kx, self.ky
    )
end

function Transform:frommat(mat)
    -- only x, y, r, sx, and sy will be retrieved
    -- a fair amount of precision is also lost in r, sx, and sy
    -- e.g. a 2x scale became 2.003... in some of my testing

    -- [1 0 x][ c -s 0][sx   0][1    0]   [sx*c sx*-s x]
    -- [0 1 y][ s  c 0][   1 1][  sy 0] = [sy*s sy*c  y]
    -- [0 0 1][ 0  0 1][0  0 1][0  0 1]   [0    0     1]
    e11, e12, e13, e14,
    e21, e22, e23, e24,
    e31, e32, e33, e34,
    e41, e42, e43, e44 = mat:getMatrix()
    -- e4_ and e_3 are 'junk'

    function sign(x) return x>0 and 1 or x<0 and -1 or 0 end

    self.x = e14
    self.y = e24
    self.sx = math.sqrt(e11*e11 + e12*e12) * sign(e11)
    self.sy = math.sqrt(e21*e21 + e22*e22) * sign(e22)
    self.r = math.acos(e11/self.sx)
    self.ox = 0
    self.oy = 0
    self.kx = 0
    self.ky = 0
end

