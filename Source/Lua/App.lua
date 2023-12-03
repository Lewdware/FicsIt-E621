
print('App.lua')

filesystem.doFile('/Require.lua')



local fetch = require('Fetch')
local JSON = require('JSON')



local gpu = computer.getPCIDevices(classes.GPU_T1_C)[1]

assert(gpu,'No GPU T1 found!')

local comp = component.findComponent(classes.Screen)[1]

assert(comp,'No Screen found!')

local screen = component.proxy(comp)

assert(screen,'No Screen Proxy found')


local buffer = gpu:getBuffer()


-- local request = fetch('https://e621.net/posts/4438475.json')
local request = fetch('https://static1.e621.net/data/5d/92/5d925c501404c251f6565d484c9f25ac.jpg')


local status , data , headers = request:await()

print(status,headers,#data)

print(data:sub(1,100))


local function arrayStr ( array )
    return table.concat(array,' , ')
end

local function toChannel ( data , index ) 
    
    local string = data:sub( index , index + 2 )

    if tonumber(string) == nil then
        print(#data,index,index + 2,"'" .. string .. "'")
    end

    return tonumber(string) / 255
end

local function toColor ( data , index )
    return {
        toChannel(data,index + 0) ,
        toChannel(data,index + 3) ,
        toChannel(data,index + 6) ,
        1
    }
end


local width = tonumber(data:sub(1,6))
local height = tonumber(data:sub(7,12))

local halfHeight = ( height + 1 ) // 2

gpu:setSize(width,halfHeight)
gpu:bindScreen(screen)

local w , h = gpu:getSize()

assert(
    ( width <= w ) and ( height <= ( 2 * h ) ) ,
    'Error image is too big, max size: 300x200'
)


function clearScreen ( gpu )

    gpu:setBackground(0,0,0,0.2)
    
    local w , h = gpu:getSize()
    gpu:fill(0,0,w,h,' ')
end

clearScreen(gpu)
gpu:flush()

print('Size:',width,'x',height)


local index = 12 + 1

for y = 0 , halfHeight - 1 , 1 do
    for x = 0 , width - 1 , 1 do

        local top = toColor(data,index)

        index = index + ( 3 * 3 )


        local bottom = { 0 , 0 , 0 , 0 }

        if y * 2 <= height then

            bottom = toColor(data,index)
        
            index = index + ( 3 * 3 )
        end

       

        buffer:set(x,y,'\u{2580}',top,bottom)
    end
end



gpu:setBuffer(buffer)
gpu:flush()

print('Done',math.random())

-- print(JSON.parse(data))
