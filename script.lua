local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local gamePassId = 1105218641 -- Updated to the correct GamePass ID
local requiredRobux = 0

-- Create UI cover
gui = Instance.new("ScreenGui")
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

local priceLabel = Instance.new("TextLabel")
priceLabel.Parent = promptFrame
priceLabel.Size = UDim2.new(1, 0, 0.2, 0)
priceLabel.Position = UDim2.new(0, 0, 0.35, 0)
priceLabel.BackgroundTransparency = 1
priceLabel.TextColor3 = Color3.new(1, 1, 1)
priceLabel.TextScaled = true

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

-- Remove the big gray thing (cover background)
coverFrame.BackgroundTransparency = 1  -- Make it transparent

-- Add loading bar instead of showing gray background
local loadingBar = Instance.new("Frame")
loadingBar.Parent = promptFrame
loadingBar.Size = UDim2.new(0.8, 0, 0.1, 0)
loadingBar.Position = UDim2.new(0.1, 0, 0.5, 0)
loadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local loadingFill = Instance.new("Frame")
loadingFill.Parent = loadingBar
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.BackgroundColor3 = Color3.fromRGB(0, 176, 255)

local uiCornerBar = Instance.new("UICorner")
uiCornerBar.CornerRadius = UDim.new(0.2, 0)
uiCornerBar.Parent = loadingBar

-- Disable movement & actions
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
    end
end

-- Function to trigger purchase
local function promptPurchase()
    if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId) then
        promptLabel.Text = "Game pass verified! Enjoy the game."
        coverFrame:Destroy()
        player.Character.Humanoid.WalkSpeed = 16
        player.Character.Humanoid.JumpPower = 50
    else
        checkRobux()
        local price = requiredRobux
        priceLabel.Text = "Price: " .. tostring(price) .. " Robux"
        promptLabel.Text = "Purchase the Game Pass to Continue!"

        -- Simulate loading progress bar
        local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(loadingFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
        tween:Play()

        task.wait(5)  -- Wait until loading bar completes

        purchaseButton.Text = "Click to Purchase"
        purchaseButton.Visible = true
    end
end

-- Purchase button function
purchaseButton.MouseButton1Click:Connect(function()
    purchaseButton.Text = "Processing..."
    MarketplaceService:PromptGamePassPurchase(player, gamePassId)
end)

-- Detect purchase completion
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(userId, passId, purchased)
    if userId == player.UserId and passId == gamePassId then
        if purchased then
            promptPurchase()
        else
            promptLabel.Text = "You must purchase the game pass to play!"
            task.wait(2)
            promptPurchase()
        end
    end
end)

-- Call the function when the script runs
promptPurchase()
