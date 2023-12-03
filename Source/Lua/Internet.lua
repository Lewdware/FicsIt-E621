
print('Internet.lua')


Devices = Devices or {}


Devices.Internet = computer.getPCIDevices(classes.FINInternetCard)[1]

if not Devices.Internet then
    panic('No Internet Card Found')
end
