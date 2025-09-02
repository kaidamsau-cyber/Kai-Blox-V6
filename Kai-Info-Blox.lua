--[[
💡 Kai Perf HUD v1.2
- HUD gọn: FPS • Ping • Memory • Players • Position
- Menu chi tiết: FPS min/avg/max, ping, network in/out, total memory, job scheduler, chất lượng đồ hoạ
- Viền cầu vồng + kéo thả, gọn nhẹ (update 0.25s)
- Toggle HUD: F8 | Toggle Menu: RightShift
- Dán vào executor và chạy (LocalScript)

Lưu ý:
- Một vài số liệu phụ thuộc API Stats; nếu game chặn, script sẽ tự bỏ qua.
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- ====== Utils ======
local function safe(fn, default)
    local ok, res = pcall(fn)
    if ok then return res end
    return default
end

local function formatMB(mb)
    if not mb then return "?" end
    if mb >= 1024 then
        return string.format("%.1f GB", mb/1024)
    else
        return string.format("%.0f MB", mb)
    end
end

local function formatVec3(v)
    if not v then return "x: ?, y: ?, z: ?" end
    return string.format("x: %.1f, y: %.1f, z: %.1f", v.X, v.Y, v.Z)
end

-- ====== GUI Build ======
local gui = Instance.new("ScreenGui")
gui.Name = "KaiPerfHUD"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = game:GetService("CoreGui")

-- HUD gọn (corner)
local hud = Instance.new("Frame")
hud.Name = "HUD"
hud.Parent = gui
hud.AnchorPoint = Vector2.new(1, 1)
hud.Position = UDim2.new(1, -12, 1, -12)
hud.Size = UDim2.new(0, 270, 0, 60)
hud.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
hud.BackgroundTransparency = 0.05
hud.BorderSizePixel = 0
hud.AutomaticSize = Enum.AutomaticSize.Y
hud.ClipsDescendants = true

local hudCorner = Instance.new("UICorner", hud)
hudCorner.CornerRadius = UDim.new(0, 16)

local hudPadding = Instance.new("UIPadding", hud)
hudPadding.PaddingTop = UDim.new(0, 10)
hudPadding.PaddingBottom = UDim.new(0, 10)
hudPadding.PaddingLeft = UDim.new(0, 12)
hudPadding.PaddingRight = UDim.new(0, 12)

local hudList = Instance.new("UIListLayout", hud)
hudList.FillDirection = Enum.FillDirection.Vertical
hudList.SortOrder = Enum.SortOrder.LayoutOrder
hudList.Padding = UDim.new(0, 4)

local hudStroke = Instance.new("UIStroke", hud)
hudStroke.Thickness = 2
hudStroke.Transparency = 0.2

local function mkLabel(parent, txt, size, bold)
    local l = Instance.new("TextLabel")
    l.Parent = parent
    l.BackgroundTransparency = 1
    l.Text = txt or ""
    l.TextColor3 = Color3.fromRGB(235, 240, 255)
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextSize = size or 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Top
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.Size = UDim2.new(1, 0, 0, 0)
    return l
end

local title = mkLabel(hud, "Kai Perf HUD", 16, true)
title.TextTransparency = 0.1

local line = Instance.new("Frame")
line.Parent = hud
line.Size = UDim2.new(1, 0, 0, 1)
line.BackgroundColor3 = Color3.fromRGB(255,255,255)
line.BackgroundTransparency = 0.9

local info1 = mkLabel(hud, "FPS: …   Ping: …   Mem: …", 14, false)
local info2 = mkLabel(hud, "Players: …   Pos: …", 14, false)

-- Drag HUD
do
    local dragging = false
    local dragStart, startPos
    hud.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = hud.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            hud.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Menu chi tiết
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Parent = gui
menu.AnchorPoint = Vector2.new(0, 0)
menu.Position = UDim2.new(0, 20, 0, 80)
menu.Size = UDim2.new(0, 420, 0, 300)
menu.BackgroundColor3 = Color3.fromRGB(12,12,16)
menu.BackgroundTransparency = 0.03
menu.BorderSizePixel = 0
menu.Visible = false

local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 18)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Thickness = 2
menuStroke.Transparency = 0.2

local header = Instance.new("Frame")
header.Parent = menu
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundTransparency = 1

local menuTitle = mkLabel(header, "⚙️ Kai Performance Monitor", 18, true)
menuTitle.Position = UDim2.new(0, 12, 0, 10)
menuTitle.Size = UDim2.new(1, -90, 1, -10)

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = header
closeBtn.AnchorPoint = Vector2.new(1,0)
closeBtn.Position = UDim2.new(1, -10, 0, 6)
closeBtn.Size = UDim2.new(0, 32, 0, 30)
closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.fromRGB(240,240,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
local cbCorner = Instance.new("UICorner", closeBtn)
cbCorner.CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    menu.Visible = false
end)

-- Drag Menu
do
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = menu.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Nội dung menu
local body = Instance.new("Frame")
body.Parent = menu
body.Position = UDim2.new(0, 12, 0, 46)
body.Size = UDim2.new(1, -24, 1, -58)
body.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", body)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.CellSize = UDim2.new(0, 190, 0, 56)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.FillDirectionMaxCells = 2

local function mkCard(labelText)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(20,20,28)
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    local c = Instance.new("UICorner", card); c.CornerRadius = UDim.new(0, 14)
    local s = Instance.new("UIStroke", card); s.Thickness = 1.5; s.Transparency = 0.25
    local lab = mkLabel(card, labelText, 12, true); lab.TextTransparency = 0.15; lab.Position = UDim2.new(0, 10, 0, 6)
    local val = mkLabel(card, "…", 18, true); val.Position = UDim2.new(0, 10, 0, 26)
    return card, val, s
end

local cFPS, vFPS, sFPS = mkCard("FPS (min / avg / max)")
cFPS.Parent = body
local cPing, vPing, sPing = mkCard("Ping (ms)")
cPing.Parent = body
local cMem, vMem, sMem = mkCard("Memory (Total)")
cMem.Parent = body
local cNetIn, vNetIn, sNetIn = mkCard("Network In (KB/s)")
cNetIn.Parent = body
local cNetOut, vNetOut, sNetOut = mkCard("Network Out (KB/s)")
cNetOut.Parent = body
local cPlayers, vPlayers, sPlayers = mkCard("Players / Max")
cPlayers.Parent = body
local cPos, vPos, sPos = mkCard("Position (HRP)")
cPos.Parent = body
local cGfx, vGfx, sGfx = mkCard("Graphics Quality")
cGfx.Parent = body

-- Footer hint
local footer = mkLabel(menu, "RightShift: mở/đóng menu • F8: ẩn/hiện HUD", 12, false)
footer.Position = UDim2.new(0, 12, 1, -18)
footer.TextTransparency = 0.25

-- ====== Rainbow Stroke ======
local function updateRainbow(strokeObj)
    local t = tick() % 5 / 5
    local r, g, b = Color3.fromHSV(t, 1, 1).R, Color3.fromHSV(t, 1, 1).G, Color3.fromHSV(t, 1, 1).B
    strokeObj.Color = Color3.new(r, g, b)
end

RunService.RenderStepped:Connect(function()
    updateRainbow(hudStroke)
    updateRainbow(menuStroke)
    sFPS.Color = hudStroke.Color
    sPing.Color = hudStroke.Color
    sMem.Color = hudStroke.Color
    sNetIn.Color = hudStroke.Color
    sNetOut.Color = hudStroke.Color
    sPlayers.Color = hudStroke.Color
    sPos.Color = hudStroke.Color
    sGfx.Color = hudStroke.Color
    line.BackgroundColor3 = hudStroke.Color
end)

-- ====== Metrics Collectors ======
local fps, fpsMin, fpsMax, fpsSum, fpsSamples = 60, 999, 0, 0, 0
local hudVisible = true
local menuVisible = false

-- FPS via Heartbeat (smoothed)
do
    local last = tick()
    RunService.Heartbeat:Connect(function()
        local now = tick()
        local dt = now - last
        last = now
        local currentFPS = math.clamp(1 / math.max(dt, 1/1000), 1, 1000)
        -- exponential smoothing
        fps = fps * 0.9 + currentFPS * 0.1
        -- stats
        fpsMin = math.min(fpsMin, currentFPS)
        fpsMax = math.max(fpsMax, currentFPS)
        fpsSum += currentFPS
        fpsSamples += 1
    end)
end

-- Ping
local function getPing()
    local pingMs = safe(function()
        local ssi = Stats.Network.ServerStatsItem
        local pingItem = ssi and ssi["Data Ping"]
        if pingItem and pingItem.GetValue then
            return math.max(0, math.floor(pingItem:GetValue()))
        end
        return nil
    end, nil)
    return pingMs
end

-- Net in/out (KB/s)
local function getNetKB()
    local recv = safe(function()
        local recvItem = Stats.Network:FindFirstChild("ReceiveKbps")
        if recvItem and recvItem:GetValue() then return recvItem:GetValue() end
        local r = Stats.Network:FindFirstChild("IncomingKbps")
        if r and r:GetValue() then return r:GetValue() end
        return nil
    end, nil)
    local sent = safe(function()
        local sendItem = Stats.Network:FindFirstChild("SendKbps")
        if sendItem and sendItem:GetValue() then return sendItem:GetValue() end
        local s = Stats.Network:FindFirstChild("OutgoingKbps")
        if s and s:GetValue() then return s:GetValue() end
        return nil
    end, nil)
    return recv, sent
end

-- Memory
local function getMemoryMB()
    return safe(function()
        return Stats:GetTotalMemoryUsageMb()
    end, nil)
end

-- Graphics Quality (0-21 typical)
local function getGraphicsLevel()
    return safe(function()
        return settings().Rendering.QualityLevel.Value
    end, "Auto")
end

-- Player position
local function getHRPPos()
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return hrp.Position
end

-- Players
local function getPlayerCounts()
    local total = #Players:GetPlayers()
    local maxPlayers = safe(function() return game.Players.MaxPlayers end, 0)
    return total, maxPlayers
end

-- ====== Update Loops ======
local UPDATE_INTERVAL = 0.25
task.spawn(function()
    while true do
        -- HUD text
        local ping = getPing()
        local mem = getMemoryMB()
        local fpsNow = math.floor(fps + 0.5)

        info1.Text = string.format("FPS: %d   Ping: %s   Mem: %s",
            fpsNow,
            ping and (tostring(ping).."ms") or "N/A",
            formatMB(mem))

        local pos = getHRPPos()
        local pText = formatVec3(pos)
        local pCount, pMax = getPlayerCounts()
        info2.Text = string.format("Players: %d/%s   Pos: %s",
            pCount, (pMax > 0 and tostring(pMax) or "?"), pText)

        -- Menu values
        local fpsAvg = (fpsSamples > 0) and (fpsSum / fpsSamples) or fpsNow
        vFPS.Text = string.format("%d / %d / %d", math.floor(fpsMin+0.5), math.floor(fpsAvg+0.5), math.floor(fpsMax+0.5))

        vPing.Text = ping and tostring(ping).." ms" or "N/A"

        vMem.Text = formatMB(mem)

        local inKB, outKB = getNetKB()
        vNetIn.Text = inKB and string.format("%.0f", inKB) or "N/A"
        vNetOut.Text = outKB and string.format("%.0f", outKB) or "N/A"

        local tot, maxp = getPlayerCounts()
        vPlayers.Text = string.format("%d / %s", tot, (maxp > 0 and tostring(maxp) or "?"))

        vPos.Text = formatVec3(getHRPPos())

        vGfx.Text = tostring(getGraphicsLevel())

        task.wait(UPDATE_INTERVAL)
    end
end)

-- ====== Keybinds ======
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F8 then
        hudVisible = not hudVisible
        hud.Visible = hudVisible
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        menu.Visible = menuVisible
    end
end)

-- ====== Nice touches ======
-- Ẩn thông báo hệ thống làm HUD gọn hơn (không bắt buộc)
pcall(function()
    StarterGui:SetCore("TopbarEnabled", true)
end)

-- Tự mở HUD lần đầu
hud.Visible = true

-- Reset FPS stats mỗi 20s để theo dõi giai đoạn
task.spawn(function()
    while true do
        task.wait(20)
        fpsMin, fpsMax, fpsSum, fpsSamples = 999, 0, 0, 0
    end
end)
