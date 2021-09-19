function system_log(user,ip,akcja,opis)
	exports.db:zapytanie("insert into Logi_http values(null,now(),?,?,?,?)",getAccountName(user),ip,akcja,opis)
end
function system_nieautoryzowane(user,ip,akcja,opis)
	exports.db:zapytanie("insert into Logi_http values(null,now(),?,?,?,?)",getAccountName(user),ip,"NIEAUTORYZOWANE",akcja.." | "..opis)
end
function prawa(user,prawo)
	if hasObjectPermissionTo("user."..getAccountName(user),prawo,true) then
		return true
	else
		return false
	end
end

-- funkcje zasoby
function zasoby_start(skrypt)
	if prawa(user,"function.zasoby") then
		local res=getResourceFromName(skrypt)
		if getResourceState(res)=="running" then
			system_log(user,hostname,"zasoby > start (try)",skrypt)
			return "Skrypt jest już włączony!";
		end
		if res then
			system_log(user,hostname,"zasoby > start (ok)",skrypt)
			startResource(res)
			return "Skrypt włączony pomyślnie!";
		else
			system_log(user,hostname,"zasoby > start (błąd)",skrypt)
			return "Taki skrypt nie istnieje!"
		end
	else
		system_nieautoryzowane(user,hostname,"zasoby > start (nieaut)",skrypt)
		return "Skrypt włączony pomyślnie!";
	end
end
function zasoby_stop(skrypt)
	if prawa(user,"function.zasoby") then
		local res=getResourceFromName(skrypt)
		if getResourceState(res)=="loaded" then
			system_log(user,hostname,"zasoby > stop (try)",skrypt)
			return "Skrypt jest już wyłączony!";
		end
		if getResourceState(res)=="failed to load" then
			system_log(user,hostname,"zasoby > stop (try)",skrypt)
			return "Skrypt nie działa poprawnie!";
		end
		if getResourceState(res)=="stopping" then
			system_log(user,hostname,"zasoby > stop (try)",skrypt)
			return "Skrypt jest w trakcie wyłączania!";
		end
		if getResourceState(res)=="starting" then
			system_log(user,hostname,"zasoby > stop (try)",skrypt)
			return "Skrypt jest w trakcie włączania!";
		end
		if res then
			system_log(user,hostname,"zasoby > stop (ok)",skrypt)
			stopResource(res)
			return "Skrypt wyłączony pomyślnie!";
		else
			system_log(user,hostname,"zasoby > stop (błąd)",skrypt)
			return "Taki skrypt nie istnieje!"
		end
	else
		system_nieautoryzowane(user,hostname,"zasoby > stop (nieaut)",skrypt)
		return "Skrypt wyłączony pomyślnie!";
	end
end
function zasoby_restart(skrypt)
	if prawa(user,"function.zasoby") then
		local res=getResourceFromName(skrypt)
		if getResourceState(res)=="loaded" then
			system_log(user,hostname,"zasoby > restart (try)",skrypt)
			return "Skrypt musi być włączony!";
		end
		if getResourceState(res)=="failed to load" then
			system_log(user,hostname,"zasoby > restart (try)",skrypt)
			return "Skrypt nie działa poprawnie!";
		end
		if getResourceState(res)=="stopping" then
			system_log(user,hostname,"zasoby > restart (try)",skrypt)
			return "Skrypt jest w trakcie wyłączania!";
		end
		if getResourceState(res)=="starting" then
			system_log(user,hostname,"zasoby > restart (try)",skrypt)
			return "Skrypt jest w trakcie włączania!";
		end
		if res then
			system_log(user,hostname,"zasoby > restart (ok)",skrypt)
			restartResource(res)
			return "Skrypt został zresetowany pomyślnie!";
		else
			system_log(user,hostname,"zasoby > restart (błąd)",skrypt)
			return "Taki skrypt nie istnieje!"
		end
	else
		system_nieautoryzowane(user,hostname,"zasoby > restart (nieaut)",skrypt)
		return "Skrypt został zresetowany pomyślnie!";
	end
end

statusNazwa={
["loaded"]={ "Załadowany", "#ff00ff"},
["running"]={ "Włączony", "#006400"},
["starting"]={ "Startuje", "#000064"},
["stopping"]={ "Trwa wyłączanie", "#006400"},
["failed to load"]={ "Nie działa", "#ff0000"}, }
function zasoby_status(skrypt)
	if prawa(user,"function.zasoby") then
		local res=getResourceFromName(skrypt)
		return skrypt,statusNazwa[getResourceState(res)][1],statusNazwa[getResourceState(res)][2]
	else
		return "","",""
	end
end

function gracze_wiadomosc(gracz,tresc)
	if prawa(user,"function.gracze") then
		graczd=getPlayerFromName(gracz)
		if graczd then
			outputChatBox("#ff0000[SERWER] #ee1100"..tresc,graczd,255,255,255,true)
			playSoundFrontEnd(graczd,33)
			system_log(user,hostname,"gracze > wiadomosc (ok)",gracz.." > "..tresc)
			return "Wiadomość wysłana pomyślnie!"
		else
			system_log(user,hostname,"gracze > wiadomosc (blad)",gracz.." > "..tresc)
			return "Taki gracz nie istnieje!"
		end
	else
		system_nieautoryzowane(user,hostname,"gracze > wiadomosc (nieaut)",gracz.." > "..tresc)
		return "Wiadomość wysłana pomyślnie!"
	end
end

function gracze_pobierz()
	if prawa(user,"function.gracze") then
		gracze={}
		for i,v in ipairs(getElementsByType("player")) do
			table.insert(gracze,getPlayerName(v))
		end
		return gracze
	else
		system_nieautoryzowane(user,hostname,"gracze > pobierz (nieaut)","")
		return {}
	end
end