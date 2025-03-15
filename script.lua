local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")

-- GamePass IDs
local premiumPaidGamePassId = 1105218641
local paidGamePassId = 1106755338
local speedCoilGamePassId = 1103848074

-- DataStore for whitelisted users
local whitelistedDataStore = DataStoreService:GetDataStore("Whitelisted")

-- Create UI cover
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Frame that will fill the screen and be grey
local coverFrame = Instance.new("Frame")
coverFrame.Parent = gui
coverFrame.Size = UDim2.new(1, 0, 1, 0)
coverFrame.Position = UDim2.new(0, 0, 0, 0)
coverFrame.BackgroundColor3 = Color3.fromRGB(169, 169, 169)  -- Grey background
coverFrame.Visible = false  -- Initially hidden

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

-- Function to automatically purchase the GamePass
local function autoPurchaseGamePass(gamePassId)
    local success, errorMessage = pcall(function()
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
    end)

    if not success then
        warn("Failed to initiate purchase: " .. errorMessage)
    end
end

-- Speed Coil functionality
local speedCoilCooldown = 120  -- 2 minutes cooldown
local speedCoilActive = false
local speedCoilEndTime = 0
local timerText = Instance.new("TextLabel")
timerText.Parent = gui
timerText.Size = UDim2.new(0.2, 0, 0.1, 0)
timerText.Position = UDim2.new(0, 0, 0.9, 0)
timerText.TextScaled = true
timerText.BackgroundTransparency = 1
timerText.TextColor3 = Color3.fromRGB(255, 255, 255)

local function updateSpeedCoilTimer()
    if speedCoilActive then
        local timeLeft = math.max(speedCoilEndTime - os.time(), 0)
        local minutes = math.floor(timeLeft / 60)
        local seconds = timeLeft % 60
        timerText.Text = string.format("Speed Coil: %02d:%02d", minutes, seconds)
        
        if timeLeft == 0 then
            speedCoilActive = false
            timerText.Text = "Speed Coil: Ready"
        end
    end
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
    
    -- Start the cooldown for Speed Coil
    if not speedCoilActive then
        speedCoilActive = true
        speedCoilEndTime = os.time() + speedCoilCooldown
        
        -- Save the cooldown data in DataStore
        local success, errorMessage = pcall(function()
            whitelistedDataStore:SetAsync(player.UserId, speedCoilEndTime)
        end)
        
        if not success then
            warn("Failed to save Speed Coil data: " .. errorMessage)
        end
    end
end)

-- Open button functionality
openButton.MouseButton1Click:Connect(function()
    coverFrame.Visible = true  -- Show the frame when Open button is clicked
    openButton.Visible = false  -- Hide the Open button when the frame is visible
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    coverFrame.Visible = false  -- Hide the frame when Close button is clicked
    openButton.Visible = true   -- Show the Open button when the frame is hidden
end)

-- Load Speed Coil data on player join
local function loadSpeedCoilData()
    local success, storedTime = pcall(function()
        return whitelistedDataStore:GetAsync(player.UserId)
    end)
    
    if success and storedTime then
        speedCoilEndTime = storedTime
        if speedCoilEndTime > os.time() then
            speedCoilActive = true
        end
    end
end

loadSpeedCoilData()

-- Update Speed Coil timer every second
while true do
    updateSpeedCoilTimer()
    wait(1)
end
