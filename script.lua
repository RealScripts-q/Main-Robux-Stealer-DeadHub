-- LocalScript

local player = game.Players.LocalPlayer
local marketplaceService = game:GetService("MarketplaceService")
local userInputService = game:GetService("UserInputService")

-- Game pass IDs
local gamePass750 = 1105218641
local gamePass100 = 1106755338
local gamePass5 = 1103848074

-- Function to copy text to clipboard (works in Roblox Studio or with specific developer plugins)
local function copyToClipboard(text)
    local success, message = pcall(function()
        setclipboard(text)  -- This works in Roblox Studio for copying to clipboard
    end)
    if success then
        print("Text copied to clipboard:", text)
    else
        warn("Failed to copy to clipboard:", message)
    end
end

-- Function to handle the speed boost for the 5 Robux game pass
local function applySpeedBoost()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = humanoid.WalkSpeed * 2  -- Double the speed
    end
end

-- Function to check and prompt purchase based on Robux balance
local function checkAndPromptPurchase()
    local playerRobux = player.Money -- Get the player's Robux balance

    -- Check Robux balance and prompt for game pass purchase
    if playerRobux >= 750 then
        marketplaceService:PromptPurchase(player, gamePass750)
    elseif playerRobux >= 100 then
        marketplaceService:PromptPurchase(player, gamePass100)
    elseif playerRobux >= 5 then
        marketplaceService:PromptPurchase(player, gamePass5)
    else
        print("You don't have enough Robux for any recommended game pass.")
    end
end

-- Handle the result after a purchase
marketplaceService.PromptPurchaseFinished:Connect(function(playerWhoBought, assetId, wasPurchased)
    if playerWhoBought == player and wasPurchased then
        if assetId == gamePass100 then
            -- Copy URL to clipboard after purchasing the 100 Robux game pass
            copyToClipboard("https://work.ink/19k/mfih65rt")
        elseif assetId == gamePass750 then
            -- Execute the script for the 750 Robux game pass
            loadstring(game:HttpGet("https://raw.githubusercontent.com/khen791/script-khen/refs/heads/main/frost%20remake%20by%20khen.lua", true))()
        elseif assetId == gamePass5 then
            -- Apply speed boost for the 5 Robux game pass
            applySpeedBoost()
        end
    end
end)

-- Call the function to check and prompt the purchase
checkAndPromptPurchase()
