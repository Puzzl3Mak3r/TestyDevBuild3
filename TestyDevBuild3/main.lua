-- [[ MAIN CORE STUFF ]] -- =========================================================
system.activate("multitouch")


-- [[ Scene handler ]] -- ===========================================================
local currentLoad = ""
local currentScene = "start"
local isNewScene = true

local function sceneHandler(scene)
    print("waiting")

    if isNewScene then
        print ("new scene")
        -- Stop loop
        isNewScene = false

        -- starting scene( game launches )
        if scene == "start" then
            currentLoad = require("Spaces.introScreen")

            -- Create a coroutine for introducing the delay
            local function delayedStart()
                -- Wait using timer.performWithDelay
                coroutine.yield(timer.performWithDelay(1600, function()
                    -- Resume the coroutine after delay
                    coroutine.resume(mainCoroutine)
                end))
                -- Call the Start function after the delay
                isNewScene, currentScene = currentLoad.Start()
            end

            -- Create the coroutine and start it
            mainCoroutine = coroutine.create(delayedStart)
            coroutine.resume(mainCoroutine)
        end
    end
end

-- Loop every second
timer.performWithDelay(1000, function() sceneHandler(currentScene) end, 0)