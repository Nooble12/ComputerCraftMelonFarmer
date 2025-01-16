--Robot Config
local numberOfRows = 11

local boundaryBlock = "minecraft:cobblestone"
local returnBlock = "minecraft:redstone_block"
local breakableBlock = "minecraft:melon"

local currentRowNumber = 1
local isRobotRunning = true

--Gets coal from a storage below and refuels
local function refuelTurtle()
    turtle.suckDown()
    turtle.refuel()
end

--Runs when turtle starts
refuelTurtle()

--Moves turtle's inventory items to a chest above
local function depositItems()
    for slot = 1, 16 do 
        turtle.select(slot)
        turtle.dropUp()
    end
end

local function resetCurrentRowNumber()
    currentRowNumber = 1
end

local function returnHome()
    turtle.turnLeft()

    for i = 1, numberOfRows, 1 do
        turtle.forward()
    end
    turtle.turnLeft()

    depositItems()
    resetCurrentRowNumber()
    refuelTurtle()
end

local function onTouchCobble()
    currentRowNumber = currentRowNumber + 1
    if (currentRowNumber %2 == 1) then
        turtle.turnRight()
        turtle.forward()
        turtle.turnRight()

    else
        turtle.turnLeft()
        turtle.forward()
        turtle.turnLeft()
    end
end

local function checkFront()
    local hasBlock, blockData = turtle.inspect()

    if (hasBlock and blockData.name == boundaryBlock) then
        onTouchCobble()
    end

    if (hasBlock and blockData.name == returnBlock) then
        returnHome()
    end
end

local function onTouchBreakableBlock()
    turtle.digDown()
end

local function checkBelow()
    local hasBlock, blockData = turtle.inspectDown()

    if (hasBlock and blockData.name == breakableBlock) then
        onTouchBreakableBlock()
    end
end

local function runTurtle()
    while isRobotRunning do
        turtle.forward()
        checkFront()
        checkBelow()
    end
end

--Networking Code
rednet.open("left")

local computerID = 6

--Only runs once since limit does not change
local fuelLevelLimit = turtle.getFuelLimit()

local function sendTurtleDataToComputer()
    while isRobotRunning do
        local fuelLevel = turtle.getFuelLevel()
    
        rednet.send(computerID, {
            type = "fuelData",
            fuelLevel = fuelLevel,
            fuelLevelLimit = fuelLevelLimit
        })
        
        os.sleep(1) 
    end
end

parallel.waitForAny
(
    sendTurtleDataToComputer,  
    runTurtle      
)
