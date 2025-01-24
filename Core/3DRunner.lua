-- Remove annoying warnings (Remove this when building applications)
local display = display
local Runtime = Runtime

-- Parameters
local playing = true
local fx, fy = display.contentWidth, display.contentHeight
local cx, cy = display.contentCenterX, display.contentCenterY
local moveRight, moveLeft, moveForward = false, false, false
local holdingLeft, holdingRight, holdingActionButton = false, false, false -- for mobile
local diffX, diffY = 0, 0
local RayLine = {} -- for displaying line, will not be used except for dev building
local FOV = 400
local SPREAD = FOV / 90
local inventory = {
    keys = 0
}

-- Fullscreen
-- native.setProperty(windowMode, fullscreen)




-- [[ 2D ]] -- ===============================================

-- Physics
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-- Player
local player = display.newPolygon( cx, cy, {0,0, 40,20, 0,40, 10,20}) -- Pointed Arrow
-- Circle player collision
physics.addBody( player, "static", { radius=1 } )

-- Enemy
local enemy = display.newPolygon( cx+100, cy, {0,0, 40,20, 0,40, 10,20}) -- Pointed Arrow
physics.addBody( enemy, "static", { radius=1 } )
enemy.name = "object"
enemy.objectType = "enemy"

-- Create a 2D representation of the 3D environment
local wall1 = display.newRect(0, 0, 100, 300)
wall1.x = 600
wall1.y = 800

local wall2 = display.newRect(0, 0, 100, 300)
wall2.x = 300
wall2.y = 600

-- Key Item
local key1 = display.newImageRect( "Assets/Images/3D/key.png", 20, 20 )
key1.x, key1.y = cx + 100, cy + 50
key1.xScale, key1.yScale = 4, 4
-- local key = display.newImageRect( [parent,] filename, [baseDir,] width, height )
-- local key = display.newPolygon( cx+100, cy+50, {0,0, 40,20, 0,40, 10,20}) -- Pointed Arrow
physics.addBody( key1, "static", { radius=3 } )
key1.name = "object"
key1.objectType = "key"
key1.keyname = "key1"

-- Spin group (spinning items)
local spinGroup = display.newGroup()
spinGroup:insert(key1)

-- Add 2D elements to the group
local _2Dgroup = display.newGroup()
_2Dgroup.x, _2Dgroup.y = cx, cy

_2Dgroup:insert(player)
_2Dgroup:insert(enemy)
_2Dgroup:insert(wall1)
_2Dgroup:insert(wall2)
_2Dgroup:insert(spinGroup)

_2Dgroup.x, _2Dgroup.y = 700, 270

local overlay2d = display.newImageRect( "Assets/Images/3D/overlay.png", 1920, 1080 )
overlay2d.x, overlay2d.y = cx,cy
-- overlay2d.alpha = 0.5 -- Change before export


-- Text over the overlay
local textOption = display.newText( "", cx, cy + 300, native.systemFont, 70 ) -- to be used for when something can be interracted with


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
    if playing then
        if moveRight then
            player:rotate(3)
        end
        if moveLeft then
            player:rotate(-3)
        end

        -- Move Forward
        if moveForward then
            diffX, diffY = math.cos(math.rad(player.rotation)), math.sin(math.rad(player.rotation))
            _2Dgroup:translate( -3*diffX, -3*diffY )
            player:translate(3 * diffX, 3 * diffY)
        end
    end
end
Runtime:addEventListener( "enterFrame", MovePlayer )



-- [[ Inputs ]] -- ===============================================
-- PC

-- Keybinds
local pressedKeys = {}
function onKeyEvent(event)
    if playing then
        if event.phase == "down" then
            pressedKeys[event.keyName] = true
        elseif event.phase == "up" then
            pressedKeys[event.keyName] = false
        else
            pressedKeys[event.keyName] = false
        end
    end
end
local function keyRunner()
    if playing then
        -- Move Left and Right
        moveRight, moveLeft = false, false
        if pressedKeys["d"] then
            moveRight = true
        end if pressedKeys["a"] then
            moveLeft = true
        end if pressedKeys["right"] then
            moveRight = true
        end if pressedKeys["left"] then
            moveLeft = true
        end
        if moveLeft and moveRight then
            moveLeft, moveRight = false, false
        end

        -- Move Forward
        if pressedKeys["w"] or pressedKeys["up"] then
            moveForward = true
        else moveForward = false end
    end
end
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "enterFrame", keyRunner )



-- -- Mobile -- Change back for exporting to mobile
-- local touchL, touchR = display.newRect(0, 0, cx, fy), display.newRect(0, 0, cx, fy)
-- touchL.x, touchL.y, touchR.x, touchR.y = (fx)/4, cy, (fx*3)/4, cy
-- touchL.alpha, touchR.alpha = 0.01, 0.01 -- Setting to 0 breaks touch detection
-- touchL.name, touchR.name = "Left", "Right"

-- local touchAction = display.newRect(0, 0, 500, 100)
-- touchAction.x, touchAction.y = cx, cy + 300
-- touchAction.alpha = 0.01 -- Setting to 0 breaks touch detection
-- touchAction.name = "Action"

-- touchAction:addEventListener( "touch", function(event)
--     if event.phase == "began" then
--         holdingActionButton = true
--     elseif event.phase == "ended" then
--         holdingActionButton = false
--     end
-- end )

-- local function onTouch(event)
--     if event.phase == "began" or event.phase == "moved" then
--         if event.target.name == "Left" and not holdingActionButton then
--             holdingLeft = true
--         end
--         if event.target.name == "Right" and not holdingActionButton then
--             holdingRight = true
--         end
--         if holdingLeft and holdingRight then
--             holdingLeft, holdingRight = false, false
--             moveForward = true
--         end
--     end
--     if event.phase == "ended" then
--         holdingLeft = false
--         holdingRight = false
--     end
-- end

-- local function holdingLeftRight()
--     if playing then
--         if holdingLeft then
--             moveLeft = true
--         else
--             moveLeft = false
--         end
--         if holdingRight then
--             moveRight = true
--         else
--             moveRight = false
--         end
--     end
-- end

-- touchL:addEventListener( "touch", onTouch )
-- touchR:addEventListener( "touch", onTouch )
-- Runtime:addEventListener( "enterFrame", holdingLeftRight )



-- Determine posisition in front of player using direction
player.rotation = 360
local function playerDirection(num)
    if playing then
        -- Limit Direction
        local playerForward = player.rotation
        if playerForward > 360 then
            playerForward = playerForward - 360
        end
        if playerForward < 0 then
            playerForward = playerForward + 360
        end

        -- Correct the Direction
        playerForward = playerForward + (num - (FOV/2))/(SPREAD)

        -- Calculate direction of player
        local playerForwardX = player.x + (800 * math.cos(math.rad(playerForward)))
        local playerForwardY = player.y + (800 * math.sin(math.rad(playerForward)))

        return playerForwardX, playerForwardY
    end
end



-- [[ 3D ]] -- ===============================================

--  Create the walls
local function createWalls(wallNum, wallDistance)
    if playing then
        -- Height of wall
        local height = math.floor( wallDistance )
        if height < 0 then height = 0 end

        -- Create wall
        local wall = display.newRect(0, cy, 5.5, 1080 * 11 / height) -- Thickness --> 5 normal -- 4.5 medium -- 3 small

        -- Position wall
        wall.x = 192/9 * (wallNum - 0.5) / (FOV/100)

        -- Darkness of wall depending on distance
        local darkness = 1 - (wallDistance / 700)
        wall.fill = {darkness, darkness, darkness}

        -- If wall is too close, disable moving
        if wallDistance < 30 then
            moveForward = false
        end

        -- Join wall group
        wallGroup:insert(wall)
    end
end


-- [[ Display Objects ]] -- ===============================================

local txtInventory = display.newText( "keys "..inventory.keys, fx - 50, 50, native.systemFont, 30 ) -- Debug


local spin = 0
local function displayObjects(xPos, distance, objectType, object)
    if playing then
        local cacheObject -- for deletion if needed

        -- Display
        if objectType == "enemy" then
            object = display.newImageRect( "Assets/Images/3D/badGuy.png", 20, 20 )
            object.x, object.y = 192/9 * (xPos - 0.5) / (FOV/100), cy
        elseif objectType == "key" then
            cacheObject = object
            object = display.newImageRect( "Assets/Images/3D/key.png", 20, 20 )
            object.x, object.y = 192/9 * (xPos - 0.5) / (FOV/100), cy
        end
        object.objectType = objectType
        object.alpha = 1

        -- Add to objectsGroup
        objectsGroup:insert(object)

        -- Scale
        local scale = (2000/(distance))
        object.xScale, object.yScale = scale, scale

        -- [[ SPIN ]]
        -- Spin update
        spin = spin + 1

        -- Avoid numbers 360, -360 and 0
        if spin == 359 then spin = -359 elseif spin == 0 then spin = 1 end

        -- Rotate
        if objectType == "key" then
            -- Collecting the key
            if distance <= 50 then
                textOption.text = "Collect Key" -- Display text
                if pressedKeys["space"] or holdingActionButton then
                    display.remove( cacheObject ) -- qwerty
                    inventory.keys = inventory.keys + 1
                    textOption.text = ""
                    txtInventory.text = "keys "..inventory.keys -- Debug
                end
            end

            -- Oscillate xScale
            object.alpha = 0.05
            object.xScale = object.xScale * math.sin( math.rad( spin/2 ) )
            -- object.yScale = object.yScale * math.sin( math.rad( (spin+180)/2 )) -- for the fun of it
        end
    end
end


-- Create a function to cast rays from the player
local function castRays()
    if playing then
        local rays = {}
        for i = 1, FOV do
            rays[i] = physics.rayCast(player.x, player.y, playerDirection(i))
            -- -- Display a line representing the ray
            -- RayLine[i] = display.newLine(player.x, player.y, playerDirection(i))
            -- RayLine[i].strokeWidth, RayLine[i].alpha = 2, 0.1

            if ( rays[i] ) then
                -- Distance formula
                local rayDistance = math.sqrt( (player.x - rays[i][1].position.x)^2 + (player.y - rays[i][1].position.y)^2 )

                -- Create wall
                if rays[i][1].object.name == "wall" then
                    createWalls(i, rayDistance)
                end

                -- Create object
                if rays[i][1].object.name == "object" then
                    displayObjects(i, rayDistance, rays[i][1].object.objectType, rays[i][1].object)
                    -- display.remove( rays[i][1].object )
                end
            end
        end
    end
end



-- Call the castRays function every frame
local function callCastRays()
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
    if playing then

        -- Text
        textOption.text = ""

        -- Cast Rays
        if playing then
            castRays()
        end
    end
end
Runtime:addEventListener("enterFrame", callCastRays)





-- [[ Start ]]

local _3dRunner = {}

function _3dRunner.Start()
    -- Proof of start
    print("3D Runner")
end

function _3dRunner.Yeild()
    -- Yeild
    playing = false
    Runtime:removeEventListener( callCastRays )
    Runtime:removeEventListener( MovePlayer )
    Runtime:removeEventListener( castRays )
    Runtime:removeEventListener( onKeyEvent )
    Runtime:removeEventListener( keyRunner )

    -- remove everything in _2Dgroup
    if _2Dgroup.numChildren ~= 0 then
        for i = 1, _2Dgroup.numChildren do
            display.remove( _2Dgroup[i] )
        end
    end

    -- remove walls
    for i = 1, wallGroup.numChildren do
    display.remove( wallGroup[i] )
    end
    -- remove objects
    if objectsGroup.numChildren ~= 0 then for i = 1, objectsGroup.numChildren do
    display.remove( objectsGroup[i] )
    end end
    -- remove rays
    if #RayLine ~= 0 then for i = 1, #RayLine do
    display.remove( RayLine[i] )
    end end

    -- remove last objects
    display.remove( player )
    display.remove( textOption )
    display.remove( txtInventory )
    display.remove( wall1 )
    display.remove( wall2 )
    display.remove( key1 )
    display.remove( overlay2d )
    display.remove( enemy )

end

return _3dRunner