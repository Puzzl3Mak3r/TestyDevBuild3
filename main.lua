-- $$\      $$\           $$\               $$\                          
-- $$$\    $$$ |          \__|              $$ |                         
-- $$$$\  $$$$ | $$$$$$\  $$\ $$$$$$$\      $$ |     $$\   $$\  $$$$$$\  
-- $$\$$\$$ $$ | \____$$\ $$ |$$  __$$\     $$ |     $$ |  $$ | \____$$\ 
-- $$ \$$$  $$ | $$$$$$$ |$$ |$$ |  $$ |    $$ |     $$ |  $$ | $$$$$$$ |
-- $$ |\$  /$$ |$$  __$$ |$$ |$$ |  $$ |    $$ |     $$ |  $$ |$$  __$$ |
-- $$ | \_/ $$ |\$$$$$$$ |$$ |$$ |  $$ |$$\ $$$$$$$$\\$$$$$$  |\$$$$$$$ |
-- \__|     \__| \_______|\__|\__|  \__|\__|\________|\______/  \_______|



------------------------------------------------------------------------------------
-- Important
------------------------------------------------------------------------------------

system.activate("multitouch")
local physics = require("physics")
system.activate( "physics" )
physics.start()
local io = require("io")
local currentScene = ""
local currentLoad = ""
local SceneManager = {}



------------------------------------------------------------------------------------
-- Writing && Reading && Parsing
------------------------------------------------------------------------------------

-- Convert commas to ¤
local function replace_commas_with_forex(text)
    local result = ""
    local in_string = false
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == '"' then
            in_string = not in_string
        elseif char == ',' and in_string then
            char = '¤'
        end
        result = result .. char
    end
    -- print("Result: "..result)
    return result
end

-- Parse the CSV
local function parse_csv_to_array(oldCsv)
    -- The 2D array
    local csv = replace_commas_with_forex(oldCsv)
    local array = {}
    for line in csv:gmatch("[^\r\n]+") do
        -- The 1D array inside the 2D array
        local row = {}
        for cell in line:gmatch("[^,]+") do
            table.insert(row, cell)
        end
        table.insert(array, row)
    end
    return array
end

-- Write the StartScreen
local FileTemp = io.open( system.pathForFile( "temp.csv", system.DocumentsDirectory ), "w" )
if FileTemp then
    FileTemp:write("New,StartScreen")
    io.close( FileTemp )
else print ("Error: Cannot overwrite file to be reset - File does not exist - Line 47")
end



------------------------------------------------------------------------------------
-- Read && Run Scene
------------------------------------------------------------------------------------

-- Overwrite "FileTemp"
function readWriteTempFile(option)
    if option == "O" then
        FileTempRaw = io.open( system.pathForFile( "temp.csv", system.DocumentsDirectory ), "r" )
        FileTemp = parse_csv_to_array(FileTempRaw:read("*a"))
        print ("closed file")
        io.close( FileTempRaw )
    elseif option == "C" then
        FileTempRaw = io.open( system.pathForFile( "temp.csv", system.DocumentsDirectory ), "w" )
        FileTempRaw:write("Old,")
        io.close( FileTempRaw )
    end
end readWriteTempFile("O")

-- [[ Load the Scene Manager ]] -- ==================================================
local function updateSceneManager()
    local KeyWords = io.open( system.pathForFile("Core/Keywords.csv", system.ResourceDirectory), "r" )
    if KeyWords then
        SceneManager = parse_csv_to_array(KeyWords:read("*a"))
    end
end updateSceneManager()


local function sceneHandler(scene)

    -- Iterate through each possible keyword
    for i = 1, #SceneManager do
        if SceneManager[i][1] == scene then
            print( "scene"..scene )
            scene = SceneManager[i][2]
            currentLoad = require(scene)
            currentLoad.Start()
            break
        else print("not scene "..scene)
        end
    end
end


local function CheckUpdate()
    print ("Checking for updates")
    readWriteTempFile("O")
    if FileTemp[1][1] == "New" then
        -- Print the new scene
        print ("New Scene")
        print (FileTemp[1][2])

        -- Get rid of old scene
        currentScene = nil

        -- Load the new scene
        currentScene = FileTemp[1][2]
        sceneHandler(currentScene)

        -- Reset the temp file
        readWriteTempFile("C")
    end
end

-- Check update every 2 seconds
timer.performWithDelay(2500, function() CheckUpdate() end, 0)