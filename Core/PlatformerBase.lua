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
local physics = require('physics')
physics.start()
physics.setGravity(0, 50)
-- physics.setDrawMode('hybrid')

-- Buttons, Joysticks, Mouse and Keyboard Variables
local leftMiddlePartOfScreen = display.newRect(fx/4,cy,fx*3/4,fy*1.5)
leftMiddlePartOfScreen.alpha = 0.01 -- It wont work if isVisible is false
local pressedKeys = {}

-- Groups
local cameraGroup = display.newGroup()
cameraGroup.x, cameraGroup.y = cx, cy

-- Other
local hasDashed = false
local isDashing = false
local dashDuration = 100  -- milliseconds
local dashSpeed = 1000
local maxJumps = 3
local jumps = maxJumps
local stillTouchingGround = false
local facingRight = true

-- PC only
local jumping = false -- idk how tf this is working with this but it works

-- Mobile only



------------------------------------------------------------------------------------
-- Ground Platform(s)
------------------------------------------------------------------------------------

-- First one is for display
local ground = display.newRect(cx, cy + 300, 600, 60)
cameraGroup:insert(ground)
ground:setFillColor(0.3)
physics.addBody(ground, 'static', {bounce = 0})
ground.isSolid = true

-- Second is for reseting jumps, dashes, etc
local groundWithReset = display.newRect(cx, cy + 271, 590, 2)
cameraGroup:insert(groundWithReset)
physics.addBody( groundWithReset, 'static', {bounce = 0})
groundWithReset.isSolid = true
groundWithReset.objectType = 'ground'
groundWithReset.isVisible = false -- makes it invisible without the 0 alpha problem



------------------------------------------------------------------------------------
-- Player
------------------------------------------------------------------------------------

local player = display.newRect(cx, cy+50, 50, 50)
cameraGroup:insert(player)
player:setFillColor(0.1, 0.6, 1)
physics.addBody(player, 'dynamic', {bounce = 0, friction = 1})
player.isGrounded = false
player.isFixedRotation = true
local Vx, Vy = 0, 0 -- Velocity
local left, right = false, false



------------------------------------------------------------------------------------
-- Camera
------------------------------------------------------------------------------------

-- Follow Player
local followObject = display.newCircle(0, 0, 50)
cameraGroup:insert(followObject)
followObject.x, followObject.y = player.x, player.y
followObject.alpha = 0.3
-- followObject.isVisible = false -- disable in debug
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

Runtime:addEventListener('enterFrame', followPlayer)



------------------------------------------------------------------------------------
-- Functions Pt 1 -- Universal Functions
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
---- Grounding Check and Reset

-- Pre Collision Reset
function onPreCollision(event)
    if event.contact.isTouching and event.other.objectType == 'ground' then
        print('touching ground')
        hasDashed = false
    end
    print('pre collision')
end

-- On Collision Reset
local function onCollision(event)
    if event.other.objectType == 'ground' and event.other.isSolid == true then
        if event.phase == 'ended' then
            -- Player is not grounded
            player.isGrounded = false
            stillTouchingGround = false
        elseif event.phase == 'began' then
            -- Player is grounded
            player.isGrounded = true
            stillTouchingGround = true
            -- Resets
            jumps = maxJumps
        end
        print(event.phase)
    end
end

player:addEventListener('preCollision', onPreCollision)
player:addEventListener('collision', onCollision)



------------------------------------------------------------------------------------
---- Keep track of Velocity and Resets

local function keepTrackOfVelocity()
    -- Velocity
    Vx, Vy = player:getLinearVelocity()
    -- Resets
    if stillTouchingGround and not jumping then
        hasDashed = false
        jumps = maxJumps
    end
end
Runtime:addEventListener('enterFrame', keepTrackOfVelocity)



------------------------------------------------------------------------------------
---- Key Event handler (PC) but can be used for emulators ig

local function onKeyEvent(event)
    if event.phase == 'down' then
        pressedKeys[event.keyName] = true
    elseif event.phase == 'up' then
        pressedKeys[event.keyName] = false
    end
end

Runtime:addEventListener('key', onKeyEvent)





-- $$$$$$$\   $$$$$$\  
-- $$  __$$\ $$  __$$\ 
-- $$ |  $$ |$$ /  \__|
-- $$$$$$$  |$$ |      
-- $$  ____/ $$ |      
-- $$ |      $$ |  $$\ 
-- $$ |      \$$$$$$  |
-- \__|       \______/ 
-- Enable for using & building to PC





------------------------------------------------------------------------------------
-- Functions Pt 2 -- PC Functions
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
---- Jumping

local function jump()
    if isDashing then
        -- Interrupt dash immediately
        isDashing = false
        player.gravityScale = 1
    end

    if jumps >= 1 then -- allow jumping any time if you want (remove this `or true` if not)
        player:setLinearVelocity(0, -500)
        player.isGrounded = false
        jumps = jumps - 1
        print('jumping now false')
    end
end

local function jumpPC(event)
    if event.phase == 'down' and event.keyName == 'z' then
        jump()
        jumping = true
        print('jumping now true')
    end

    -- -- Cut jump short when releasing space -- cancelled bcos we cant do on mobile
    -- if event.phase == 'up' and event.keyName == 'z' and Vy < -0.5 then
    --     player:setLinearVelocity(0, -0.5)
    -- end
end

Runtime:addEventListener('key', jumpPC)



------------------------------------------------------------------------------------
---- Moving Left / Right

local function movePlayer()
    -- Dont move if both pressed
    if left and right then
        left, right = false, false
    end

    -- Move Left / Right
    if left then
        player.x = player.x - 7
        facingRight = false
    elseif right then
        player.x = player.x + 7
        facingRight = true
    end
    left, right = false, false

    if pressedKeys['left'] --[[ or pressedKeys['a'] ]] then
        left = true
    end
    if pressedKeys['right'] --[[ or pressedKeys['d'] ]] then
        right = true
    end
end

Runtime:addEventListener('enterFrame', movePlayer)



------------------------------------------------------------------------------------
---- Dashing

local function dash()
    if isDashing or hasDashed then return end

    isDashing = true
    hasDashed = true

    -- Get current velocity
    local cachVx, cachVy = player:getLinearVelocity()

    -- Determine dash direction
    local direction = -1
    if facingRight then
        direction = 1
    end

    print('dashing now true')

    -- Temporarily disable gravity for a smoother dash
    player.gravityScale = 0
    player:setLinearVelocity(dashSpeed * direction, 0)

    -- End dash after a short burst
    timer.performWithDelay(dashDuration, function()
        if isDashing then
            isDashing = false
            player.gravityScale = 1
            player:setLinearVelocity(cachVx, cachVy)
            cachVx, cachVy = nil, nil
        end
    end)
end

local function dashPC(event)
    if event.phase == 'down' and event.keyName == 'x' then
        dash()
        print ('Dashing')
    end
end

Runtime:addEventListener('key', dashPC)





-- -- $$\      $$\           $$\       $$\ $$\           
-- -- $$$\    $$$ |          $$ |      \__|$$ |          
-- -- $$$$\  $$$$ | $$$$$$\  $$$$$$$\  $$\ $$ | $$$$$$\  
-- -- $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$ |$$ |$$  __$$\ 
-- -- $$ \$$$  $$ |$$ /  $$ |$$ |  $$ |$$ |$$ |$$$$$$$$ |
-- -- $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$ |$$ |$$   ____|
-- -- $$ | \_/ $$ |\$$$$$$  |$$$$$$$  |$$ |$$ |\$$$$$$$\ 
-- -- \__|     \__| \______/ \_______/ \__|\__| \_______|
-- -- Enable for using & building to Mobile





-- ------------------------------------------------------------------------------------
-- -- Functions Pt 2 -- Mobile Functions
-- ------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------
-- ---- Jumping

-- local jumpButton = display.newCircle(fx*3/4, fy*3/4, 70)
-- local jumpButtonPressed = false
-- jumpButton.alpha = 0.7
-- local function jump()
--     if player.isGrounded then
--         jumps = maxJumps
--         player.isGrounded = false -- Prevent re-jumping until grounded again
--     end
--     if jumps >= 1 then
--         player:setLinearVelocity(Vx, 2) -- idk its mobile
--         player:applyLinearImpulse(0, -0.5, player.x, player.y)
--     end
-- end



-- ------------------------------------------------------------------------------------
-- ---- Moving Left / Right

-- local function movePlayer()
--     -- Move Left / Right
--     if left then
--         player.x = player.x - amountToMove
--     elseif right then
--         player.x = player.x + amountToMove
--     end
-- end

-- Runtime:addEventListener('enterFrame', movePlayer)



-- ------------------------------------------------------------------------------------
-- ---- Jumping

-- -- Button to jump
-- function jumpMobile (event)
--     if event.phase == 'began' then
--         jumpButtonPressed = true
--         jump()
--         jumpButton.alpha = 0.4
--     end
--     if event.phase == 'ended' then
--         jumpButtonPressed = false
--         -- -- Cut jump short when button released -- Cancelled after testing
--         -- if Vy < -0.5 then
--         --     player:setLinearVelocity(0, -0.5)
--         -- end
--         jumpButton.alpha = 0.7
--     end
-- end
-- jumpButton:addEventListener('touch', jumpMobile)

-- -- Joystick to move
-- local joystickInner = display.newCircle(fx/4, fy*3/4, 50)
-- local joystickOuter = display.newCircle(fx/4, fy*3/4, 100)
-- joystickInner.alpha = 0.5
-- joystickOuter.alpha = 0.5

-- local function axis(event)
--     -- Check if the touch is not too much on the right side
--     if event.x > cx then
--         -- Return joystick to idle
--         if event.phase == 'ended' then
--             joystickOuter.x, joystickOuter.y = fx/4, fy*3/4
--             joystickInner.x, joystickInner.y = fx/4, fy*3/4
--             right, left = false, false
--         end

--         -- print ('Too far right')
--         return
--     else
--         -- print ('Not too far right')

--         if event.phase == 'began' then
--             joystickOuter.x, joystickOuter.y = event.x, event.y
--             joystickInner.x, joystickInner.y = event.x, event.y
--         end

--         -- Small circle
--         joystickInner.x, joystickInner.y = event.x, event.y

--         -- If exceed 100 or -100 at an angle then adjust stick position
--         local dx, dy = event.x - joystickOuter.x, event.y - joystickOuter.y
--         local distance = math.sqrt(dx * dx + dy * dy)

--         if distance > 100 then
--             local angle = math.atan2(dy, dx)
--             joystickOuter.x = event.x - math.cos(angle) * 100
--             joystickOuter.y = event.y - math.sin(angle) * 100
--         end

--         -- Determine which way the player should move
--         if event.x < joystickOuter.x then
--             left = true
--             facingRight = false
--         elseif event.x > joystickOuter.x then
--             right = true
--             facingRight = true
--         else
--             left, right = false, false
--         end

--         -- Calculate how much to move
--         amountToMove = (math.abs(event.x - joystickOuter.x) / 10)

--         -- Dont move player if increments are very small
--         if amountToMove < 2 then
--             left, right = false, false
--             amountToMove = 0
--         end

--         -- Return joystick to idle
--         if event.phase == 'ended' then
--             joystickOuter.x, joystickOuter.y = fx/4, fy*3/4
--             joystickInner.x, joystickInner.y = fx/4, fy*3/4
--             right, left = false, false
--         end
--     end
-- end
-- leftMiddlePartOfScreen:addEventListener('touch', axis)

-- ------------------------------------------------------------------------------------
-- ---- Dashing

-- local dashButton = display.newCircle((fx*3/4) + 110, (fy*3/4) - 110, 50)
-- dashButton.alpha = 0.7
-- local function dash()

--     if isDashing or hasDashed then return end

--     isDashing = true
--     hasDashed = true

--     -- Get current velocity
--     local cachVx, cachVy = player:getLinearVelocity()

--     -- Determine dash direction
--     local direction = -1
--     if facingRight then
--         direction = 1
--     end

--     -- Temporarily disable gravity for a better dash
--     player.gravityScale = 0
--     player:setLinearVelocity(dashSpeed * direction, 0)

--     -- End dash after a short burst
--     timer.performWithDelay(dashDuration, function()
--         if isDashing then
--             isDashing = false
--             player.gravityScale = 1
--             player:setLinearVelocity(cachVx, cachVy)
--             cachVx, cachVy = nil, nil
--         end
--     end)
-- end

-- local function dashMobile(event)
--     if event.phase == 'began' then
--         dashButton.alpha = 0.4
--     end
--     if event.phase == 'ended' then
--         dash()
--         dashButton.alpha = 0.7
--     end
-- end

-- dashButton:addEventListener('touch', dashMobile)



------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------

local platforming = {}

function platforming.Start()
    print('Platforming')
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return platforming