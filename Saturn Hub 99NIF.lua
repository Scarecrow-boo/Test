-- Load Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/main/src/Modules/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/main/src/Modules/InterfaceManager.lua"))()

-- Create main window
local Window = Fluent:CreateWindow({
    Title = "Saturn Hub",
    SubTitle = "Syncing",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = nil,
})

-- Initialize SaveManager and InterfaceManager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Create tabs
local InfoTab = Window:AddTab({ Title = "Info", Icon = "info" })
local ESPTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
local TeleportTab = Window:AddTab({ Title = "Teleport", Icon = "map-pin" })
local BringTab = Window:AddTab({ Title = "Bring Items", Icon = "package" })
local HitboxTab = Window:AddTab({ Title = "Hitbox", Icon = "box" })
local MiscTab = Window:AddTab({ Title = "Misc", Icon = "settings" })

-- Info tab content
InfoTab:AddParagraph({
    Title = "Saturn Hub Say :",
    Content = "Welcome to Saturn Hub, Join discord server for news and upcoming script/Update"
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ESP System (Optimized)
local ESP = {
    Enabled = false,
    Players = false,
    Fairies = false,
    Wolves = false,
    Bunnies = false,
    Cultists = false,
    PeltTraders = false,
    Items = false,
    ItemColor = Color3.fromRGB(255, 255, 0),
    ItemDistance = 100,
    Drawings = {},
    ItemDrawings = {},
    TrackedItems = {},
    ItemToggles = {
        Berry = false,
        Log = false,
        Chest = false,
        Toolbox = false,
        Coal = false,
        Carrot = false,
        Flashlight = false,
        Radio = false,
        ["Sheet Metal"] = false,
        Bolt = false,
        Chair = false,
        Fan = false,
        ["Good Sack"] = false,
        ["Good Axe"] = false,
        ["Raw Meat"] = false,
        ["Cooked Meat"] = false,
        Stone = false,
        Nails = false,
        Scrap = false,
        ["Wooden Plank"] = false,
        Revolver = false,
        ["Revolver Ammo"] = false,
        Bandage = false
    }
}

-- Create ESP drawing objects efficiently
local function createESPObject()
    local obj = {
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBack = Drawing.new("Square"),
        Tracer = Drawing.new("Line")
    }
    
    obj.Name.Size = 16
    obj.Name.Center = true
    obj.Name.Outline = true
    
    obj.HealthBar.Filled = true
    obj.HealthBar.Thickness = 1
    
    obj.HealthBack.Filled = true
    obj.HealthBack.Thickness = 1
    obj.HealthBack.Color = Color3.new(0, 0, 0)
    obj.HealthBack.Transparency = 0.7
    
    obj.Tracer.Thickness = 1
    obj.Tracer.Color = Color3.new(1, 0, 0)
    
    return obj
end

-- Create item ESP drawing
local function createItemESP()
    local text = Drawing.new("Text")
    text.Size = 14
    text.Center = true
    text.Outline = true
    text.Font = 2
    return text
end

-- ESP Update function (optimized)
local function updateESP()
    if not ESP.Enabled then return end
    
    local screenMid = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 10)
    
    -- Clear all drawings first
    for _, drawing in pairs(ESP.Drawings) do
        drawing.Name.Visible = false
        drawing.HealthBar.Visible = false
        drawing.HealthBack.Visible = false
        drawing.Tracer.Visible = false
    end
    
    -- Process characters and NPCs
    for _, model in pairs(Workspace:GetChildren()) do
        if model:IsA("Model") then
            local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
            if head then
                local isPlayer = Players:GetPlayerFromCharacter(model)
                local shouldShow = false
                local label = ""
                
                if isPlayer and ESP.Players then
                    local distance = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
                    label = model.Name .. " {" .. distance .. "m}"
                    shouldShow = true
                elseif not isPlayer then
                    local name = model.Name:lower()
                    local distance = math.floor((Camera.CFrame.Position - head.Position).Magnitude)
                    
                    if ESP.Fairies and name:find("fairy") then
                        label = "🧚 Fairy {" .. distance .. "m}"
                        shouldShow = true
                    elseif ESP.Wolves and (name:find("wolf") or name:find("alpha")) then
                        label = "🐺 Wolf {" .. distance .. "m}"
                        shouldShow = true
                    elseif ESP.Bunnies and name:find("bunny") then
                        label = "🐰 Bunny {" .. distance .. "m}"
                        shouldShow = true
                    elseif ESP.Cultists and name:find("cultist") then
                        label = name:find("cross") and "🏹 CrossBow Cultist {" .. distance .. "m}" or "👺 Cultist {" .. distance .. "m}"
                        shouldShow = true
                    elseif ESP.PeltTraders and name:find("pelt") then
                        label = "🛒 Pelt Trader {" .. distance .. "m}"
                        shouldShow = true
                    end
                end
                
                if shouldShow then
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        -- Get or create ESP object
                        local espObj = ESP.Drawings[model]
                        if not espObj then
                            espObj = createESPObject()
                            ESP.Drawings[model] = espObj
                        end
                        
                        -- Update ESP elements
                        local textY = headPos.Y - 25
                        
                        espObj.Name.Text = label
                        espObj.Name.Position = Vector2.new(headPos.X, textY)
                        espObj.Name.Visible = true
                        
                        -- Health bar
                        local humanoid = model:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            local barWidth = 60
                            local barHeight = 6
                            local barX = headPos.X - (barWidth / 2)
                            local barY = textY + 18
                            
                            espObj.HealthBack.Size = Vector2.new(barWidth, barHeight)
                            espObj.HealthBack.Position = Vector2.new(barX, barY)
                            espObj.HealthBack.Visible = true
                            
                            espObj.HealthBar.Size = Vector2.new(barWidth * hpPercent, barHeight)
                            espObj.HealthBar.Position = Vector2.new(barX, barY)
                            espObj.HealthBar.Color = Color3.new(1 - hpPercent, hpPercent, 0)
                            espObj.HealthBar.Visible = true
                        end
                        
                        -- Tracer
                        espObj.Tracer.From = screenMid
                        espObj.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                        espObj.Tracer.Visible = true
                    end
                end
            end
        end
    end
end

-- Item ESP Update
local function updateItemESP()
    if not ESP.Items then
        for _, drawing in pairs(ESP.ItemDrawings) do
            drawing.Visible = false
        end
        return
    end
    
    -- Clear all item drawings
    for _, drawing in pairs(ESP.ItemDrawings) do
        drawing.Visible = false
    end
    
    -- Process items
    local itemsFolder = Workspace:FindFirstChild("Items")
    if not itemsFolder then return end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
        if part and ESP.ItemToggles[item.Name] then
            local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = math.floor((Camera.CFrame.Position - part.Position).Magnitude)
                if distance <= ESP.ItemDistance then
                    local drawing = ESP.ItemDrawings[item]
                    if not drawing then
                        drawing = createItemESP()
                        ESP.ItemDrawings[item] = drawing
                    end
                    
                    drawing.Text = string.format("%s [%dm]", item.Name, distance)
                    drawing.Position = Vector2.new(pos.X, pos.Y)
                    drawing.Color = ESP.ItemColor
                    drawing.Visible = true
                end
            end
        end
    end
end

-- ESP Toggles
ESPTab:AddToggle("PlayerESP", {
    Title = "Player ESP",
    Default = false,
    Callback = function(value)
        ESP.Players = value
        ESP.Enabled = value or ESP.Fairies or ESP.Wolves or ESP.Bunnies or ESP.Cultists or ESP.PeltTraders
    end
})

ESPTab:AddToggle("FairyESP", {
    Title = "Fairy ESP",
    Default = false,
    Callback = function(value)
        ESP.Fairies = value
        ESP.Enabled = ESP.Players or value or ESP.Wolves or ESP.Bunnies or ESP.Cultists or ESP.PeltTraders
    end
})

ESPTab:AddToggle("WolfESP", {
    Title = "Wolf ESP",
    Default = false,
    Callback = function(value)
        ESP.Wolves = value
        ESP.Enabled = ESP.Players or ESP.Fairies or value or ESP.Bunnies or ESP.Cultists or ESP.PeltTraders
    end
})

ESPTab:AddToggle("BunnyESP", {
    Title = "Bunny ESP",
    Default = false,
    Callback = function(value)
        ESP.Bunnies = value
        ESP.Enabled = ESP.Players or ESP.Fairies or ESP.Wolves or value or ESP.Cultists or ESP.PeltTraders
    end
})

ESPTab:AddToggle("CultistESP", {
    Title = "Cultist ESP",
    Default = false,
    Callback = function(value)
        ESP.Cultists = value
        ESP.Enabled = ESP.Players or ESP.Fairies or ESP.Wolves or ESP.Bunnies or value or ESP.PeltTraders
    end
})

ESPTab:AddToggle("PeltTraderESP", {
    Title = "Pelt Trader ESP",
    Default = false,
    Callback = function(value)
        ESP.PeltTraders = value
        ESP.Enabled = ESP.Players or ESP.Fairies or ESP.Wolves or ESP.Bunnies or ESP.Cultists or value
    end
})

-- Item ESP Toggles
ESPTab:AddToggle("ItemESP", {
    Title = "Item ESP",
    Default = false,
    Callback = function(value)
        ESP.Items = value
    end
})

ESPTab:AddColorPicker("ItemColor", {
    Title = "Item ESP Color",
    Default = Color3.fromRGB(255, 255, 0),
    Callback = function(value)
        ESP.ItemColor = value
    end
})

ESPTab:AddSlider("ItemDistance", {
    Title = "Item ESP Distance",
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
        ESP.ItemDistance = value
    end
})

-- Food ESP toggle
ESPTab:AddToggle("FoodESP", {
    Title = "Food ESP",
    Default = false,
    Callback = function(value)
        ESP.ItemToggles["Berry"] = value
        ESP.ItemToggles["Carrot"] = value
        ESP.ItemToggles["Raw Meat"] = value
        ESP.ItemToggles["Cooked Meat"] = value
    end
})

-- Revolver ESP toggle
ESPTab:AddToggle("RevolverESP", {
    Title = "Revolver + Ammo ESP",
    Default = false,
    Callback = function(value)
        ESP.ItemToggles["Revolver"] = value
        ESP.ItemToggles["Revolver Ammo"] = value
    end
})

-- Individual item toggles
for itemName, _ in pairs(ESP.ItemToggles) do
    if not string.match(itemName, "Raw Meat") and not string.match(itemName, "Cooked Meat") and 
       not string.match(itemName, "Berry") and not string.match(itemName, "Carrot") and
       not string.match(itemName, "Revolver") and not string.match(itemName, "Revolver Ammo") then
        ESPTab:AddToggle(itemName .. "Toggle", {
            Title = itemName .. " ESP",
            Default = false,
            Callback = function(value)
                ESP.ItemToggles[itemName] = value
            end
        })
    end
end

-- Teleport Functions
TeleportTab:AddButton({
    Title = "Teleport to Camp",
    Description = "Teleports you to the camp location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end
})

TeleportTab:AddButton({
    Title = "Teleport to Trader",
    Description = "Teleports you to the trader location",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(-37.08, 3.98, -16.33)
        end
    end
})

-- Bring Items Functions
local function bringItemsByName(name)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local itemsFolder = Workspace:FindFirstChild("Items")
    if not itemsFolder then return end
    
    for _, item in pairs(itemsFolder:GetChildren()) do
        if string.find(string.lower(item.Name), string.lower(name)) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
    end
end

BringTab:AddButton({
    Title = "Bring Everything",
    Description = "Brings all nearby items to you",
    Callback = function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local itemsFolder = Workspace:FindFirstChild("Items")
        if not itemsFolder then return end
        
        for _, item in pairs(itemsFolder:GetChildren()) do
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                part.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
    end
})

BringTab:AddButton({
    Title = "Auto Cook Meat",
    Description = "Brings all meat to the campfire",
    Callback = function()
        local campfirePos = Vector3.new(1.87, 4.33, -3.67)
        local itemsFolder = Workspace:FindFirstChild("Items")
        if not itemsFolder then return end
        
        for _, item in pairs(itemsFolder:GetChildren()) do
            if string.find(string.lower(item.Name), "meat") then
                local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
                if part then
                    part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2)))
                end
            end
        end
    end
})

-- Add more bring buttons for specific items
local bringItems = {
    "Logs",
    "Coal",
    "Meat (Raw + Cooked)",
    "Flashlight",
    "Nails",
    "Fan",
    "Ammo",
    "Sheet Metal",
    "Fuel Canister",
    "Tyre",
    "Bandage",
    "Lost Child",
    "Revolver"
}

for _, item in pairs(bringItems) do
    local name = string.gsub(item, "%s%(%a+%s%+%s%a+%)", "") -- Remove parentheses for function name
    BringTab:AddButton({
        Title = "Bring " .. item,
        Description = "Brings all " .. string.lower(item) .. " to you",
        Callback = function()
            bringItemsByName(name)
        end
    })
end

-- Hitbox System
local Hitbox = {
    Enabled = false,
    Wolves = false,
    Bunnies = false,
    Cultists = false,
    Size = 10,
    Show = false
}

local function updateHitboxes()
    for _, model in pairs(Workspace:GetDescendants()) do
        if model:IsA("Model") then
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then
                local name = string.lower(model.Name)
                local shouldResize = false
                
                if Hitbox.Wolves and (string.find(name, "wolf") or string.find(name, "alpha")) then
                    shouldResize = true
                elseif Hitbox.Bunnies and string.find(name, "bunny") then
                    shouldResize = true
                elseif Hitbox.Cultists and (string.find(name, "cultist") or string.find(name, "cross")) then
                    shouldResize = true
                end
                
                if shouldResize then
                    root.Size = Vector3.new(Hitbox.Size, Hitbox.Size, Hitbox.Size)
                    root.Transparency = Hitbox.Show and 0.5 or 1
                    root.Color = Color3.new(1, 1, 1)
                    root.Material = Enum.Material.Neon
                    root.CanCollide = false
                end
            end
        end
    end
end

-- Hitbox Toggles
HitboxTab:AddToggle("WolfHitbox", {
    Title = "Expand Wolf Hitbox",
    Default = false,
    Callback = function(value)
        Hitbox.Wolves = value
        Hitbox.Enabled = value or Hitbox.Bunnies or Hitbox.Cultists
        updateHitboxes()
    end
})

HitboxTab:AddToggle("BunnyHitbox", {
    Title = "Expand Bunny Hitbox",
    Default = false,
    Callback = function(value)
        Hitbox.Bunnies = value
        Hitbox.Enabled = Hitbox.Wolves or value or Hitbox.Cultists
        updateHitboxes()
    end
})

HitboxTab:AddToggle("CultistHitbox", {
    Title = "Expand Cultist Hitbox",
    Default = false,
    Callback = function(value)
        Hitbox.Cultists = value
        Hitbox.Enabled = Hitbox.Wolves or Hitbox.Bunnies or value
        updateHitboxes()
    end
})

HitboxTab:AddSlider("HitboxSize", {
    Title = "Hitbox Size",
    Default = 10,
    Min = 2,
    Max = 30,
    Rounding = 0,
    Callback = function(value)
        Hitbox.Size = value
        if Hitbox.Enabled then
            updateHitboxes()
        end
    end
})

HitboxTab:AddToggle("ShowHitbox", {
    Title = "Show Hitbox (Transparency)",
    Default = false,
    Callback = function(value)
        Hitbox.Show = value
        if Hitbox.Enabled then
            updateHitboxes()
        end
    end
})

-- Misc Features
local Misc = {
    SpeedEnabled = false,
    SpeedValue = 28,
    ShowFPS = true,
    ShowPing = true
}

-- Speed Hack
MiscTab:AddToggle("SpeedHack", {
    Title = "Speed Hack",
    Default = false,
    Callback = function(value)
        Misc.SpeedEnabled = value
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = value and Misc.SpeedValue or 16
        end
    end
})

MiscTab:AddSlider("SpeedValue", {
    Title = "Speed Value",
    Default = 28,
    Min = 16,
    Max = 600,
    Rounding = 0,
    Callback = function(value)
        Misc.SpeedValue = value
        if Misc.SpeedEnabled then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.WalkSpeed = value
                end
            end
        end
    end
})

-- FPS and Ping Display
local fpsText = Drawing.new("Text")
fpsText.Size = 16
fpsText.Position = Vector2.new(Camera.ViewportSize.X - 100, 10)
fpsText.Color = Color3.new(0, 1, 0)
fpsText.Outline = true
fpsText.Visible = Misc.ShowFPS

local pingText = Drawing.new("Text")
pingText.Size = 16
pingText.Position = Vector2.new(Camera.ViewportSize.X - 100, 30)
pingText.Color = Color3.new(0, 1, 0)
pingText.Outline = true
pingText.Visible = Misc.ShowPing

MiscTab:AddToggle("ShowFPS", {
    Title = "Show FPS",
    Default = true,
    Callback = function(value)
        Misc.ShowFPS = value
        fpsText.Visible = value
    end
})

MiscTab:AddToggle("ShowPing", {
    Title = "Show Ping (ms)",
    Default = true,
    Callback = function(value)
        Misc.ShowPing = value
        pingText.Visible = value
    end
})

-- FPS Boost
MiscTab:AddButton({
    Title = "FPS Boost",
    Description = "Reduces graphics quality for better performance",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") then
                    obj.Enabled = false
                end
            end
            
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
            
            Fluent:Notify({
                Title = "FPS Boost",
                Content = "✅ FPS Boost Applied",
                Duration = 3
            })
        end)
    end
})

-- Main render loop (optimized)
local lastUpdate = 0
RunService.RenderStepped:Connect(function(deltaTime)
    -- Update ESP at 30 FPS (0.033s) to reduce load
    if tick() - lastUpdate > 0.033 then
        updateESP()
        updateItemESP()
        lastUpdate = tick()
    end
    
    -- Update FPS counter every second
    if Misc.ShowFPS or Misc.ShowPing then
        local now = tick()
        if now - (fpsText.LastUpdate or 0) >= 1 then
            if Misc.ShowFPS then
                fpsText.Text = "FPS: " .. math.floor(1 / deltaTime)
            end
            
            if Misc.ShowPing then
                local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                pingText.Text = "Ping: " .. ping .. "ms"
                
                if ping <= 60 then
                    pingText.Color = Color3.new(0, 1, 0)
                elseif ping <= 120 then
                    pingText.Color = Color3.new(1, 0.65, 0)
                else
                    pingText.Color = Color3.new(1, 0, 0)
                end
            end
            
            fpsText.LastUpdate = now
        end
    end
end)

-- Cleanup on script termination
Window:OnDestroy(function()
    for _, drawing in pairs(ESP.Drawings) do
        for _, obj in pairs(drawing) do
            if typeof(obj) == "Drawing" then
                obj:Remove()
            end
        end
    end
    
    for _, drawing in pairs(ESP.ItemDrawings) do
        if typeof(drawing) == "Drawing" then
            drawing:Remove()
        end
    end
    
    fpsText:Remove()
    pingText:Remove()
end)

-- Initialize InterfaceManager and SaveManager
InterfaceManager:SetFolder("FluentInterface")
SaveManager:SetFolder("FluentScript")

InterfaceManager:BuildInterfaceSection(Window)
SaveManager:BuildConfigSection(Window)

Window:SelectTab(1)
Fluent:Notify({
    Title = "99 Nights in Forest",
    Content = "Script loaded successfully!",
    Duration = 5
})
