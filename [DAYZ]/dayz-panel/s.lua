function aktualizuj()
	q=exports.db:pobierzTabeleWynikow("select * from Changelog ORDER BY data DESC")
	setElementData(resourceRoot,"$Changelog$",q)
	q=exports.db:pobierzTabeleWynikow("select * from Pojazdy ORDER BY ID DESC")
	setElementData(resourceRoot,"$Pojazdy$",q)
	q=exports.db:pobierzTabeleWynikow("select Kategoria,SubKategoria from Przedmioty group by Kategoria,Subkategoria")
	setElementData(resourceRoot,"$EkwipunekKategorieSubKategorie$",q)
	
end
aktualizuj()
addEvent("aktualizuj_panel",true)
addEventHandler("aktualizuj_panel",resourceRoot,aktualizuj)

wyswietl=100
function pobierzranking(typ)
	if typ=="morderstwa" then
		q=exports.db:pobierzTabeleWynikow("SELECT ID,morderstwa_wsumie as m,login as l FROM Konta ORDER BY morderstwa_wsumie DESC limit ?",wyswietl)
	elseif typ=="czasgry" then
		q=exports.db:pobierzTabeleWynikow("SELECT ID,czasgry_wsumie as m,login as l FROM Konta ORDER BY czasgry_wsumie DESC limit ?",wyswietl)
	elseif typ=="zabitezombie" then
		q=exports.db:pobierzTabeleWynikow("SELECT ID,zabitezombie_wsumie as m,login as l FROM Konta ORDER BY zabitezombie_wsumie DESC limit ?",wyswietl)
	elseif typ=="najbogatsi" then
		q=exports.db:pobierzTabeleWynikow("SELECT ID,gp as m,login as l FROM Konta ORDER BY gp DESC limit ?",wyswietl)
	elseif typ=="najlepszy" then
		q=exports.db:pobierzTabeleWynikow("SELECT ID,floor(sqrt(morderstwa_wsumie*(zabitezombie_wsumie*60+czasgry_wsumie))) as m,login as l FROM Konta ORDER BY m DESC limit ?",wyswietl)
	end
	triggerClientEvent(client,"odeslij_ranking",client,typ,q)
	--q=exports.db:pobierzTabeleWynikow("select * from Changelog ORDER BY data DESC")
end
addEvent("aktualizuj_panel_pobierzranking",true)
addEventHandler("aktualizuj_panel_pobierzranking",resourceRoot,pobierzranking)



kody = {
	["2zł (2,46zł z VAT)"]={1896,7255},
	["4zł (4.92zł z VAT)"]={1967,7455},
	["6zł (7.38zł z VAT)"]={1965,7636},
	["11zł (12,30zł z VAT)"]={1508,91055},
	["19zł (23.37zł z VAT)"]={1966,91955},
	["25zł (30,75zł z VAT)"]={1509,92555},
};

function sprawdzSms(oferta,kod)
	uid=getElementData(client,"UID")
	exports.db:zapytanie("insert into Logi_sklep_sms values(NULL,now(),?,?,?,?,?,0)",getPlayerSerial(client),uid,oferta,kod,"próba")
	wybrane=kody[oferta]
	if wybrane then
		local query=string.format("http://microsms.pl/api/check.php?userid=1156&number=%s&code=%s&serviceid=%s",wybrane[2],kod,wybrane[1])
		fetchRemote(query,result,"",false,client,amount,oferta,uid,kod)
	end
end
addEvent("SprawdzKodSMS",true)
addEventHandler("SprawdzKodSMS",resourceRoot,sprawdzSms)

kwotaPP={
[2]=2,
[4]=5,
[6]=15,
[11]=30,
[19]=55,
[25]=100
}
function sms(gracz,kwota,oferta,uid,kod)
	otrzymaPP=kwotaPP[kwota]
	outputChatBox("Otrzymałeś "..otrzymaPP.." punktów premium!",gracz,0,255,0)
	exports.db:zapytanie("insert into Logi_sklep_sms values(NULL,now(),?,?,?,?,?,?)",getPlayerSerial(gracz),uid,oferta,kod,"sukces",otrzymaPP)
	exports.db:zapytanie("update Konta set pp=pp+? where ID=?",otrzymaPP,getElementData(gracz,"UID"))
end

function result(responseData, errno, player,amount,oferta,uid,kod)
	if errno==0 then
		if string.find(responseData,"1896") then
			return sms(player,2,oferta,uid,kod)
		elseif string.find(responseData,"1967") then
			return sms(player,4,oferta,uid,kod)
		elseif string.find(responseData,"1965") then
			return sms(player,6,oferta,uid,kod)
		elseif string.find(responseData,"1508") then
			return sms(player,11,oferta,uid,kod)
		elseif string.find(responseData,"1966") then
			return sms(player,19,oferta,uid,kod)
		elseif string.find(responseData,"1509") then
			return sms(player,25,oferta,uid,kod)
		end
		outputChatBox("Błędny kod",player,255,0,0)
	end
end