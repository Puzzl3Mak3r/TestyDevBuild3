-- $$$$$$$\  $$\            $$\      $$$$$$\                                   $$\                         $$\                          
-- $$  __$$\ $$ |           $$ |    $$  __$$\                                  \__|                        $$ |                         
-- $$ |  $$ |$$ | $$$$$$\ $$$$$$\   $$ /  \__|$$$$$$\   $$$$$$\  $$$$$$\$$$$\  $$\ $$$$$$$\   $$$$$$\      $$ |     $$\   $$\  $$$$$$\  
-- $$$$$$$  |$$ | \____$$\\_$$  _|  $$$$\    $$  __$$\ $$  __$$\ $$  _$$  _$$\ $$ |$$  __$$\ $$  __$$\     $$ |     $$ |  $$ | \____$$\ 
-- $$  ____/ $$ | $$$$$$$ | $$ |    $$  _|   $$ /  $$ |$$ |  \__|$$ / $$ / $$ |$$ |$$ |  $$ |$$ /  $$ |    $$ |     $$ |  $$ | $$$$$$$ |
-- $$ |      $$ |$$  __$$ | $$ |$$\ $$ |     $$ |  $$ |$$ |      $$ | $$ | $$ |$$ |$$ |  $$ |$$ |  $$ |    $$ |     $$ |  $$ |$$  __$$ |
-- $$ |      $$ |\$$$$$$$ | \$$$$  |$$ |     \$$$$$$  |$$ |      $$ | $$ | $$ |$$ |$$ |  $$ |\$$$$$$$ |$$\ $$$$$$$$\\$$$$$$  |\$$$$$$$ |
-- \__|      \__| \_______|  \____/ \__|      \______/ \__|      \__| \__| \__|\__|\__|  \__| \____$$ |\__|\________|\______/  \_______|
--                                                                                           $$\   $$ |                                 
--                                                                                           \$$$$$$  |                                 
--                                                                                            \______/                                  



------------------------------------------------------------------------------------
-- Important
------------------------------------------------------------------------------------

-- Screen Variables
local cx, cy = display.contentCenterX, display.contentCenterY
local fx, fy = display.contentWidth, display.contentHeight

-- Physics
local physics = require("physics")
physics.start()
physics.setGravity(0, 50)
physics.setDrawMode("hybrid")

-- Buttons, Joysticks, Mouse and Keyboard Variables
local pressedKeys = {}
local left, right = false, false
local amountToMove = 0


------------------------------------------------------------------------------------
-- Input Tracking
------------------------------------------------------------------------------------

local pressedKeys = {}
local function onKeyEvent(event)
    if event.phase == "down" then
        pressedKeys[event.keyName] = true
    elseif event.phase == "up" then
        pressedKeys[event.keyName] = false
    end
    return false
end
Runtime:addEventListener("key", onKeyEvent)



------------------------------------------------------------------------------------
-- Ground Platform
------------------------------------------------------------------------------------

local ground = display.newRect(cx, cy + 300, 600, 60)
ground:setFillColor(0.3)
physics.addBody(ground, "static", {bounce = 0})
ground.objectType = "ground"



------------------------------------------------------------------------------------
-- Player
------------------------------------------------------------------------------------

local player = display.newRect(cx, cy, 50, 50)
player:setFillColor(0.1, 0.6, 1)
physics.addBody(player, "dynamic", {bounce = 0, friction = 1})
player.isGrounded = false
player.isFixedRotation = true



------------------------------------------------------------------------------------
-- Ground Detection
------------------------------------------------------------------------------------

local function onCollision(event)
    if event.phase == "began" then
        if event.other.objectType == "ground" then
            player.isGrounded = true
        end
    elseif event.phase == "ended" then
        if event.other.objectType == "ground" then
            player.isGrounded = false
        end
    end
end
player:addEventListener("collision", onCollision)



------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------

-- Jumping
local function jump()
    if player.isGrounded then
        player:applyLinearImpulse(0, -0.5, player.x, player.y)
        player.isGrounded = false -- Prevent re-jumping until grounded again
    end
end

-- Moving Left/Right
local function movePlayer()
    if left and right then
        left, right = false, false
    end

    -- -- PC
    -- if left then
    --     player.x = player.x - 5
    -- elseif right then
    --     player.x = player.x + 5
    -- end

    -- Mobile
    if left then
        player.x = player.x - amountToMove
    elseif right then
        player.x = player.x + amountToMove
    end
end

-- Joystick for Mobile
local joystickInner = display.newCircle(fx/4, fy*3/4, 50)
local joystickOuter = display.newCircle(fx/4, fy*3/4, 100)
joystickInner.alpha = 0.5
joystickOuter.alpha = 0.5

local function axis(event)
    -- Check if the touch is not too much on the right side
    if event.x > cx + 100 then
        -- Return joystick to idle
        if event.phase == "ended" then
            joystickOuter.x, joystickOuter.y = fx/4, fy*3/4
            joystickInner.x, joystickInner.y = fx/4, fy*3/4
            right, left = false, false
        end
        
        print ("Too far right")
        return
    else
        print ("Not too far right")
    end
    if event.phase == "began" then
        joystickOuter.x, joystickOuter.y = event.x, event.y
        joystickInner.x, joystickInner.y = event.x, event.y
    end

    -- Small circle
    joystickInner.x, joystickInner.y = event.x, event.y

    -- If exceed 100 or -100 at an angle then adjust stick position
    local dx, dy = event.x - joystickOuter.x, event.y - joystickOuter.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 100 then
        local angle = math.atan2(dy, dx)
        joystickOuter.x = event.x - math.cos(angle) * 100
        joystickOuter.y = event.y - math.sin(angle) * 100
    end

    -- Determine which way the player should move
    if event.x < joystickOuter.x then
        left = true
    elseif event.x > joystickOuter.x then
        right = true
    else
        left, right = false, false
    end

    -- Calculate how much to move
    amountToMove = (math.abs(event.x - joystickOuter.x) / 10)

    -- Dont move player if increments are very small
    if amountToMove < 2 then
        left, right = false, false
        amountToMove = 0
    end

    -- Return joystick to idle
    if event.phase == "ended" then
        joystickOuter.x, joystickOuter.y = fx/4, fy*3/4
        joystickInner.x, joystickInner.y = fx/4, fy*3/4
        right, left = false, false
    end
end
Runtime:addEventListener("touch", axis)
Runtime:addEventListener("enterFrame", movePlayer)



------------------------------------------------------------------------------------
-- Inputs && Actions
------------------------------------------------------------------------------------

-- Jumping
-- -- Mobile
Runtime:addEventListener("touch", function(event)
    if event.phase == "began" then
        jump()
    end
end)

-- -- PC
Runtime:addEventListener("enterFrame", function()
    if pressedKeys["space"] then
        jump()
        pressedKeys["space"] = false -- prevent holding space
    end
end)

-- Moving Left/Right
-- -- Mobile

------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------

local platforming = {}

function platforming.Start()
    print("Platforming")
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return platforming