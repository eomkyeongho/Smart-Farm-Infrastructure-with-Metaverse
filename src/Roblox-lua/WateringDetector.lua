local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local activateWP = Instance.new("RemoteFunction")
activateWP.Name = "activateWP"
activateWP.Parent = ReplicatedStorage

local function onactivateWPRequested(player, target)
	
	local HttpService = game:GetService("HttpService")
	local URI_WP = "/Mobius/" .. target .. "/waterpump"
	local response = HttpService:RequestAsync({
		Url = workspace.mobius.Value .. URI_WP,
		Method = "POST",
		Headers = {	
			["Content-Type"] = "application/json;ty=4",
			["X-M2M-RI"] = "12345",
			["X-M2M-Origin"] = "COrigin12345",			
		},
		Body = HttpService:JSONEncode({
			["m2m:cin"] = {
				["con"] = "ON"
			}
		})
})

	print("Watering " .. target)
end

activateWP.OnServerInvoke = onactivateWPRequested