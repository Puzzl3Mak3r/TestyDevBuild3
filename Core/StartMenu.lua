--[[ Parameters ]]--                 =========================================================

local fullw                                  = display.actualContentWidth
local fullh                                  = display.actualContentHeight
local cx                                     = display.contentCenterX
local cy                                     = display.contentCenterY
local screenX                                = display.contentWidth
local screenY                                = display.contentHeight
local left, right                            = false, false
local leftMove, rightMove                    = false, false
local holdingLeft, holdingRight              = false, false
local doubleJump                             = false
local levelchosen                            = ""
local options                                = ""
local platform                                = ""
local spawnX, spawnY                         = cx, cy
local BackGround                             = display.newRect( cx, cy, 3*screenX, 3*screenY)
local velocity                               = 1
local v1, v2, v3                             = false, false, false
local Countv1, Countv2, Countv3              = false, false, false



--[[ PreBuild ]]--                     =========================================================

function PreBuild(placeHolder)

    --[[ DevGround ]]-- =========================================================

    local ground = display.newRect( cx, screenY-30, 2000, 60 )
    physics.addBody( ground, "static", { density=1.0, friction=100, bounce=0} )

    local groundTwo =display.newRect( cx, screenY-80, 500, 180 )
    physics.addBody( groundTwo, "static", { density=1.0, friction=10000, bounce=-300000} )

    options = placeHolder print( "loaded the options" )

end

--[[ Game Code ]]--                    =========================================================


function StartPlayingPlatformer()

    if platform == "mobile" then
        leftArrow =display.newImageRect( 'Assets/Images/UI/playing/arrowLeft.png', 150, 100 )
        rightArrow =display.newImageRect( 'Assets/Images/UI/playing/arrowRight.png', 150, 100 )
        leftArrow.x, leftArrow.y = cx+650,screenY-(cy/2.5)
        rightArrow.x, rightArrow.y = cx-650,screenY-(cy/2.5)
        leftArrow.name,rightArrow.name = "right","left"
    end

    --[[ Player ]]--                 =========================================================

    -- Load the sheets
    local player = display.newRect( cx, cy, 100, 70)
    player.name = "real"
    player.fill = {1,1,0}
    playerVx, playerVy = 0, 0
    physics.addBody( player )
    player.isFixedRotation=true
    player.postCollision = nil


    --[[ Testy Animation ]]-- ========================================================

    local TestyFrameSize =
    {
        width = 605,
        height = 344,
        numFrames = 143
    }

    local TestySheet = graphics.newImageSheet( "Assets/Sprites/Testy.png", TestyFrameSize )

    -- sequences table
    local TestySequences = {
        {
            name="idle",
            frames= { 1 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="hit",
            frames= { 131, 131 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="blink",
            frames= { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="startrun",
            frames= { 12, 13, 14, 15, 16, 17, 18 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="run",
            frames= { 27, 28, 29 }, -- frame indexes of animation, in image sheet
            time = 300,
            loopCount = 7                -- Optional ; default is 0
        },
        {
            name="dash",
            frames= { 40, 41, 42, 43, 44, 45, 46, 47, 48 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="jump",
            frames= { 53, 54 }, -- frame indexes of animation,     in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0 
        },
        {
            name="startJump",
            frames= { 66, 67, 68, 69, 70 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="fall",
            frames= { 79, 80 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1         -- Optional ; default is 0
        },
        {
            name="startFall",
            frames= { 92, 93, 94, 95 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        },
        {
            name="highjump",
            frames= { 105, 106 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 0                -- Optional ; default is 0
        },
        {
            name="startHighjump",
            frames= { 54, 105, 106 }, -- frame indexes of animation, in image sheet
            time = 100,
            loopCount = 1                -- Optional ; default is 0
        }
    }

    local newPlayer = display.newSprite( TestySheet, TestySequences )


    newPlayer:setSequence("idle")
    newPlayer:play()
    newPlayer.xScale, newPlayer.yScale = 0.3,0.3
    player.alpha = 0


    --[[ Main Level Functions ]]-- ===================================================

    -- Make the player jump
    local jumps = 0

    local function ResetJumps()
        if playerVy == 0 then
            jumps = 1
            print( "Jump has been reset" )
        end
    end

    local function Jump( event )
        if platform == "mobile" then
            if(event.phase == "began") then
                if ((holdingLeft or holdingRight)== false) then
                    if jumps == 1 then
                        player:setLinearVelocity(0,-270)
                        print( "Player Jumped" )
                        jumps = jumps - 1
                    else
                        ResetJumps()
                    end
                end
            end
        else
            if jumps == 1 then
                player:setLinearVelocity(0,-270)
                print( "Player Jumped" )
                jumps = jumps - 1
            else
                ResetJumps()
            end
        end
    end

    -- Moving left & right
    local count = 0
    local function delayVelocity()
        count = count + 1
        -- To delay because this function is called ~30 times a second
        if count == 33 then
            count = 0
            -- slowly increasing the velocity
            if v1 == false then
                v1 = true
            elseif v2 == false then
                v2 = true
            elseif v3 == false then
                v3 = true
            end
        end
    end

    local function startVelocity()
        -- delaying, so not updating ~30 times 
        delayVelocity()
        if velocity == 2.5 then
            -- do nothing
        elseif v3 then
            velocity = 2.5
            print( 'changed velocity to 2.5' )
        elseif v2 then
            velocity = 2
            print( 'changed velocity to 2' )
        elseif v1 then
            velocity = 1.5
            print( 'changed velocity to 1.5' )
        else
            velocity = 1.1
            print( 'changed velocity to 1.1' )
        end
    end

    local function resetVelocity()
        v1, v2, v3 = false, false, false
        velocity = 1
        print( 'changed velocity to 1' )
    end

    local function moveLeft()
        player.x = player.x - (3*velocity)
        newPlayer.xScale = -0.3
        print( "moved left" )
    end
    local function moveRight()
        player.x = player.x + (3*velocity)
        newPlayer.xScale = 0.3
        print( "moved right" )
    end

    local function playerLeftRight()
        newPlayer:setSequence("run")
        newPlayer:play()
    end

    local alreadyMoving = false
    local function falling()
        -- Falling animation
        if ( playerMoving ) then
            if playerMoving then
                if alreadyMoving == false then
                    alreadyMoving = true
                    playerLeftRight()
                end
            end
        else
            alreadyMoving = false
            if (playerVy >= 0) then
                newPlayer:setSequence("fall")
                newPlayer:play("fall")
            end
            if (playerVy <= 0) then
                newPlayer:setSequence("jump")
                newPlayer:play("jump")
            end
            if (playerVy == 0) then
                newPlayer:setSequence("idle")
                newPlayer:play("idle")
            end
        end
    end

    local function moveTesty()
        if holdingLeft and holdingRight then
            playerMoving = false
        elseif holdingLeft then
            moveLeft()
            startVelocity()
        elseif holdingRight then
            moveRight()
            startVelocity()
        end
    end

    local function ConfirmTouch(event)
        if(event.phase == "moved" or event.phase == "began")then
            if (event.target.name == "left") then
                holdingLeft, playerMoving = true, true
            elseif (event.target.name == "right") then
                holdingRight, playerMoving = true, true
            end
            print("touched")
        end
        if(event.phase == "ended")then
            resetVelocity()
            holdingLeft, holdingRight = false, false
            -- newPlayer:setSequence("idle")
            -- newPlayer:play()
        end
    end

    -- [[ Set variables for player velocities ]] -- ==================================
    local function WhenPlaying()
        newPlayer.x,newPlayer.y=player.x,(player.y - 8 )
        playerVx, playerVy = player:getLinearVelocity()
    end


    -- [[ PC controls ]]

    local function onEnterFrame(event)
        if pressedKeys["w"] then
            Jump()
        end
        if pressedKeys["a"] and pressedKeys["d"] then
            playerMoving = false
            if velocity ~= 1 then resetVelocity() end
        elseif pressedKeys["a"] then
            playerMoving = true
            moveLeft()
            startVelocity()
        elseif pressedKeys["d"] then
            playerMoving = true
            moveRight()
            startVelocity()
        elseif not pressedKeys["a"] and not pressedKeys["d"] then
            playerMoving = false
            if velocity ~= 1 then resetVelocity() end
        end
    end
    pressedKeys = {}
    function onKeyEvent(event)
        if event.phase == "down" then
            pressedKeys[event.keyName] = true
        elseif event.phase == "up" then
            pressedKeys[event.keyName] = false
        else
            pressedKeys[event.keyName] = false
        end
    end


    --[[ Delays And Listeners ]]-- ===================================================
    Runtime:addEventListener("enterFrame", WhenPlaying )
    Runtime:addEventListener("enterFrame", falling )


    if platform == "mobile" then
        BackGround:addEventListener( "touch", Jump )
        rightArrow:addEventListener( "touch", ConfirmTouch )
        leftArrow:addEventListener( "touch", ConfirmTouch )
        Runtime:addEventListener( "enterFrame", moveTesty )

        -- rightArrow:addEventListener("touch", ConfirmTouch)
        -- leftArrow:addEventListener("touch", ConfirmTouch)
    end
    -- if platform == "pc" then 
    if platform == true then 
            Runtime:addEventListener( "enterFrame", onEnterFrame )
            Runtime:addEventListener( "key", onKeyEvent )

    end
end

--==============================================================================
-- local PlayLevel = {}

-- function PlayLevel.Start()
--     PreBuild(placeHolder)
--     StartPlayingPlatformer()
-- end

-- function PlayLevel.PC()
--     platform = "pc"
-- end

-- function PlayLevel.MOBILE()
--     platform = "mobile"      
-- end

-- function PlayLevel.Stop()
--     StartPlayingPlatformer()
-- end

-- return PlayLevel -- Need to return or Solar2D will run into errors. It's not realy returning anything












local StartMenu = {}

function StartMenu.Start()
    print("Hello World")
    PreBuild(placeHolder)
    StartPlayingPlatformer()
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return StartMenu