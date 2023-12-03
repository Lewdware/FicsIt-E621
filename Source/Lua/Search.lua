
print('Search.lua')


local encodeURIComponent = require('URL/Encode').encodeURIComponent


local Class = {}
Class.__index = Class

function Class:new ()

    local instance = {}
    setmetatable(instance,Class)

    instance.parameters = {}
    
    return instance
end

function Class:set ( name , value )
    self.parameters[ name ] = value
    print('sefs',self.parameters)
end

function Class.__concat ( other , self )

    local string = tostring(other)

    for name , value in pairs(self.parameters) do
        string = string 
            .. encodeURIComponent(name) 
            .. '=' 
            .. encodeURIComponent(value)
    end

    return string
end

function Class:toString ()
    return self:__concat()
end


return Class