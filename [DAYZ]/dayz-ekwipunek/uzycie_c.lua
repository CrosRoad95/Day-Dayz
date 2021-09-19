local playerFire={}
local fireCounter=0
function playerUseItem(itemName,itemInfo)
	triggerServerEvent("przedmiot_uzycie",resourceRoot,itemName,itemInfo)
end

function playerZoom(key, keyState)
	if key == "n" then
		if getElementData(getLocalPlayer(), "Night Vision Goggles") > 0 then
			if nightvision then
				nightvision = false
				setCameraGoggleEffect("normal")
				do
					local hour, minutes = getTime()
				end
			else
				nightvision = true
				setCameraGoggleEffect("nightvision")
				setFarClipDistance(1000)
			end
		end
	elseif key == "i" and 0 < getElementData(getLocalPlayer(), "Infrared Goggles") then
		if infaredvision then
			infaredvision = false
			setCameraGoggleEffect("normal")
		else
			infaredvision = true
			setCameraGoggleEffect("thermalvision")
		end
	end
end
bindKey("n", "down", playerZoom)
bindKey("i", "up", playerZoom)