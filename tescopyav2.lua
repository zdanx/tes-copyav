-- ============================================
-- AVATAR COPIER — Delta Executor Android
-- Author: Workik Assistant
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- ===== VARIABLES =====
local originalAvatar = nil  -- menyimpan avatar asli untuk reset
local guiVisible = true

-- ===== CREATE GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarCopierGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Rounded corners via UICorner
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Shadow / Stroke
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 150, 255)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- ===== TITLE BAR =====
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

-- Fix top corners only
local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 8)
topBarFix.Position = UDim2.new(0, 0, 0, 27)
topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
topBarFix.BorderSizePixel = 0
topBarFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🎭 Avatar Copier"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 2)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===== CONTENT =====
-- Label
local instructionLabel = Instance.new("TextLabel")
instructionLabel.Size = UDim2.new(0, 280, 0, 20)
instructionLabel.Position = UDim2.new(0, 20, 0, 50)
instructionLabel.BackgroundTransparency = 1
instructionLabel.Text = "Masukkan username pemain:"
instructionLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
instructionLabel.TextSize = 13
instructionLabel.Font = Enum.Font.Gotham
instructionLabel.TextXAlignment = Enum.TextXAlignment.Left
instructionLabel.Parent = mainFrame

-- TextBox
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0, 280, 0, 35)
textBox.Position = UDim2.new(0, 20, 0, 75)
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
textBox.BorderSizePixel = 0
textBox.PlaceholderText = "Contoh: xXProPlayerXx"
textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 14
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
textBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 280, 0, 16)
statusLabel.Position = UDim2.new(0, 20, 0, 115)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "👤 Menunggu input..."
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- ===== BUTTONS =====
local buttonFrame = Instance.new("Frame")
buttonFrame.Size = UDim2.new(1, -40, 0, 35)
buttonFrame.Position = UDim2.new(0, 20, 0, 138)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = mainFrame

-- Copy Button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.5, -5, 1, 0)
copyButton.Position = UDim2.new(0, 0, 0, 0)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
copyButton.BorderSizePixel = 0
copyButton.Text = "📋 Copy Avatar"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 13
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = buttonFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 6)
copyCorner.Parent = copyButton

-- Reset Button
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.5, -5, 1, 0)
resetButton.Position = UDim2.new(0.5, 5, 0, 0)
resetButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
resetButton.BorderSizePixel = 0
resetButton.Text = "↩️ Reset Avatar"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = 13
resetButton.Font = Enum.Font.GothamBold
resetButton.Parent = buttonFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 6)
resetCorner.Parent = resetButton

-- ===== FUNCTIONS =====

-- Fungsi: Mendapatkan player berdasarkan username
function getPlayerByUsername(username)
    username = username:lower():gsub("^%s+", ""):gsub("%s+$", "")
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower() == username or p.DisplayName:lower() == username then
            return p
        end
    end
    return nil
end

-- Fungsi: Copy avatar pemain
function copyAvatar(username)
    statusLabel.Text = "⏳ Mencari pemain..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    
    local targetPlayer = getPlayerByUsername(username)
    
    if not targetPlayer then
        statusLabel.Text = "❌ Pemain tidak ditemukan!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    if targetPlayer == player then
        statusLabel.Text = "❌ Tidak bisa copy avatar sendiri!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    statusLabel.Text = "⏳ Menunggu karakter " .. targetPlayer.DisplayName .. "..."
    
    -- Tunggu sampai karakter target muncul
    local targetChar = targetPlayer.Character
    if not targetChar then
        targetChar = targetPlayer.CharacterAdded:Wait(5)
    end
    
    if not targetChar then
        statusLabel.Text = "❌ Karakter target tidak ditemukan!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        return
    end
    
    -- Simpan avatar asli (jika belum)
    local localChar = player.Character
    if localChar and not originalAvatar then
        originalAvatar = localChar:Clone()
    end
    
    -- Hancurkan karakter lama
    if localChar and localChar.Parent then
        localChar:BreakJoints()
        wait(0.5)
        localChar:Destroy()
    end
    
    -- Clone karakter target SEPENUHNYA (termasuk pakaian, aksesoris, dll)
    wait(0.3)
    local newChar = targetChar:Clone()
    newChar.Parent = workspace
    player.Character = newChar
    
    -- Set Humanoid properties
    wait(0.5)
    local humanoid = newChar:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayName = player.DisplayName
        humanoid.Name = player.Name
    end
    
    -- Pindahkan kamera
    wait(0.1)
    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraSubject = newChar:FindFirstChildOfClass("Humanoid")
    end
    
    statusLabel.Text = "✅ Berhasil menyalin avatar @" .. targetPlayer.DisplayName
    statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
    
    -- Animasi button
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    wait(0.3)
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 70)
    
    print("[AvatarCopier] Berhasil copy avatar dari: " .. targetPlayer.Name)
end

-- Fungsi: Reset avatar ke aslinya
function resetAvatar()
    if not originalAvatar then
        statusLabel.Text = "⚠️ Tidak ada avatar asli yang tersimpan"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        return
    end
    
    statusLabel.Text = "⏳ Mereset avatar..."
    
    local localChar = player.Character
    if localChar and localChar.Parent then
        localChar:BreakJoints()
        wait(0.5)
        localChar:Destroy()
    end
    
    wait(0.3)
    local newChar = originalAvatar:Clone()
    newChar.Parent = workspace
    player.Character = newChar
    
    wait(0.5)
    local humanoid = newChar:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayName = player.DisplayName
        humanoid.Name = player.Name
    end
    
    local camera = workspace.CurrentCamera
    if camera then
        camera.CameraSubject = humanoid
    end
    
    originalAvatar = nil
    
    statusLabel.Text = "✅ Avatar berhasil direset!"
    statusLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
end

-- ===== HOTKEY (Tekan F4 untuk toggle GUI) =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F4 then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

-- ===== BUTTON EVENTS =====

-- Copy button
copyButton.MouseButton1Click:Connect(function()
    local username = textBox.Text
    if username and username ~= "" then
        copyAvatar(username)
    else
        statusLabel.Text = "⚠️ Masukkan username terlebih dahulu!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
    end
end)

-- Reset button
resetButton.MouseButton1Click:Connect(function()
    resetAvatar()
end)

-- Enter key on TextBox
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local username = textBox.Text
        if username and username ~= "" then
            copyAvatar(username)
        end
    end
end)

-- ===== NOTIFICATION =====
print("[AvatarCopier] ✅ Loaded! Tekan F4 untuk toggle GUI")