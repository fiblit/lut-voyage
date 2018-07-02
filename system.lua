-- todo: panning via the system

local sections = {}
local gl_i = 0
local gl_j = 0
local gl_sw = 1000
local gl_sh = 1000

function add_section(i, j)
    sections['§-'..i..'-'..j] = {
        x=i*gl_sw,
        y=j*gl_sh,
        w=gl_sw,
        h=gl_sh,
        planets={},
        stars={},
    }
end

function get_section(i, j)
    return sections['§-'..i..'-'..j]
end

function rget_section(di, dj)
    return sections['§-'..(gl_i+di)..'-'..(gl_j+dj)]
end

function move_section(di, dj)
    gl_i = gl_i + di
    gl_j = gl_j + dj
end

