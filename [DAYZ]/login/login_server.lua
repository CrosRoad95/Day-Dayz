_root=getResourceRootElement(getThisResource())
betaTesty=true
kontaBetaTesty={
--["Beta-Tester_14"]=true,
--["Beta-Tester_15"]=true,
}
function zaloguj(login,haslo)
	if betaTesty then
		if not kontaBetaTesty[login] then
			--return outputChatBox("To konto nie jest zapisane do beta testów!",client,255,0,0)
		end
	end
	q=exports.db:pobierzTabeleWynikow("select haslo from Konta where login=? limit 1",login)
	if #q==0 then
		return outputChatBox("[BŁĄD]#FF9900 Takie konto nie istnieje",client,255,255,255,true)
	end
	haslo_=haslo
	if q[1]["haslo"]==md5(sha256(md5(haslo))) then
		haslo_="*POPRAWNE*"
		outputChatBox("[SUKCES]#FF9900 Hasło poprawne!",client,255,255,255,true)
		fadeCamera(client,false)
		triggerClientEvent(client,"onPlayerDoneLogin",client)
		setTimer(function(client,login)
			triggerEvent("gracz_zaloguj",getRootElement(),client,login)
			fadeCamera(client,true)
		end,1250,1,client,login)
	else
		outputChatBox("[BŁĄD]#FF9900 Błędne hasło!",client,255,255,255,true)
	end
	exports.db:zapytanie("insert into Logi_logowanie values(NULL,now(),?,?,?)",login,haslo_,getPlayerSerial(client))
end
addEvent("wyslij_zaloguj",true)
addEventHandler("wyslij_zaloguj",_root,zaloguj)

function zarejestruj(login,haslo)
	q=exports.db:pobierzTabeleWynikow("select login from Konta where login=? limit 1",login)
	if #q>0 then
		return outputChatBox("[BŁĄD]#FF9900 Taki login jest już zajęty!",client,255,255,255,true)
	end
	q=exports.db:pobierzTabeleWynikow("select count(serial_rejestracji) as serial,count(ip_rejestracji) as ip from Konta where serial_rejestracji=? AND ip_rejestracji=? limit 3",serial,ip)
	serial=getPlayerSerial(client)
	ip=getPlayerIP(client)
	if q[1]["serial"]>=3 or q[1]["ip"]>=3 then
		return outputChatBox("[BŁĄD]#FF9900 Posiadasz abyt dużo kont! Jeśli masz problem, zgłoś się na forum: www.niceshot.eu",client,255,255,255,true)
	end
	rand = math.random(1,4)
	if rand == 1 then
		x,y,z=2907,math.random(-2644, 3009),1000
	elseif rand == 2 then
		x,y,z=math.random(-2964, 2940), 3009, 1000
	elseif rand == 3 then
		x,y,z=-2964,math.random(-2948, 2939), 1000
	elseif rand == 4 then
		x,y,z=math.random(-2920, 94), -2948, 1000
	end
	sql="insert into Konta values(null,?,?,?,?,?,?,NOW(),0,0,0,0,0,0,0,0,0,0,12000,100,0,0,0,100,3660,2500,0,0,?,?,?,0,0,0,0,0,0,73,1,'','','','[[]]',8,'[[]]','',0,0,'[[]]')"
	exports.db:zapytanie(sql,login,md5(sha256(md5(haslo))),serial,serial,ip,ip,x,y,z)
	outputChatBox("[SUKCES]#FF9900Konto zarejestrowane pomyślnie! Teraz możesz się zalogować",client,255,255,255,true)
end
addEvent("wyslij_zarejestruj", true)
addEventHandler("wyslij_zarejestruj",_root,zarejestruj)

addEventHandler("onPlayerJoin", getRootElement(),
	function()
	fadeCamera(source, true) 
	setCameraMatrix(source,592.48,-1450.22,300,945.17,-1435.38,50)
end)