-- =======================
-- [[ Parameters ]]
-- =======================

-- local animation     = require("plugin.animation")

local fullw         = display.actualContentWidth
local fullh         = display.actualContentHeight
local cx            = display.contentCenterX
local cy            = display.contentCenterY
local screenX       = display.contentWidth
local screenY       = display.contentHeight

-- =======================
-- [[ Animation ]]
-- =======================

function Animate(option)
    if option == "add" then
    -- [[ Add Parts ]]
        -- Background
            background    = display.newImageRect("Assets/UI/StartScreen/background.png",fullw,fullh)
            background.x , background.y = cx, cy

        -- Side Bars
            lightBlueUp   = display.newImageRect("Assets/UI/StartScreen/lightBlueUp.png",fullw,fullh)
            lightBlueDown = display.newImageRect("Assets/UI/StartScreen/lightBlueDown.png",fullw,fullh)
            darkBlueUp    = display.newImageRect("Assets/UI/StartScreen/darkBlueUp.png",fullw,fullh)
            darkBlueDown  = display.newImageRect("Assets/UI/StartScreen/darkBlueDown.png",fullw,fullh)
            lightBlueUp.x , lightBlueUp.y       = cx, -5*cy/2
            lightBlueDown.x , lightBlueDown.y   = cx,  5*cy/2
            darkBlueUp.x , darkBlueUp.y         = fullw, cy
            darkBlueDown.x , darkBlueDown.y     = -fullh, cy
        -- Testy
            testy = display.newImageRect("Assets/UI/StartScreen/testy.png",433/1.8,289/1.8)
            testy.x , testy.y = -2*cx, cy+10
        -- Words
            words0 = display.newImageRect("Assets/UI/StartScreen/words0.png",625/1.8,263/1.8)
            words1 = display.newImageRect("Assets/UI/StartScreen/words1.png",625/1.8,273/1.8)
            words0.x , words0.y = -3*cx, cy+10
            words1.x , words1.y = cx+40, -3*cy
        -- Lines
            lines = display.newImageRect("Assets/UI/StartScreen/lines.png",142/1.8,278/1.8)
            lines.x , lines.y = -4*cx, 17*cy/16


        -- Start text "Press to Start" and make invisible
            startText = display.newText("Press to Start", (5/3)*cx, (5/3)*cy, nil, 30 )
            startText.alpha = 0


        -- Create flash graphic without image, as big as screen
            flash = display.newRect(cx, cy, 3*screenX, 3*screenY)
            flash.fill, flash.alpha = { 1,1,1 }, 0
    end




    -- [[ Animate ]]
    if option == "animate" then

        -- Part 1
        transition.to( lightBlueUp,     { y = cy, time = 400 } )
        transition.to( lightBlueDown,   { y = cy, time = 400 } )
        transition.to( testy,           { x = 5*cx/3, time = 400 } )
        transition.to( words0,          { x = 7*cx/6, time = 350 } )

        -- Part 2
        transition.to( lines,           { x = cx/4, time = 400, delay = 200 } )
        transition.to( words1,          { y = 17*cy/16, time = 400, delay = 300 } )

        -- Part 3
        transition.to( flash,           { alpha = 0.75, time = 130, delay = 870 } )
        transition.to( darkBlueUp,      { x = cx, time = 250, delay = 900 } )
        transition.to( darkBlueDown,    { x = cx, time = 250, delay = 900 } )
        transition.to( flash,           { alpha = 0, time = 110, delay = 1100 } )

        -- Part 4
        transition.to( startText,       { alpha = 1, time = 200, delay = 1400 } )


    end

    if option == "remove" then

        -- [[ Remove Parts by alpha tween ]]
        transition.to( lightBlueUp,     { alpha = 0, time = 200} )
        transition.to( lightBlueDown,   { alpha = 0, time = 200} )
        transition.to( darkBlueUp,      { alpha = 0, time = 200} )
        transition.to( darkBlueDown,    { alpha = 0, time = 200} )
        transition.to( words0,          { alpha = 0, time = 200} )
        transition.to( words1,          { alpha = 0, time = 200} )
        transition.to( lines,           { alpha = 0, time = 200} )
        transition.to( background,      { alpha = 0, time = 200} )
        transition.to( startText,       { alpha = 0, time = 200} )

        -- Special
        transition.to( testy,           { alpha = 0, time = 300, delay = 400} )
        startText.isVisible = false

    end
end

-- Function that removes all objects
local function objRemover()
        -- Remove all objects
        display.remove(background)
        display.remove(lightBlueUp)
        display.remove(lightBlueDown)
        display.remove(darkBlueUp)
        display.remove(darkBlueDown)
        display.remove(testy)
        display.remove(words0)
        display.remove(words1)
        display.remove(lines)

        -- Set objects to nil
        background = nil
        lightBlueUp = nil
        lightBlueDown = nil
        darkBlueUp = nil
        darkBlueDown = nil
        testy = nil
        words0 = nil
        words1 = nil
        lines = nil
end

local function fade()
    Runtime:removeEventListener( "touch", fade )
    Animate("remove")
    -- Call the objRemover function after 220ms
    timer.performWithDelay( 710, objRemover, 1 )
end

Animate("add")
Animate("animate")
--  Touch to start
Runtime:addEventListener( "touch", fade )

-- =======================
-- [[ Function Calling ]]
-- =======================
local StartScreen = {}

function StartScreen.Name()
end

-- return StartScreen -- Need to return or Solar2D will run into errors. It's not really returning any value

local function Body()
    -- DoSomething()
 
    coroutine.yield( 1, "3" )
 
    -- DoSomethingElse()
 
    coroutine.yield( 5 )
 
    -- DoOneLastThing()
 
    return "Data", 1
end
 
local co = coroutine.create( Body )
 
print( coroutine.resume( co ) )  -- prints true, 1, "3"
print( 5 * coroutine.resume( co ) )  -- prints true, something about the table, 7, 4
print( coroutine.resume( co ) )  -- prints true, "Data", 1