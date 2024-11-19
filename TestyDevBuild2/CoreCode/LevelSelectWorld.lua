-- OVERWORLD CODE!!!!!
local require = require
io.output():setvbuf("no")
display.setStatusBar  (display.HiddenStatusBar)
local physics = require "physics"
physics.start()
physics.setGravity(0, 0)
-- require "extensions.string"
-- require "extensions.io"
-- require "extensions.table"
-- require "extensions.math"
-- require "extensions.display"
local platform          = ""
local fullw             = display.actualContentWidth
local fullh             = display.actualContentHeight
local cx                = display.contentCenterX
local cy                = display.contentCenterY
local spawnX, spanwnY   = cx, cy
local Speed             = 4 -- Changes speed of player movement
local pressedKeys       = {}

-- [[ Camera ]] -- Made by Gymbyl, tysm
local perspective       = require("CoreCode.Perspective.perspective") -- VIRTUAL CAMERA WHOOOOOO
local camera            = perspective.createView()

-- [[ Player Animation ]]
function animatedPositioning()
    newPlayer.x = LevelPlayer.x
    newPlayer.y = LevelPlayer.y
    camera:trackFocus()
end

-- [[ Player Movement ]]

-- [[ PC controls ]]

function startLevel()

end

local function onEnterFrame(event)-- Up and Down
    if (pressedKeys["w"] and pressedKeys["s"]) or (pressedKeys["up"] and pressedKeys["down"]) or (pressedKeys["up"] and pressedKeys["s"]) or (pressedKeys["down"] and pressedKeys["w"]) then
    elseif pressedKeys["w"] or pressedKeys["up"] then
        LevelPlayer.y = LevelPlayer.y - Speed
    elseif pressedKeys["s"] or pressedKeys["down"] then
        LevelPlayer.y = LevelPlayer.y + Speed
    end

    -- Left and Right
    if (pressedKeys["a"] and pressedKeys["d"]) or (pressedKeys["left"] and pressedKeys["right"]) or (pressedKeys["a"] and pressedKeys["right"]) or (pressedKeys["d"] and pressedKeys["left"]) then
    elseif pressedKeys["a"] or pressedKeys["left"] then
        LevelPlayer.x = LevelPlayer.x - Speed
    elseif pressedKeys["d"] or pressedKeys["right"] then
        LevelPlayer.x = LevelPlayer.x + Speed
    end


    -- -- Enter Level
    -- if pressedKeys["space"] then
    --     startLevel()
    -- end
    -- Maybe use a hover and click event to start the level
end
local function onKeyEvent(event)
    if event.phase == "down" then
        pressedKeys[event.keyName] = true
    elseif event.phase == "up" then
        pressedKeys[event.keyName] = false
    else
        pressedKeys[event.keyName] = false
    end
end





-- Load CSV file as table of tables, where each sub-table is a row
-- [[ Whole World Generation Code ]]
local path = system.pathForFile("Overworld/Area_0.csv", system.ResourceDirectory)

local file = io.open(path, "r")
if file then
    local rows = {}
    for line in file:lines() do
        rows[#rows+1] = string.fromCSV(line)
    end
    io.close(file)
    -- Use the 'rows' table here
else
    -- Handle the case when the file cannot be opened
end

-- Note that I made it green to skip "print" so it doesn't annoy you
-- table.print_r(rows)

-- Top of your code:
local curRow    = 1
local forLooper
local id        = 0
local rectTable = {}  -- for keeping references on created rectangles
local filename

local function buildLevel(build)

    -- [[ Actual Loader Function ]]-- =========================================================

    if( curRow <= #rows ) then
        table.print_r(rows[curRow])
        local forLooper = tonumber((rows[1][1]))
        -- spawnX, spawnY = tonumber((rows[1][2])), tonumber((rows[1][3]))

        while (forLooper>=1) do

            -- In your loop:

            -- Create 'id' to make array assortment easier
            id = forLooper + 1

            if not rows[id] then
                break
            end -- this new line will stop the loop if index is nil

            -- Make the Blocks
            local rectID  = tostring(id)
            local xOffset = cx + tonumber(rows[id][1]) * 100
            local yOffset = cy + tonumber(rows[id][2]) * 100

            if tostring(build) == "YES" then
                if ((tostring(rows[id][3])) == ".7") then
                    rectTable[rectID] = display.newImageRect( "Assets/OLD_tiles1.png", 100, 100 )
                elseif ((tostring(rows[id][3])) == ".3") then
                    rectTable[rectID] = display.newImageRect( "Assets/OLD_tiles2.png", 100, 100 )
                else
                    rectTable[rectID] = display.newImageRect( "Assets/OLD_tiles1.png", 100, 100 )
                end
                rectTable[rectID].x, rectTable[rectID].y = xOffset, yOffset

                if ((tostring(rows[id][4])) == "Y") then
                    physics.addBody( (rectTable[rectID]), "static", { density=1.0, friction=100, bounce=-10} )
                end

            elseif tostring(build) == "NO" then
                display.remove( rectTable[rectID] )
            end
            -- Repeat until finished CSV
            forLooper = forLooper - 1
        end
    end
end


-- [[ Animation ]]
local function animation()
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
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="hit",
      frames= { 131, 131 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="blink",
      frames= { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="startrun",
      frames= { 12, 13, 14, 15, 16, 17, 18 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="run",
      frames= { 27, 28, 29 }, -- frame indexes of animation, in image sheet
      time = 300,
      loopCount = 7        -- Optional ; default is 0
    },
    {
      name="dash",
      frames= { 40, 41, 42, 43, 44, 45, 46, 47, 48 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="jump",
      frames= { 53, 54 }, -- frame indexes of animation,   in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0 
    },
    {
      name="startJump",
      frames= { 66, 67, 68, 69, 70 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="fall",
      frames= { 79, 80 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1     -- Optional ; default is 0
    },
    {
      name="startFall",
      frames= { 92, 93, 94, 95 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    },
    {
      name="highjump",
      frames= { 105, 106 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 0        -- Optional ; default is 0
    },
    {
      name="startHighjump",
      frames= { 54, 105, 106 }, -- frame indexes of animation, in image sheet
      time = 100,
      loopCount = 1        -- Optional ; default is 0
    }
  }

    newPlayer = display.newSprite( TestySheet, TestySequences )


    newPlayer:setSequence("idle")
    newPlayer:play()
    newPlayer.xScale, newPlayer.yScale = 0.3,0.3
end

-- [[ Code for Creating the Player ]]
function LoadWorldSelectPlayer(option)
    if option == "Load" then
        LevelPlayer = display.newRect( spawnX, spanwnY, 70, 70 )
        LevelPlayer.fill = {1,1,0.5}
        -- LevelPlayer.alpha = 0
        animation()
        Runtime:addEventListener( "enterFrame", animatedPositioning )
        if platform == "pc" then
            Runtime:addEventListener( "enterFrame", onEnterFrame )
            Runtime:addEventListener( "key", onKeyEvent )
        end

        -- Camera
        camera:add(LevelPlayer, 1)      -- Add Testy to the camera system
        camera:snap(LevelPlayer)        -- Snaps to Testy
        camera:setFocus(LevelPlayer)    -- Set the focus to the player
        camera:track()                  -- Begin auto-tracking
        print("Isthis workin?")

    elseif option == "unLoad" then
        Runtime:removeEventListener( animatedPositioning )
        camera:destroy()
        display.remove( LevelPlayer )
        Runtime:removeEventListener( onEnterFrame )
        Runtime:removeEventListener( onKeyEvent )
    end
end

-- [[ Lua File Functions ]]

local M = {}

function M.option(option)
    if option == "pc" then
        platform = "pc"
    elseif option == "mobile" then
        platform = "mobile"
    end
end

function M.LoadWorld()
    buildLevel("YES")
    LoadWorldSelectPlayer("Load")
end

function M.unLoadWorld()
    buildLevel("NO")
    LoadWorldSelectPlayer("unLoad")
end


--Has to be put last
return M