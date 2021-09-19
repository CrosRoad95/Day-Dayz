function getPlayerInfo(gracz)
	return "Nick: "..getPlayerName(gracz)..", Serial: "..getPlayerSerial(gracz)..", IP:"..getPlayerIP(gracz)..", ID Konta:"..tostring(getElementData(gracz,"UID"))
end

function dodajLogGrupy(kto,grupa,typakcji,opis)
	exports.db:zapytanie("INSERT INTO `Logi_grupy` (`Gracz`, `Data`, `ID_Grupy`, `Typ_Akcji`, `Opis`) VALUES (?,NOW(),?,?,?);",kto,grupa,typakcji,opis)
end

function pobierzOstatnieLogiGrupy(idgrupy,ilosc)
	return exports.db:pobierzTabeleWynikow("SELECT * FROM ( SELECT * FROM Logi_grupy WHERE ID_Grupy=? ORDER BY ID DESC LIMIT ? ) sub ORDER BY ID ASC",idgrupy,ilosc)
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
 
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
 
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
 
    return timestamp
end

function aktualizujGrupeGracza(plr)
	acname=getElementData(plr,"Login_name")
	if not acname then return end
	yes=false
	q = exports.db:pobierzTabeleWynikow([[SELECT * FROM `Grupy_grupy` WHERE `Czlonkowie` LIKE '%]]..acname..[[":%']])
	if #q>0 then
		for i=1,#q do
			graczeX=fromJSON(q[i]["Czlonkowie"])
			if graczeX[acname] and tonumber(graczeX[acname]["ID_POSTACI"])==getElementData(plr,"UID") then
				setElementData(plr,"grupa",{[1]=q[i]["ID"],[2]=q[i]["Nazwa"],[3]=graczeX,[4]=fromJSON(q[i]["Dane"])})
--outputConsole(toJSON({[1]=q[i]["ID"],[2]=q[i]["Nazwa"],[3]=graczeX,[4]=fromJSON(q[i]["Dane"])}))
				yes=true
			end
		end
		if not yes then
			setElementData(plr,"grupa",false)
		end
	else
		setElementData(plr,"grupa",false)
		setElementData(plr,"grupa_sojusze",false)
		return
	end
	grupa=getElementData(plr,"grupa")
	if not grupa then
		setElementData(plr,"grupa_sojusze",false)
	else
		sojusze={}
		sojuszeZatwierdzone={}
		A = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_sojusze` WHERE A=?",grupa[1])
		B = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_sojusze` WHERE B=?",grupa[1])
		for i,v in pairs(A) do
			sojusze[v.B]=true
		end
		for i,v in pairs(B) do
			if sojusze[v.A] then
				sojuszeZatwierdzone[v.A..":"..v.B]=true
				sojuszeZatwierdzone[v.B..":"..v.A]=true
			end
		end
		setElementData(plr,"grupa_sojusze",sojuszeZatwierdzone)
	end
end

listapraw={
{"CHAT"},
{"EDYCJA_INFORMACJI"},
{"DODAJ"},
{"USUN"},
{"ZMIEN_TAG"},
{"SPRAWDZANIE_INFORMACJI_O_GRACZACH"},
{"ZMIANA_PRAW"},
{"SOJUSZE"},
{"LOGI"},
{"OCHRONA"}
}

function stworzGrupe(plr,cmd,nazwagrupy,tag)
	if nazwagrupy and tag and string.len(nazwagrupy)>=4 and string.len(nazwagrupy)<=30 and string.len(tag)>=2 and string.len(tag)<=4 then
		accname=getElementData(plr,"Login_name")
		q = exports.db:pobierzTabeleWynikow([[SELECT * FROM `Grupy_grupy` WHERE `Czlonkowie` LIKE '%"]]..accname..[[":%' LIMIT 1]])
		if #q>0 then
			if tonumber(fromJSON(q[1]["Czlonkowie"])[accname]["ID_POSTACI"])==getElementData(plr,"UID") then
				return outputChatBox("Jesteś już w jakiejś grupie!",plr,255,0,0)
			end
		end
		q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE Nazwa=?",nazwagrupy)
		if #q>0 then
			return outputChatBox("Jest już grupa o takiej nazwie!",plr,255,0,0)
		end

		sql="INSERT INTO `Grupy_grupy` (`Nazwa`,`Czlonkowie`,`Dane`) VALUES (?,?,?);"
		czlonkowie={
			[getElementData(plr,"Login_name")]={
				["RANGA"]="Lider",
				["ID_POSTACI"]=getElementData(plr,"UID"),
				["OSTATNIO_BYL"]=getTimestamp(),
				["DATA_DOLACZENIA"]=exports.db:data(3),
				["IP"]=getPlayerIP(plr),
				["PRAWA"]=string.rep('1',#listapraw)
				}
		}
		dane={
			["TAG"]=tag,
			["OPIS"]="opis,informacje, wpisz tu cokolwiek ;)",
			["DATA_ZALOZENIA"]=exports.db:data(3),
			["ZALOZYCIEL"]=getElementData(plr,"Login_name"),
			["SOJUSZE"]={}
		}
		exports.db:zapytanie(sql,nazwagrupy,toJSON(czlonkowie,true),toJSON(dane,true))
		outputChatBox("Grupa została stworzona! Aby nią zarządzać kliknij F4",plr,0,255,0)
		aktualizujGrupeGracza(plr)
	else
		outputChatBox("Jeżeli chcesz stworzyć grupę wpis komende:",plr,0,255,0)
		outputChatBox("/grupa NAZWA_GRUPY TAG",plr,0,255,0)
		outputChatBox("gdzie dane nazwy oznaczają:",plr,0,255,0)
		outputChatBox("NAZWA_GRUPY - Nazwa grupy od 4 do 30 znaków",plr,0,255,0)
		outputChatBox("TAG - Wyświetlana nazwa grupy podczas pisania na chacie od 2 do 4 znaków",plr,0,255,0)
		outputChatBox("Po stworzeniu grupy dostaniesz możliwość używania panelu pod F4",plr,0,255,0)
	end
end
addCommandHandler("grupa",stworzGrupe)
addCommandHandler("stworzgrupe",stworzGrupe)
addCommandHandler("stworzgang",stworzGrupe)
addCommandHandler("gang",stworzGrupe)
addCommandHandler("group",stworzGrupe)

function aktualizujWszystkimGrupe()
	for i,v in ipairs(getElementsByType("player")) do
		aktualizujGrupeGracza(v)
	end
end
setTimer(aktualizujWszystkimGrupe,30000,0)
function dodajDoGrupy(id,login,idpostaci)
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=?",id)
	if q and #q>0 then
		czlonk=fromJSON(q[1]["Czlonkowie"])
		czlonk[login]={["RANGA"]="Nowy",["OSTATNIO_BYL"]=getTimestamp(),["ID_POSTACI"]=idpostaci,["DATA_DOLACZENIA"]=exports.db:data(3),["PRAWA"]=string.rep('0',#listapraw)}
		exports.db:zapytanie("UPDATE `Grupy_grupy` SET Czlonkowie=? WHERE ID=?",toJSON(czlonk,true),id)
		aktualizujWszystkimGrupe()
	end
end

function zmienopis(id,opis)
	opis=string.gsub(opis,'[^a-zA-Z0-9ążźśęćńół\
 ]',"") -- nie rusz :) CrosRoad95 skype: CrosRoad5
	
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=?",id)
	if q and #q>0 then
		dane=fromJSON(q[1]["Dane"])
		dodajLogGrupy(getPlayerInfo(client),id,2,"Zmiana opisu z: '"..dane["OPIS"].."' na: "..opis)
		dane["OPIS"]=opis
		exports.db:zapytanie("UPDATE `Grupy_grupy` SET Dane=? WHERE ID=?",toJSON(dane,true),id)
		outputChatBox("Opis zmieniony pomyślnie!",client,0,255,0)
		aktualizujWszystkimGrupe()
	end
end
addEvent( "gang:zmienopis", true )
addEventHandler( "gang:zmienopis",resourceRoot,zmienopis)

function odeslijSojusze(kto,id)
	q1 = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_sojusze` WHERE A=?",id)
	q2 = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_sojusze` WHERE B=?",id)	
	triggerClientEvent(client,"grupy:odeslijlistesojuszy",kto,q1,q2)
end
function pobierzlistesojuszy(id)
	odeslijSojusze(client,id)
end
addEvent( "gang:pobierzlistesojuszy", true )
addEventHandler( "gang:pobierzlistesojuszy",resourceRoot,pobierzlistesojuszy)

function zerwijsojusz(grupa,sel)
	if type(sel)=="table" then
		exports.db:zapytanie("DELETE FROM `Grupy_sojusze` WHERE ID=?",sel[1])
		exports.db:zapytanie("DELETE FROM `Grupy_sojusze` WHERE ID=?",sel[2])
	else
		exports.db:zapytanie("DELETE FROM `Grupy_sojusze` WHERE ID=?",sel)
	end
	dodajLogGrupy(getPlayerInfo(client),id,14,"Zerwanie sojuszu z grupą: "..toJSON(sel,true))
	odeslijSojusze(client,grupa[1])
	aktualizujWszystkimGrupe()
	outputChatBox("Sojusz z tą grupą został zerwany!",client,0,255,0)
end
addEvent( "gang:zerwijsojusz", true )
addEventHandler( "gang:zerwijsojusz",resourceRoot,zerwijsojusz)

function dodajsojusz(id,grupazktorachcesojusz)
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=?",grupazktorachcesojusz)
	if #q>0 then
		qq = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_sojusze` WHERE A=? AND B=?",id[1],grupazktorachcesojusz)
		if #qq>0 then
			return outputChatBox("Już dodałeś tą grupe do sojuszy!",client,255,0,0)
		end
		exports.db:zapytanie("INSERT INTO Grupy_sojusze SET A=?,B=?,NazwaA=?,NazwaB=?",id[1],grupazktorachcesojusz,id[2],q[1]["Nazwa"])
		outputChatBox("Wysłano/Zaakceptowano prośbę o sojusz!",client,0,255,0)
		dodajLogGrupy(getPlayerInfo(client),id,13,"Zawarcie sojuszu z: "..tostring(grupazktorachcesojusz))
	else
		outputChatBox("Nie ma takiej grupy!",client,255,0,0)
		return
	end
	odeslijSojusze(client,id[1])
	aktualizujWszystkimGrupe()
end
addEvent( "gang:dodajsojusz", true )
addEventHandler( "gang:dodajsojusz",resourceRoot,dodajsojusz)

function aktualizujprawa(id,noweprawa,ranga)
	ranga=string.gsub(ranga,'[^a-zA-Z0-9ążźśęćńół ]',"")
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=?",id)
	edytowanaosoba=getElementData(client,"grupa:edytowanaosoba")
	if q and #q>0 and edytowanaosoba then
		czlnk=fromJSON(q[1]["Czlonkowie"])
		dodajLogGrupy(getPlayerInfo(client),id,7,"Zmiana praw: "..edytowanaosoba.." z: "..czlnk[edytowanaosoba]["PRAWA"].." na: "..noweprawa..", rangi z: '"..czlnk[edytowanaosoba]["RANGA"].."' na: '"..ranga.."'")
		czlnk[edytowanaosoba]["PRAWA"]=noweprawa
		czlnk[edytowanaosoba]["RANGA"]=ranga
		
		exports.db:zapytanie("UPDATE `Grupy_grupy` SET Czlonkowie=? WHERE ID=?",toJSON(czlnk,true),id)
		outputChatBox("Prawa zmienione pomyślnie!",client,0,255,0)
		aktualizujWszystkimGrupe()
	end
end
addEvent( "gang:aktualizujprawa", true )
addEventHandler( "gang:aktualizujprawa",resourceRoot,aktualizujprawa)

function dolacz(plr,cmd,id,...)
	if getElementData(plr,"grupa") then
		return outputChatBox("Już należysz do jakiejś grupy!",plr,255,0,0)
	end
	txt=table.concat({...}," ") or "-"
	if txt=="" then
		outputChatBox("Aby uatrakcyjnić twoją prośbe o dodanie napisz po id, dlaczego chcesz dołączyć",plr,0,255,0)
		outputChatBox("np.: /dolacz "..id.." jestem dobrym sniperem",plr,0,255,0)
		
	end
	if id and tonumber(id) then
		setElementData(plr,"chcedolaczyc",tonumber(id))
		setElementData(plr,"powoddolaczenia",txt)
		outputChatBox("Zostałeś dodany do listy osób które chcą dołączyć do gangu o id: "..id.." poczekaj aż upoważniona osoba cię doda!",plr,0,255,0)
	else
		if getElementData(plr,"chcedolaczyc") then
			outputChatBox("Prośba o przyjęcie usunięta!",plr,0,255,0)
			setElementData(plr,"chcedolaczyc",false)
			setElementData(plr,"powoddolaczenia",false)
			return
		end
		outputChatBox("Błąd, podaj id gangu do którego chcesz dołączyć od 1-99999",plr,255,0,0)
	end
end
addCommandHandler("dolacz",dolacz)

for i,v in ipairs(getElementsByType("player")) do
	aktualizujGrupeGracza(v)
	setElementData(v,"accname",getElementData(v,"Login_name"))
end

function aktualizujGracza(plr)
	aktualizujGrupeGracza(plr)
end

function aktualizujmnie()
	aktualizujGrupeGracza(client)
end
addEvent( "gang:aktualizujmnie", true )
addEventHandler( "gang:aktualizujmnie",resourceRoot,aktualizujmnie)

function zaproponujdolaczenie(kto)
	outputChatBox(getPlayerName(client).." chce zaprosić cię do swojej grupy "..getElementData(client,"grupa")[2]..", wpisz komende /dolacz "..getElementData(client,"grupa")[1],kto,0,255,0)
end
addEvent( "gang:zaproponujdolaczenie", true )
addEventHandler( "gang:zaproponujdolaczenie",resourceRoot,zaproponujdolaczenie)

function historiaaktywnosci(id)
	triggerClientEvent(client,"grupy:logi",client,pobierzOstatnieLogiGrupy(id,1000),exports.db:data(3))
end
addEvent( "gang:historiaaktywnosci", true )
addEventHandler( "gang:historiaaktywnosci",resourceRoot,historiaaktywnosci)

function wyrzuczgrupy(id,sel)
	if sel==getElementData(client,"Login_name") then
		return outputChatBox("Nie możesz samego siebie usunąć!",client,255,0,0)
	end
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=? LIMIT 1",id)
	if q and #q>0 then
		czlnk=fromJSON(q[1]["Czlonkowie"])
		czlnk[sel]=nil
		exports.db:zapytanie("UPDATE `Grupy_grupy` SET Czlonkowie=? WHERE ID=?",toJSON(czlnk,true),id)
		dodajLogGrupy(getPlayerInfo(client),id,4,"Wyrzucenie "..sel.." z grupy")
		outputChatBox(sel.." został pomyślnie usunięty z grupy!",client,0,255,0)
		aktualizujWszystkimGrupe()
		for i,v in ipairs(getElementsByType("player")) do
			if czlnk[getElementData(v,"Login_name")] then
				triggerClientEvent(client,"grupy:aktualizuj",client)
			end
		end
	end
end
addEvent( "gang:wyrzuczgrupy", true )
addEventHandler( "gang:wyrzuczgrupy",resourceRoot,wyrzuczgrupy)

function oposcgrupe(id)
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=? LIMIT 1",id)
	if q and #q>0 then
		czlnk=fromJSON(q[1]["Czlonkowie"])
		dane=fromJSON(q[1]["Dane"])
		ja = getElementData(client,"Login_name")
		if dane["ZALOZYCIEL"]==ja then
			return outputChatBox("Nie możesz odejść z grupy której jesteś liderem!",client,255,0,0)
		end
		czlnk[ja]=nil
		exports.db:zapytanie("UPDATE `Grupy_grupy` SET Czlonkowie=? WHERE ID=?",toJSON(czlnk,true),id)
		dodajLogGrupy(getPlayerInfo(client),id,12,"Opuszczenie grupy")
		outputChatBox("Odszedłeś z grupy: "..q[1]["Nazwa"],client,0,255,0)
		aktualizujWszystkimGrupe()
		triggerClientEvent(client,"grupy:wylacz",client)
		for i,v in ipairs(getElementsByType("player")) do
			if czlnk[getElementData(v,"Login_name")] then
				triggerClientEvent(client,"grupy:aktualizuj",client)
			end
		end
	end
end
addEvent( "gang:oposcgrupe", true )
addEventHandler( "gang:oposcgrupe",resourceRoot,oposcgrupe)

function usungrupe(id)
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `Grupy_grupy` WHERE ID=? LIMIT 1",id)
	if q and #q>0 then
		czlnk=fromJSON(q[1]["Czlonkowie"])
		dane=fromJSON(q[1]["Dane"])
		ja = getElementData(client,"Login_name")
		if dane["ZALOZYCIEL"]~=ja then
			return outputChatBox("Tylko lider może usunąć grupe!",client,255,0,0)
		end
		exports.db:zapytanie("DELETE FROM `Grupy_grupy` WHERE ID=?",id)
		dodajLogGrupy(getPlayerInfo(client),id,11,"Usunięcie grupy")
		outputChatBox("Grupa została usunięta!",client,0,255,0)
		aktualizujWszystkimGrupe()
		triggerClientEvent(client,"grupy:wylacz",client)
		for i,v in ipairs(getElementsByType("player")) do
			if czlnk[getElementData(v,"Login_name")] then
				triggerClientEvent(client,"grupy:wylacz",client)
				setElementData(client,"grupa",false)
			end
		end
	end
end
addEvent( "gang:usungrupe", true )
addEventHandler( "gang:usungrupe",resourceRoot,usungrupe)

function sprawdzgracza(login)
	outputChatBox("Opcja stalkowania graczy jeszcze nie jest dostępna :)",client,0,255,0)
--[[
	q = exports.db:pobierzTabeleWynikow("SELECT * FROM `DAYZ_Accounts` WHERE login=?",login)
	if q and #q>0 then
		qq = exports.db:pobierzTabeleWynikow("SELECT * FROM `DAYZ_Characters` WHERE owner=?",q[1]["ID"])
		outputChatBox("Informacje o "..login,client,0,255,0)
		outputChatBox("Ilość postaci: "..#qq,client,0,255,0)
		outputChatBox("Postać stworzona: "..#qq,client,0,255,0)
	end]]
end
addEvent( "gang:sprawdzgracza", true )
addEventHandler( "gang:sprawdzgracza",resourceRoot,sprawdzgracza)

function dodajnowaosowe(login,id)
	plr=getPlayerFromName(login)
	if not plr then return end
	dodajDoGrupy(getElementData(plr,"chcedolaczyc"),getElementData(plr,"Login_name"),getElementData(plr,"UID"))
	outputChatBox(login.." został pomyślnie dodany do twojej grupy!",client,0,255,0)
	
	dodajLogGrupy(getPlayerInfo(client),id,3,"Dodanie "..getElementData(plr,"Login_name")..", chciał być dodany ponieważ: "..getElementData(plr,"powoddolaczenia"))
	setElementData(plr,"chcedolaczyc",false)
	setElementData(plr,"powoddolaczenia",false)
end
addEvent( "gang:dodajnowaosowe", true )
addEventHandler( "gang:dodajnowaosowe",resourceRoot,dodajnowaosowe)

function aktualizujDaneGracza(acc,ip)
	q = exports.db:pobierzTabeleWynikow([[SELECT * FROM `Grupy_grupy` WHERE `Czlonkowie` LIKE '%"]]..acc..[[":%' LIMIT 1]])
	if q and #q>0 then
		czlnk=fromJSON(q[1]["Czlonkowie"])
		czlnk[acc]["OSTATNIO_BYL"]=getTimestamp()	
		czlnk[acc]["IP"]=ip,
		exports.db:zapytanie("UPDATE `Grupy_grupy` SET Czlonkowie=? WHERE ID=?",toJSON(czlnk,true),q[1]["ID"])
		aktualizujWszystkimGrupe()
	end
end