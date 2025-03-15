local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- Set the GamePass IDs
local paidGamePassId = 123456789 -- Replace with your actual Paid GamePass ID
local paidWithPremiumGamePassId = 987654321 -- Replace with your actual Paid with Premium GamePass ID
local speedCoilGamePassId = 13600173502 -- Speed Coil GamePass ID (use the actual ID here)

-- Create UI cover
local gui = Instance.new("ScreenGui")
gui.Parent = player:FindFirstChildOfClass("PlayerGui") or Instance.new("PlayerGui", player)
gui.ResetOnSpawn = false

-- Create buttons for each GamePass
local premiumPaidButton = Instance.new("TextButton")
premiumPaidButton.Parent = gui
premiumPaidButton.Size = UDim2.new(0.3, 0, 0.1, 0)
premiumPaidButton.Position = UDim2.new(0.35, 0, 0.3, 0)
premiumPaidButton.Text = "Premium Paid (750 Robux)"
premiumPaidButton.TextScaled = true
premiumPaidButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
premiumPaidButton.TextColor3 = Color3.new(1, 1, 1)

local paidButton = Instance.new("TextButton")
paidButton.Parent = gui
paidButton.Size = UDim2.new(0.3, 0, 0.1, 0)
paidButton.Position = UDim2.new(0.35, 0, 0.45, 0)
paidButton.Text = "Paid (100 Robux)"
paidButton.TextScaled = true
paidButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
paidButton.TextColor3 = Color3.new(1, 1, 1)

local speedCoilButton = Instance.new("TextButton")
speedCoilButton.Parent = gui
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

-- Auto purchase the corresponding GamePass based on the button clicked
premiumPaidButton.MouseButton1Click:Connect(function()
    -- Automatically purchase the Premium Paid GamePass
    autoPurchaseGamePass(paidWithPremiumGamePassId)
    premiumPaidButton.Visible = false -- Optionally hide the button after purchase
end)

paidButton.MouseButton1Click:Connect(function()
    -- Automatically purchase the Paid GamePass
    autoPurchaseGamePass(paidGamePassId)
    paidButton.Visible = false -- Optionally hide the button after purchase
end)

speedCoilButton.MouseButton1Click:Connect(function()
    -- Automatically purchase the Speed Coil GamePass
    autoPurchaseGamePass(speedCoilGamePassId)
    speedCoilButton.Visible = false -- Optionally hide the button after purchase
end)
