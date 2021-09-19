prywatnyChat={}

function PrywatnaWiadomosc(cel,wiadomosc)
	if not cel then return end
	nclient=getPlayerName(client)
	local times = getRealTime()
	local month = times.month+1
	local day = times.monthday
	local hours = times.hour
	local minutes = times.minute
	local second = times.second
	
	playSoundFrontEnd(getPlayerFromName(cel),12)
	aktualneWiadomosci=prywatnyChat[nclient.." : "..cel] or ""
	data="["..day.."."..month.." "..hours..":"..minutes..":"..second.."]"
	prywatnyChat[nclient.." : "..cel] = data.." "..skipColorCode(nclient)..": "..wiadomosc.."\n"..aktualneWiadomosci
	prywatnyChat[cel.." : "..nclient] = data.." "..skipColorCode(nclient)..": "..wiadomosc.."\n"..aktualneWiadomosci
	triggerClientEvent(getPlayerFromName(cel),"PrywatnyChat:odeslij",getPlayerFromName(cel),nclient,prywatnyChat[nclient.." : "..cel])
	if client then
		triggerClientEvent(client,"PrywatnyChat:odeslij",client,cel,prywatnyChat[nclient.." : "..cel])
	end
end
addEvent("PrywatnyChat:wiadomosc",true)
addEventHandler("PrywatnyChat:wiadomosc",getRootElement(),PrywatnaWiadomosc)
function pobierzwiadomosc(cel)
	if cel then
		nclient=getPlayerName(client)
		triggerClientEvent(client,"PrywatnyChat:odeslijj",client,cel,prywatnyChat[nclient.." : "..cel])
	end
end
addEvent("PrywatnyChat:pobierzwiadomosc",true)
addEventHandler("PrywatnyChat:pobierzwiadomosc",getRootElement(),pobierzwiadomosc)

function aktualizuj()
	triggerClientEvent(client,"PrywatnyChat:aktualizuja",client,prywatnyChat)
end
addEvent("PrywatnyChat:aktualizuj",true)
addEventHandler("PrywatnyChat:aktualizuj",getRootElement(),aktualizuj)

function pobierzListePomocyAdministracji()
	lista={}
	for i,v in pairs(prywatnyChat) do
		if string.find(i," : Pomoc Administracji") then
			lista[string.gsub(i," : Pomoc Administracji","")]=v
		end
	end
	return lista
end

function skipColorCode ( s )
	if type ( s ) == "string" then
		return string.gsub ( s, "(#%x%x%x%x%x%x)", "" )
	elseif type ( s ) == "userdata" and getElementType ( s ) == "player" then
		return string.gsub ( getPlayerName ( s ), "(#%x%x%x%x%x%x)", "" )
	end
end	