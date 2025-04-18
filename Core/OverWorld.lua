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



------------------------------------------------------------------------------------
-- Environment
------------------------------------------------------------------------------------

-- Load from file



------------------------------------------------------------------------------------
-- Player
------------------------------------------------------------------------------------

-- Make player
local player = display.newRect(cx, cy, 100, 100)
player:setFillColor(0, 0, 1)



------------------------------------------------------------------------------------
-- Virtual Camera
------------------------------------------------------------------------------------

local camDiffX = 0
local camDiffY = 0
local function moveCamera()
    if playing then
        -- Center the camera on the player
        camDiffX = cx - player.x
        camDiffY = cy - player.y

        -- followCamForeGrp.x = camDiffX * 1.2
        -- followCamForeGrp.y = camDiffY * 1.2

        followCamMiddGrp.x = camDiffX
        followCamMiddGrp.y = camDiffY

        -- followCamBackGrp.x = camDiffX * 0.8
        -- followCamBackGrp.y = camDiffY * 0.8
    end
end

Runtime:addEventListener("enterFrame", moveCamera) -- never got used



------------------------------------------------------------------------------------
-- Move Player -- Virtual Joystick - Inspired by PonyWolf
------------------------------------------------------------------------------------

local leftStickOuter = display.newCircle(cx/3, cy + 300, 130)
local leftStickInner = display.newCircle(cx/3, cy + 300, 50)
leftStickOuter.alpha = 0.5
leftStickInner.alpha = 0.5
leftStickOuter.x, leftStickOuter.y = cx/3, cy + 300


local function axis(event)

    if event.phase == "began" then
        leftStickOuter.x, leftStickOuter.y = event.x, event.y
        leftStickInner.x, leftStickInner.y = event.x, event.y
    end

    -- Small circle
    leftStickInner.x, leftStickInner.y = event.x, event.y

    -- Move outer circle
    -- If exceed 100 or -100 then adjust stick position
    if event.x - leftStickOuter.x > 100 then
        leftStickOuter.x = event.x - 100
    end if event.x - leftStickOuter.x < -100 then
        leftStickOuter.x = event.x + 100
    end

    if event.y - leftStickOuter.y > 100 then
        leftStickOuter.y = event.y - 100
    end if event.y - leftStickOuter.y < -100 then
        leftStickOuter.y = event.y + 100
    end

    -- Reset stick position
    if event.phase == "ended" then
        leftStickOuter.x, leftStickOuter.y = cx/3, cy + 300
        leftStickInner.x, leftStickInner.y = cx/3, cy + 300
        -- moveRight, moveLeft, moveUp, moveDown = false, false, false, false -------- Not used in 360 degrees
    end
end

-- Whenever the left side of the screen is pressed, move thew stick to that location
local leftSideRect = display.newRect( -1.8*cx, -cy/2, cx*3, cy*3)
leftSideRect.anchorX, leftSideRect.anchorY = 0, 0
leftSideRect.alpha = 0.01
leftSideRect:addEventListener("touch", axis)



-- ------------------------------------------------------------------------------------
-- Different movement options
-- ------------------------------------------------------------------------------------

-- Free 360 degree motion
local directionX, directionY, stickDiffX, stickDiffY = 0, 0, 0, 0
Runtime:addEventListener("enterFrame", function()
    -- Find difference
    stickDiffX = leftStickInner.x - leftStickOuter.x
    stickDiffY = leftStickInner.y - leftStickOuter.y

    -- stickDiffX and stickDiffY must not be between 20 and -20
    if stickDiffX > 20 or stickDiffX < -20 or stickDiffY > 20 or stickDiffY < -20 then
        -- Find the angle
        directionX = math.atan2(stickDiffY, stickDiffX)
        directionY = math.atan2(stickDiffY, stickDiffX)

        -- Move Player
        player.x = player.x + math.cos(directionX) * 5
        player.y = player.y + math.sin(directionY) * 5
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