local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- Set the required Robux for different checks
local requiredRobuxPaid = 100 -- Minimum Robux for Paid GamePass
local requiredRobuxPaidWithPremium = 750 -- Minimum Robux for Paid with Premium GamePass
local maxRobux = 1000000000 -- Maximum Robux limit (1 billion)

-- Set the GamePass IDs
local paidGamePassId = 123456789 -- Replace with your actual Paid GamePass ID
local paidWithPremiumGamePassId = 987654321 -- Replace with your actual Paid with Premium GamePass ID
local speedCoilGamePassId = 13600173502 -- Speed Coil GamePass ID (use the actual ID here)

-- Create UI cover
local gui = Instance.new("ScreenGui")
gui.Parent = player:FindFirstChildOfClass("PlayerGui") or Instance.new("PlayerGui", player)
gui.ResetOnSpawn = false

local purchaseButton = Instance.new("TextButton")
purchaseButton.Parent = gui
purchaseButton.Size = UDim2.new(0.3, 0, 0.1, 0) -- Adjust size as needed
purchaseButton.Position = UDim2.new(0.35, 0, 0.45, 0)
purchaseButton.Text = "Purchase"
purchaseButton.TextScaled = true
purchaseButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
purchaseButton.TextColor3 = Color3.new(1, 1, 1)
purchaseButton.Visible = false

local uiCornerButton = Instance.new("UICorner")
uiCornerButton.CornerRadius = UDim.new(0.2, 0)
uiCornerButton.Parent = purchaseButton

-- Function to get user's Robux balance
local function getUserRobux()
    local success, robux = pcall(function()
        return player:GetRobuxBalanceAsync()
    end)
    return success and robux or 0
end

-- Function to show the UI and enable the button for purchase
local function showPurchaseButton(gamePassId)
    purchaseButton.Visible = true
    purchaseButton.MouseButton1Click:Connect(function()
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
        purchaseButton.Visible = false -- Hide the button after purchase attempt
    end)
end

-- Function to check if the player has enough Robux for "Paid" game pass
local function checkRobuxForPaid()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaid and robux <= maxRobux then
        showPurchaseButton(paidGamePassId)
    end
end

-- Function to check if the player has enough Robux for "Paid with Premium" game pass
local function checkRobuxForPaidWithPremium()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaidWithPremium and robux <= maxRobux then
        showPurchaseButton(paidWithPremiumGamePassId)
    end
end

-- Function to check if the player has enough Robux for "Speed Coil" game pass
local function checkSpeedCoilPurchase()
    local robux = getUserRobux()
    if robux >= 5 and robux <= maxRobux then -- Speed Coil costs 5 Robux
        showPurchaseButton(speedCoilGamePassId)
    end
end

-- Check the player's Robux balance and show the button if eligible
checkRobuxForPaid()
checkRobuxForPaidWithPremium()
checkSpeedCoilPurchase()
