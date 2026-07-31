local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AvatarCopierGUI"
ScreenGui.ResetOnSpawn = false
-- Memasukkan ke CoreGui agar tidak mudah terdeteksi oleh script anti-cheat game
ScreenGui.Parent = CoreGui 

-- 2. Membuat Frame Utama (Bisa digeser/Draggable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 150)
MainFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

-- Corner Radius untuk mempercantik UI
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- 3. Membuat Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Avatar Copier"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- 4. Membuat Kolom Input Username
local UsernameInput = Instance.new("TextBox")
UsernameInput.Size = UDim2.new(0.8, 0, 0, 35)
UsernameInput.Position = UDim2.new(0.1, 0, 0.35, 0)
UsernameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
UsernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UsernameInput.PlaceholderText = "Masukkan Username..."
UsernameInput.Text = ""
UsernameInput.Font = Enum.Font.Gotham
UsernameInput.TextSize = 14
UsernameInput.ClearTextOnFocus = false
UsernameInput.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = UsernameInput

-- 5. Membuat Tombol Copy
local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(0.6, 0, 0, 35)
CopyButton.Position = UDim2.new(0.2, 0, 0.65, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.Text = "Copy Avatar"
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 14
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CopyButton

-- 6. Membuat Tombol Close (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame

-- Logika Tutup GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 7. Logika Utama Copy Avatar
CopyButton.MouseButton1Click:Connect(function()
    local targetUsername = UsernameInput.Text
    
    if targetUsername == "" then
        CopyButton.Text = "Isi Username!"
        task.wait(1.5)
        CopyButton.Text = "Copy Avatar"
        return
    end

    CopyButton.Text = "Mencari User..."

    -- Mencari UserId berdasarkan Username menggunakan pcall (agar tidak error/crash jika salah)
    local successId, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(targetUsername)
    end)

    if successId and userId then
        CopyButton.Text = "Menerapkan..."
        
        -- Mengambil seluruh deskripsi avatar (baju, wajah, aksesoris, animasi) dari server Roblox
        local successDesc, description = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(userId)
        end)

        if successDesc and description then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                -- Terapkan deskripsi ke karakter kamu
                char.Humanoid:ApplyDescription(description)
                CopyButton.Text = "Sukses!"
                CopyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Berubah hijau
            else
                CopyButton.Text = "Karakter Error!"
                CopyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        else
            CopyButton.Text = "Gagal Ambil Data!"
            CopyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    else
        CopyButton.Text = "User Tidak Ada!"
        CopyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end

    -- Kembalikan tombol ke semula setelah 2 detik
    task.wait(2)
    CopyButton.Text = "Copy Avatar"
    CopyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)
