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
-- physics.setDrawMode("hybrid")

-- Buttons, Joysticks, Mouse and Keyboard Variables
local leftMiddlePartOfScreen = display.newRect(fx/4,cy,fx*3/4,fy*1.5)
leftMiddlePartOfScreen.alpha = 0.01
local pressedKeys = {}
local amountToMove = 0

-- Groups
local cameraGroup = display.newGroup()
cameraGroup.x, cameraGroup.y = cx, cy



-- ------------------------------------------------------------------------------------
-- -- Input Tracking
-- ------------------------------------------------------------------------------------

-- local function onKeyEvent(event)
--     if event.phase == "down" then
--         pressedKeys[event.keyName] = true
--     elseif event.phase == "up" then
--         pressedKeys[event.keyName] = false
--     end
--     return false
-- end
-- Runtime:addEventListener("key", onKeyEvent)



------------------------------------------------------------------------------------
-- Ground Platform
------------------------------------------------------------------------------------

local ground = display.newRect(cx, cy + 300, 600, 60)
cameraGroup:insert(ground)
ground:setFillColor(0.3)
physics.addBody(ground, "static", {bounce = 0})
ground.objectType = "ground"



------------------------------------------------------------------------------------
-- Player
------------------------------------------------------------------------------------

local player = display.newRect(cx, cy, 50, 50)
cameraGroup:insert(player)
player:setFillColor(0.1, 0.6, 1)
physics.addBody(player, "dynamic", {bounce = 0, friction = 1})
player.isGrounded = false
player.isFixedRotation = true
local Vx, Vy = 0, 0 -- Velocity
local left, right = false, false
local facingRight = true



------------------------------------------------------------------------------------
-- Camera
------------------------------------------------------------------------------------

-- Follow Player
local followObject = display.newCircle(0, 0, 50)
cameraGroup:insert(followObject)
followObject.x, followObject.y = player.x, player.y
followObject.alpha = 0.3
followObject.fill = {1,1,0}

-- Some Variables
local diffX, diffY = 0, 0

local function followPlayer()
    -- Continuosly get closer to the player
    diffX = player.x - followObject.x
    diffY = player.y - followObject.y
    followObject.x = followObject.x + (diffX * 0.15)
    followObject.y = followObject.y + (diffY * 0.15)

    -- Center the camera on the player (and reuse diffX and diffY)
    diffX = cx - followObject.x
    diffY = cy - followObject.y

    cameraGroup.x = diffX
    cameraGroup.y = diffY
end

Runtime:addEventListener("enterFrame", followPlayer)



------------------------------------------------------------------------------------
-- Functions Pt 1 -- Universal Functions
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
---- Grounding Check

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
---- Keep track of Velocity

local function keepTrackOfVelocity()
    Vx, Vy = player:getLinearVelocity()
end
Runtime:addEventListener("enterFrame", keepTrackOfVelocity)



------------------------------------------------------------------------------------
---- Key Event handler (PC) but can be used for emulators ig

local function onKeyEvent(event)
    if event.phase == "down" then
        pressedKeys[event.keyName] = true
    elseif event.phase == "up" then
        pressedKeys[event.keyName] = false
    end
end

Runtime:addEventListener("key", onKeyEvent)





-- -- $$$$$$$\   $$$$$$\  
-- -- $$  __$$\ $$  __$$\ 
-- -- $$ |  $$ |$$ /  \__|
-- -- $$$$$$$  |$$ |      
-- -- $$  ____/ $$ |      
-- -- $$ |      $$ |  $$\ 
-- -- $$ |      \$$$$$$  |
-- -- \__|       \______/ 





-- ------------------------------------------------------------------------------------
-- -- Functions Pt 2 -- PC Functions
-- ------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------
-- ---- Jumping

-- local function jump()
--     if player.isGrounded then
--         player:applyLinearImpulse(0, -0.5, player.x, player.y)
--         player.isGrounded = false -- Prevent re-jumping until grounded again
--     end
-- end



-- ------------------------------------------------------------------------------------
-- ---- Moving Left / Right

-- local function movePlayer()
--     -- Dont move if both pressed
--     if left and right then
--         left, right = false, false
--     end

--     -- Move Left / Right
--     if left then
--         player.x = player.x - 7
--     elseif right then
--         player.x = player.x + 7
--     end
--     left, right = false, false
-- end

-- Runtime:addEventListener("enterFrame", movePlayer)



-- ------------------------------------------------------------------------------------
-- ---- Jumping

-- -- Z to jump
-- local function jumpPC()
--     if pressedKeys["z"] then
--         jump()
--         -- pressedKeys["z"] = false -- prevent holding space
--     end

--     -- Cut jump short when releasing space
--         if Vy < -0.5 and not pressedKeys["z"] then
--             player:setLinearVelocity(0, -0.5)
--         end
-- end
-- Runtime:addEventListener("enterFrame", jumpPC)


-- ------------------------------------------------------------------------------------
-- ---- Moving Left/Right

-- -- PC - Left & Right arrow keys
-- local function keyRunner()
--     if pressedKeys["left"] or pressedKeys["a"] then
--         left = true
--     end
--     if pressedKeys["right"] or pressedKeys["d"] then
--         right = true
--     end
-- end
-- Runtime:addEventListener("enterFrame", keyRunner)





-- $$\      $$\           $$\       $$\ $$\           
-- $$$\    $$$ |          $$ |      \__|$$ |          
-- $$$$\  $$$$ | $$$$$$\  $$$$$$$\  $$\ $$ | $$$$$$\  
-- $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$ |$$ |$$  __$$\ 
-- $$ \$$$  $$ |$$ /  $$ |$$ |  $$ |$$ |$$ |$$$$$$$$ |
-- $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$ |$$ |$$   ____|
-- $$ | \_/ $$ |\$$$$$$  |$$$$$$$  |$$ |$$ |\$$$$$$$\ 
-- \__|     \__| \______/ \_______/ \__|\__| \_______|





------------------------------------------------------------------------------------
-- Functions Pt 2 -- Mobile Functions
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
---- Jumping


local jumpButton = display.newCircle(fx*3/4, fy*3/4, 70)
local jumpButtonPressed = false
jumpButton.alpha = 0.7
local function jump()
    if player.isGrounded then
        player:applyLinearImpulse(0, -0.5, player.x, player.y)
        player.isGrounded = false -- Prevent re-jumping until grounded again
    end
    -- Keep jumping when touching ground and button held down
    if player.isGrounded and jumpButtonPressed then
        player:applyLinearImpulse(0, -0.5, player.x, player.y)
    end
end



------------------------------------------------------------------------------------
---- Moving Left / Right

local function movePlayer()
    -- Move Left / Right
    if left then
        player.x = player.x - amountToMove
    elseif right then
        player.x = player.x + amountToMove
    end
end

Runtime:addEventListener("enterFrame", movePlayer)



------------------------------------------------------------------------------------
---- Jumping

-- Button to jump
function jumpMobile (event)
    if event.phase == "began" then
        jumpButtonPressed = true
        jump()
        jumpButton.alpha = 0.4
    end
    if event.phase == "ended" then
        jumpButtonPressed = false
        -- Cut jump short when button released
        if Vy < -0.5 then
            player:setLinearVelocity(0, -0.5)
        end
        jumpButton.alpha = 0.7
    end
end
jumpButton:addEventListener("touch", jumpMobile)


-- Joystick to move
local joystickInner = display.newCircle(fx/4, fy*3/4, 50)
local joystickOuter = display.newCircle(fx/4, fy*3/4, 100)
joystickInner.alpha = 0.5
joystickOuter.alpha = 0.5

local function axis(event)
    -- Check if the touch is not too much on the right side
    if event.x > cx then
        -- Return joystick to idle
        if event.phase == "ended" then
            joystickOuter.x, joystickOuter.y = fx/4, fy*3/4
            joystickInner.x, joystickInner.y = fx/4, fy*3/4
            right, left = false, false
        end

        -- print ("Too far right")
        return
    else
        -- print ("Not too far right")

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
end
leftMiddlePartOfScreen:addEventListener("touch", axis)




------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------

local platforming = {}

function platforming.Start()
    print("Platforming")
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return platforming