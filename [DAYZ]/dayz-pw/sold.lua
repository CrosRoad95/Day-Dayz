prywatnyChat={}

function PrywatnaWiadomosc(cel,wiadomosc)
	if client then
		nickclienta=getPlayerName(client)
	else
		nickclienta='Pomoc Administracji'
	end
	if cel=="Pomoc Administracji" then
		aktualneWiadomosci=prywatnyChat[nickclienta.." : "..cel] or ""
		prywatnyChat[nickclienta.." : "..cel] = nickclienta..": "..wiadomosc.."\n"..aktualneWiadomosci
		triggerClientEvent(client,"PrywatnyChat:odeslij",client,cel,prywatnyChat[nickclienta.." : "..cel])
		return
	end
	if nickclienta=="Pomoc Administracji" then
		outputChatBox(wiadomosc)
		aktualneWiadomoscia=prywatnyChat[cel.." : "..nickclienta] or ""
		aktualneWiadomoscib=prywatnyChat[nickclienta.." : "..cel] or ""
		
		prywatnyChat[nickclienta.." : "..cel] = "Pomoc Administracji: "..wiadomosc.."\n"..aktualneWiadomoscib
		prywatnyChat[cel.." : "..nickclienta] = "Pomoc Administracji: "..wiadomosc.."\n"..aktualneWiadomoscia
		triggerClientEvent(getPlayerFromName(cel),"PrywatnyChat:odeslij",getPlayerFromName(cel),cel,prywatnyChat[cel.." : "..nickclienta])
		return
	end
	
	playSoundFrontEnd(getPlayerFromName(cel),12)
	aktualneWiadomosci=prywatnyChat[nickclienta.." : "..cel] or ""
	prywatnyChat[nickclienta.." : "..cel] = nickclienta..": "..wiadomosc.."\n"..aktualneWiadomosci
	prywatnyChat[cel.." : "..nickclienta] = nickclienta..": "..wiadomosc.."\n"..aktualneWiadomosci
	triggerClientEvent(getPlayerFromName(cel),"PrywatnyChat:odeslij",getPlayerFromName(cel),nickclienta,prywatnyChat[nickclienta.." : "..cel])
	exports.db:zapytanie("insert into Logi_chat_prywatny values(null,?,?,now(),?)",getElementData(client,"UID").."| "..nickclienta,getElementData(getPlayerFromName(cel),"UID").."| "..cel,wiadomosc)
	if client then
		triggerClientEvent(client,"PrywatnyChat:odeslij",client,cel,prywatnyChat[nickclienta.." : "..cel])
	end
end
addEvent("PrywatnyChat:wiadomosc",true)
addEventHandler("PrywatnyChat:wiadomosc",getRootElement(),PrywatnaWiadomosc)

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