local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()

-- Globals
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ItemsFolder = Workspace:WaitForChild("Items")

-- UI Setup with Fluent Renewed
local Window = Library:CreateWindow({
    Title = "Saturn Hub",
    SubTitle = "",
    TabGravity = Fluent.GravityTypes.Left -- You can change this to Right if you prefer
})

-- Tabs
local InfoTab = Window:AddTab("Info")
local ESPTab = Window:AddTab("ESP")
local TeleportTab = Window:AddTab("Teleport")
local BringTab = Window:AddTab("Bring Items")
local HitboxTab = Window:AddTab("Hitbox")
local MiscTab = Window:AddTab("Misc")

InfoTab:AddParagraph({
    Title = "Saturn Hub Say :",
    Content = "Thanks so much for using this Hub, AND JOIN OUR DISCORD SERVER FOR NEWS AND TRY UPCOMING SCRIPT!!!" 
})

-- ESP System
local espSettings = {
    PlayerESP = false,
    Fairy = false,
    Wolf = false,
    Bunny = false,
    Cultist = false,
    CrossBow = false,
    PeltTrader = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameSize = 16,
    HPBarSize = Vector2.new(60, 6)
}

local ESPDrawings = {} -- Stores all Drawing objects for ESP
local tracers = {} -- Stores tracer lines

-- Optimized createESP function
local function createESP(model)
    [span_1](start_span)local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart") --[span_1](end_span)
    if not head then return end

    if ESPDrawings[model] then return end -- Already created ESP for this model

    local name = Drawing.new("Text")
    [span_2](start_span)[span_3](start_span)name.Size = espSettings.NameSize --[span_2](end_span)[span_3](end_span)
    name.Center = true
    name.Outline = true
    [span_4](start_span)[span_5](start_span)name.Color = espSettings.NameColor --[span_4](end_span)[span_5](end_span)
    name.Visible = false

    local hpBack = Drawing.new("Square")
    [span_6](start_span)hpBack.Color = Color3.fromRGB(0, 0, 0) --[span_6](end_span)
    [span_7](start_span)hpBack.Thickness = 1 --[span_7](end_span)
    [span_8](start_span)hpBack.Filled = true --[span_8](end_span)
    [span_9](start_span)hpBack.Transparency = 0.7 --[span_9](end_span)
    hpBack.Visible = false

    local hpBar = Drawing.new("Square")
    [span_10](start_span)hpBar.Color = Color3.fromRGB(0, 255, 0) --[span_10](end_span)
    [span_11](start_span)hpBar.Thickness = 1 --[span_11](end_span)
    [span_12](start_span)hpBar.Filled = true --[span_12](end_span)
    [span_13](start_span)hpBar.Transparency = 0.9 --[span_13](end_span)
    hpBar.Visible = false

    ESPDrawings[model] = {
        head = head,
        name = name,
        hpBar = hpBar,
        hpBack = hpBack,
        model = model -- Keep reference to model
    }
end

-- Function to remove ESP drawings
local function removeESP(model)
    local esp = ESPDrawings[model]
    if esp then
        esp.name:Remove()
        esp.hpBar:Remove()
        esp.hpBack:Remove()
        ESPDrawings[model] = nil
    end
end

-- Clear all tracers safely
local function clearTracers()
    [span_14](start_span)for _, line in ipairs(tracers) do --[span_14](end_span)
        [span_15](start_span)line:Remove() --[span_15](end_span)
    end
    [span_16](start_span)table.clear(tracers) --[span_16](end_span)
end

-- Main ESP render loop
RunService.RenderStepped:Connect(function()
    [span_17](start_span)local screenMid = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- bottom center screen[span_17](end_span)
    [span_18](start_span)clearTracers() --[span_18](end_span)

    for model, data in pairs(ESPDrawings) do
        local head = data.head
        -- Check if model and head still exist and are in workspace
        [span_19](start_span)if not (model and head and model.Parent and head:IsDescendantOf(Workspace)) then --[span_19](end_span)
            removeESP(model)
            continue
        end

        [span_20](start_span)local isPlayer = Players:GetPlayerFromCharacter(model) --[span_20](end_span)
        local visible = false
        local labelText = ""

        [span_21](start_span)if isPlayer and espSettings.PlayerESP then --[span_21](end_span)
            [span_22](start_span)local distVal = math.floor((Camera.CFrame.Position - head.Position).Magnitude) --[span_22](end_span)
            [span_23](start_span)labelText = model.Name .. " {" .. distVal .. "m}" --[span_23](end_span)
            visible = true
        elseif not isPlayer then
            [span_24](start_span)local n = model.Name:lower() --[span_24](end_span)
            [span_25](start_span)local distVal = math.floor((Camera.CFrame.Position - head.Position).Magnitude) --[span_25](end_span)

            [span_26](start_span)if espSettings.Fairy and n:find("fairy") then --[span_26](end_span)
                [span_27](start_span)labelText = "🧚 Fairy {" .. distVal .. "m}" --[span_27](end_span)
                visible = true
            [span_28](start_span)elseif espSettings.Wolf and (n:find("wolf") or n:find("alpha")) then --[span_28](end_span)
                [span_29](start_span)labelText = "🐺 Wolf {" .. distVal .. "m}" --[span_29](end_span)
                [span_30](start_span)visible = true --[span_30](end_span)
            [span_31](start_span)elseif espSettings.Bunny and n:find("bunny") then --[span_31](end_span)
                [span_32](start_span)labelText = "🐰 Bunny {" .. distVal .. "m}" --[span_32](end_span)
                visible = true
            [span_33](start_span)elseif espSettings.Cultist and n:find("cultist") and not n:find("cross") then --[span_33](end_span)
                [span_34](start_span)labelText = "👺 Cultist {" .. distVal .. "m}" --[span_34](end_span)
                visible = true
            [span_35](start_span)elseif espSettings.CrossBow and n:find("cross") then --[span_35](end_span)
                [span_36](start_span)labelText = "🏹 CrossBow Cultist {" .. distVal .. "m}" --[span_36](end_span)
                visible = true
            [span_37](start_span)elseif espSettings.PeltTrader and n:find("pelt") then --[span_37](end_span)
                [span_38](start_span)labelText = "🛒 Pelt Trader {" .. distVal .. "m}" --[span_38](end_span)
                visible = true
            end
        end

        if visible then
            [span_39](start_span)local headPos, onScreen = Camera:WorldToViewportPoint(head.Position) --[span_39](end_span)

            [span_40](start_span)if onScreen then --[span_40](end_span)
                [span_41](start_span)local textY = headPos.Y - 25 -- Position text 25 pixels ABOVE the head[span_41](end_span)

                [span_42](start_span)data.name.Text = labelText --[span_42](end_span)
                [span_43](start_span)data.name.Position = Vector2.new(headPos.X, textY) --[span_43](end_span)
                [span_44](start_span)data.name.Color = espSettings.NameColor --[span_44](end_span)
                [span_45](start_span)data.name.Size = espSettings.NameSize --[span_45](end_span)
                [span_46](start_span)data.name.Visible = true --[span_46](end_span)

                [span_47](start_span)local humanoid = model:FindFirstChildOfClass("Humanoid") --[span_47](end_span)
                [span_48](start_span)if humanoid and humanoid.Health > 0 then --[span_48](end_span)
                    [span_49](start_span)local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1) --[span_49](end_span)
                    [span_50](start_span)local barWidth = espSettings.HPBarSize.X --[span_50](end_span)
                    [span_51](start_span)local barHeight = espSettings.HPBarSize.Y --[span_51](end_span)
                    [span_52](start_span)local barX = headPos.X - (barWidth / 2) --[span_52](end_span)
                    [span_53](start_span)local barY = textY + 18 -- 18 pixels below the text[span_53](end_span)

                    [span_54](start_span)data.hpBack.Size = Vector2.new(barWidth, barHeight) --[span_54](end_span)
                    [span_55](start_span)data.hpBack.Position = Vector2.new(barX, barY) --[span_55](end_span)
                    [span_56](start_span)data.hpBack.Visible = true --[span_56](end_span)

                    [span_57](start_span)data.hpBar.Size = Vector2.new(barWidth * hpPercent, barHeight) --[span_57](end_span)
                    [span_58](start_span)data.hpBar.Position = Vector2.new(barX, barY) --[span_58](end_span)
                    [span_59](start_span)data.hpBar.Color = Color3.new(1 - hpPercent, hpPercent, 0) -- green to red gradient[span_59](end_span)
                    [span_60](start_span)data.hpBar.Visible = true --[span_60](end_span)
                else
                    [span_61](start_span)data.hpBar.Visible = false --[span_61](end_span)
                    [span_62](start_span)data.hpBack.Visible = false --[span_62](end_span)
                end

                [span_63](start_span)local line = Drawing.new("Line") --[span_63](end_span)
                [span_64](start_span)line.From = screenMid - Vector2.new(0, 10) --[span_64](end_span)
                [span_65](start_span)line.To = Vector2.new(headPos.X, headPos.Y) --[span_65](end_span)
                [span_66](start_span)line.Color = Color3.fromRGB(255, 0, 0) --[span_66](end_span)
                [span_67](start_span)line.Thickness = 1 --[span_67](end_span)
                [span_68](start_span)line.Visible = true --[span_68](end_span)
                [span_69](start_span)table.insert(tracers, line) --[span_69](end_span)
            else
                [span_70](start_span)data.name.Visible = false --[span_70](end_span)
                [span_71](start_span)data.hpBar.Visible = false --[span_71](end_span)
                [span_72](start_span)data.hpBack.Visible = false --[span_72](end_span)
            end
        else
            [span_73](start_span)data.name.Visible = false --[span_73](end_span)
            [span_74](start_span)data.hpBar.Visible = false --[span_74](end_span)
            [span_75](start_span)data.hpBack.Visible = false --[span_75](end_span)
        end
    end
end)

-- Scanner to add ESP to models dynamically (optimized)
-- Reduced scan frequency to every 0.5 seconds for less lag
task.spawn(function()
    while true do
        [span_76](start_span)for _, model in ipairs(Workspace:GetDescendants()) do --[span_76](end_span)
            if model:IsA("Model") and model:FindFirstChild("Humanoid") and not ESPDrawings[model] then
                -- Only create ESP for characters (players and NPCs with Humanoids)
                createESP(model)
            end
        end
        task.wait(0.5) -- Reduced wait time slightly, can be adjusted
    end
end)

-- Player Counter and Tracer Lines (optimized)
local playerCounter = Drawing.new("Text")
[span_77](start_span)playerCounter.Center = true --[span_77](end_span)
[span_78](start_span)playerCounter.Outline = true --[span_78](end_span)
[span_79](start_span)playerCounter.Size = 40 --[span_79](end_span)
[span_80](start_span)playerCounter.Color = Color3.fromRGB(255, 0, 0) --[span_80](end_span)
[span_81](start_span)playerCounter.Font = 4 --[span_81](end_span)
[span_82](start_span)playerCounter.Visible = false --[span_82](end_span)

local playerTracerLines = {}
local MAX_PLAYER_LINES = 50 -- Cap the number of lines to avoid excessive drawing
for i = 1, MAX_PLAYER_LINES do
    [span_83](start_span)local line = Drawing.new("Line") --[span_83](end_span)
    [span_84](start_span)line.Visible = false --[span_84](end_span)
    [span_85](start_span)line.Color = Color3.fromRGB(255, 0, 0) --[span_85](end_span)
    [span_86](start_span)line.Thickness = 2 --[span_86](end_span)
    playerTracerLines[i] = line
end

ESPTab:AddToggle({
    Text = "Player ESP",
    Callback = function(v)
        [span_87](start_span)espSettings.PlayerESP = v -- shows name + HP[span_87](end_span)
        [span_88](start_span)playerCounter.Visible = v -- shows player count[span_88](end_span)

        -- Hide all player tracer lines if ESP is disabled
        [span_89](start_span)if not v then --[span_89](end_span)
            [span_90](start_span)for _, line in pairs(playerTracerLines) do --[span_90](end_span)
                [span_91](start_span)line.Visible = false --[span_91](end_span)
            end
        end
    end
})

-- Update Player Counter and Tracer Lines
RunService.RenderStepped:Connect(function()
    local trackerEnabled = espSettings.PlayerESP -- Linked to Player ESP toggle
    if not trackerEnabled then
        [span_92](start_span)playerCounter.Visible = false --[span_92](end_span)
        [span_93](start_span)for _, line in pairs(playerTracerLines) do --[span_93](end_span)
            [span_94](start_span)line.Visible = false --[span_94](end_span)
        end
        return
    end

    [span_95](start_span)local visibleCount = 0 --[span_95](end_span)
    [span_96](start_span)local viewportSize = Camera.ViewportSize --[span_96](end_span)
    [span_97](start_span)local startLinePos = Vector2.new(viewportSize.X / 2, 50) --[span_97](end_span)

    local currentVisiblePlayers = {}

    [span_98](start_span)for _, player in pairs(Players:GetPlayers()) do --[span_98](end_span)
        [span_99](start_span)if player ~= LocalPlayer and player.Character then --[span_99](end_span)
            [span_100](start_span)local head = player.Character:FindFirstChild("Head") --[span_100](end_span)
            if head then
                [span_101](start_span)local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position) --[span_101](end_span)
                [span_102](start_span)if onScreen and screenPos.Z > 0 then --[span_102](end_span)
                    [span_103](start_span)visibleCount += 1 --[span_103](end_span)
                    [span_104](start_span)table.insert(currentVisiblePlayers, {player = player, pos = Vector2.new(screenPos.X, screenPos.Y)}) --[span_104](end_span)
                end
            end
        end
    end

    [span_105](start_span)playerCounter.Text = tostring(visibleCount) --[span_105](end_span)
    [span_106](start_span)playerCounter.Position = Vector2.new(viewportSize.X / 2, 8) --[span_106](end_span)
    [span_107](start_span)playerCounter.Visible = trackerEnabled --[span_107](end_span)

    -- Hide all lines first
    [span_108](start_span)for i = 1, MAX_PLAYER_LINES do --[span_108](end_span)
        playerTracerLines[i].Visible = false
    end

    -- Draw lines for visible players up to MAX_PLAYER_LINES
    if visibleCount > 0 then
        [span_109](start_span)for i, info in ipairs(currentVisiblePlayers) do --[span_109](end_span)
            [span_110](start_span)if i > MAX_PLAYER_LINES then break end --[span_110](end_span)
            [span_111](start_span)local line = playerTracerLines[i] --[span_111](end_span)
            [span_112](start_span)line.From = startLinePos --[span_112](end_span)
            [span_113](start_span)line.To = info.pos --[span_113](end_span)
            [span_114](start_span)line.Visible = true --[span_114](end_span)
        end
    end
end)


ESPTab:AddToggle({
    Text = "Fairy ESP",
    [span_115](start_span)Callback = function(v) espSettings.Fairy = v end --[span_115](end_span)
})
ESPTab:AddToggle({
    Text = "Wolf ESP",
    [span_116](start_span)Callback = function(v) espSettings.Wolf = v end --[span_116](end_span)
})
ESPTab:AddToggle({
    Text = "Bunny ESP",
    [span_117](start_span)Callback = function(v) espSettings.Bunny = v end --[span_117](end_span)
})
ESPTab:AddToggle({
    Text = "Cultist ESP",
    Callback = function(v)
        [span_118](start_span)espSettings.Cultist = v --[span_118](end_span)
        [span_119](start_span)espSettings.CrossBow = v --[span_119](end_span)
    end
})
ESPTab:AddToggle({
    Text = "Pelt Trader ESP",
    [span_120](start_span)Callback = function(v) espSettings.PeltTrader = v end --[span_120](end_span)
})

-- Item ESP
[span_121](start_span)local itemESPEnabled = true --[span_121](end_span)
[span_122](start_span)local itemColor = Color3.fromRGB(255, 255, 0) --[span_122](end_span)
local itemESPDrawings = {} -- New table to manage item ESP drawings

local showToggles = {
    [span_123](start_span)["Berry"] = false, --[span_123](end_span)
    [span_124](start_span)["Log"] = false, --[span_124](end_span)
    [span_125](start_span)["Chest"] = false, --[span_125](end_span)
    [span_126](start_span)["Toolbox"] = false, --[span_126](end_span)
    [span_127](start_span)["Coal"] = false, --[span_127](end_span)
    [span_128](start_span)["Carrot"] = false, --[span_128](end_span)
    [span_129](start_span)["Flashlight"] = false, --[span_129](end_span)
    [span_130](start_span)["Radio"] = false, --[span_130](end_span)
    [span_131](start_span)["Sheet Metal"] = false, --[span_131](end_span)
    [span_132](start_span)["Bolt"] = false, --[span_132](end_span)
    [span_133](start_span)["Chair"] = false, --[span_133](end_span)
    [span_134](start_span)["Fan"] = false, --[span_134](end_span)
    [span_135](start_span)["Good Sack"] = false, --[span_135](end_span)
    [span_136](start_span)["Good Axe"] = false, --[span_136](end_span)
    [span_137](start_span)["Raw Meat"] = false, --[span_137](end_span)
    [span_138](start_span)["Cooked Meat"] = false, --[span_138](end_span)
    [span_139](start_span)["Stone"] = false, --[span_139](end_span)
    [span_140](start_span)["Nails"] = false, --[span_140](end_span)
    [span_141](start_span)["Scrap"] = false, --[span_141](end_span)
    [span_142](start_span)["Wooden Plank"] = false, --[span_142](end_span)
    ["Revolver"] = false,
    ["Revolver Ammo"] = false,
    -- Add other items as needed
}

ESPTab:AddToggle({
    Text = "Item ESP",
    [span_143](start_span)CurrentValue = true, --[span_143](end_span)
    [span_144](start_span)Callback = function(v) itemESPEnabled = v end, --[span_144](end_span)
})

ESPTab:AddColorPicker({
    Text = "Item ESP Color",
    [span_145](start_span)Color = itemColor, --[span_145](end_span)
    [span_146](start_span)Callback = function(v) itemColor = v end, --[span_146](end_span)
})

local foodItems = {
    [span_147](start_span)"Berry", --[span_147](end_span)
    [span_148](start_span)"Carrot", --[span_148](end_span)
    [span_149](start_span)"Raw Meat", --[span_149](end_span)
    [span_150](start_span)"Cooked Meat" --[span_150](end_span)
}

ESPTab:AddToggle({
    Text = "Food ESP",
    [span_151](start_span)CurrentValue = false, --[span_151](end_span)
    Callback = function(v)
        [span_152](start_span)for _, itemName in ipairs(foodItems) do --[span_152](end_span)
            [span_153](start_span)showToggles[itemName] = v --[span_153](end_span)
        end
    end
})

ESPTab:AddToggle({
    Text = "Revolver + Ammo ESP",
    CurrentValue = false,
    Callback = function(v)
        [span_154](start_span)showToggles["Revolver"] = v --[span_154](end_span)
        [span_155](start_span)showToggles["Revolver Ammo"] = v --[span_155](end_span)
    end
})

[span_156](start_span)for itemName, _ in pairs(showToggles) do --[span_156](end_span)
    [span_157](start_span)local isFood = table.find(foodItems, itemName) --[span_157](end_span)
    [span_158](start_span)if not isFood then --[span_158](end_span)
        ESPTab:AddToggle({
            [span_159](start_span)Text = itemName, --[span_159](end_span)
            [span_160](start_span)CurrentValue = false, --[span_160](end_span)
            [span_161](start_span)Callback = function(v) showToggles[itemName] = v end, --[span_161](end_span)
        })
    end
end

-- Optimized item ESP logic
local function createItemText()
    [span_162](start_span)local text = Drawing.new("Text") --[span_162](end_span)
    [span_163](start_span)text.Size = 14 --[span_163](end_span)
    [span_164](start_span)text.Center = true --[span_164](end_span)
    [span_165](start_span)text.Outline = true --[span_165](end_span)
    [span_166](start_span)text.Font = 2 --[span_166](end_span)
    [span_167](start_span)text.Color = itemColor --[span_167](end_span)
    [span_168](start_span)text.Visible = false --[span_168](end_span)
    return text
end

-- Update and manage item ESP drawings
local function updateItemESPDrawings()
    -- Add new items
    [span_169](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_169](end_span)
        if not itemESPDrawings[item] then
            [span_170](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_170](end_span)
            if part then
                itemESPDrawings[item] = {
                    [span_171](start_span)part = part, --[span_171](end_span)
                    [span_172](start_span)text = createItemText() --[span_172](end_span)
                }
            end
        end
    end

    -- Remove despawned items
    [span_173](start_span)for obj, esp in pairs(itemESPDrawings) do --[span_173](end_span)
        [span_174](start_span)if not obj:IsDescendantOf(Workspace) then --[span_174](end_span)
            [span_175](start_span)esp.text:Remove() --[span_175](end_span)
            [span_176](start_span)itemESPDrawings[obj] = nil --[span_176](end_span)
        end
    end
end

RunService.RenderStepped:Connect(function()
    [span_177](start_span)if not itemESPEnabled then --[span_177](end_span)
        [span_178](start_span)for _, esp in pairs(itemESPDrawings) do --[span_178](end_span)
            [span_179](start_span)esp.text.Visible = false --[span_179](end_span)
        end
        return
    end

    updateItemESPDrawings() -- Ensure our item ESP drawings are up-to-date

    [span_180](start_span)for item, esp in pairs(itemESPDrawings) do --[span_180](end_span)
        [span_181](start_span)local part = esp.part --[span_181](end_span)
        [span_182](start_span)local text = esp.text --[span_182](end_span)
        [span_183](start_span)local name = item.Name --[span_183](end_span)

        [span_184](start_span)if part and showToggles[name] then --[span_184](end_span)
            [span_185](start_span)local pos, visible = Camera:WorldToViewportPoint(part.Position) --[span_185](end_span)
            [span_186](start_span)if visible then --[span_186](end_span)
                [span_187](start_span)local distance = (Camera.CFrame.Position - part.Position).Magnitude --[span_187](end_span)
                [span_188](start_span)text.Text = string.format("%s [%.0fm]", name, distance) --[span_188](end_span)
                [span_189](start_span)text.Position = Vector2.new(pos.X, pos.Y) --[span_189](end_span)
                [span_190](start_span)text.Color = itemColor --[span_190](end_span)
                [span_191](start_span)text.Visible = true --[span_191](end_span)
            else
                [span_192](start_span)text.Visible = false --[span_192](end_span)
            end
        else
            [span_193](start_span)text.Visible = false --[span_193](end_span)
        end
    end
end)

-- Speed hack
[span_194](start_span)getgenv().speedEnabled = false --[span_194](end_span)
[span_195](start_span)getgenv().speedValue = 28 --[span_195](end_span)

MiscTab:AddToggle({
    Text = "Speed Hack",
    [span_196](start_span)CurrentValue = false, --[span_196](end_span)
    Callback = function(v)
        [span_197](start_span)getgenv().speedEnabled = v --[span_197](end_span)
        [span_198](start_span)local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() --[span_198](end_span)
        local hum = char:FindFirstChildOfClass("Humanoid") -- Using FindFirstChildOfClass for robustness
        [span_199](start_span)if hum then hum.WalkSpeed = v and getgenv().speedValue or 16 end --[span_199](end_span)
    end
})

MiscTab:AddSlider({
    Text = "Speed Value",
    [span_200](start_span)Range = {16, 600}, --[span_200](end_span)
    [span_201](start_span)Increment = 1, --[span_201](end_span)
    [span_202](start_span)Suffix = "Speed", --[span_202](end_span)
    [span_203](start_span)CurrentValue = 28, --[span_203](end_span)
    Callback = function(val)
        [span_204](start_span)getgenv().speedValue = val --[span_204](end_span)
        [span_205](start_span)if getgenv().speedEnabled then --[span_205](end_span)
            [span_206](start_span)local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") --[span_206](end_span)
            [span_207](start_span)if hum then hum.WalkSpeed = val end --[span_207](end_span)
        end
    end
})

-- FPS + Ping Drawing Setup
[span_208](start_span)local showFPS = true --[span_208](end_span)
[span_209](start_span)local showPing = true --[span_209](end_span)

local fpsText = Drawing.new("Text")
[span_210](start_span)fpsText.Size = 16 --[span_210](end_span)
[span_211](start_span)fpsText.Position = Vector2.new(Camera.ViewportSize.X - 100, 10) --[span_211](end_span)
[span_212](start_span)fpsText.Color = Color3.fromRGB(0, 255, 0) --[span_212](end_span)
[span_213](start_span)fpsText.Center = false --[span_213](end_span)
[span_214](start_span)fpsText.Outline = true --[span_214](end_span)
[span_215](start_span)fpsText.Visible = showFPS --[span_215](end_span)

local msText = Drawing.new("Text")
[span_216](start_span)msText.Size = 16 --[span_216](end_span)
[span_217](start_span)msText.Position = Vector2.new(Camera.ViewportSize.X - 100, 30) --[span_217](end_span)
[span_218](start_span)msText.Color = Color3.fromRGB(0, 255, 0) --[span_218](end_span)
[span_219](start_span)msText.Center = false --[span_219](end_span)
[span_220](start_span)msText.Outline = true --[span_220](end_span)
[span_221](start_span)msText.Visible = showPing --[span_221](end_span)

[span_222](start_span)local fpsCounter = 0 --[span_222](end_span)
[span_223](start_span)local fpsLastUpdate = tick() --[span_223](end_span)

RunService.RenderStepped:Connect(function()
    [span_224](start_span)fpsCounter += 1 --[span_224](end_span)
    [span_225](start_span)if tick() - fpsLastUpdate >= 1 then --[span_225](end_span)
        -- Update FPS
        [span_226](start_span)if showFPS then --[span_226](end_span)
            [span_227](start_span)fpsText.Text = "FPS: " .. tostring(fpsCounter) --[span_227](end_span)
            [span_228](start_span)fpsText.Visible = true --[span_228](end_span)
        else
            [span_229](start_span)fpsText.Visible = false --[span_229](end_span)
        end

        -- Update Ping
        [span_230](start_span)if showPing then --[span_230](end_span)
            [span_231](start_span)local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"] --[span_231](end_span)
            [span_232](start_span)local ping = pingStat and math.floor(pingStat:GetValue()) or 0 --[span_232](end_span)
            [span_233](start_span)msText.Text = "Ping: " .. ping .. " ms" --[span_233](end_span)

            [span_234](start_span)if ping <= 60 then --[span_234](end_span)
                [span_235](start_span)msText.Color = Color3.fromRGB(0, 255, 0) --[span_235](end_span)
            [span_236](start_span)elseif ping <= 120 then --[span_236](end_span)
                [span_237](start_span)msText.Color = Color3.fromRGB(255, 165, 0) --[span_237](end_span)
            else
                [span_238](start_span)msText.Color = Color3.fromRGB(255, 0, 0) --[span_238](end_span)
            end

            [span_239](start_span)msText.Visible = true --[span_239](end_span)
        else
            [span_240](start_span)msText.Visible = false --[span_240](end_span)
        end

        [span_241](start_span)fpsCounter = 0 --[span_241](end_span)
        [span_242](start_span)fpsLastUpdate = tick() --[span_242](end_span)
    end
end)

-- FPS + Ping Toggles
MiscTab:AddToggle({
    Text = "Show FPS",
    [span_243](start_span)CurrentValue = true, --[span_243](end_span)
    Callback = function(val)
        [span_244](start_span)showFPS = val --[span_244](end_span)
        [span_245](start_span)fpsText.Visible = val --[span_245](end_span)
    end
})

MiscTab:AddToggle({
    Text = "Show Ping (ms)",
    [span_246](start_span)CurrentValue = true, --[span_246](end_span)
    Callback = function(val)
        [span_247](start_span)showPing = val --[span_247](end_span)
        msText.Visible = val -- Corrected from `Text.Visible` to `msText.Visible`
    end
})

MiscTab:AddButton({
    Text = "FPS Boost",
    Callback = function()
        [span_248](start_span)pcall(function() --[span_248](end_span)
            -- Lower rendering quality
            [span_249](start_span)settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 --[span_249](end_span)

            -- Disable lighting effects
            [span_250](start_span)local lighting = game:GetService("Lighting") --[span_250](end_span)
            [span_251](start_span)lighting.Brightness = 0 --[span_251](end_span)
            [span_252](start_span)lighting.FogEnd = 100 --[span_252](end_span)
            [span_253](start_span)lighting.GlobalShadows = false --[span_253](end_span)
            [span_254](start_span)lighting.EnvironmentDiffuseScale = 0 --[span_254](end_span)
            [span_255](start_span)lighting.EnvironmentSpecularScale = 0 --[span_255](end_span)
            [span_256](start_span)lighting.ClockTime = 14 --[span_256](end_span)
            [span_257](start_span)lighting.OutdoorAmbient = Color3.new(0, 0, 0) --[span_257](end_span)

            -- Terrain settings
            [span_258](start_span)local terrain = Workspace:FindFirstChildOfClass("Terrain") --[span_258](end_span)
            if terrain then
                [span_259](start_span)terrain.WaterWaveSize = 0 --[span_259](end_span)
                [span_260](start_span)terrain.WaterWaveSpeed = 0 --[span_260](end_span)
                [span_261](start_span)terrain.WaterReflectance = 0 --[span_261](end_span)
                [span_262](start_span)terrain.WaterTransparency = 1 --[span_262](end_span)
            end

            -- Disable all post effects
            [span_263](start_span)for _, obj in ipairs(lighting:GetDescendants()) do --[span_263](end_span)
                [span_264](start_span)if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then --[span_264](end_span)
                    [span_265](start_span)obj.Enabled = false --[span_265](end_span)
                end
            end

            -- Remove textures and particles
            [span_266](start_span)for _, obj in ipairs(game:GetDescendants()) do --[span_266](end_span)
                [span_267](start_span)if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then --[span_267](end_span)
                    [span_268](start_span)obj.Enabled = false --[span_268](end_span)
                [span_269](start_span)elseif obj:IsA("Texture") or obj:IsA("Decal") then --[span_269](end_span)
                    [span_270](start_span)obj.Transparency = 1 --[span_270](end_span)
                end
            end

            -- Remove shadows on parts
            [span_271](start_span)for _, part in ipairs(Workspace:GetDescendants()) do --[span_271](end_span)
                [span_272](start_span)if part:IsA("BasePart") then --[span_272](end_span)
                    [span_273](start_span)part.CastShadow = false --[span_273](end_span)
                end
            end
        end)
        [span_274](start_span)print("✅ FPS Boost Applied") --[span_274](end_span)
    end
})

TeleportTab:AddButton({
    Text = "Teleport to Camp",
    Callback = function()
        [span_275](start_span)local char = LocalPlayer.Character --[span_275](end_span)
        [span_276](start_span)if char and char:FindFirstChild("HumanoidRootPart") then --[span_276](end_span)
            [span_277](start_span)char.HumanoidRootPart.CFrame = CFrame.new( --[span_277](end_span)
                [span_278](start_span)13.287363052368164, 3.999999761581421, 0.36212217807769775, --[span_278](end_span)
                [span_279](start_span)0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062, --[span_279](end_span)
                [span_280](start_span)6.430457055728311e-09, 1, 2.364672191390582e-08, --[span_280](end_span)
                -[span_281](start_span)0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113 --[span_281](end_span)
            )
        end
    end,
})

TeleportTab:AddButton({
    Text = "Teleport to Trader",
    Callback = function()
        [span_282](start_span)local pos = Vector3.new(-37.08, 3.98, -16.33) -- your trader position[span_282](end_span)
        [span_283](start_span)local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() --[span_283](end_span)
        [span_284](start_span)local hrp = character:WaitForChild("HumanoidRootPart") --[span_284](end_span)

        [span_285](start_span)hrp.CFrame = CFrame.new(pos) --[span_285](end_span)
    end
})

BringTab:AddButton({
    Text = "Bring Everything",
    [span_286](start_span)Callback = function() --[span_286](end_span)
        local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end

        [span_287](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_287](end_span)
            [span_288](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_288](end_span)
            if part then
                [span_289](start_span)part.CFrame = localHRP.CFrame + Vector3.new(0, 3, 0) --[span_289](end_span)
            end
        end
    end
})

[span_290](start_span)local campfirePos = Vector3.new(1.87, 4.33, -3.67) --[span_290](end_span)
local function bringMeat()
    [span_291](start_span)for _, item in pairs(ItemsFolder:GetChildren()) do --[span_291](end_span)
        [span_292](start_span)if item:IsA("Model") or item:IsA("BasePart") then --[span_292](end_span)
            [span_293](start_span)local name = item.Name:lower() --[span_293](end_span)
            [span_294](start_span)if name:find("meat") then --[span_294](end_span)
                [span_295](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or item --[span_295](end_span)
                if part then
                    [span_296](start_span)part.CFrame = CFrame.new(campfirePos + Vector3.new(math.random(-2, 2), 0.5, math.random(-2, 2))) --[span_296](end_span)
                end
            end
        end
    end
end

BringTab:AddButton({
    Text = "Auto Cook Meat",
    [span_297](start_span)Callback = bringMeat --[span_297](end_span)
})

BringTab:AddButton({
    Text = "Bring Logs",
    [span_298](start_span)Callback = function() --[span_298](end_span)
        [span_299](start_span)local lp = Players.LocalPlayer --[span_299](end_span)
        [span_300](start_span)local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") --[span_300](end_span)
        if not root then return end
        [span_301](start_span)local count = 0 --[span_301](end_span)
        [span_302](start_span)for _, item in pairs(ItemsFolder:GetChildren()) do --[span_302](end_span)
            [span_303](start_span)if item.Name:lower():find("log") and item:IsA("Model") then --[span_303](end_span)
                [span_304](start_span)local main = item:FindFirstChildWhichIsA("BasePart") --[span_304](end_span)
                if main then
                    [span_305](start_span)main.CFrame = root.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_305](end_span)
                    [span_306](start_span)count += 1 --[span_306](end_span)
                end
            end
        end
        [span_307](start_span)print("✅ Brought " .. count .. " logs to you.") --[span_307](end_span)
    end
})

BringTab:AddButton({
    Text = "Bring Coal",
    [span_308](start_span)Callback = function() --[span_308](end_span)
        [span_309](start_span)local lp = Players.LocalPlayer --[span_309](end_span)
        [span_310](start_span)local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") --[span_310](end_span)
        if not root then return end
        [span_311](start_span)local count = 0 --[span_311](end_span)
        [span_312](start_span)for _, item in pairs(ItemsFolder:GetChildren()) do --[span_312](end_span)
            [span_313](start_span)if item.Name:lower():find("coal") and item:IsA("Model") then --[span_313](end_span)
                [span_314](start_span)local main = item:FindFirstChildWhichIsA("BasePart") --[span_314](end_span)
                if main then
                    [span_315](start_span)main.CFrame = root.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_315](end_span)
                    [span_316](start_span)count += 1 --[span_316](end_span)
                end
            end
        end
        [span_317](start_span)print("✅ Brought " .. count .. " coal to you.") --[span_317](end_span)
    end
})

BringTab:AddButton({
    Text = "Bring Meat (Raw + Cooked)",
    [span_318](start_span)Callback = function() --[span_318](end_span)
        [span_319](start_span)local lp = Players.LocalPlayer --[span_319](end_span)
        [span_320](start_span)local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") --[span_320](end_span)
        if not root then return end
        [span_321](start_span)local count = 0 --[span_321](end_span)
        [span_322](start_span)for _, item in pairs(ItemsFolder:GetChildren()) do --[span_322](end_span)
            [span_323](start_span)local name = item.Name:lower() --[span_323](end_span)
            [span_324](start_span)if (name:find("meat") or name:find("cooked")) and item:IsA("Model") then --[span_324](end_span)
                [span_325](start_span)local main = item:FindFirstChildWhichIsA("BasePart") --[span_325](end_span)
                if main then
                    [span_326](start_span)main.CFrame = root.CFrame * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_326](end_span)
                    [span_327](start_span)count += 1 --[span_327](end_span)
                end
            end
        end
        [span_328](start_span)print("✅ Brought " .. count .. " meat items to you.") --[span_328](end_span)
    end
})

local function bringItemsByName(name)
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return end
    [span_329](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_329](end_span)
        [span_330](start_span)if item.Name:lower():find(name:lower()) then --[span_330](end_span)
            [span_331](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_331](end_span)
            if part then
                [span_332](start_span)part.CFrame = localHRP.CFrame + Vector3.new(0, 3, 0) --[span_332](end_span)
            end
        end
    end
end

BringTab:AddButton({
    Text = "Bring Flashlight",
    Callback = function()
        [span_333](start_span)bringItemsByName("Flashlight") --[span_333](end_span)
    end
})

BringTab:AddButton({
    Text = "Bring Nails",
    Callback = function()
        [span_334](start_span)bringItemsByName("Nails") --[span_334](end_span)
    end
})

BringTab:AddButton({
    Text = "Bring Fan",
    [span_335](start_span)Callback = function() --[span_335](end_span)
        [span_336](start_span)bringItemsByName("Fan") --[span_336](end_span)
    end
})

BringTab:AddButton({
    Text = "Bring Ammo",
    [span_337](start_span)Callback = function() --[span_337](end_span)
        [span_338](start_span)local keywords = {"ammo"} --[span_338](end_span)
        [span_339](start_span)local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") --[span_339](end_span)
        if not root then return end

        [span_340](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_340](end_span)
            [span_341](start_span)for _, word in ipairs(keywords) do --[span_341](end_span)
                [span_342](start_span)if item.Name:lower():find(word) then --[span_342](end_span)
                    [span_343](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_343](end_span)
                    if part then
                        [span_344](start_span)part.CFrame = root.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_344](end_span)
                    end
                end
            end
        end
    end
})

BringTab:AddButton({
    Text = "Bring Sheet Metal",
    [span_345](start_span)Callback = function() --[span_345](end_span)
        [span_346](start_span)local keyword = "sheet metal" --[span_346](end_span)
        [span_347](start_span)local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") --[span_347](end_span)
        if not root then return end

        [span_348](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_348](end_span)
            [span_349](start_span)if item.Name:lower():find(keyword) then --[span_349](end_span)
                [span_350](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_350](end_span)
                if part then
                    [span_351](start_span)part.CFrame = root.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_351](end_span)
                end
            end
        end
    end
})

BringTab:AddButton({
    Text = "Bring Fuel Canister",
    [span_352](start_span)Callback = function() --[span_352](end_span)
        [span_353](start_span)local keyword = "fuel canister" --[span_353](end_span)
        [span_354](start_span)local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") --[span_354](end_span)
        if not root then return end

        [span_355](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_355](end_span)
            [span_356](start_span)if item.Name:lower():find(keyword) then --[span_356](end_span)
                [span_357](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_357](end_span)
                if part then
                    [span_358](start_span)part.CFrame = root.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_358](end_span)
                end
            end
        end
    end
})

BringTab:AddButton({
    Text = "Bring Tyre",
    [span_359](start_span)Callback = function() --[span_359](end_span)
        [span_360](start_span)local keyword = "tyre" --[span_360](end_span)
        [span_361](start_span)local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") --[span_361](end_span)
        if not root then return end

        [span_362](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_362](end_span)
            [span_363](start_span)if item.Name:lower():find(keyword) then --[span_363](end_span)
                [span_364](start_span)local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item) --[span_364](end_span)
                if part then
                    [span_365](start_span)part.CFrame = root.CFrame + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)) --[span_365](end_span)
                end
            end
        end
    end
})

BringTab:AddButton({
    Text = "Bring Bandage",
    [span_366](start_span)Callback = function() --[span_366](end_span)
        [span_367](start_span)local lp = Players.LocalPlayer --[span_367](end_span)
        [span_368](start_span)local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") --[span_368](end_span)
        if not root then return end

        [span_369](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_369](end_span)
            [span_370](start_span)if item:IsA("Model") and item.Name:lower():find("bandage") then --[span_370](end_span)
                [span_371](start_span)local part = item:FindFirstChildWhichIsA("BasePart") --[span_371](end_span)
                if part then
                    [span_372](start_span)part.CFrame = root.CFrame + Vector3.new(0, 2, 0) --[span_372](end_span)
                end
            end
        end
    end
})

BringTab:AddButton({
    Text = "Bring Lost Child",
    [span_373](start_span)Callback = function() --[span_373](end_span)
        local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP then return end
        [span_374](start_span)for _, model in ipairs(Workspace:GetDescendants()) do --[span_374](end_span)
            [span_375](start_span)if model:IsA("Model") and model.Name:lower():find("lost") and model:FindFirstChild("HumanoidRootPart") then --[span_375](end_span)
                [span_376](start_span)model:PivotTo(localHRP.CFrame + Vector3.new(0, 2, 0)) --[span_376](end_span)
            end
        end
    end
})

BringTab:AddButton({
    Text = "Bring Revolver",
    [span_377](start_span)Callback = function() --[span_377](end_span)
        [span_378](start_span)for _, item in ipairs(ItemsFolder:GetChildren()) do --[span_378](end_span)
            [span_379](start_span)if item:IsA("Model") and item.Name:lower():find("revolver") then --[span_379](end_span)
                [span_380](start_span)local part = item:FindFirstChildWhichIsA("BasePart") --[span_380](end_span)
                if part then
                    [span_381](start_span)part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0) --[span_381](end_span)
                end
            end
        end
    end
})

-- Hitbox Expansion
local hitboxSettings = {
    [span_382](start_span)Wolf = false, --[span_382](end_span)
    [span_383](start_span)Bunny = false, --[span_383](end_span)
    [span_384](start_span)Cultist = false, --[span_384](end_span)
    [span_385](start_span)Show = false, --[span_385](end_span)
    [span_386](start_span)Size = 10 --[span_386](end_span)
}

local appliedHitboxes = {} -- To keep track of applied hitboxes

-- Apply hitbox updates to a model
local function applyHitbox(model)
    [span_387](start_span)local root = model:FindFirstChild("HumanoidRootPart") --[span_387](end_span)
    if not root then return end

    [span_388](start_span)local name = model.Name:lower() --[span_388](end_span)
    local shouldResize =
        [span_389](start_span)(hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or --[span_389](end_span)
        [span_390](start_span)(hitboxSettings.Bunny and name:find("bunny")) or --[span_390](end_span)
        [span_391](start_span)(hitboxSettings.Cultist and (name:find("cultist") or name:find("cross"))) --[span_391](end_span)

    if shouldResize then
        -- Only apply if not already applied or settings changed
        if not appliedHitboxes[model] or appliedHitboxes[model].Size ~= hitboxSettings.Size or appliedHitboxes[model].Show ~= hitboxSettings.Show then
            [span_392](start_span)root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size) --[span_392](end_span)
            [span_393](start_span)root.Transparency = hitboxSettings.Show and 0.5 or 1 --[span_393](end_span)
            [span_394](start_span)root.Color = Color3.fromRGB(255, 255, 255) -- white[span_394](end_span)
            [span_395](start_span)root.Material = Enum.Material.Neon --[span_395](end_span)
            [span_396](start_span)root.CanCollide = false --[span_396](end_span)
            appliedHitboxes[model] = {Size = hitboxSettings.Size, Show = hitboxSettings.Show}
        end
    else
        -- Reset hitbox if it was previously modified and no longer matches criteria
        if appliedHitboxes[model] then
            root.Size = Vector3.new(2, 2, 2) -- Default size or original size if known
            root.Transparency = 1
            root.Material = Enum.Material.Plastic -- Default material
            root.CanCollide = true
            appliedHitboxes[model] = nil
        end
    end
end

-- Loop to scan and apply hitbox updates every 0.5 seconds
task.spawn(function()
    while true do
        [span_397](start_span)for _, model in ipairs(Workspace:GetDescendants()) do --[span_397](end_span)
            [span_398](start_span)if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then --[span_398](end_span)
                applyHitbox(model)
            end
        end
        task.wait(0.5)
    end
end)

HitboxTab:AddToggle({
    Text = "Expand Wolf Hitbox",
    [span_399](start_span)CurrentValue = false, --[span_399](end_span)
    Callback = function(val)
        [span_400](start_span)hitboxSettings.Wolf = val --[span_400](end_span)
    end
})

HitboxTab:AddToggle({
    Text = "Expand Bunny Hitbox",
    [span_401](start_span)CurrentValue = false, --[span_401](end_span)
    Callback = function(val)
        [span_402](start_span)hitboxSettings.Bunny = val --[span_402](end_span)
    end
})

HitboxTab:AddToggle({
    Text = "Expand Cultist Hitbox",
    [span_403](start_span)CurrentValue = false, --[span_403](end_span)
    Callback = function(val)
        [span_404](start_span)hitboxSettings.Cultist = val --[span_404](end_span)
    end
})

HitboxTab:AddSlider({
    Text = "Hitbox Size",
    [span_405](start_span)Range = {2, 30}, --[span_405](end_span)
    [span_406](start_span)Increment = 1, --[span_406](end_span)
    [span_407](start_span)Suffix = "Size", --[span_407](end_span)
    [span_408](start_span)CurrentValue = 10, --[span_408](end_span)
    Callback = function(val)
        hitboxSettings.Size = val --
    end
})

HitboxTab:AddToggle({
    Text = "Show Hitbox (Transparency)",
    CurrentValue = false, --
    Callback = function(val)
        hitboxSettings.Show = val --
    end
})

