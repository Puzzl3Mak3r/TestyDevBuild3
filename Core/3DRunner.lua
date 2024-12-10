-- Remove annoying warnings (Remove this when building applications)
local display = display
local Runtime = Runtime

-- Parameters
local fw, fh = display.contentWidth, display.contentHeight
local cx, cy = display.contentCenterX, display.contentCenterY
local moveRight, moveLeft, moveForward = false, false, false
local diffX, diffY = 0, 0
local raycastDistance = {}
local wallGroup = display.newGroup()

-- Physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Player
local player = display.newPolygon( cx, cy, {0,0, 40,20, 0,40, 10,20}) -- Pointed Arrow
-- Circle player collision
physics.addBody( player, "dynamic", { radius=15 } )

-- Move player
local function MovePlayer()
    if moveRight then
        player:rotate(4)
    end
    if moveLeft then
        player:rotate(-4)
    end

    diffX, diffY = math.cos(math.rad(player.rotation)), math.sin(math.rad(player.rotation))

    -- Find direction

    if moveForward then
        player:translate(3 * diffX, 3 * diffY)
    end
end
Runtime:addEventListener( "enterFrame", MovePlayer )


-- Keybinds
local pressedKeys = {}
function onKeyEvent(event)
    if event.phase == "down" then
        pressedKeys[event.keyName] = true
    elseif event.phase == "up" then
        pressedKeys[event.keyName] = false
    else
        pressedKeys[event.keyName] = false
    end
end
local function keyRunner()
    -- Move Left and Right
    if pressedKeys["d"] then
        moveRight, moveLeft = true, false
    elseif pressedKeys["a"] then
        moveRight, moveLeft = false, true
    elseif pressedKeys["right"] then
        moveRight, moveLeft = true, false
    elseif pressedKeys["left"] then
        moveRight, moveLeft = false, true
    else
        moveRight, moveLeft = false, false
    end

    -- Move Forward
    if pressedKeys["w"] or pressedKeys["up"] then
        moveForward = true
    else moveForward = false end
end
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "enterFrame", keyRunner )



-- Create a 2D representation of the 3D environment
local wall1 = display.newRect(0, 0, 100, 300)
wall1.x = 600
wall1.y = 800

local wall2 = display.newRect(0, 0, 100, 300)
wall2.x = 300
wall2.y = 600

-- Apply Physics
physics.addBody(wall1, "static")
physics.addBody(wall2, "static")
wall1.name = "wall1"
wall2.name = "wall2"

-- physics.setDrawMode( "hybrid" )

-- Determine posisition in front of player using direction
player.rotation = 360
local function playerDirection(num)
    -- Limit Direction
    local playerForward = player.rotation
    if playerForward >= 360 then
        playerForward = playerForward - 360
    end
    if playerForward <= 0 then
        playerForward = playerForward + 360
    end

    -- Correct direction
    playerForward = playerForward + num - 45

    -- Calculate direction of player
    local playerForwardX = player.x + (800 * math.cos(math.rad(playerForward)))
    local playerForwardY = player.y + (800 * math.sin(math.rad(playerForward)))

    return playerForwardX, playerForwardY
end

--  Create the walls
local function createWalls(wallNum, wallDistance)
    -- Height of wall
    local height = math.floor( wallDistance )
    if height < 0 then height = 0 end

    -- Create wall
    local wall = display.newRect(0, 960, 192/9, 1080 * 5 / height)

    -- Position wall
    wall.x = 192/9 * (wallNum - 0.5)
    wall.y = cy

    -- Join wall group
    wallGroup:insert(wall)
end


-- Create a function to cast rays from the player
local function castRays()
    local rays = {}
    -- local RayLine = {} -- for displaying line, will not be used except for dev building
    for i = 1, 90 do
        -- print ("Cast ray " .. i)
        rays[i] = physics.rayCast(player.x, player.y, playerDirection(i))
        -- -- Display a line representing the ray
        -- RayLine[i] = display.newLine(player.x, player.y, playerDirection(i))
        -- RayLine[i].strokeWidth, RayLine[i].alpha = 2, 0.3
        if ( rays[i] ) then
            -- -- Rounding
            -- raycastDistance[i] = ( math.floor( 10* math.sqrt( (player.x - rays[i][1].position.x)^2 + (player.y - rays[i][1].position.y)^2 ) ) ) /10 -10

            -- No Rounding
            raycastDistance[i] = math.sqrt( (player.x - rays[i][1].position.x)^2 + (player.y - rays[i][1].position.y)^2 )

            createWalls(i, raycastDistance[i])
        end

    end
end

-- Call the castRays function every frame
Runtime:addEventListener("enterFrame", function()

    -- Delete everything in wallGroup
    if wallGroup.numChildren ~= 0 then for i = 1, wallGroup.numChildren do
        display.remove( wallGroup[i] )
        print ("i: " .. i)
    end end

    -- Cast Rays
    castRays()
end)






local _3dRunner = {}

function _3dRunner.Start()
    -- Proof of start
    print("3D Runner")
end

function _3dRunner.Yeild()
    -- Yeild
end

return _3dRunner