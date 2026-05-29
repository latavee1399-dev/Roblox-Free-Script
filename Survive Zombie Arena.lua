repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer
repeat task.wait() until LocalPlayer:FindFirstChild("Credits")
repeat task.wait() until LocalPlayer:FindFirstChild("VoidShards")
repeat task.wait() until LocalPlayer:FindFirstChild("SelectedClass")

local Credits = LocalPlayer.Credits
local VoidShards = LocalPlayer.VoidShards
local SelectedClass = LocalPlayer.SelectedClass

local GetOwnedWeapons = ReplicatedStorage
    :WaitForChild("LoadoutRemotes")
    :WaitForChild("GetOwnedWeapons")

local function FormatNumber(Number)
    Number = tonumber(Number) or 0

    local Formatted = tostring(Number)

    while true do
        Formatted, Count = Formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")

        if Count == 0 then
            break
        end
    end

    return Formatted
end

local function SafeText(Text)
    Text = tostring(Text)

    Text = Text:gsub("|", "")
    Text = Text:gsub(";", "")

    return Text
end

local function GetWeaponsText()

    local WeaponText = "None"

    local Success, Data = pcall(function()
        return GetOwnedWeapons:InvokeServer()
    end)

    if Success and typeof(Data) == "table" then

        local Names = {}

        for i,v in pairs(Data) do

            if typeof(v) == "string" then
                table.insert(Names, v)

            elseif typeof(v) == "table" then

                if v.Name then
                    table.insert(Names, tostring(v.Name))
                end
            end
        end

        if #Names > 0 then
            WeaponText = table.concat(Names, " / ")
        end
    end

    return WeaponText
end

local function UpdateDescription()

    local messages =
        "💰 Credits : " .. FormatNumber(Credits.Value) ..
        " , 🌌 VoidShards : " .. FormatNumber(VoidShards.Value) ..
        " , ⚔️ Class : " .. tostring(SelectedClass.Value) ..
        " , 🔫 Weapons : " .. GetWeaponsText()

    messages = SafeText(messages)

    pcall(function()
        if _G.Horst_SetDescription then
            _G.Horst_SetDescription(messages)
            print(messages)
        end
    end)
end

UpdateDescription()

Credits.Changed:Connect(UpdateDescription)
VoidShards.Changed:Connect(UpdateDescription)
SelectedClass.Changed:Connect(UpdateDescription)

task.spawn(function()
    while task.wait(5) do
        UpdateDescription()
    end
end)
