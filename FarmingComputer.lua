rednet.open("left") -- Open the modem on the left side

print("Computer ID: " .. os.getComputerID())
term.setCursorPos(1,2)
print("Waiting for fuel level from turtle...")

local monitor = peripheral.find("monitor")

local currentFuelLevel = 0
local maxFuelLevel = 0

local function updateMonitor()
    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.write("Turtle Statistics")
    
    monitor.setCursorPos(1, 3)
    monitor.write("Fuel: " .. (currentFuelLevel or 0) .. "/" .. (maxFuelLevel or 0))
    
end

while true do
    local senderID, message, protocol = rednet.receive()

    if type(message) == "table" and message.type == "fuelData" then
        currentFuelLevel = message.fuelLevel
        maxFuelLevel = message.fuelLevelLimit
    end

    updateMonitor()
    os.sleep(1)
end
