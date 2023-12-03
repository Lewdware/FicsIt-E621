
print('Url/Encode.lua')


local function encodeURICharacter ( character )
    return string.format('%%%02X',string.byte(character))
end

local function encodeURIComponent ( value )

    value = value .. ''

    value = string.gsub(value,'([^%w%.%- ])',encodeURICharacter)
    
    value = string.gsub(value,' ','+')

    return value
end


return {
    encodeURIComponent = encodeURIComponent
}