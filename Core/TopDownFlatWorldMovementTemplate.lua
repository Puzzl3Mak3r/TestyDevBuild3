-- TopDownFlatWorldMovementTemplate.lua 1.0 19/03/2025 12:49


------------------------------------------------------------------------------------
-- Important
------------------------------------------------------------------------------------

local cx, cy = display.contentCenterX, display.contentCenterY
local playing = true



local followCamBackGrp = display.newGroup() -- Background
local followCamMiddGrp = display.newGroup() -- Middleground
local followCamForeGrp = display.newGroup() -- Foreground
local moveRight, moveLeft = false, false
local moveUp, moveDown = false, false
local joyStickPressed = false



------------------------------------------------------------------------------------
-- Player
------------------------------------------------------------------------------------

-- Make player
local player = display.newRect(cx, cy, 20, 20)
player:setFillColor(0, 0, 1)



------------------------------------------------------------------------------------
-- Virtual Camera
------------------------------------------------------------------------------------

local diffX = 0
local diffY = 0
local function moveCamera()
    if playing then
        -- Center the camera on the player
        diffX = cx - player.x
        diffY = cy - player.y

        -- followCamForeGrp.x = diffX * 1.2
        -- followCamForeGrp.y = diffY * 1.2

        followCamMiddGrp.x = diffX
        followCamMiddGrp.y = diffY

        -- followCamBackGrp.x = diffX * 0.8
        -- followCamBackGrp.y = diffY * 0.8
    end
end

Runtime:addEventListener("enterFrame", moveCamera) -- never got used



------------------------------------------------------------------------------------
-- Move Player -- Virtual Joystick - Made by PonyWolf
------------------------------------------------------------------------------------

-- Require and call
local vjoy = require "Addons.ponywolf.vjoy"

local leftStick = vjoy.newStick() -- default stick
leftStick.x, leftStick.y = cx, cy


local function axis(event)

    -- print ("X" .. event.x - leftStick.x .. " Y" .. event.y - leftStick.y)

    -- If exceed 100 or -100 then adjust stick position
    if event.x - leftStick.x > 100 then
        leftStick.x = event.x - 100
    end if event.x - leftStick.x < -100 then
        leftStick.x = event.x + 100
    end

    if event.y - leftStick.y > 100 then
        leftStick.y = event.y - 100
    end if event.y - leftStick.y < -100 then
        leftStick.y = event.y + 100
    end

    -- Round whether moving left or right
    if event.x > leftStick.x + 20 then
        moveRight = true
        moveLeft = false
    end if event.x < leftStick.x - 20 then
        moveRight = false
        moveLeft = true
    end if event.x < leftStick.x + 20 and event.x > leftStick.x - 20 then
        moveRight, moveLeft = false, false
    end

    -- Round whether moving up or down
    if event.y < leftStick.y - 20 then
        moveUp = true
        moveDown = false
    end if event.y > leftStick.y + 20 then
        moveUp = false
        moveDown = true
    end if event.y < leftStick.y + 20 and event.y > leftStick.y - 20 then
        moveUp, moveDown = false, false
    end

    -- Reset stick position
    if event.phase == "ended" then
        leftStick.x, leftStick.y = cx, cy
        moveRight, moveLeft, moveUp, moveDown = false, false, false, false
        joyStickPressed = false
    else
        joyStickPressed = true
    end


end
leftStick:addEventListener("touch", axis)

Runtime:addEventListener("enterFrame", function()
    if moveRight then
        print("Move Right")
    end if moveLeft then
        print("Move Left")
    end

    if moveUp then
        print("Move Up")
    end if moveDown then
        print("Move Down")
    end
end)



-- ------------------------------------------------------------------------------------
-- -- Move Player -- Keyboard
-- ------------------------------------------------------------------------------------

-- local pressedKeys = {}

-- local function keyRunner()
--     -- Key Detection
--     moveRight, moveLeft, moveUp, moveDown = false, false, false, false
--     if pressedKeys["d"] or pressedKeys["right"] then
--         moveRight = true
--     end if pressedKeys["a"] or pressedKeys["left"] then
--         moveLeft = true
--     end if pressedKeys["w"] or pressedKeys["up"] then
--         moveUp = true
--     end if pressedKeys["s"] or pressedKeys["down"] then
--         moveDown = true
--     end

--     -- Finalised Movement
--     if moveRight and moveLeft then
--         moveRight, moveLeft = false, false
--     end if moveUp and moveDown then
--         moveUp, moveDown = false, false
--     end

--     -- Move Player
--     if moveRight then
--         player.x = player.x + 5
--     end if moveLeft then
--         player.x = player.x - 5
--     end if moveUp then
--         player.y = player.y - 5
--     end if moveDown then
--         player.y = player.y + 5
--     end
-- end

-- -- Key event handler
-- local function onKeyEvent(event)
--     if event.phase == "down" then
--         pressedKeys[event.keyName] = true
--     elseif event.phase == "up" then
--         pressedKeys[event.keyName] = false
--     end
-- end

-- -- Event listeners
-- Runtime:addEventListener("enterFrame", keyRunner)
-- Runtime:addEventListener("key", onKeyEvent)



------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------

local overworld = {}

function overworld.Start()
    -- call functions from here 
end

return overworld