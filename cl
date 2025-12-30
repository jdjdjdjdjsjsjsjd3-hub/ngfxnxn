local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Bases Hub (SMART) - V2",
   LoadingTitle = "Iniciando Protocolos...",
   LoadingSubtitle = "por Gemini",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- 🔧 Serviços & Variáveis
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Bases = workspace:WaitForChild("Bases")

_G.AutoCollect = false
_G.SpamPrompts = false
local DelayPrompts = 0.15
local MyBase = nil

-- 🧠 Detectar Minha Base (Melhorado)
local function DetectMyBase()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local closest, dist = nil, math.huge
    
    for _, base in ipairs(Bases:GetChildren()) do
        local primary = base:FindFirstChild("CollectZone") or base:FindFirstChildWhichIsA("BasePart", true)
        if primary then
            local d = (primary.Position - hrp.Position).Magnitude
            if d < dist then dist = d; closest = base end
        end
    end
    return closest
end

local function UpdateMyBase()
    MyBase = DetectMyBase()
    Rayfield:Notify({Title = "Base Detectada", Content = "Sua base foi identificada com sucesso.", Duration = 3})
end

-- ⚡ LOOP 1: Auto Collect (Todas as Bases)
task.spawn(function()
    while true do
        if _G.AutoCollect then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Agora percorre TODAS as bases na pasta
                for _, b in ipairs(Bases:GetChildren()) do
                    if b:FindFirstChild("CollectZone") then
                        firetouchinterest(hrp, b.CollectZone, 0)
                        firetouchinterest(hrp, b.CollectZone, 1)
                    end
                end
            end
        end
        task.wait(0.1) -- Delay leve para evitar lag excessivo
    end
end)

-- ⚡ LOOP 2: ProximityPrompts (Global)
task.spawn(function()
    while true do
        if _G.SpamPrompts then
            for _, base in ipairs(Bases:GetChildren()) do
                -- Ignora a sua própria base para não bugar seus itens
                if base ~= MyBase then
                    for _, obj in ipairs(base:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            local name = obj.Parent and obj.Parent.Name:lower() or ""
                            local isDoor = name:find("door") or name:find("porta") or name:find("gate")
                            
                            if not isDoor then
                                pcall(function()
                                    obj.HoldDuration = 0
                                    if fireproximityprompt then fireproximityprompt(obj) end
                                end)
                            end
                        end
                    end
                end
            end
        end
        task.wait(DelayPrompts)
    end
end)

-- 🧩 UI TABS
local Tab = Window:CreateTab("Principal", 4483362458)

Tab:CreateToggle({
   Name = "Coletar de TODAS as Bases",
   CurrentValue = false,
   Callback = function(Value) _G.AutoCollect = Value end,
})

Tab:CreateToggle({
   Name = "Spam Prompts (Exceto Portas)",
   CurrentValue = false,
   Callback = function(Value) _G.SpamPrompts = Value end,
})

Tab:CreateSlider({
   Name = "Velocidade do Prompt",
   Range = {0, 1},
   Increment = 0.05,
   Suffix = "s",
   CurrentValue = 0.15,
   Callback = function(Value) DelayPrompts = Value end,
})

Tab:CreateButton({
   Name = "Recalcular Minha Base",
   Callback = function() UpdateMyBase() end,
})
