local option = "wylacz, oko, kolizja, komponenty"

function cmdMode(player, command, ...)
	--if not exports.dutyadmin:getAdmin(player,4) then return end
	local arg = {...}
	local helper = getElementData(player,"helper")
	local typ = arg[1]
	if typ == "wlacz" then
		if not(helper) then
			helper = {}
			setElementData(player,"helper",helper)
			triggerClientEvent(player, "toggleDeveloperMode", player, true )
			outputChatBox( "Tryb developerski został włączony.",player, 255,255,255)
			return true
		end
	elseif typ == "wylacz" then
		if helper then
			removeElementData(player,"helper",false)
			triggerClientEvent(player, "toggleDeveloperMode", player, false )
			outputChatBox( "Tryb developerski został wyłączony.",player, 255,255,255)
			return true
		end
	elseif typ == "oko" then
		if helper.eye then
			helper.eye = false
			helper.textury = false
			triggerClientEvent(player, "toggleEyeMode", player, false )
			outputChatBox( "Zawansowany podglad zostal wyłączony.",player, 255,255,255)
		elseif not(helper.eye) then
			helper.eye = true
			triggerClientEvent(player, "toggleEyeMode", player, true )
			outputChatBox( "Zawansowany podglad zostal włączony.",player, 255,255,255)	
		end
	elseif typ == "kolizja" then
		if helper.collision then
			helper.collision = false
			triggerClientEvent(player, "toggleCollisionMode", player, false )
			outputChatBox( "Podgląd kolizji został wyłączony.",player, 255,255,255)
		elseif not(helper.collision) then
			helper.collision = true
			triggerClientEvent(player, "toggleCollisionMode", player, true )
			outputChatBox( "Podgląd kolizji został włączony.",player, 255,255,255)	
		end
	elseif typ == "komponenty" then
		if helper.components then
			if not(helper.eye) then outputChatBox( "Najpirew musisz włączyć tryb zawansowanego podglądu.",player, 255,255,255) end
			helper.components = false
			outputChatBox( "Podgląd komponentów został wyłączony.",player, 255,255,255)
		elseif not(helper.components) then
			helper.components = true
			outputChatBox( "Podgląd komponentów został włączony.",player, 255,255,255)	
		end
	elseif typ == "textury" then
		if not(helper.eye) then outputChatBox( "Najpirew musisz włączyć tryb zawansowanego podglądu.",player, 255,255,255) end
		if helper.texture then
			helper.texture = false
			outputChatBox( "Podgląd textur został wyłączony.",player, 255,255,255)
		elseif not(helper.texture) then
			helper.texture = true
			outputChatBox( "Podgląd textur został włączony.",player, 255,255,255)	
		end
	elseif not(typ == nil) then
		outputChatBox( "Wystąpił błąd!")
		return
	end
	setElementData(player,"helper",helper)
	
	if helper and typ == nil then
		outputChatBox( string.format("TIP: /worldinfo [%s]", option),player, 255,255,255 )
	elseif not(helper) and typ == nil then
 		outputChatBox( "TIP: /worldinfo [wlacz]",player, 255,255,255)
	end


end
addCommandHandler("worldinfo", cmdMode, false, false)
