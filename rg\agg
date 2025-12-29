local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 Madara Hub V3 - Híbrido", "DarkTheme")

-- ⚙️ Serviços
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AbilityEffects = Remotes:WaitForChild("AbilityEffects")
local AbilityHit = Remotes:WaitForChild("AbilityHit")

-- 📂 Detecção de Skills (Dinâmico)
local allSkills = {}
local sharedFolder = ReplicatedStorage:FindFirstChild("SharedModules") and ReplicatedStorage.SharedModules:FindFirstChild("Abilities")
if sharedFolder then
    for _, module in ipairs(sharedFolder:GetChildren()) do
        table.insert(allSkills, module.Name)
    end
end

-------------------------------------------------
-- 🌀 ABA MADARA (Combos Fixos)
-------------------------------------------------
local TabMadara = Window:NewTab("Madara")
local SectionMadara = TabMadara:NewSection("Skills Combo")

local toggleMadara = false
local toggleSemTimeStop = false
local toggleSupremo = false -- Novo

-- Funções de Disparo
local function ativarMadara()
    AbilityEffects:FireServer("Spirit Summon")
    AbilityEffects:FireServer("Ice Path")
    AbilityEffects:FireServer("Dirt Wall")
    AbilityEffects:FireServer("Time Stop", CFrame.new(631.381, 3.5, -422.702))
    AbilityEffects:FireServer("Shrine Expansion")
end

local function ativarSupremo()
    for _, skill in ipairs(allSkills) do
        AbilityEffects:FireServer(skill, Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
    end
end

SectionMadara:NewToggle("Combo Full (Madara)", "Sequência Original", function(v) toggleMadara = v end)
SectionMadara:NewToggle("🔥 COMBO SUPREMO", "Usa todas as skills detectadas", function(v) toggleSupremo = v end)

-------------------------------------------------
-- ⚔️ ABA BRING + POWERS (Alvos)
-------------------------------------------------
local TabBP = Window:NewTab("Alvos & Skills")
local SectionBP = TabBP:NewSection("Configurar Ataque")

local playersList = {}
for _, plr in ipairs(Players:GetPlayers()) do 
    if plr ~= Players.LocalPlayer then table.insert(playersList, plr.Name) end 
end

local selectedPlayer = nil
SectionBP:NewDropdown("Escolher Jogador", "Alvo", playersList, function(v) selectedPlayer = v end)

-- Usa a lista detectada ou uma lista padrão se falhar
local powerList = #allSkills > 0 and allSkills or {"Bring Spell", "Copied Purple", "Hollow Purple"}
local selectedPower = powerList[1]

SectionBP:NewDropdown("Escolher Poder", "Habilidade", powerList, function(v) selectedPower = v end)

local toggleBP = false

local function ativarPoderNoAlvo()
    if not selectedPlayer then return end
    local target = Players:FindFirstChild(selectedPlayer)
    if not target or not target.Character then return end
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    AbilityHit:FireServer(selectedPower, humanoid, target.Character.HumanoidRootPart.CFrame)
end

SectionBP:NewToggle("Atacar Alvo (Loop)", "Ativa repetidamente no alvo", function(v) toggleBP = v end)

-------------------------------------------------
-- 🔁 LOOP DE EXECUÇÃO
-------------------------------------------------
RunService.Heartbeat:Connect(function()
    if toggleMadara then ativarMadara() end
    if toggleSupremo then ativarSupremo() end
    if toggleBP then ativarPoderNoAlvo() end
end)

-- Configurações
local SectionConfig = TabMadara:NewSection("Config")
SectionConfig:NewKeybind("Abrir/Fechar Menu", "Shift Direito", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)

print("✅ Madara Hub Híbrido Carregado!")
