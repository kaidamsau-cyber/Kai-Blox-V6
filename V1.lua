-- ====== Menu dạng sidebar (kiểu Maru Hub) ======
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Parent = gui
menu.AnchorPoint = Vector2.new(0, 0)
menu.Position = UDim2.new(0, 20, 0, 80)
menu.Size = UDim2.new(0, 500, 0, 340)
menu.BackgroundColor3 = Color3.fromRGB(12,12,16)
menu.BackgroundTransparency = 0.03
menu.BorderSizePixel = 0
menu.Visible = false

local menuCorner = Instance.new("UICorner", menu)
menuCorner.CornerRadius = UDim.new(0, 18)
local menuStroke = Instance.new("UIStroke", menu)
menuStroke.Thickness = 2
menuStroke.Transparency = 0.2

-- Sidebar
local sidebar = Instance.new("Frame", menu)
sidebar.Size = UDim2.new(0, 130, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(18,18,25)
sidebar.BorderSizePixel = 0
local sbCorner = Instance.new("UICorner", sidebar)
sbCorner.CornerRadius = UDim.new(0, 12)

local tabList = Instance.new("UIListLayout", sidebar)
tabList.Padding = UDim.new(0, 6)
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.VerticalAlignment = Enum.VerticalAlignment.Top
tabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Content
local content = Instance.new("Frame", menu)
content.Position = UDim2.new(0, 140, 0, 0)
content.Size = UDim2.new(1, -150, 1, 0)
content.BackgroundColor3 = Color3.fromRGB(20,20,28)
content.BorderSizePixel = 0
local ctCorner = Instance.new("UICorner", content)
ctCorner.CornerRadius = UDim.new(0, 12)

-- Function tạo tab
local pages = {}
local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Parent = sidebar
    btn.Size = UDim2.new(1, -20, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,38)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(235, 240, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0, 8)

    local page = Instance.new("Frame", content)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(pages) do
            p.Visible = (n == name)
        end
    end)
    return page
end

-- Tab Status
local statusPage = createTab("Status")

-- Grid trong statusPage (dùng lại card cũ)
local grid = Instance.new("UIGridLayout", statusPage)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.CellSize = UDim2.new(0, 160, 0, 56)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.FillDirectionMaxCells = 2

-- Reuse mkCard cho Status tab
local function mkCard(labelText)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(24,24,32)
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    local c = Instance.new("UICorner", card); c.CornerRadius = UDim.new(0, 12)
    local s = Instance.new("UIStroke", card); s.Thickness = 1.2; s.Transparency = 0.25
    local lab = mkLabel(card, labelText, 12, true); lab.TextTransparency = 0.15; lab.Position = UDim2.new(0, 8, 0, 6)
    local val = mkLabel(card, "…", 18, true); val.Position = UDim2.new(0, 8, 0, 24)
    return card, val, s
end

local cFPS, vFPS, sFPS = mkCard("FPS (min / avg / max)"); cFPS.Parent = statusPage
local cPing, vPing, sPing = mkCard("Ping (ms)"); cPing.Parent = statusPage
local cMem, vMem, sMem = mkCard("Memory (Total)"); cMem.Parent = statusPage
local cNetIn, vNetIn, sNetIn = mkCard("Network In (KB/s)"); cNetIn.Parent = statusPage
local cNetOut, vNetOut, sNetOut = mkCard("Network Out (KB/s)"); cNetOut.Parent = statusPage
local cPlayers, vPlayers, sPlayers = mkCard("Players / Max"); cPlayers.Parent = statusPage
local cPos, vPos, sPos = mkCard("Position (HRP)"); cPos.Parent = statusPage
local cGfx, vGfx, sGfx = mkCard("Graphics Quality"); cGfx.Parent = statusPage

-- Tab khác (chưa có nội dung)
local farmPage = createTab("Farm Settings")
mkLabel(farmPage, "⚙️ Auto Farm Settings here", 16, true).Position = UDim2.new(0, 12, 0, 12)

local mainPage = createTab("Main")
mkLabel(mainPage, "📂 Main controls", 16, true).Position = UDim2.new(0, 12, 0, 12)

local multiPage = createTab("Multi Farm")
mkLabel(multiPage, "🤖 Multi farm options", 16, true).Position = UDim2.new(0, 12, 0, 12)

-- Default mở Status
for n, p in pairs(pages) do p.Visible = false end
pages["Status"].Visible = true
