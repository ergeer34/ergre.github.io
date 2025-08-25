local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Remote = game:GetService("ReplicatedStorage").RemoteEvents.RequestTakeDiamonds
local Interface = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface")
local DiamondCount = Interface:WaitForChild("DiamondCount"):WaitForChild("Count")

local a, b, c, d, e, f, g, notificationLabel
local chest, proxPrompt
local startTime

local function rainbowStroke(stroke)
    task.spawn(function()
        while task.wait() do
            for hue = 0, 1, 0.01 do
                stroke.Color = Color3.fromHSV(hue, 1, 1)
                task.wait(0.02)
            end
        end
    end)
end

local function hopServer()
    local gameId = game.PlaceId
    while true do
        local success, body = pcall(function()
            return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(gameId))
        end)
        if success then
            local data = HttpService:JSONDecode(body)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    while true do
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(gameId, server.id, LocalPlayer)
                        end)
                        task.wait(0.1)
                    end
                end
            end
        end
        task.wait(0.2)
    end
end

task.spawn(function()
    while task.wait(1) do
        for _, char in pairs(workspace.Characters:GetChildren()) do
            if char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                if char:FindFirstChild("Humanoid").DisplayName == LocalPlayer.DisplayName then
                    hopServer()
                end
            end
        end
    end
end)

-- Create the big centered GUI
a = Instance.new("ScreenGui")
a.Name = "DiamondFarmUI"
a.ResetOnSpawn = false
a.Parent = game.CoreGui

-- Main frame
b = Instance.new("Frame", a)
b.Size = UDim2.new(0, 400, 0, 220)
b.Position = UDim2.new(0.5, -200, 0.5, -110)
b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
b.BorderSizePixel = 0
b.Active = true
b.Draggable = true

c = Instance.new("UICorner", b)
c.CornerRadius = UDim.new(0, 16)

d = Instance.new("UIStroke", b)
d.Thickness = 2
rainbowStroke(d)

-- Title
e = Instance.new("TextLabel", b)
e.Size = UDim2.new(1, 0, 0, 50)
e.Position = UDim2.new(0, 0, 0, 0)
e.BackgroundTransparency = 1
e.Text = "Farm Diamond | CÁo Mod"
e.TextColor3 = Color3.fromRGB(255, 255, 255)
e.Font = Enum.Font.GothamBold
e.TextSize = 28
e.TextStrokeTransparency = 0.6

-- Diamond count
f = Instance.new("TextLabel", b)
f.Size = UDim2.new(1, -40, 0, 60)
f.Position = UDim2.new(0, 20, 0, 60)
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.TextColor3 = Color3.new(1, 1, 1)
f.Font = Enum.Font.GothamBold
f.TextSize = 24
f.BorderSizePixel = 0

g = Instance.new("UICorner", f)
g.CornerRadius = UDim.new(0, 12)

-- Info / notification label (always visible, updates with status)
notificationLabel = Instance.new("TextLabel", b)
notificationLabel.Size = UDim2.new(1, -40, 0, 50)
notificationLabel.Position = UDim2.new(0, 20, 0, 130)
notificationLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
notificationLabel.BackgroundTransparency = 0.3
notificationLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
notificationLabel.Font = Enum.Font.GothamBold
notificationLabel.TextSize = 20
notificationLabel.Text = "Waiting for diamond chest..."
notificationLabel.BorderSizePixel = 0
local notificationCorner = Instance.new("UICorner", notificationLabel)
notificationCorner.CornerRadius = UDim.new(0, 12)

-- Live diamond count updater
task.spawn(function()
    while task.wait(0.2) do
        f.Text = "Diamonds: " .. DiamondCount.Text
    end
end)

-- Utility for updating info label
local function updateInfo(text)
    notificationLabel.Text = text
end

-- Wait for character spawn
repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

chest = workspace.Items:FindFirstChild("Stronghold Diamond Chest")
if not chest then
    updateInfo("Chest not found (my fault), hopping server...")
    hopServer()
    return
end

updateInfo("Teleporting to chest...")
LocalPlayer.Character:PivotTo(CFrame.new(chest:GetPivot().Position))

repeat
    task.wait(0.1)
    local prox = chest:FindFirstChild("Main")
    if prox and prox:FindFirstChild("ProximityAttachment") then
        proxPrompt = prox.ProximityAttachment:FindFirstChild("ProximityInteraction")
    end
until proxPrompt

updateInfo("Trying to open stronghold chest...")

startTime = tick()
while proxPrompt and proxPrompt.Parent and (tick() - startTime) < 10 do
    pcall(function()
        fireproximityprompt(proxPrompt)
    end)
    task.wait(0.2)
end

if proxPrompt and proxPrompt.Parent then
    updateInfo("Stronghold is starting (auto coming soon), hopping server...")
    hopServer()
    return
end

updateInfo("Searching for diamonds in workspace...")

repeat task.wait(0.1) until workspace:FindFirstChild("Diamond", true)

local diamondsFound = 0
for _, v in pairs(workspace:GetDescendants()) do
    if v.ClassName == "Model" and v.Name == "Diamond" then
        Remote:FireServer(v)
        diamondsFound = diamondsFound + 1
    end
end

updateInfo("Took all diamonds (" .. diamondsFound .. "), hopping server...")

task.wait(1)
hopServer()
