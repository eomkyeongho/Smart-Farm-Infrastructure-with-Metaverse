local f = false
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tool = script.Parent
local activateWP = ReplicatedStorage:WaitForChild("activateWP")

script.Parent.Activated:Connect(function()
	if not f then
		f = true
		local YAnimation = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(script.Parent.Animation)
		YAnimation:Play()
		local Target = Mouse.Target
		while not Target:isA("Model") do
			Target = Target.Parent
		end
		Target = Target.Parent
		if Target:GetAttribute("isPlant") then
			activateWP:InvokeServer(Target.Name)
		end
		wait(3)
		f = false
	end
end)