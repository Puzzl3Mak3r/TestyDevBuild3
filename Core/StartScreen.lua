--  $$$$$$\    $$\                          $$\      $$$$$$\                                                        $$\                          
-- $$  __$$\   $$ |                         $$ |    $$  __$$\                                                       $$ |                         
-- $$ /  \__|$$$$$$\    $$$$$$\   $$$$$$\ $$$$$$\   $$ /  \__| $$$$$$$\  $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\      $$ |     $$\   $$\  $$$$$$\  
-- \$$$$$$\  \_$$  _|   \____$$\ $$  __$$\\_$$  _|  \$$$$$$\  $$  _____|$$  __$$\ $$  __$$\ $$  __$$\ $$  __$$\     $$ |     $$ |  $$ | \____$$\ 
--  \____$$\   $$ |     $$$$$$$ |$$ |  \__| $$ |     \____$$\ $$ /      $$ |  \__|$$$$$$$$ |$$$$$$$$ |$$ |  $$ |    $$ |     $$ |  $$ | $$$$$$$ |
-- $$\   $$ |  $$ |$$\ $$  __$$ |$$ |       $$ |$$\ $$\   $$ |$$ |      $$ |      $$   ____|$$   ____|$$ |  $$ |    $$ |     $$ |  $$ |$$  __$$ |
-- \$$$$$$  |  \$$$$  |\$$$$$$$ |$$ |       \$$$$  |\$$$$$$  |\$$$$$$$\ $$ |      \$$$$$$$\ \$$$$$$$\ $$ |  $$ |$$\ $$$$$$$$\\$$$$$$  |\$$$$$$$ |
--  \______/    \____/  \_______|\__|        \____/  \______/  \_______|\__|       \_______| \_______|\__|  \__|\__|\________|\______/  \_______|



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
-- Animation
------------------------------------------------------------------------------------

function Animate(option)
    if option == "add" then
        -- [[ Add Parts ]]
        -- Background
        background = display.newImageRect("Assets/StartScreen/background.png", screenX, screenY)
        background.x, background.y = 960, 540 -- No change

        -- Side Bars
        lightBlueUp = display.newImageRect("Assets/StartScreen/lightBlueUp.png", screenX, screenY)
        lightBlueDown = display.newImageRect("Assets/StartScreen/lightBlueDown.png", screenX, screenY)
        darkBlueUp = display.newImageRect("Assets/StartScreen/darkBlueUp.png", screenX, screenY)
        darkBlueDown = display.newImageRect("Assets/StartScreen/darkBlueDown.png", screenX, screenY)

        lightBlueUp.x, lightBlueUp.y = 960, -1350 -- -5*540/2 = -1350
        lightBlueDown.x, lightBlueDown.y = 960, 1350 -- 5*540/2 = 1350
        darkBlueUp.x, darkBlueUp.y = 1960, 540
        darkBlueDown.x, darkBlueDown.y = -1900, 540

        -- Testy
        testy = display.newImageRect("Assets/StartScreen/testy.png", 720, 459) -- 0.75*960 = 720, 0.85*540 = 459
        testy.x, testy.y = -1920, 621 -- -2*960 = -1920, 540*1.15 = 621

        -- Words
        words0 = display.newImageRect("Assets/StartScreen/words0.png", 347*3, 3*146)
        words1 = display.newImageRect("Assets/StartScreen/words1.png", 347*3, 3*152)
        words0.x, words0.y = -2880, 580 -- -3*960 = -2880, 540+10 = 550
        words1.x, words1.y = 1000, -1620 -- 960+40 = 1000, -3*540 = -1620

        -- Lines
        lines = display.newImageRect("Assets/StartScreen/lines.png", 79*3, 3*155)
        lines.x, lines.y = -3840, 573 -- -4*960 = -3840, 17*540/16 = 573

        -- Start text "Press to Start" and make invisible
        startText = display.newText("Press to Start", adjustX * 3200, adjustY * 1800, nil, 30) -- (5/3)*960 = 3200, (5/3)*540 = 1800
        startText.alpha = 0

        -- Create flash graphic without image, as big as screen
        flash = display.newRect(960, 540, 3 * screenX, 3 * screenY)
        flash.fill, flash.alpha = {1, 1, 1}, 0
    end

    -- [[ Animate ]]
    if option == "animate" then
        -- Part 1
        transition.to(lightBlueUp, {y = 540, time = 400})
        transition.to(lightBlueDown, {y = 540, time = 400})
        transition.to(testy, {x = 1440, time = 400}) -- 9*960/6 = 1440
        transition.to(words0, {x = 1000, time = 350}) -- 7*960/6 = 1120

        -- Part 2
        transition.to(lines, {x = 370, time = 400, delay = 200}) -- 960/4 = 240
        transition.to(words1, {y = 573, time = 400, delay = 300}) -- 17*540/16 = 573

        -- Part 3
        transition.to(flash, {alpha = 0.5, time = 130, delay = 870})
        transition.to(darkBlueUp, {x = 960, time = 250, delay = 900})
        transition.to(darkBlueDown, {x = 960, time = 250, delay = 900})
        transition.to(flash, {alpha = 0, time = 110, delay = 1100})

        -- Part 4
        transition.to(startText, {alpha = 1, time = 200, delay = 1400})
    end

    if option == "remove" then
        -- [[ Remove Parts by alpha tween ]]
        transition.to(lightBlueUp, {alpha = 0, time = 200})
        transition.to(lightBlueDown, {alpha = 0, time = 200})
        transition.to(darkBlueUp, {alpha = 0, time = 200})
        transition.to(darkBlueDown, {alpha = 0, time = 200})
        transition.to(words0, {alpha = 0, time = 200})
        transition.to(words1, {alpha = 0, time = 200})
        transition.to(lines, {alpha = 0, time = 200})
        transition.to(background, {alpha = 0, time = 200})
        transition.to(startText, {alpha = 0, time = 200})

        -- Special
        transition.to(testy, {alpha = 0, time = 300, delay = 400})
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
    print ("fade")


    -- Write to file with a little delay
    timer.performWithDelay( 750, function()
        local file = io.open( system.pathForFile( "temp.csv", system.DocumentsDirectory ), "w" )
        if file then
            file:write("New,StartMenu")
            io.close( file )
            print( "File write successful" )
        else
            print( "File write failed" )
        end
    end, 1 )
end

--  Touch to start
Runtime:addEventListener( "touch", fade )



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