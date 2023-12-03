
local cache = {}


require = function ( name )

    if cache[ name ] then 
        return cache[ name ]
    end

    local path = '/' .. name .. '.lua'

    local data = filesystem.doFile(path)

    cache[ name ] = data

    return data
end