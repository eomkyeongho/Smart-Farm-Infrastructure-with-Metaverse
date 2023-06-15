local part = script.Parent
local HttpService = game:GetService("HttpService")
local URI_LIGHT = "/Mobius/plantLight/status"
local response
local touched = false
local status = "OFF"
local light = script.Parent.Parent.Parent.Teaser.Light

function createCIN()
	if touched then
		return
	end	
	
	touched = true
	
	if status == "OFF" then
		status = "ON"
		light.Transparency=0.8
	elseif status == "ON" then
		status = "OFF"
		light.Transparency=1
	end

	response = HttpService:RequestAsync({
		Url = workspace.mobius.Value .. URI_LIGHT,
		Method = "POST",
		Headers = {	
			["Content-Type"] = "application/json;ty=4",
			["X-M2M-RI"] = "12345",
			["X-M2M-Origin"] = "COrigin12345",			
		},
		Body = HttpService:JSONEncode({
			["m2m:cin"] = {
				["con"] = status
			}
		})
	})
	print("Plant Light " .. status)
	print(response)
	
	wait(4)
	touched = false
end

function onPart()
	part.BrickColor = BrickColor.new("CGA brown")
end

function outPart()
	part.BrickColor = BrickColor.new("New Yeller")
end

part.Touched:Connect(onPart)
part.Touched:Connect(createCIN)
part.TouchEnded:Connect(outPart)