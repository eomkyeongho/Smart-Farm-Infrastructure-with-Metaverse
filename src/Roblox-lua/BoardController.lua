local temperatureBar = script.Parent.TemperatureBar
local temperatureText = script.Parent.SurfaceGui.TemperatureText
local temperature, temperatureRate, temperatureState

local humidityBar = script.Parent.HumidityBar
local humidityText = script.Parent.SurfaceGui.HumidityText
local humidity, humidityRate, humidityState

local sunshineBar = script.Parent.SunshineBar
local sunshineText = script.Parent.SurfaceGui.SunshineText
local sunshine, sunshineRate

local totalStateBar = script.Parent.TotalStateBar
local totalStateText = script.Parent.SurfaceGui.TotalStateText
local totalState, totalStateRate

local HttpService = game:GetService("HttpService")
local URI_SENSOR = "/Mobius/sensorgrp/fopt";

local response, data

local lighting = game:GetService("Lighting")

print(script.Parent.Parent.Parent.Name)

while true do
	response = HttpService:RequestAsync({
		Url = workspace.mobius.Value .. URI_SENSOR,
		Headers = {
			["X-M2M-RI"] = "12345",
			["X-M2M-Origin"] = "COrigin12345",
		}
	})

	data = HttpService:JSONDecode(response["Body"])
	
	local sunshineStateText = ""
	temperatureState = 0;
	humidityState = 0;
	sunshineState = 0;
	
	for _, rsp in data["m2m:agr"]["m2m:rsp"] do
		if rsp['pc']["m2m:cin"]["cr"] == "temperature" then
			temperature = tonumber(rsp["pc"]["m2m:cin"]["con"])

			temperatureState = 34 - 1.3*math.abs(25-temperature)
			temperatureState = math.max(temperatureState, 0)

			temperatureRate = (temperature/40.0)*3.9
			temperatureRate = math.max(temperatureRate, 0.05);
			temperatureRate = math.min(temperatureRate, 3.9);

			temperatureBar.Size = Vector3.new(temperatureRate,0.25,0.04)
			temperatureText.Text = (string.format("Temperature : %.1f ℃", temperature))
		elseif rsp['pc']["m2m:cin"]["cr"] == "humidity"  then
			humidity = tonumber(rsp["pc"]["m2m:cin"]["con"])

			humidityState = 33 - 0.5*math.abs(75-humidity)
			humidityState = math.max(humidityState, 0)

			humidityRate = (humidity/100.0)*3.9
			humidityRate = math.max(humidityRate, 0.05);
			humidityRate = math.min(humidityRate, 3.9);

			humidityBar.Size = Vector3.new(humidityRate,0.25,0.04)
			humidityText.Text = (string.format("Humidity : %d %%", humidity))
		elseif rsp['pc']["m2m:cin"]["cr"] == "sunshine"  then
			sunshine = tonumber(rsp["pc"]["m2m:cin"]["con"])

			sunshineState = 33 - 0.03*math.abs(1000-sunshine)
			sunshineState = math.max(sunshineState, 0)

			sunshineRate = (500.0/sunshine)*3.9
			sunshineRate = math.max(sunshineRate, 0.05)
			sunshineRate = math.min(sunshineRate, 3.9)

			sunshineBar.Size = Vector3.new(sunshineRate,0.25,0.04)
			
			if sunshine <= 900 then
				sunshineStateText = "Bright"
				lighting.ClockTime = 12
			elseif 900 < sunshine and sunshine <= 1200 then
				sunshineStateText = "Slightly Bright"
				lighting.ClockTime = 17.5
			elseif 1200 < sunshine and sunshine <= 1500 then
				sunshineStateText = "Slightly Dark"
				lighting.ClockTime = 17.7
			else
				sunshineStateText = "Dark"
				lighting.ClockTime = 18
			end
			sunshineText.Text = (string.format("Sunshine : %s", sunshineStateText))
			
		elseif rsp['pc']["m2m:cin"]["cr"] == "airquality" then
			airQuality = tonumber(rsp["pc"]["m2m:cin"]["con"])
			airQualityRate = (airQuality/100.0)*3.9
			airQualityRate = math.max(airQualityRate, 0.05);
			airQualityRate = math.min(airQualityRate, 3.9)
			
			print(airQualityRate)
					
			totalStateBar.Size = Vector3.new(airQualityRate,0.25,0.04)
			totalStateText.Text = (string.format("AirQuality Score: %.1f", airQuality))
		end
	end

	wait(10)
end