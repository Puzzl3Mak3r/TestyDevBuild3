-- =======================
-- [[ Parameters ]]
-- =======================

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

-- =======================
-- [[ Animation ]]
-- =======================

function Animate(option)
    if option == "add" then
        -- [[ Add Parts ]]
        -- Background
        background = display.newImageRect("Assets/Images/StartScreen/background.png", screenX, screenY)
        background.x, background.y = 960, 540

        -- Background scroll
        bgScroll0a = display.newImageRect("Assets/Images/StartScreen/bgScroll0.png", screenX, screenY)
        bgScroll0b = display.newImageRect("Assets/Images/StartScreen/bgScroll0.png", screenX, screenY)
        bgScroll1a = display.newImageRect("Assets/Images/StartScreen/bgScroll1.png", screenX, screenY)
        bgScroll1b = display.newImageRect("Assets/Images/StartScreen/bgScroll1.png", screenX, screenY)
        bgScroll0a.x, bgScroll0a.y = cx, cy
        bgScroll0b.x, bgScroll0b.y = -cx, cy
        bgScroll1a.x, bgScroll1a.y = cx, cy
        bgScroll1b.x, bgScroll1b.y = -cx, cy


        -- Side Bars
        lightBlueUp = display.newImageRect("Assets/Images/StartScreen/lightBlueUp.png", screenX, screenY)
        lightBlueDown = display.newImageRect("Assets/Images/StartScreen/lightBlueDown.png", screenX, screenY)
        darkBlueUp = display.newImageRect("Assets/Images/StartScreen/darkBlueUp.png", screenX, screenY)
        darkBlueDown = display.newImageRect("Assets/Images/StartScreen/darkBlueDown.png", screenX, screenY)


        lightBlueUp.anchorX = 0
        lightBlueUp.anchorY = 0
        lightBlueDown.anchorX = 0
        lightBlueDown.anchorY = 0
        darkBlueUp.anchorX = 0
        darkBlueUp.anchorY = 0
        darkBlueDown.anchorX = 0
        darkBlueDown.anchorY = 0

        lightBlueUp.x, lightBlueUp.y = 0, 0
        lightBlueDown.x, lightBlueDown.y = 0, 0
        darkBlueUp.x, darkBlueUp.y = 0, 0
        darkBlueDown.x, darkBlueDown.y = 0, 0

        -- Testy
        testy = display.newImageRect("Assets/Images/StartScreen/testy.png", 720, 459) -- 0.75*960 = 720, 0.85*540 = 459
        testy.x, testy.y = -1920, 621 -- -2*960 = -1920, 540*1.15 = 621

        -- Words
        title0 = display.newImageRect("Assets/Images/StartScreen/title0.png", 1280, 720)
        title1 = display.newImageRect("Assets/Images/StartScreen/title1.png", 1280, 720)
        title0.x, title0.y = -2880, 580 -- -3*960 = -2880, 540+10 = 550
        title1.x, title1.y = 1000, -1620 -- 960+40 = 1000, -3*540 = -1620

        -- Lines
        lines = display.newImageRect("Assets/Images/StartScreen/lines.png", 79*3, 3*155)
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
        function scrollBgObjects()
            -- Move all
            bgScroll0a.x = bgScroll0a.x + 10
            bgScroll0b.x = bgScroll0b.x + 10
            bgScroll1a.x = bgScroll1a.x + 4
            bgScroll1b.x = bgScroll1b.x + 4

            -- Reset if too far
            if bgScroll0a.x >= 1920 + cx then
                bgScroll0a.x = cx
            end
            if bgScroll0b.x >= cx then
                bgScroll0b.x = -cx
            end
            if bgScroll1a.x >= 1920 + cx then
                bgScroll1a.x = cx
            end
            if bgScroll1b.x >= cx then
                bgScroll1b.x = -cx
            end
        end
        Runtime:addEventListener( "enterFrame", scrollBgObjects )
    end

    if option == "remove" then
        -- [[ Remove enterFrame listeners ]]
        Runtime:removeEventListener( scrollBgObjects )        
        -- [[ Remove Parts by alpha tween ]]
        transition.to(lightBlueUp, {alpha = 0, time = 200})
        transition.to(lightBlueDown, {alpha = 0, time = 200})
        transition.to(darkBlueUp, {alpha = 0, time = 200})
        transition.to(darkBlueDown, {alpha = 0, time = 200})
        transition.to(title0, {alpha = 0, time = 200})
        transition.to(title1, {alpha = 0, time = 200})
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
    display.remove(title0)
    display.remove(title1)
    display.remove(lines)
    display.remove(flash)
    display.remove(startText)
    display.remove(bgScroll0a)
    display.remove(bgScroll0b)
    display.remove(bgScroll1a)
    display.remove(bgScroll1b)

    -- Set objects to nil
    background = nil
    lightBlueUp = nil
    lightBlueDown = nil
    darkBlueUp = nil
    darkBlueDown = nil
    testy = nil
    title0 = nil
    title1 = nil
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
            file:write( "New,StartMenu" )
            io.close( file )
            print( "File write successful" )
        else
            print( "File write failed" )
        end
    end, 1 )
end

--  Touch to start
Runtime:addEventListener( "touch", fade )

-- =======================
-- [[ Function Calling ]]
-- =======================
local introScreen = {}

function introScreen.Start()
    print("Start Screen Anim")
    Animate("add")
    Animate("animate")
end

-- Need to return or Solar2D will run into errors. It's not really returning any value
return introScreen