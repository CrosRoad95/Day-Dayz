function pobierzPP(gracz)
	idgracza=getElementData(gracz,"UID")
	q=exports.db:pobierzTabeleWynikow("select pp from Konta where ID=? limit 1",idgracza)
	if #q==0 then return end
	return q[1].pp
end
function pokaz(el)
	if getElementType(el)=="player" then
		q=exports.db:pobierzTabeleWynikow("select * from Sklep_pp")
		triggerClientEvent(el,"sklep_pp_pokaz",el,q,pobierzPP(el))
	end
end

function bindTheKeys(plr)
	if plr and type(plr)=="userdata" then
		source=plr
	end
  bindKey(source, "f6", "down",pokaz)
end
for i,v in ipairs(getElementsByType("player")) do
	bindTheKeys(v)
end
addEventHandler("onPlayerSpawn",getRootElement(),bindTheKeys)

function kup_przedmiot(id)
	q=exports.db:pobierzTabeleWynikow("select * from Sklep_pp")
	for i,v in ipairs(q) do
		if v.ID==id then
			if pobierzPP(client)>=v.koszt then
				idgracza=getElementData(client,"UID")
				q=exports.db:zapytanie("update Konta set pp=pp-? where ID=? limit 1",v.koszt,idgracza)
				pokaz(client,false,true)
				item=getElementData(client,v.data)
				if item then
					setElementData(client,v.data,item+v.powieksz)
				else
					setElementData(client,v.data,v.powieksz)
				end
				outputChatBox("Pomyślnie kupiłeś "..v.nazwa.." za "..v.koszt,client,0,255,0)
				exports.db:zapytanie("insert into Logi_sklep_pp values(NULL,NOW(),?,?,?,?)",idgracza,v.nazwa,v.koszt,pobierzPP(client))
				break
			end
		end
	end
end
addEvent("kup_przedmiot",true)
addEventHandler("kup_przedmiot",resourceRoot,kup_przedmiot)