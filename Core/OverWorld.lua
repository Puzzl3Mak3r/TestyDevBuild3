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
local followCamBackGrp = display.newGroup() -- Background
local followCamMiddGrp = display.newGroup() -- Middleground
local followCamForeGrp = display.newGroup() -- Foreground
local playing = true


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
-- Move Player
------------------------------------------------------------------------------------

local moveRight, moveLeft = false, false
local moveUp, moveDown = false, false
local pressedKeys = {}

local function keyRunner()
    -- Key Detection
    moveRight, moveLeft, moveUp, moveDown = false, false, false, false
    if pressedKeys["d"] or pressedKeys["right"] then
        moveRight = true
    end if pressedKeys["a"] or pressedKeys["left"] then
        moveLeft = true
    end if pressedKeys["w"] or pressedKeys["up"] then
        moveUp = true
    end if pressedKeys["s"] or pressedKeys["down"] then
        moveDown = true
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
end

-- Key event handler
local function onKeyEvent(event)
    if event.phase == "down" then
        pressedKeys[event.keyName] = true
    elseif event.phase == "up" then
        pressedKeys[event.keyName] = false
    end
end

-- Event listeners
Runtime:addEventListener("enterFrame", keyRunner)
Runtime:addEventListener("key", onKeyEvent)



------------------------------------------------------------------------------------
-- Function Calling
------------------------------------------------------------------------------------

local overworld = {}

function overworld.Start()
    -- call functions from here 
end

return overworld