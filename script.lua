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

local coverFrame = Instance.new("Frame")
coverFrame.Parent = gui
coverFrame.Size = UDim2.new(1, 0, 1, 0)
coverFrame.BackgroundColor3 = Color3.new(0, 0, 0)
coverFrame.BackgroundTransparency = 0.5

local promptFrame = Instance.new("Frame")
promptFrame.Parent = coverFrame
promptFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
promptFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
promptFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
promptFrame.BorderSizePixel = 0
promptFrame.Visible = false
promptFrame.ClipsDescendants = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.1, 0)
uiCorner.Parent = promptFrame

local promptLabel = Instance.new("TextLabel")
promptLabel.Parent = promptFrame
promptLabel.Size = UDim2.new(1, 0, 0.3, 0)
promptLabel.Position = UDim2.new(0, 0, 0, 0)
promptLabel.BackgroundTransparency = 1
promptLabel.Text = "Loading Game Pass..."
promptLabel.TextColor3 = Color3.new(1, 1, 1)
promptLabel.TextScaled = true

local purchaseButton = Instance.new("TextButton")
purchaseButton.Parent = promptFrame
purchaseButton.Size = UDim2.new(0.8, 0, 0.25, 0)
purchaseButton.Position = UDim2.new(0.1, 0, 0.7, 0)
purchaseButton.Text = "Purchase"
purchaseButton.TextScaled = true
purchaseButton.BackgroundColor3 = Color3.fromRGB(0, 176, 255)
purchaseButton.TextColor3 = Color3.new(1, 1, 1)
purchaseButton.Visible = false

local uiCornerButton = Instance.new("UICorner")
uiCornerButton.CornerRadius = UDim.new(0.2, 0)
uiCornerButton.Parent = purchaseButton

coverFrame.Active = true
coverFrame.ZIndex = 2

-- Function to get user's Robux balance
local function getUserRobux()
    local success, robux = pcall(function()
        return player:GetRobuxBalanceAsync()
    end)
    return success and robux or 0
end

-- Function to show the UI and enable the button for purchase
local function showPurchaseButton(gamePassId)
    promptLabel.Text = "You have enough Robux for this GamePass!"
    purchaseButton.Visible = true

    purchaseButton.MouseButton1Click:Connect(function()
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
        coverFrame:Destroy() -- Close the UI after purchase attempt
    end)
end

-- Function to check if the player has enough Robux for "Paid" game pass
local function checkRobuxForPaid()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaid and robux <= maxRobux then
        promptFrame.Visible = true
        showPurchaseButton(paidGamePassId)
    else
        print("Not enough Robux for the Paid Game Pass.")
    end
end

-- Function to check if the player has enough Robux for "Paid with Premium" game pass
local function checkRobuxForPaidWithPremium()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaidWithPremium and robux <= maxRobux then
        promptFrame.Visible = true
        showPurchaseButton(paidWithPremiumGamePassId)
    else
        print("Not enough Robux for the Paid with Premium Game Pass.")
    end
end

-- Function to check if the player has enough Robux for "Speed Coil" game pass
local function checkSpeedCoilPurchase()
    local robux = getUserRobux()
    if robux >= 5 and robux <= maxRobux then -- Speed Coil costs 5 Robux
        promptFrame.Visible = true
        showPurchaseButton(speedCoilGamePassId)
    else
        print("Not enough Robux for the Speed Coil Game Pass.")
    end
end

-- Check the player's Robux balance and show the button if eligible
checkRobuxForPaid()
checkRobuxForPaidWithPremium()
checkSpeedCoilPurchase()
