-- ZETA ULTIMATE AUTO FARM + CONGELAR ZUMBIS + AUTO COLETA SEM TELEPORTE [rev Copilot]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local AutoFarm = true
local CongelarZumbis = false
local AutoColetar = false
local minimized = false

----------------------------------------------------
-- HITBOX MELHORADA
----------------------------------------------------
local function increaseZombieHitbox(zombie)
    pcall(function()
        local root = zombie:FindFirstChild("HumanoidRootPart")
        if root then
            root.Size = Vector3.new(10, 10, 10)
            root.CanCollide = false
            root.Massless = true
            root.Transparency = 0.4
            root.Material = "Neon"
            root.Color = Color3.fromRGB(255, 0, 0)
            zombie.PrimaryPart = root
        end
    end)
end

----------------------------------------------------
-- FIND ZOMBIES
----------------------------------------------------
local function findZombies()
    local zombies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
            if string.find(string.lower(obj.Name), "zombie") or string.find(string.lower(obj.Name), "infected") then
                table.insert(zombies, obj)
                increaseZombieHitbox(obj)
            end
        end
    end
    return zombies
end

----------------------------------------------------
-- SISTEMA DE CONGELAR ZUMBIS
----------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if CongelarZumbis then
            for _, zumbi in pairs(findZombies()) do
                pcall(function()
                    local hrp = zumbi:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- CONGELA O ZUMBI NA POSIÇÃO ATUAL
                        hrp.CFrame = CFrame.new(hrp.Position)
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.RotVelocity = Vector3.new(0, 0, 0)
                        -- Congela também o Humanoid
                        local humanoid = zumbi:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.WalkSpeed = 0
                        end
                    end
                end)
            end
        end
    end
end)

----------------------------------------------------
-- SISTEMA DE COLETA SEM TELEPORTE (USANDO HOLD)
----------------------------------------------------
local function coletarItensProximos()
    local itensColetados = 0

    for _, item in pairs(workspace:GetDescendants()) do
        if AutoColetar then
            local prox = (item.Position and ((HumanoidRootPart.Position - item.Position).Magnitude < 25))
            -- Berry & BerryBush
            if item.Name == "Berry" or item.Name == "BerryBush" then
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt") or item:FindFirstChild("PickBerryPrompt")
                if prompt and prox then
                    prompt:InputHoldBegin()
                    wait(0.5) -- Ajuste este tempo se necessário!
                    prompt:InputHoldEnd()
                    itensColetados = itensColetados + 1
                end
            end
            -- PotionSpawns
            if item.Name == "PotionSpawns" then
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt and prox then
                    prompt:InputHoldBegin()
                    wait(0.5)
                    prompt:InputHoldEnd()
                    itensColetados = itensColetados + 1
                end
            end
            -- FuelSpawns
            if item.Name == "FuelSpawns" then
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt")
                if prompt and prox then
                    prompt:InputHoldBegin()
                    wait(0.5)
                    prompt:InputHoldEnd()
                    itensColetados = itensColetados + 1
                end
            end
        end
    end

    if itensColetados > 0 then
        print("🎯 Coletados " .. itensColetados .. " itens próximos!")
    end
end

-- LOOP DE COLETA
task.spawn(function()
    while task.wait(2) do
        if AutoColetar then
            coletarItensProximos()
        end
    end
end)

----------------------------------------------------
-- KILL ZOMBIE (SISTEMA ORIGINAL)
----------------------------------------------------
local function killZombie(zombie)
    if not AutoFarm then return end
    if not zombie or not zombie:FindFirstChild("HumanoidRootPart") then return end

    local damageEvent = game:GetService("ReplicatedStorage"):FindFirstChild("ZombieDamageEvent")

    while AutoFarm and zombie:FindFirstChild("Humanoid") and zombie.Humanoid.Health > 0 do
        local pos = zombie.HumanoidRootPart.Position
        HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(5, 3, 5))

        if damageEvent then
            damageEvent:FireServer(zombie, 1000)
        end

        task.wait(0.1)
    end
end

----------------------------------------------------
-- LOOP PRINCIPAL AUTO FARM
----------------------------------------------------
task.spawn(function()
    while true do
        if AutoFarm then
            local zombies = findZombies()
            if #zombies > 0 then
                for _, z in ipairs(zombies) do
                    if AutoFarm and z:FindFirstChild("Humanoid") and z.Humanoid.Health > 0 then
                        killZombie(z)
                    end
                end
            else
                wait(3)
            end
        end
        task.wait(0.5)
    end
end)

----------------------------------------------------
-- TP PARA BASE
----------------------------------------------------
local SpawnPoint = Vector3.new(1300.2952880859375, 416.98870849609375, -3557.832275390625)
local function TPBase()
    HumanoidRootPart.CFrame = CFrame.new(SpawnPoint)
end

----------------------------------------------------
-- UI PROFISSIONAL
----------------------------------------------------
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 270)
frame.Position = UDim2.new(0.5, -130, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -90, 0, 40)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "imkaisure"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(180, 180, 255)

-- Botão Minimizar
local minimize = Instance.new("TextButton", frame)
minimize.Size = UDim2.new(0, 40, 0, 30)
minimize.Position = UDim2.new(1, -90, 0, 5)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

-- Botão Fechar
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 40, 0, 30)
close.Position = UDim2.new(1, -45, 0, 5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

----------------------------------------------------
-- BOTÕES DA UI
----------------------------------------------------
local elements = {}

-- AUTO FARM
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.new(0, 10, 0, 50)
toggle.Text = "DESATIVAR AUTO FARM"
toggle.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 16
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)
table.insert(elements, toggle)

-- TP BASE
local tp = Instance.new("TextButton", frame)
tp.Size = UDim2.new(1, -20, 0, 40)
tp.Position = UDim2.new(0, 10, 0, 95)
tp.Text = "TP PARA BASE"
tp.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
tp.TextColor3 = Color3.fromRGB(255, 255, 255)
tp.Font = Enum.Font.GothamBold
tp.TextSize = 16
Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 8)
table.insert(elements, tp)

-- CONGELAR ZUMBIS
local congelarBtn = Instance.new("TextButton", frame)
congelarBtn.Size = UDim2.new(1, -20, 0, 40)
congelarBtn.Position = UDim2.new(0, 10, 0, 140)
congelarBtn.Text = "CONGELAR ZUMBIS: OFF"
congelarBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 255)
congelarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
congelarBtn.Font = Enum.Font.GothamBold
congelarBtn.TextSize = 16
Instance.new("UICorner", congelarBtn).CornerRadius = UDim.new(0, 8)
table.insert(elements, congelarBtn)

-- AUTO COLETAR (SEM TELEPORTE)
local coletarBtn = Instance.new("TextButton", frame)
coletarBtn.Size = UDim2.new(1, -20, 0, 40)
coletarBtn.Position = UDim2.new(0, 10, 0, 185)
coletarBtn.Text = "AUTO COLETAR: OFF"
coletarBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
coletarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
coletarBtn.Font = Enum.Font.GothamBold
coletarBtn.TextSize = 16
Instance.new("UICorner", coletarBtn).CornerRadius = UDim.new(0, 8)
table.insert(elements, coletarBtn)

----------------------------------------------------
-- FUNÇÕES DOS BOTÕES
----------------------------------------------------
toggle.MouseButton1Click:Connect(function()
    AutoFarm = not AutoFarm
    toggle.Text = AutoFarm and "DESATIVAR AUTO FARM" or "ATIVAR AUTO FARM"
    toggle.BackgroundColor3 = AutoFarm and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(100, 170, 255)
end)

tp.MouseButton1Click:Connect(function()
    TPBase()
end)

congelarBtn.MouseButton1Click:Connect(function()
    CongelarZumbis = not CongelarZumbis
    congelarBtn.Text = CongelarZumbis and "CONGELAR ZUMBIS: ON" or "CONGELAR ZUMBIS: OFF"
    congelarBtn.BackgroundColor3 = CongelarZumbis and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(150, 80, 255)
end)

coletarBtn.MouseButton1Click:Connect(function()
    AutoColetar = not AutoColetar
    coletarBtn.Text = AutoColetar and "AUTO COLETAR: ON" or "AUTO COLETAR: OFF"
    coletarBtn.BackgroundColor3 = AutoColetar and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(80, 200, 120)
end)

----------------------------------------------------
-- MINIMIZAR/FECHAR
----------------------------------------------------
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, v in ipairs(elements) do
        v.Visible = not minimized
    end
    title.Visible = not minimized
    frame.Size = minimized and UDim2.new(0, 160, 0, 40) or UDim2.new(0, 260, 0, 270)
    minimize.Text = minimized and "+" or "-"
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)