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
-- Requirements
------------------------------------------------------------------------------------

local physics = require("physics")
physics.start()
physics.setGravity(0, 50)



------------------------------------------------------------------------------------
-- Display Constants
------------------------------------------------------------------------------------

local cx, cy = display.contentCenterX, display.contentCenterY
local screenX, screenY = display.contentWidth, display.contentHeight



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
ground.name = "ground"



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
        if event.other.name == "ground" then
            player.isGrounded = true
        end
    elseif event.phase == "ended" then
        if event.other.name == "ground" then
            player.isGrounded = false
        end
    end
end
player:addEventListener("collision", onCollision)



------------------------------------------------------------------------------------
-- Jumping Logic
------------------------------------------------------------------------------------

local function jump()
    if player.isGrounded then
        player:applyLinearImpulse(0, -0.5, player.x, player.y)
        player.isGrounded = false -- Prevent re-jumping until grounded again
    end
end

-- Touch to jump
Runtime:addEventListener("touch", function(event)
    if event.phase == "began" then
        jump()
    end
end)

-- Spacebar to jump
Runtime:addEventListener("enterFrame", function()
    if pressedKeys["space"] then
        jump()
        pressedKeys["space"] = false -- prevent holding space
    end
end)



------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------

local platforming = {}

function platforming.Start()
    print("Platforming")
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return platforming