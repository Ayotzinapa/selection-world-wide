local function createBox(character)
    local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if torso then
       
        for _, child in pairs(torso:GetChildren()) do
            if child:IsA("BoxHandleAdornment") then
                child:Destroy()
            end
        end
        
        
        local box = Instance.new("BoxHandleAdornment")
        box.Size = torso.Size + Vector3.new(2, 2, 2) 
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5 
        box.Adornee = torso
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Parent = torso
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        createBox(character)
    end)
    
   
    if player.Character then
        createBox(player.Character)
    end
end


for _, player in pairs(game.Players:GetPlayers()) do
    onPlayerAdded(player)
end


game.Players.PlayerAdded:Connect(onPlayerAdded)
