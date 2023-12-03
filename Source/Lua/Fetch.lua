
require('Internet')


local Search = require('Search')



local function fetch ( url )

    local search = Search:new()
    search:set('Url',url)

    return Devices.Internet:request('localhost:8080?' .. search,'GET','')
end


return fetch