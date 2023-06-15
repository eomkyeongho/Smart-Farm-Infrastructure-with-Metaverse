local part = script.Parent
local HttpService = game:GetService("HttpService")
local URI_FAN = "/Mobius/fan1/status"
local response
local touched = false
local status = "OFF"
local fanStatus = workspace.ventilator.isON

function createCIN()
	if touched then
		return
	end
	
	if status == "OFF" then
		status = "ON"
		part.FanImage.Transparency=0
		fanStatus.Value = true
	elseif status == "ON" then
		status = "OFF"
		part.FanImage.Transparency=0.3
		fanStatus.Value = false
	end
	
	touched = true

	response = HttpService:RequestAsync({
		Url = workspace.mobius.Value .. URI_FAN,
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
	print("FAN " .. status)
	print(response)
	
	wait(4)
	touched = false
end

part.Touched:Connect(createCIN)