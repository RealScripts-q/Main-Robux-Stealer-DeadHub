-- Advanced Script for a customizable executor interface with mobile support

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local scriptHubButton = Instance.new("TextButton")
local loadButton = Instance.new("TextButton")
local saveButton = Instance.new("TextButton")
local copyButton = Instance.new("TextButton")
local scriptBox = Instance.new("TextBox")
local runButton = Instance.new("TextButton")
local toggleEditorButton = Instance.new("TextButton")
local editorMode = false  -- Toggle editor mode
local items = {}  -- To store created UI items
local lockedItems = {}  -- Items that are locked into position
local scriptHub = {}  -- Stores saved scripts

-- Setup basic UI elements
screenGui.Parent = player.PlayerGui
screenGui.Name = "ExecutorUI"

mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Draggable = true

-- Script Hub Button
scriptHubButton.Parent = mainFrame
scriptHubButton.Size = UDim2.new(0, 100, 0, 50)
scriptHubButton.Position = UDim2.new(0, 20, 0, 20)
scriptHubButton.Text = "Script Hub"
scriptHubButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)

-- Load Script Button
loadButton.Parent = mainFrame
loadButton.Size = UDim2.new(0, 100, 0, 50)
loadButton.Position = UDim2.new(0, 140, 0, 20)
loadButton.Text = "Load Script"
loadButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)

-- Save Script Button
saveButton.Parent = mainFrame
saveButton.Size = UDim2.new(0, 100, 0, 50)
saveButton.Position = UDim2.new(0, 20, 0, 80)
saveButton.Text = "Save Script"
saveButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Copy Script Button
copyButton.Parent = mainFrame
copyButton.Size = UDim2.new(0, 100, 0, 50)
copyButton.Position = UDim2.new(0, 140, 0, 80)
copyButton.Text = "Copy Script"
copyButton.BackgroundColor3 = Color3.fromRGB(100, 255, 255)

-- Script Input Box
scriptBox.Parent = mainFrame
scriptBox.Size = UDim2.new(0, 360, 0, 100)
scriptBox.Position = UDim2.new(0, 20, 0, 140)
scriptBox.Text = ""
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true
scriptBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- Run Script Button
runButton.Parent = mainFrame
runButton.Size = UDim2.new(0, 100, 0, 50)
runButton.Position = UDim2.new(0, 260, 0, 20)
runButton.Text = "Run Script"
runButton.BackgroundColor3 = Color3.fromRGB(255, 255, 100)

-- Editor Mode Toggle Button
toggleEditorButton.Parent = mainFrame
toggleEditorButton.Size = UDim2.new(0, 100, 0, 50)
toggleEditorButton.Position = UDim2.new(0, 20, 0, 200)
toggleEditorButton.Text = "Editor Mode"
toggleEditorButton.BackgroundColor3 = Color3.fromRGB(100, 255, 255)

-- Mobile-friendly function to enable touch dragging
local function makeDraggable(element)
    local dragging = false
    local dragInput, dragStart, startPos

    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = element.Position
            input.Changed:Connect(function()
                if dragging then
                    local delta = input.Position - dragStart
                    element.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)

    element.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Function to execute the script (example)
local function executeScript(script)
    local success, result = pcall(function()
        loadstring(script)()
    end)
    if success then
        print("Script executed successfully!")
    else
        warn("Error executing script: " .. result)
    end
end

-- Function to save a script
local function saveScript(scriptName, scriptContent)
    scriptHub[scriptName] = scriptContent
    print("Script saved: " .. scriptName)
end

-- Function to load a script
local function loadScript(scriptName)
    return scriptHub[scriptName]
end

-- Function to copy script to clipboard (simulated by text box)
local function copyToClipboard(scriptContent)
    scriptBox.Text = scriptContent
    print("Script copied to clipboard: " .. scriptContent)
end

-- Function to toggle editor mode (UI design)
toggleEditorButton.MouseButton1Click:Connect(function()
    editorMode = not editorMode
    toggleEditorButton.Text = editorMode and "Exit Editor" or "Editor Mode"

    -- In editor mode, we enable movement and resizing of UI elements
    if editorMode then
        mainFrame.Draggable = true
        -- Allow touch dragging for mobile
        makeDraggable(mainFrame)
    else
        mainFrame.Draggable = false
    end
end)

-- Button actions
scriptHubButton.MouseButton1Click:Connect(function()
    print("Opening script hub...")
    -- Toggle visibility of the script hub frame
    mainFrame.Visible = not mainFrame.Visible
end)

saveButton.MouseButton1Click:Connect(function()
    local scriptContent = scriptBox.Text
    if scriptContent and scriptContent ~= "" then
        local scriptName = "UserScript_" .. tick()  -- Name it based on time for uniqueness
        saveScript(scriptName, scriptContent)
        scriptBox.Text = ""  -- Clear input box after saving
    else
        print("No script to save.")
    end
end)

loadButton.MouseButton1Click:Connect(function()
    local scriptName = "UserScript_" .. tick()  -- You can modify this for more complex script loading
    local loadedScript = loadScript(scriptName)
    if loadedScript then
        scriptBox.Text = loadedScript
        print("Script loaded: " .. scriptName)
    else
        print("Script not found.")
    end
end)

copyButton.MouseButton1Click:Connect(function()
    local scriptContent = scriptBox.Text
    if scriptContent and scriptContent ~= "" then
        copyToClipboard(scriptContent)
    else
        print("No script to copy.")
    end
end)

runButton.MouseButton1Click:Connect(function()
    local scriptContent = scriptBox.Text
    if scriptContent and scriptContent ~= "" then
        executeScript(scriptContent)
    else
        print("No script to run.")
    end
end)

-- Function to add a new UI element dynamically (e.g., buttons)
local function addNewButton(name, position, size, callback)
    local button = Instance.new("TextButton")
    button.Parent = mainFrame
    button.Size = size
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    button.Name = name

    -- Make the button draggable if editor mode is enabled
    if editorMode then
        button.Draggable = true
    end

    -- Mobile-friendly: enable touch input for interaction
    makeDraggable(button)

    button.MouseButton1Click:Connect(callback)
end

-- Example: Adding a customizable button dynamically
addNewButton("Custom Button", UDim2.new(0, 20, 0, 260), UDim2.new(0, 100, 0, 50), function()
    print("Custom button clicked!")
end)
