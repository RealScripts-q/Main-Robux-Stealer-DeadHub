-- Create a ScreenGui to hold the interface
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a frame to act as the window (Synapse-like)
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 400, 0, 300)
window.Position = UDim2.new(0.5, -200, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  -- Dark background
window.BackgroundTransparency = 0.2
window.BorderSizePixel = 0
window.Parent = screenGui

-- Add a title bar to the window
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Text = "Lua Executor (Synapse-like)"
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.TextSize = 18
titleBar.TextAlignment = Enum.TextAlignment.Center
titleBar.Parent = window

-- Add a text box to input Lua code
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -20, 0, 150)
inputBox.Position = UDim2.new(0, 10, 0, 40)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 14
inputBox.Multiline = true
inputBox.ClearTextOnFocus = false
inputBox.PlaceholderText = "Enter Lua code here..."
inputBox.Parent = window

-- Add a button to run the script
local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0, 150, 0, 40)
executeButton.Position = UDim2.new(0.5, -75, 1, -60)
executeButton.Text = "Execute Script"
executeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
executeButton.TextSize = 16
executeButton.Parent = window

-- Add a settings tab button
local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(0, 150, 0, 40)
settingsButton.Position = UDim2.new(0.5, -75, 0, 10)
settingsButton.Text = "Settings"
settingsButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.TextSize = 16
settingsButton.Parent = window

-- Create a settings frame (hidden by default)
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 400, 0, 150)
settingsFrame.Position = UDim2.new(0.5, -200, 1, -150)
settingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
settingsFrame.Visible = false
settingsFrame.Parent = screenGui

-- Create a slider for changing screen height in settings
local heightLabel = Instance.new("TextLabel")
heightLabel.Size = UDim2.new(0, 200, 0, 30)
heightLabel.Position = UDim2.new(0, 10, 0, 10)
heightLabel.Text = "Window Height:"
heightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
heightLabel.TextSize = 14
heightLabel.Parent = settingsFrame

local heightSlider = Instance.new("Slider")
heightSlider.Size = UDim2.new(0, 200, 0, 20)
heightSlider.Position = UDim2.new(0, 10, 0, 50)
heightSlider.MinValue = 200
heightSlider.MaxValue = 500
heightSlider.Value = window.Size.Y.Offset
heightSlider.Parent = settingsFrame

-- Function to save the script
local function saveScript(scriptCode)
    local file = Instance.new("StringValue")
    file.Name = "SavedScript"
    file.Value = scriptCode
    file.Parent = game.ServerStorage
    print("Script saved!")
end

-- Function to load the saved script
local function loadScript()
    local file = game.ServerStorage:FindFirstChild("SavedScript")
    if file then
        inputBox.Text = file.Value
        print("Script loaded!")
    else
        print("No saved script found.")
    end
end

-- Function to execute the entered script
local function executeScript()
    local scriptCode = inputBox.Text
    
    -- Check if the code is empty
    if scriptCode == "" then
        print("No code entered!")
        return
    end

    -- Load and execute the script using loadstring
    local func, err = loadstring(scriptCode)
    if not func then
        print("Error: " .. err)
    else
        -- Safely execute the script
        local success, result = pcall(func)
        if not success then
            print("Runtime Error: " .. result)
        else
            print("Script executed successfully!")
        end
    end
end

-- Auto execute saved script (if exists)
local function autoExecuteScript()
    loadScript()
    executeScript()
end

-- Auto execute script on startup
autoExecuteScript()

-- Connect the execute button to the execute function
executeButton.MouseButton1Click:Connect(executeScript)

-- Connect the settings button to toggle the settings frame
settingsButton.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

-- Update the window height based on the slider value
heightSlider.Changed:Connect(function()
    window.Size = UDim2.new(0, 400, 0, heightSlider.Value)
end)

-- Optionally save script manually
saveScriptButton = Instance.new("TextButton")
saveScriptButton.Size = UDim2.new(0, 150, 0, 40)
saveScriptButton.Position = UDim2.new(0.5, -75, 0, 60)
saveScriptButton.Text = "Save Script"
saveScriptButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
saveScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveScriptButton.TextSize = 16
saveScriptButton.Parent = window

saveScriptButton.MouseButton1Click:Connect(function()
    saveScript(inputBox.Text)
end)
