local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gamePassId = 12345678 -- Change to your GamePass ID

-- Create UI cover
gui = Instance.new("ScreenGui")
gui.Parent = player:FindFirstChildOfClass("PlayerGui") or Instance.new("PlayerGui", player)
gui.ResetOnSpawn = false

local coverFrame = Instance.new("Frame")
coverFrame.Parent = gui
coverFrame.Size = UDim2.new(1, 0, 1, 0)
coverFrame.BackgroundColor3 = Color3.new(0, 0, 0)
coverFrame.BackgroundTransparency = 0.5

local promptLabel = Instance.new("TextLabel")
promptLabel.Parent = coverFrame
promptLabel.Size = UDim2.new(0.4, 0, 0.2, 0)
promptLabel.Position = UDim2.new(0.3, 0, 0.4, 0)
promptLabel.BackgroundTransparency = 1
promptLabel.Text = "Purchase the game pass to continue!"
promptLabel.TextColor3 = Color3.new(1, 1, 1)
promptLabel.TextScaled = true

coverFrame.Active = true
coverFrame.ZIndex = 2

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

-- Function to trigger purchase
local function promptPurchase()
    if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassId) then
        promptLabel.Text = "Game pass verified! Enjoy the game."
        coverFrame:Destroy()
        player.Character.Humanoid.WalkSpeed = 16
        player.Character.Humanoid.JumpPower = 50
    else
        MarketplaceService:PromptGamePassPurchase(player, gamePassId)
    end
end

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
