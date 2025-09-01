local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 🌈 Hàm tạo màu cầu vồng
local function rainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

-- ESP Data
local espEnabled = false
local espObjects = {}

-- Tạo ESP cho 1 player
local function createESP(plr)
    if plr == player then return end
    if not plr.Character then return end
    if espObjects[plr] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = plr.Character

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.AlwaysOnTop = true
    billboard.Parent = plr.Character:WaitForChild("HumanoidRootPart")

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.fromRGB(255,0,0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboard

    espObjects[plr] = {highlight=highlight, billboard=billboard, label=nameLabel}
end

-- Xóa ESP
local function removeESP(plr)
    if espObjects[plr] then
        espObjects[plr].highlight:Destroy()
        espObjects[plr].billboard:Destroy()
        espObjects[plr] = nil
    end
end

-- Bật ESP
local function enableESP()
    espEnabled = true
    for _,plr in pairs(Players:GetPlayers()) do
        createESP(plr)
    end
end

-- Tắt ESP
local function disableESP()
    espEnabled = false
    for plr,_ in pairs(espObjects) do
        removeESP(plr)
    end
end

-- Player mới vào
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            createESP(plr)
        end
    end)
end)

-- Cập nhật màu cầu vồng
RunService.RenderStepped:Connect(function()
    if espEnabled then
        local color = rainbowColor()
        for _,data in pairs(espObjects) do
            data.highlight.OutlineColor = color
            data.label.TextColor3 = color
        end
    end
end)

---------------------------------------------------
-- 🟢 Giao diện menu
---------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "KaiMenu"
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame chính (menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = true
frame.Parent = gui
Instance.new("UICorner", frame)

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 Kai Menu 🔥"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Nút X (ẩn menu)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn)

-- 🟡 Icon khi menu ẩn
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 70, 0, 70)
icon.Position = UDim2.new(0.1, 0, 0.8, 0)
icon.BackgroundColor3 = Color3.fromRGB(173,216,230) -- xanh biển nhạt
icon.Text = "KAI\nPREMIUM"
icon.TextColor3 = Color3.fromRGB(20,20,80)
icon.TextSize = 14
icon.Font = Enum.Font.FredokaOne
icon.Visible = false
icon.Parent = gui
local icorner = Instance.new("UICorner", icon)
icorner.CornerRadius = UDim.new(1,0)

---------------------------------------------------
-- 🔄 Kéo thả
---------------------------------------------------
local function makeDraggable(ui)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        ui.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    ui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    ui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(icon)
makeDraggable(frame)

---------------------------------------------------
-- Ẩn/hiện menu
---------------------------------------------------
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
    frame.Visible = true
    icon.Visible = false
end)

---------------------------------------------------
-- Nội dung trong menu
---------------------------------------------------
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 50)
info.Position = UDim2.new(0, 10, 0, 50)
info.BackgroundTransparency = 1
info.Text = "Đây là giao diện KaiTool\nBật/tắt ESP bằng nút bên dưới!"
info.TextWrapped = true
info.Font = Enum.Font.Gotham
info.TextSize = 20
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Parent = frame

-- 🔘 Nút bật/tắt ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 150, 0, 40)
espBtn.Position = UDim2.new(0, 20, 1, -50)
espBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
espBtn.Text = "Bật ESP"
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 20
espBtn.Parent = frame
Instance.new("UICorner", espBtn)

-- 🛑 Thông báo ESP bật/tắt
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 300, 0, 40)
notify.Position = UDim2.new(0.5, -150, 0, 10)
notify.BackgroundColor3 = Color3.fromRGB(50,50,50)
notify.TextColor3 = Color3.new(1,1,1)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 18
notify.Visible = false
notify.Parent = gui
Instance.new("UICorner", notify)

local function showNotify(msg, color)
    notify.Text = msg
    notify.BackgroundColor3 = color
    notify.Visible = true
    task.delay(2, function()
        notify.Visible = false
    end)
end

-- Sự kiện bật/tắt ESP
espBtn.MouseButton1Click:Connect(function()
    if espEnabled then
        disableESP()
        espBtn.Text = "Bật ESP"
        espBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
        showNotify("❌ ESP đã tắt!", Color3.fromRGB(200,50,50))
    else
        enableESP()
        espBtn.Text = "Tắt ESP"
        espBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        showNotify("✅ ESP đã bật!", Color3.fromRGB(50,200,50))
    end
end)
