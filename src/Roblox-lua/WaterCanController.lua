local player = nil 
local Tool = script.Parent
local RSH = nil
local RW = Instance.new("Weld")
local Fountain = script.Parent.Fountain
local deb=false
local Mouse = nil


function pour()
for i = 0, 1, 0.05 do wait() RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90 - (i*50)),0,0) end
wait()
for i=1,80 do
		wait()
		for j=1,10 do
			local Part = Instance.new("Part")
			Part.Name = "Water"
			Part.Parent = workspace
			Part.Shape = 0
			Part.Size = Vector3.new(.2,.2,.2)
			Part.BrickColor = BrickColor.new(23)
			Part.Transparency = 0
			Part.TopSurface = 0
			Part.BottomSurface = 0
			Part.CFrame = Fountain.CFrame
			Part.Velocity=Vector3.new(math.random(-5,5),math.random(-5,5),math.random(-5,5))
			Part.CanCollide = false
		end
end
wait(0.2)
RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90),0,0)
end

Tool.Equipped:connect(function()
	player = game.Players:GetPlayerFromCharacter(script.Parent.Parent)
local ch = script.Parent.Parent
--RSH = ch.Torso["Right Shoulder"]
--RSH.Parent = nil
--RW.Part0 = ch.Torso
RW.C0 = CFrame.new(1.5, 0.5, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0)
RW.C1 = CFrame.new(0, 0.5, 0)
--RW.Part1 = ch["Right Arm"]
--RW.Parent = ch.Torso
end)

Tool.Unequipped:connect(function()
RW.Parent = nil
--RSH.Parent = player.Character.Torso
end)

Tool.Activated:connect(function()
	if deb then return end deb=true
	pour()
	delay(0.3,function() deb=false end)
end)
