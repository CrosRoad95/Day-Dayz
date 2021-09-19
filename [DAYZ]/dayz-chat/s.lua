tagadmina="@admin"
function zaladuj()
	rangi=exports.db:pobierzTabeleWynikow("SELECT * FROM `Chat_rangi`") -- ranga_acl
end
zaladuj()
function ranga(gracz)
	if getElementData(gracz,"UKRYTY") then
		return "#00ffff[GRACZ]#ffffff"
	end
	local konto=getAccountName(getPlayerAccount(gracz))
	for i,v in ipairs(rangi) do
		if aclGetGroup(v.ranga_acl) and isObjectInACLGroup("user."..konto,aclGetGroup(v.ranga_acl)) then
			return v.kolor..v.wyswietlana_ranga.."#ffffff"
		end
	end
	return "#00ffff[GRACZ]#ffffff"
end
wylaczony=false
function napisz(thePlayer, cmd, ...)
	if isPlayerMuted(thePlayer) then
		return outputChatBox("Masz zakaz pisania!",thePlayer,255,0,0)
	end
	e=not e
	local konto=getAccountName(getPlayerAccount(thePlayer))
	local message=table.concat ({...}," ")
	local gracz=string.gsub(getPlayerName(thePlayer),"#%x%x%x%x%x%x","")
	local gracz=string.gsub(gracz,"#%x%x%x%x%x%x","")
	local gracz=string.gsub(gracz,"#%x%x%x%x%x%x","")
	local message=string.gsub(message,"#%x%x%x%x%x%x","")
	local message=string.gsub(message,"#%x%x%x%x%x%x","")
	local message=string.gsub(message,"#%x%x%x%x%x%x","")
	rangaa=ranga(thePlayer)
	if rangaa=="#00ffff[GRACZ]#ffffff" and wylaczony then
		return outputChatBox("Chat globalny jest wyłączony!",thePlayer,255,0,0)
	end
	for i,v in ipairs(getElementsByType("player")) do
		outputChatBox(rangaa.." "..gracz..": "..message,v,255,255,255,true)
	end
	exports.db:zapytanie("insert into Logi_chat_globalny values(null,now(),?,?)",getElementData(thePlayer,"UID").."| "..gracz,message) 
end
addCommandHandler("Chat", napisz)

function chat(wiadomosc,typ)
	local gracz=string.gsub(getPlayerName(source),"#%x%x%x%x%x%x","")
	local gracz=string.gsub(gracz,"#%x%x%x%x%x%x","")
	local gracz=string.gsub(gracz,"#%x%x%x%x%x%x","")
    cancelEvent()
	if typ==0 then
		xx,yy,zz=getElementPosition(source)
		for i,v in ipairs(getElementsByType("player")) do
			x,y,z=getElementPosition(v)
			if getDistanceBetweenPoints3D(xx,yy,zz,x,y,z)<20 then
				outputChatBox("[LOCAL] "..gracz..": "..wiadomosc,v,230,230,230)
				exports.db:zapytanie("insert into Logi_chat_lokalny values(null,now(),?,?)",getElementData(source,"UID") or "Niezalogowany".."| "..gracz,wiadomosc) 

			end
		end
	elseif typ==2 then
		mojgang=getElementData(source,"grupa")
		if not mojgang then
			outputChatBox("Nie masz żadnego gangu!",source,255,0,0)
		end
		for i,v in ipairs(getElementsByType("player")) do
			jegogang=getElementData(v,"grupa")
			if jegogang and jegogang[1] and mojgang[1]==jegogang[1] then
				outputChatBox("[GANG] "..gracz..": "..wiadomosc,v,0,150,150)
			end
		end
		exports.db:zapytanie("insert into Logi_chat_grupowy values(null,null,?,?,?)",getElementData(source,"UID") or "Niezalogowany".."| "..gracz,mojgang[1],wiadomosc) 
	end
end
addEventHandler("onPlayerChat",getRootElement(),chat)