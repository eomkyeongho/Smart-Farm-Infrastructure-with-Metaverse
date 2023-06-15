allmodels = script.Parent:GetChildren()
models = {}

for i, v in pairs(allmodels) do
	if not v:isA("Model") then
		continue
	end
	if v:getAttribute("isPlant") then
		table.insert(models, allmodels[i]) 
	end
end



local function changePlantVisibility(model, visible)
	local parts = model:GetChildren()
	local decals
	
	for i, v in pairs(parts) do
		if not v:isA("Part") then
			continue
		end
		if visible == 1 then
			v.CanCollide = false
		else
			v.CanCollide = true
		end
		if v:IsA("UnionOperation") or v.Name == "Fruit" or v.Name == "Stem" then
			v.Transparency = visible
		end
		
		decals = v:GetChildren()
		
		for j, w in pairs(decals) do
			if w:IsA("Decal") or w:IsA("Part") then
				w.Transparency = visible
			end
		end
	end
end


while true do	
	for idx, model in models do
		local childs = model:GetChildren()
		local plantName = model.Name
		local ground = model.Ground
		local HttpService = game:GetService("HttpService")
		local URI_SENSOR = "/Mobius/" .. plantName .. "/sensorGrp/fopt"
		local URI_INFO = "/Mobius/" .. plantName .. "/infoGrp/fopt"
		local response, data, growth, moisture, rgb
		local new_growth, new_moisture, new_rgb
		
		growth = "-1"
		response = HttpService:RequestAsync({
			Url = workspace.mobius.Value .. URI_INFO,
			Headers = {
				["X-M2M-RI"] = "12345",
				["X-M2M-Origin"] = "COrigin12345",
			}
		})

		data = HttpService:JSONDecode(response["Body"])
		
		if response.StatusCode == 200 then
			for _, rsp in data["m2m:agr"]["m2m:rsp"] do
				if rsp['rsc'] ~= "2000" then
					continue
				end
				if rsp['pc']["m2m:cin"]["cr"] == "growth" then
					new_growth = rsp['pc']["m2m:cin"]["con"]
				elseif rsp['pc']["m2m:cin"]["cr"] == "rgb" then
					new_rgb = rsp['pc']["m2m:cin"]["con"]
				elseif rsp['pc']["m2m:cin"]["cr"] == "moisture" then
					new_moisture = tonumber(rsp['pc']["m2m:cin"]["con"])
				end
			end
		else
			new_growth = "0"
			new_moisture = 4095
			rgb = {0, 0, 0}
		end
		



		if new_growth ~= growth then
			growth = new_growth
			for i, v in pairs(childs) do
				if v.Name == growth then
					changePlantVisibility(v, 0)
				else
					changePlantVisibility(v, 1)
				end
			end
		end

		if new_rgb ~= rgb then
			rgb = new_rgb
			for i, v in pairs(models) do
				if v.Name == "3" or v.Name == "4" then
					children = v:GetChildren()
					for j, w in pairs(children) do
						if w.Name == "Fruit" then
							w.Color = Color3.fromRGB(rgb[1], rgb[2], rgb[3])
						end
					end
				end
			end
		end
		
		
		if new_moisture ~= moisture then
			moisture = new_moisture
			if 0 <= moisture and moisture <= 1500 then
				ground.Color = Color3.fromRGB(68,46,20)
			elseif 1500 < moisture and moisture <= 2500 then
				ground.Color = Color3.fromRGB(103,51,31)
			else 
				ground.Color = Color3.fromRGB(161,106,52) 
			end
		end
		
	end
	
	wait(10)
end
