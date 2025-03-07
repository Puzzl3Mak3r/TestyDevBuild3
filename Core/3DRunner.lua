--  $$$$$$\  $$$$$$$\  $$$$$$$\                                                    $$\                          
-- $$ ___$$\ $$  __$$\ $$  __$$\                                                   $$ |                         
-- \_/   $$ |$$ |  $$ |$$ |  $$ |$$\   $$\ $$$$$$$\  $$$$$$$\   $$$$$$\   $$$$$$\  $$ |     $$\   $$\  $$$$$$\  
--   $$$$$ / $$ |  $$ |$$$$$$$  |$$ |  $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\ $$ |     $$ |  $$ | \____$$\ 
--   \___$$\ $$ |  $$ |$$  __$$< $$ |  $$ |$$ |  $$ |$$ |  $$ |$$$$$$$$ |$$ |  \__|$$ |     $$ |  $$ | $$$$$$$ |
-- $$\   $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |      $$ |     $$ |  $$ |$$  __$$ |
-- \$$$$$$  |$$$$$$$  |$$ |  $$ |\$$$$$$  |$$ |  $$ |$$ |  $$ |\$$$$$$$\ $$ |$$\   $$$$$$$$\\$$$$$$  |\$$$$$$$ |
--  \______/ \_______/ \__|  \__| \______/ \__|  \__|\__|  \__| \_______|\__|\__|  \________|\______/  \_______|

-- Remove annoying warnings (Remove this when building applications)
local display = display
local Runtime = Runtime

-- Parameters
local fw, fh = display.contentWidth, display.contentHeight
local cx, cy = display.contentCenterX, display.contentCenterY
local moveRight, moveLeft, moveForward = false, false, false
local diffX, diffY = 0, 0
local RayLine = {} -- for displaying line, will not be used except for dev building
local raycastDistance = {}
local FOV = 400
local count = 1
local SPREAD = FOV / 90
local inventory = {
    keys = 0
}


-- [[ 2D ]] -- ===============================================

-- Physics
local physics = require( "physics" )
physics.start()
-- physics.setDrawMode( "hybrid" )

-- Player
local player = display.newPolygon( cx, cy, {0,0, 40,20, 0,40, 10,20}) -- Pointed Arrow
-- Circle player collision
physics.addBody( player, "static", { radius = 15 } )

-- Enemy
local enemy = display.newImageRect( "Assets/Images/3D/badGuy.png", 60, 60 )
enemy.x, enemy.y = cx, cy + 100
physics.addBody( enemy, "static", { radius = 1 } )
enemy.name = "object"
enemy.objectType = "enemy"

-- Key
local key = display.newImageRect( "Assets/Images/3D/key.png", 60, 60 )
key.x, key.y = cx + 100, cy + 200
physics.addBody( key, "static", { radius = 1 } )
key.name = "object"
key.objectType = "key"

-- Create a 2D representation of the 3D environment
local wall1 = display.newRect(0, 0, 100, 300)
wall1.x = 600
wall1.y = 800

local wall2 = display.newRect(0, 0, 100, 300)
wall2.x = 300
wall2.y = 600


-- Add 2D elements to the group
local _2Dgroup = display.newGroup()
_2Dgroup.x, _2Dgroup.y = cx, cy

_2Dgroup:insert( player )
_2Dgroup:insert( enemy )
_2Dgroup:insert( key )
_2Dgroup:insert( wall1 )
_2Dgroup:insert( wall2 )

_2Dgroup.x, _2Dgroup.y = 690, 270

-- physics.setDrawMode( "hybrid" )


-- [[ 3D ]] -- ===============================================

local overlay2d = display.newImageRect( "Assets/Images/3D/overlay.png", 1920, 1080 )
overlay2d.x, overlay2d.y = cx,cy

local collectPrompt = display.newText( "Press space to pick up key", cx, cy + 430, native.systemFont, 70 )
collectPrompt.alpha = 0

-- Groups
local wallGroup = display.newGroup()
local objectsGroup = display.newGroup()

-- Apply Physics
physics.addBody(wall1, "static")
physics.addBody(wall2, "static")
wall1.name = "wall"
wall2.name = "wall"


-- Move player
local function MovePlayer()
    if moveRight then
        player:rotate(3)
    end
    if moveLeft then
        player:rotate(-3)
    end

    -- Move Forward
    diffX, diffY = math.cos(math.rad(player.rotation)), math.sin(math.rad(player.rotation))
    if moveForward then
        _2Dgroup:translate( -3*diffX, -3*diffY )
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

    -- For the counter
    count = count + 0.05
end
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "enterFrame", keyRunner )

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
    playerForward = playerForward + (num - (FOV/2))/(SPREAD)

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
    local wall = display.newRect(0, cy, 6, 1080 * 11 / height)

    -- Position wall
    wall.x = 192/9 * (wallNum - 0.5) / (FOV/100)

    -- Darkness of wall depending on distance
    local darkness = 1 - (wallDistance / 1000)
    wall.fill = {darkness, darkness, darkness}

    -- Stop moving if wall is too close (fake collision)
    if wallDistance <= 20 then
        moveForward = false
    end

    -- Join wall group
    wallGroup:insert(wall)
end

-- Display Objects
local function displayObjects(xPos, distance, objectType, object)
    -- Display prompt
    collectPrompt.alpha = 0

    -- Create objects
    if objectType == "enemy" then
        object = display.newImageRect( "Assets/Images/3D/badGuy.png", 12, 12 )
        object.x, object.y = 192/9 * (xPos - 0.5) / (FOV/100), cy
        -- display.newImageRect( [parent,] filename, [baseDir,] width, height )
    elseif objectType == "key" then
        if distance <= 0 then
            if  pressedKeys["space"] then
                inventory.keys = inventory.keys + 1
                object:removeSelf()
                print ( "You picked up a key" )
                print ( "You have " .. inventory.keys .. " keys" )
            else
                collectPrompt.alpha = 1
            end
        end
        object = display.newImageRect( "Assets/Images/3D/key.png", 12, 12 )
        object.x, object.y = 192/9 * (xPos - 0.5) / (FOV/100), cy
        object.alpha = 0.15
        object.spin = true
    else
        object = display.newRect( 192/9 * (xPos - 0.5) / (FOV/100), cy, 20, 20 )
        object.fill = {1,0,0}
    end

    -- Add to objectsGroup
    objectsGroup:insert(object)

    -- Scale
    local scale = (3000/(distance))
    object.xScale, object.yScale = scale, scale

    -- Spin
    if count <= -359 or count >= 359 then count = -359 end
    local spinValue = math.sin( count )
    -- print( "spinvalue:" .. spinValue )
    if object.spin then
        object.xScale = spinValue * scale * 1.2
    end
end


-- Create a function to cast rays from the player
local function castRays()
    local rays = {}
    for i = 1, FOV do
        rays[i] = physics.rayCast(player.x, player.y, playerDirection(i))
        -- -- Display a line representing the ray
        -- RayLine[i] = display.newLine(player.x, player.y, playerDirection(i))
        -- RayLine[i].strokeWidth, RayLine[i].alpha = 2, 0.1
        if ( rays[i] ) then
            -- Distance formula
            raycastDistance[i] = math.sqrt( (player.x - rays[i][1].position.x)^2 + (player.y - rays[i][1].position.y)^2 )

            -- Create wall
            if rays[i][1].object.name == "wall" then
                createWalls(i, raycastDistance[i])
            end

            -- Create object
            if rays[i][1].object.name == "object" then
                displayObjects(i, raycastDistance[i], rays[i][1].object.objectType, rays[i][1].object)
            end
        end
    end
end

-- Call the castRays function every frame
Runtime:addEventListener("enterFrame", function()

    -- Delete everything in wallGroup
    if wallGroup.numChildren ~= 0 then for i = 1, wallGroup.numChildren do
        display.remove( wallGroup[i] )
    end end
    if objectsGroup.numChildren ~= 0 then for i = 1, objectsGroup.numChildren do
        display.remove( objectsGroup[i] )
    end end
    if #RayLine ~= 0 then for i = 1, #RayLine do
        display.remove( RayLine[i] )
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