local player = game.Players.LocalPlayer
local gamePassId = 12345678 -- Change to your GamePass ID

-- Create the UI cover
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local coverFrame = Instance.new("Frame")
coverFrame.Parent = gui
coverFrame.Size = UDim2.new(1, 0, 1, 0)
coverFrame.BackgroundColor3 = Color3.new(0, 0, 0)
coverFrame.BackgroundTransparency = 0.5 -- Adjust transparency if needed

local promptLabel = Instance.new("TextLabel")
promptLabel.Parent = coverFrame
promptLabel.Size = UDim2.new(0.4, 0, 0.2, 0)
promptLabel.Position = UDim2.new(0.3, 0, 0.4, 0)
promptLabel.BackgroundTransparency = 1
promptLabel.Text = "Purchase the game pass to continue!"
promptLabel.TextColor3 = Color3.new(1, 1, 1)
promptLabel.TextScaled = true

-- Make sure the player can still click the buy button
coverFrame.Active = true
coverFrame.ZIndex = 2 -- Keep it above the Roblox prompt, but still clickable

-- Function to trigger purchase
local function promptPurchase()
    if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, gamePassId) then
        promptLabel.Text = "You already own this game pass!"
    else
        game:GetService("MarketplaceService"):PromptGamePassPurchase(player, gamePassId)
    end
end

-- Call the function when the script runs
promptPurchase()
