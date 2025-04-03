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

local adjustX       = screenX/480
local adjustY       = screenY/320



------------------------------------------------------------------------------------
-- Player && Physics
------------------------------------------------------------------------------------

-- Player
local player = display.newRect(cx, cy, 100, 100)
physics.addBody(player)


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
-- Function Calling
------------------------------------------------------------------------------------
local introScreen = {}

function introScreen.Start()
    print("Start Screen Anim")
    Animate("add")
    Animate("animate")
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return introScreen