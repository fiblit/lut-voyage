function class(...)
    -- "cls" is the new class
    local cls, bases = {}, {...}

    -- copy base class contents into the new class
    for i, base in ipairs(bases) do
        for k, v in pairs(base) do
            cls[k] = v
        end
    end

    -- set the class's __index, and start filling an "is" table that contains
    -- this class and all of its bases so you can do an "instance of" check
    -- using my_instance.is[MyClass]
    cls.__index = cls
    cls.is = {[cls] = true}
    for i, base in ipairs(bases) do
        for c in pairs(base.is_a) do
            cls.is[c] = true
        end
    end

    -- the class's __call metamethod
    setmetatable(cls, {
        __call = function (c, ...)
            local instance = setmetatable({}, c)
            -- run the init method if it's there
            if instance._new then instance:_new(...) end
            return instance
        end,
    })

    -- return the new class table, that's ready to fill with methods
    return cls
end

