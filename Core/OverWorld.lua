--  $$$$$$\                                 $$\      $$\                     $$\       $$\     $$\                          
-- $$  __$$\                                $$ | $\  $$ |                    $$ |      $$ |    $$ |                         
-- $$ /  $$ |$$\    $$\  $$$$$$\   $$$$$$\  $$ |$$$\ $$ | $$$$$$\   $$$$$$\  $$ | $$$$$$$ |    $$ |     $$\   $$\  $$$$$$\  
-- $$ |  $$ |\$$\  $$  |$$  __$$\ $$  __$$\ $$ $$ $$\$$ |$$  __$$\ $$  __$$\ $$ |$$  __$$ |    $$ |     $$ |  $$ | \____$$\ 
-- $$ |  $$ | \$$\$$  / $$$$$$$$ |$$ |  \__|$$$$  _$$$$ |$$ /  $$ |$$ |  \__|$$ |$$ /  $$ |    $$ |     $$ |  $$ | $$$$$$$ |
-- $$ |  $$ |  \$$$  /  $$   ____|$$ |      $$$  / \$$$ |$$ |  $$ |$$ |      $$ |$$ |  $$ |    $$ |     $$ |  $$ |$$  __$$ |
--  $$$$$$  |   \$  /   \$$$$$$$\ $$ |      $$  /   \$$ |\$$$$$$  |$$ |      $$ |\$$$$$$$ |$$\ $$$$$$$$\\$$$$$$  |\$$$$$$$ |
--  \______/     \_/     \_______|\__|      \__/     \__| \______/ \__|      \__| \_______|\__|\________|\______/  \_______|



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
-- Move Player -- Virtual Joystick - Inspired by PonyWolf
------------------------------------------------------------------------------------

local leftStick = display.newCircle(cx/3, cy + 300, 100)
local leftInner = display.newCircle(cx/3, cy + 300, 50)
leftStick.alpha = 0.5
leftInner.alpha = 0.5

-- local leftStick = vjoy.newStick() -- default stick
leftStick.x, leftStick.y = cx/3, cy + 300


local function axis(event)

    -- Small circle
    leftInner.x, leftInner.y = event.x, event.y

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
        leftStick.x, leftStick.y = cx/3, cy + 300
        leftInner.x, leftInner.y = cx/3, cy + 300
        moveRight, moveLeft, moveUp, moveDown = false, false, false, false
        joyStickPressed = false
    else
        joyStickPressed = true
    end


end

-- Whenever the left side of the screen is pressed, move thew stick to that location
local leftSideRect = display.newRect( 0, 0, cx, cy*2)
leftSideRect.anchorX, leftSideRect.anchorY = 0, 0
leftSideRect.alpha = 0.01
leftSideRect:addEventListener("touch", axis)

-- Whenever stick is pressed, move player

Runtime:addEventListener("enterFrame", function()
    -- Printing stuff (can be commented out)
    if moveRight then
        print("Move Right")
    end if moveLeft then
        print("Move Left")
    end if moveUp then
        print("Move Up")
    end if moveDown then
        print("Move Down")
    end

    -- Finalised Movement
    if moveRight and moveLeft then
        moveRight, moveLeft = false, false
    end if moveUp and moveDown then
        moveUp, moveDown = false, false
    end

    -- Move Player    
    if moveRight then
        player.x = player.x + 5
    end if moveLeft then
        player.x = player.x - 5
    end if moveUp then
        player.y = player.y - 5
    end if moveDown then
        player.y = player.y + 5
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