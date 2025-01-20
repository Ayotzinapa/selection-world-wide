local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local isAimbotActive = false
local targetPlayer = nil

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Head") then
            if otherPlayer.Team ~= player.Team then  
                local headPosition = otherPlayer.Character.Head.Position
                local distance = (headPosition - player.Character.Head.Position).Magnitude
                if distance < closestDistance then
                    closestPlayer = otherPlayer
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local function toggleAimbot()
    if isAimbotActive then
        isAimbotActive = false
        targetPlayer = nil
    else
        targetPlayer = getClosestPlayer()
        if targetPlayer then
            isAimbotActive = true
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        toggleAimbot()
    end
end)

RunService.RenderStepped:Connect(function()
    if isAimbotActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local targetHead = targetPlayer.Character.Head
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
    else
        isAimbotActive = false
        targetPlayer = nil
    end
end)
