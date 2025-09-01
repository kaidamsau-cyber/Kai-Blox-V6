repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
getgenv().Team = "Pirates"
getgenv().Config = {
    ["Safe Health"] = {30},
    ["Custom Y Run"] = {
        Enabled = true,
        ["Y Run"] = 5000
    },
    ["Hunt Method"] = {
        ["Use Move Predict"] = true,
        ["Hit and Run"] = false,
        ["Aimbot"] = true,
        ["ESP Player"] = true,
        ["Max Attack Time"] = 70
    },
    ["Stats"] = {
        ["Enable"] = false,
        ["Reset Stats"] = false,
        ["Point"] = {
            ["Points per lift"] = nil,
            ["Melee"] = nil,
            ["Defence"] = nil,
            ["Sword"] = nil,
            ["Gun"] = nil,
            ["Devil Fruit"] = nil
        }
    },
    ["Shop"] = {
        ["Random Fruit"] = false,
        ["Store Fruit"] = false,
        ["Zoro Sword"] = false
    },
    ["Theme"] = {
    Name = "Hutao",
    UIUrl = "",
    Custom = {
        ["Enable"] = false,
        ["title_color"] = Color3.fromRGB(255, 221, 252),
        ["titleback_color"] = Color3.fromRGB(169, 20, 255),
        ["list_color"] = Color3.fromRGB(255, 221, 252),
        ["liststroke_color"] = Color3.fromRGB(151, 123, 207),
        ["button_color"] = Color3.fromRGB(255, 221, 252),
        ["title_font"] = Enum.Font.FredokaOne,
        ["text_font"] = Enum.Font.Gotham,
        ["title_size"] = 40,
        ["text_size"] = 24
        }
    },
    ["Setting"] = {
        ["World"] = nil,
        ["White Screen"] = false,
        ["Fast Delay"] = 0.2,
        ["Tween Speed"] = 350,
        ["FPS BOOSTER"] = false,
        ["Url"] = "",
        ["Chat"] = {
            Enabled =true,
            Wait = 350,
            Massage = {"Nexon on top"}
        }
    },
    ["Skip"] = {
        ["Avoid V4"] = false,
        ["Fruit"] = {
            ["Enabled"] = false,
            ["Avoid Fruit"] = {
                "Portal-Portal",
                "Kitsune-Kitsune"
            }
        }
    },
    ["Spam All Skill On V4"] = {
        Enabled = true,
        ["Weapons"] = {"Melee", "Sword", "Gun", "Blox Fruit"}
    },
    ["Items"] = {
        ["Use"] = {"Melee", "Sword", "Gun", "Blox Fruit"},
        ["Melee"] = {
            Enable = true,
            Delay = 0.2,
            Skills = {
                Z = {Enable = true, HoldTime = 0.2},
                X = {Enable = true, HoldTime = 0.1},
                C = {Enable = true, HoldTime = 0.1}
            }
        },
        ["Sword"] = {
            Enable = true,
            Delay = 0.2,
            Skills = {
                Z = {Enable = true, HoldTime = 0.1},
                X = {Enable = true, HoldTime = 0.1}
            }
        },
        ["Gun"] = {
            Enable = true,
            Delay = 0.2,
            Skills = {
                Z = {Enable = true, HoldTime = 0.1},
                X = {Enable = true, HoldTime = 0.1}
            }
        },
        ["Blox Fruit"] = {
            Enable = true,
            Delay = 0.1,
            Skills = {
                Z = {Enable = true, HoldTime = 0.1},
                X = {Enable = true, HoldTime = 0.1},
                C = {Enable = true, HoldTime = 0.15},
                V = {Enable = true, HoldTime = 0.2},
                F = {Enable = true, HoldTime = 0.1}
            }
        }
    }
}
