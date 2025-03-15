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

-- Function to get user's Robux balance
local function getUserRobux()
    local success, robux = pcall(function()
        return player:GetRobuxBalanceAsync()
    end)
    return success and robux or 0
end

-- Function to check if the player has enough Robux for "Paid" game pass
local function checkRobuxForPaid()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaid and robux <= maxRobux then
        print("You have enough Robux for the Paid Game Pass.")
        MarketplaceService:PromptGamePassPurchase(player, paidGamePassId)
    else
        print("Not enough Robux for the Paid Game Pass.")
    end
end

-- Function to check if the player has enough Robux for "Paid with Premium" game pass
local function checkRobuxForPaidWithPremium()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaidWithPremium and robux <= maxRobux then
        print("You have enough Robux for the Paid with Premium Game Pass.")
        MarketplaceService:PromptGamePassPurchase(player, paidWithPremiumGamePassId)
    else
        print("Not enough Robux for the Paid with Premium Game Pass.")
    end
end

-- Function to check if the player has enough Robux for "Speed Coil" game pass
local function checkSpeedCoilPurchase()
    local robux = getUserRobux()
    if robux >= 5 and robux <= maxRobux then -- Speed Coil costs 5 Robux
        print("You have enough Robux for the Speed Coil Game Pass.")
        MarketplaceService:PromptGamePassPurchase(player, speedCoilGamePassId)
    else
        print("Not enough Robux for the Speed Coil Game Pass.")
    end
end

-- Check the player's Robux balance and display a message or prompt for GamePass purchase
checkRobuxForPaid()
checkRobuxForPaidWithPremium()
checkSpeedCoilPurchase()
