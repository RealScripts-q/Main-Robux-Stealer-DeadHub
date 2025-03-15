-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")
local player = Players.LocalPlayer

-- GamePass IDs
local premiumPaidGamePassId = 1105218641
local paidGamePassId = 1106755338
local speedCoilGamePassId = 1103848074

-- DataStore to save the whitelist data
local dataStore = DataStoreService:GetDataStore("SpeedCoilWhitelist")

-- Create UI cover
local gui = Instance.new("ScreenGui")
gui.Parent = player:FindFirstChildOfClass("PlayerGui") or Instance.new("PlayerGui", player)
gui.ResetOnSpawn = false

-- Frame that will fill the screen and be grey
local coverFrame = Instance.new("Frame")
coverFrame.Parent = gui
coverFrame.Size = UDim2.new(1, 0, 1, 0)
coverFrame.Position = UDim2.new(0, 0, 0, 0)
coverFrame.BackgroundColor3 = Color3.fromRGB(169, 169, 169)  -- Grey background
coverFrame.Visible = false  -- Initially hidden until Open button is clicked

-- Create Close/X Button
local closeButton = Instance.new("TextButton")
closeButton.Parent = coverFrame
closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
closeButton.Position = UDim2.new(0.9, 0, 0, 0)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red background for the Close button
closeButton.TextColor3 = Color3.new(1, 1, 1)

-- Create Open Button
local openButton = Instance.new("TextButton")
openButton.Parent = gui
openButton.Size = UDim2.new(0.2, 0, 0.1, 0)
openButton.Position = UDim2.new(0.05, 0, 0.5, 0)
openButton.Text = "Open GamePass Menu"
openButton.TextScaled = true
openButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)  -- Blue background
openButton.TextColor3 = Color3.new(1, 1, 1)

-- Create buttons for each GamePass
local premiumPaidButton = Instance.new("TextButton")
premiumPaidButton.Parent = coverFrame
premiumPaidButton.Size = UDim2.new(0.3, 0, 0.1, 0)
premiumPaidButton.Position = UDim2.new(0.35, 0, 0.3, 0)
premiumPaidButton.Text = "Premium Paid (750 Robux)"
premiumPaidButton.TextScaled = true
premiumPaidButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
premiumPaidButton.TextColor3 = Color3.new(1, 1, 1)

local paidButton = Instance.new("TextButton")
paidButton.Parent = coverFrame
paidButton.Size = UDim2.new(0.3, 0, 0.1, 0)
paidButton.Position = UDim2.new(0.35, 0, 0.45, 0)
paidButton.Text = "Paid (100 Robux)"
paidButton.TextScaled = true
paidButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
paidButton.TextColor3 = Color3.new(1, 1, 1)

local speedCoilButton = Instance.new("TextButton")
speedCoilButton.Parent = coverFrame
speedCoilButton.Size = UDim2.new(0.3, 0, 0.1, 0)
speedCoilButton.Position = UDim2.new(0.35, 0, 0.6, 0)
speedCoilButton.Text = "Speed Coil (5 Robux)"
speedCoilButton.TextScaled = true
speedCoilButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
speedCoilButton.TextColor3 = Color3.new(1, 1, 1)

-- Add UI Corner to make buttons rounded
local uiCornerPremiumPaid = Instance.new("UICorner")
uiCornerPremiumPaid.CornerRadius = UDim.new(0.2, 0)
uiCornerPremiumPaid.Parent = premiumPaidButton

local uiCornerPaid = Instance.new("UICorner")
uiCornerPaid.CornerRadius = UDim.new(0.2, 0)
uiCornerPaid.Parent = paidButton

local uiCornerSpeedCoil = Instance.new("UICorner")
uiCornerSpeedCoil.CornerRadius = UDim.new(0.2, 0)
uiCornerSpeedCoil.Parent = speedCoilButton

-- Create a label to display the Speed Coil timer
local speedCoilTimerLabel = Instance.new("TextLabel")
speedCoilTimerLabel.Parent = gui
speedCoilTimerLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
speedCoilTimerLabel.Position = UDim2.new(0, 0, 0.9, 0)
speedCoilTimerLabel.Text = "Cooldown: 0s"
speedCoilTimerLabel.TextScaled = true
speedCoilTimerLabel.BackgroundTransparency = 1
speedCoilTimerLabel.TextColor3 = Color3.new(1, 1, 1)

-- Speed Coil Cooldown Variables
local speedCoilCooldownTime = 120  -- 2 minutes
local speedCoilTimeLeft = 0
local speedCoilCooldownActive = false

-- Function to automatically purchase the GamePass
local function autoPurchaseGamePass(gamePassId)
    local success, errorMessage = pcall(function()
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
    end)

    if not success then
        warn("Failed to initiate purchase: " .. errorMessage)
    end
end

-- Function to handle Speed Coil X2 Speed functionality
local function useSpeedCoil()
    if speedCoilCooldownActive then
        print("Speed Coil is on cooldown!")
        return
    end

    -- Give X2 speed and start cooldown timer
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = humanoid.WalkSpeed * 2  -- Double the speed
    end

    -- Start cooldown timer
    speedCoilCooldownActive = true
    speedCoilTimeLeft = speedCoilCooldownTime
    while speedCoilTimeLeft > 0 do
        wait(1)
        speedCoilTimeLeft = speedCoilTimeLeft - 1
        speedCoilTimerLabel.Text = "Cooldown: " .. speedCoilTimeLeft .. "s"
    end

    -- Reset after cooldown
    if humanoid then
        humanoid.WalkSpeed = humanoid.WalkSpeed / 2  -- Reset speed
    end
    speedCoilCooldownActive = false
    speedCoilTimerLabel.Text = "Cooldown: 0s"
end

-- Auto purchase the corresponding GamePass based on the button clicked
premiumPaidButton.MouseButton1Click:Connect(function()
    -- Automatically purchase the Premium Paid GamePass
    autoPurchaseGamePass(premiumPaidGamePassId)
end)

paidButton.MouseButton1Click:Connect(function()
    -- Automatically purchase the Paid GamePass
    autoPurchaseGamePass(paidGamePassId)
end)

speedCoilButton.MouseButton1Click:Connect(function()
    -- Automatically purchase the Speed Coil GamePass
    autoPurchaseGamePass(speedCoilGamePassId)

    -- Trigger Speed Coil use with cooldown
    useSpeedCoil()
end)

-- Open button functionality
openButton.MouseButton1Click:Connect(function()
    coverFrame.Visible = true  -- Show the frame with buttons when Open button is clicked
    openButton.Visible = false  -- Hide the Open button when the frame is visible
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    coverFrame.Visible = false  -- Hide the frame with buttons when Close button is clicked
    openButton.Visible = true   -- Show the Open button when the frame is hidden
end)

-- Function to save the player's Speed Coil time and GamePass ownership
local function saveSpeedCoilData()
    local success, errorMessage = pcall(function()
        dataStore:SetAsync(player.UserId, {
            speedCoilTimeLeft = speedCoilTimeLeft,
            speedCoilCooldownActive = speedCoilCooldownActive
        })
    end)

    if not success then
        warn("Failed to save Speed Coil data: " .. errorMessage)
    end
end

-- Function to load the player's saved Speed Coil data
local function loadSpeedCoilData()
    local success, data = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)

    if success and data then
        speedCoilTimeLeft = data.speedCoilTimeLeft or 0
        speedCoilCooldownActive = data.speedCoilCooldownActive or false
        if speedCoilCooldownActive then
            -- Resume the timer if the cooldown was active
            useSpeedCoil()
        end
    else
        -- Set default values if no data is found
        speedCoilTimeLeft = 0
        speedCoilCooldownActive = false
    end
end

-- Load player's Speed Coil data when they join
loadSpeedCoilData()

-- Save Speed Coil data when player leaves
player.AncestryChanged:Connect(function(_, parent)
    if not parent then
        saveSpeedCoilData()
    end
end)
