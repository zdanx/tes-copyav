local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local originalAvatar = nil
local guiVisible = true

local gui = Instance.new("ScreenGui")
gui.Name = "AvatarCopier"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 300, 0, 190)
main.Position = UDim2.new(0.5, -150, 0.5, -95)
main.BackgroundColor3 = Color3.new(0.08, 0.08, 0.1)
main.BackgroundTransparency = 0
main.Active = true
main.Draggable = true
main.Parent = gui
main.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.12, 0.12, 0.16)
title.Text = "Avatar Copier"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.Parent = main
title.BorderSizePixel = 0

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -28, 0, 2)
close.BackgroundTransparency = 1
close.Text = "X"
close.TextColor3 = Color3.new(1, 0.3, 0.3)
close.TextSize = 16
close.Font = Enum.Font.SourceSansBold
close.Parent = main
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 260, 0, 20)
label.Position = UDim2.new(0, 20, 0, 40)
label.BackgroundTransparency = 1
label.Text = "Masukkan username pemain:"
label.TextColor3 = Color3.new(0.7, 0.7, 0.8)
label.TextSize = 13
label.Font = Enum.Font.SourceSans
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = main

local box = Instance.new("TextBox")
box.Size = UDim2.new(0, 260, 0, 32)
box.Position = UDim2.new(0, 20, 0, 62)
box.BackgroundColor3 = Color3.new(0.15, 0.15, 0.2)
box.BackgroundTransparency = 0
box.PlaceholderText = "Username..."
box.PlaceholderColor3 = Color3.new(0.4, 0.4, 0.5)
box.TextColor3 = Color3.new(1, 1, 1)
box.TextSize = 14
box.Font = Enum.Font.SourceSans
box.ClearTextOnFocus = false
box.Parent = main
box.BorderSizePixel = 0

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 260, 0, 16)
status.Position = UDim2.new(0, 20, 0, 100)
status.BackgroundTransparency = 1
status.Text = "Menunggu input..."
status.TextColor3 = Color3.new(0.5, 0.5, 0.5)
status.TextSize = 11
status.Font = Enum.Font.SourceSans
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.5, -5, 0, 32)
copyBtn.Position = UDim2.new(0, 20, 0, 125)
copyBtn.BackgroundColor3 = Color3.new(0, 0.6, 0.25)
copyBtn.Text = "Copy Avatar"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.TextSize = 13
copyBtn.Font = Enum.Font.SourceSansBold
copyBtn.Parent = main
copyBtn.BorderSizePixel = 0

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.5, -5, 0, 32)
resetBtn.Position = UDim2.new(0.5, 5, 0, 125)
resetBtn.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
resetBtn.Text = "Reset Avatar"
resetBtn.TextColor3 = Color3.new(1, 1, 1)
resetBtn.TextSize = 13
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.Parent = main
resetBtn.BorderSizePixel = 0

function getPlayer(input)
    input = string.lower(string.gsub(input, "^%s*(.-)%s*$", "%1"))
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name) == input then return p end
        if string.lower(p.DisplayName) == input then return p end
    end
    return nil
end

function copyAvatar(username)
    status.Text = "Mencari pemain..."
    status.TextColor3 = Color3.new(1, 0.8, 0)
    
    local target = getPlayer(username)
    if not target then
        status.Text = "Pemain tidak ditemukan!"
        status.TextColor3 = Color3.new(1, 0.3, 0.3)
        return
    end
    
    if target == player then
        status.Text = "Tidak bisa copy avatar sendiri!"
        status.TextColor3 = Color3.new(1, 0.3, 0.3)
        return
    end
    
    status.Text = "Menunggu karakter " .. target.DisplayName .. "..."
    
    local targetChar = target.Character
    if not targetChar then
        local found = false
        local conn
        conn = target.CharacterAdded:Connect(function(char)
            targetChar = char
            found = true
            conn:Disconnect()
        end)
        local timeout = 0
        while not found and timeout < 100 do
            task.wait(0.1)
            timeout = timeout + 1
        end
    end
    
    if not targetChar then
        status.Text = "Karakter target tidak ditemukan!"
        status.TextColor3 = Color3.new(1, 0.3, 0.3)
        return
    end
    
    local myChar = player.Character
    if myChar and not originalAvatar then
        originalAvatar = myChar:Clone()
    end
    
    if myChar then
        myChar:BreakJoints()
        task.wait(0.5)
        if myChar.Parent then myChar:Destroy() end
    end
    
    task.wait(0.3)
    
    local newChar = targetChar:Clone()
    newChar.Parent = workspace
    player.Character = newChar
    
    task.wait(0.5)
    
    local hum = newChar:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayName = player.DisplayName
    end
    
    local cam = workspace.CurrentCamera
    if cam and hum then
        cam.CameraSubject = hum
    end
    
    status.Text = "Berhasil copy avatar @" .. target.DisplayName
    status.TextColor3 = Color3.new(0.3, 1, 0.3)
end

function resetAvatar()
    if not originalAvatar then
        status.Text = "Tidak ada avatar asli!"
        status.TextColor3 = Color3.new(1, 0.8, 0)
        return
    end
    
    status.Text = "Mereset avatar..."
    
    local myChar = player.Character
    if myChar then
        myChar:BreakJoints()
        task.wait(0.5)
        if myChar.Parent then myChar:Destroy() end
    end
    
    task.wait(0.3)
    
    local newChar = originalAvatar:Clone()
    newChar.Parent = workspace
    player.Character = newChar
    
    task.wait(0.5)
    local hum = newChar:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayName = player.DisplayName
    end
    
    local cam = workspace.CurrentCamera
    if cam and hum then
        cam.CameraSubject = hum
    end
    
    originalAvatar = nil
    status.Text = "Avatar berhasil direset!"
    status.TextColor3 = Color3.new(0.3, 1, 0.3)
end

copyBtn.MouseButton1Click:Connect(function()
    local input = box.Text
    if input and input ~= "" then
        copyAvatar(input)
    else
        status.Text = "Masukkan username dulu!"
        status.TextColor3 = Color3.new(1, 0.8, 0)
    end
end)

resetBtn.MouseButton1Click:Connect(function()
    resetAvatar()
end)

box.FocusLost:Connect(function(enter)
    if enter then
        local input = box.Text
        if input and input ~= "" then
            copyAvatar(input)
        end
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F4 then
        guiVisible = not guiVisible
        gui.Enabled = guiVisible
    end
end)

print("Avatar Copier Loaded! Tekan F4 untuk toggle GUI")