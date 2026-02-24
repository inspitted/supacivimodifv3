local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local plr = Players.LocalPlayer
local gui = Instance.new("ScreenGui",game.CoreGui)

local function circle(pos, text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(60, 60)
    b.Position = pos
    b.AnchorPoint = Vector2.new(1, 1) 
    b.BackgroundColor3 = Color3.fromRGB(139, 69, 19)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextScaled = true
    b.Font = Enum.Font.GothamBlack
    b.Parent = gui
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    return b
end

local b2 = circle(UDim2.new(1, -30, 1, -130), "DASH")
local b3 = circle(UDim2.new(1, -30, 1, -200), "SHORT\nDASH")
local b1 = circle(UDim2.new(1, -30, 1, -270), "POW")


local function twitch(btn)
	task.spawn(function()
		while btn.Parent do
			btn.Rotation = math.random(-3,3)
			task.wait(0.06)
		end
	end)
end

twitch(b1)
twitch(b2)
twitch(b3)

local function trail(part)
end
local function setupCharacter(char)
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	

	local function attachToKiller(killer)
		if killer and killer.Character and killer.Character:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = killer.Character.HumanoidRootPart.CFrame
			local w = Instance.new("WeldConstraint")
			w.Part0 = hrp
			w.Part1 = killer.Character.HumanoidRootPart
			w.Parent = hrp
			Debris:AddItem(w,1.5)
		end
	end

	local function dash(dist)
		trail(hrp)
		local cf = hrp.CFrame * CFrame.new(0,0,-dist)
		TweenService:Create(hrp,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{CFrame=cf}):Play()
	end

	local function blast()
		local sound = Instance.new("Sound",hrp)
		sound.SoundId = "rbxassetid://4961240438"
		sound:Play()
		Debris:AddItem(sound,2)

		local bullet = Instance.new("Part")
		bullet.Size = Vector3.new(1,1,4)
		bullet.Anchored = true
		bullet.CanCollide = false
		bullet.Material = Enum.Material.Neon
		bullet.Color = Color3.fromRGB(255,200,80)
		bullet.CFrame = hrp.CFrame * CFrame.new(0,0,-4)
		bullet.Parent = workspace
		trail(bullet)

		local dir = hrp.CFrame.LookVector * 60
		local t = 0
		local conn
		conn = RunService.Heartbeat:Connect(function(dt)
			if not bullet.Parent then
				conn:Disconnect()
				return
			end
			bullet.CFrame = bullet.CFrame + dir*dt
			t += dt
			if t >= 1 then
				bullet:Destroy()
				conn:Disconnect()
				return
			end
			for _,p in ipairs(Players:GetPlayers()) do
				if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local h = p.Character:FindFirstChild("Humanoid")
					if h and h.Health > 200 and (bullet.Position - p.Character.HumanoidRootPart.Position).Magnitude <= 5 then
						attachToKiller(p)
						bullet:Destroy()
						conn:Disconnect()
						break
					end
				end
			end
		end)
	end

	local function superPunch()
		local sound = Instance.new("Sound",hrp)
		sound.SoundId = "rbxassetid://75538808332206"
		sound:Play()
		Debris:AddItem(sound,2)
		trail(hrp)
		local cf = hrp.CFrame * CFrame.new(0,0,-12)
		TweenService:Create(hrp,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{CFrame=cf}):Play()
	end

	local function play(id)
		local a = Instance.new("Animation")
		a.AnimationId = "rbxassetid://"..id
		hum:LoadAnimation(a):Play()
	end

	b1.MouseButton1Click:Connect(function()
		play(74108653904830)
		blast()
	end)

	b2.MouseButton1Click:Connect(function()
		play(15938993207)
		dash(30)
	end)

	b3.MouseButton1Click:Connect(function()
		play(94027412516651)
		superPunch()
	end)
end

setupCharacter(plr.Character or plr.CharacterAdded:Wait())
plr.CharacterAdded:Connect(setupCharacter)

local P = Players.LocalPlayer
local R = RunService
local hiddenfling = true

coroutine.wrap(function()
	while hiddenfling do
		R.Heartbeat:Wait()
		local c = P.Character
		local h = c and c:FindFirstChild("HumanoidRootPart")
		if h then
			local v = h.Velocity
			h.Velocity = v*1000000 + Vector3.new(0,10000,0)
			R.RenderStepped:Wait()
			h.Velocity = v
			R.Stepped:Wait()
			h.Velocity = v + Vector3.new(0,0.1,0)
		end
	end
end)()

StarterGui:SetCore("SendNotification",{
	Title="Script Loaded";
	Text="Made by Hecker (modified by inspit)";
	Duration=3;
})
