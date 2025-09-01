-- 🌈 Viền cầu vồng cho Frame
local function createRainbowBorder(parent)
    local border = Instance.new("UIStroke")
    border.Thickness = 3
    border.Parent = parent
    return border
end

---------------------------------------------------
-- 🟢 Giao diện menu
---------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "KaiMenu"
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame chính (menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 220)
frame.Position = UDim2.new(0.5, -175, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = true
frame.Parent = gui
Instance.new("UICorner", frame)

-- 🌈 Viền cầu vồng
local rainbowBorder = createRainbowBorder(frame)

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 35)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🔥 Kai Menu 🔥"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Nút X (ẩn menu)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn)

-- 🟡 Icon khi menu ẩn
local icon = Instance.new("TextButton")
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0.05, 0, 0.85, 0)
icon.BackgroundColor3 = Color3.fromRGB(173,216,230)
icon.Text = "KAI"
icon.TextColor3 = Color3.fromRGB(20,20,80)
icon.TextSize = 12
icon.Font = Enum.Font.FredokaOne
icon.Visible = false
icon.Parent = gui
local icorner = Instance.new("UICorner", icon)
icorner.CornerRadius = UDim.new(1,0)

---------------------------------------------------
-- Nội dung trong menu (đưa lên góc trên)
---------------------------------------------------
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 40)
info.Position = UDim2.new(0, 10, 0, 45)
info.BackgroundTransparency = 1
info.Text = "👉 Bật/tắt ESP bằng nút bên dưới!"
info.TextWrapped = true
info.Font = Enum.Font.Gotham
info.TextSize = 18
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Parent = frame

-- 🔘 Nút bật/tắt ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 130, 0, 35)
espBtn.Position = UDim2.new(0, 15, 0, 90)
espBtn.BackgroundColor3 = Color3.fromRGB(50,150,50)
espBtn.Text = "Bật ESP"
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 18
espBtn.Parent = frame
Instance.new("UICorner", espBtn)

-- 🛑 Thông báo ESP bật/tắt
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 280, 0, 35)
notify.Position = UDim2.new(0.5, -140, 0, 10)
notify.BackgroundColor3 = Color3.fromRGB(50,50,50)
notify.TextColor3 = Color3.new(1,1,1)
notify.Font = Enum.Font.GothamBold
notify.TextSize = 16
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
-- 🌈 Update viền cầu vồng
---------------------------------------------------
RunService.RenderStepped:Connect(function()
    rainbowBorder.Color = rainbowColor()
end)

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
