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
-- Parameters
------------------------------------------------------------------------------------

local io = require("io")
-- local file = require("file")

local fullw         = display.actualContentWidth
local fullh         = display.actualContentHeight
local cx            = display.contentCenterX
local cy            = display.contentCenterY
local screenX       = display.contentWidth
local screenY       = display.contentHeight

local startX        = cx
local startY        = cy

local adjustX       = screenX/480
local adjustY       = screenY/320



------------------------------------------------------------------------------------
-- Key Runner
------------------------------------------------------------------------------------

-- Detect Keys
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

Runtime:addEventListener("key", onKeyEvent)



------------------------------------------------------------------------------------
-- Player && Physics
------------------------------------------------------------------------------------

-- Player
local player = display.newRect(cx, cy, 100, 100)
physics.addBody(player, "dynamic", { bounce = 0 })

-- Player Properties
player.name = "Player"
player.x = startX
player.y = startY
player.Vx = 0
player.Vy = 0


-- Change Gravity
physics.setGravity(0, 25)

-- Add platform
local platform = display.newRect(cx, cy + 300, 500, 50)
physics.addBody(platform, "static", { bounce = 0 })



------------------------------------------------------------------------------------
-- Camera
------------------------------------------------------------------------------------

local camDiffX = 0
local camDiffY = 0

local function moveCamera()
    -- Center the camera on the player
    camDiffX = cx - player.x
    camDiffY = cy - player.y

    -- followCamForeGrp.x = camDiffX * 1.2
    -- followCamForeGrp.y = camDiffY * 1.2
end

Runtime:addEventListener("enterFrame", moveCamera)



------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------

local jumps = 1

local function ResetJumps()
    print( "collision" )
    if math.floor( player.Vy ) == 0 then
        jumps = 1
        print( "Jump has been reset" )
    end
end

local function Jump()
    if jumps > 0 then
        player:applyLinearImpulse( 0, -1.5, player.x, player.y )
        print( "Player Jumped" )
        jumps = jumps - 1
    -- else
    --     ResetJumps()
    end
end

Runtime:addEventListener("touch", function (event) if event.phase == "began" then Jump() end end)
Runtime:addEventListener("key", function() if pressedKeys["space"] then Jump() end end)
Runtime:addEventListener("enterFrame", ResetJumps)
-- player:addEventListener("enterFrame", ResetJumps)
Runtime:addEventListener("enterFrame", function()
    player.Vx, player.Vy = player:getLinearVelocity()
end)



------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------
local introScreen = {}

function introScreen.Start()
    print("Start Screen Anim")
    -- Animate("add")
    -- Animate("animate")
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return introScreen