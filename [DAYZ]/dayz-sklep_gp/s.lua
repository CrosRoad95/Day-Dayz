function pobierzGP(gracz)
	idgracza=getElementData(gracz,"UID")
	q=exports.db:pobierzTabeleWynikow("select gp from Konta where ID=? limit 1",idgracza)
	if #q==0 then return end
	setElementData(gracz,"GP",q[1].gp)
	return q[1].gp
end
function pokaz(el)
	if getElementType(el)=="player" then
		q=exports.db:pobierzTabeleWynikow("select * from Sklep_gp")
		triggerClientEvent(el,"sklep_gp_pokaz",el,q)
	end
end

function bindTheKeys(plr)
	if plr and type(plr)=="userdata" then
		source=plr
	end
  bindKey(source, "f7", "down",pokaz)
end
for i,v in ipairs(getElementsByType("player")) do
	bindTheKeys(v)
end
addEventHandler("onPlayerSpawn",getRootElement(),bindTheKeys)

function kup_przedmiot(id)
	q=exports.db:pobierzTabeleWynikow("select * from Sklep_gp")
	for i,v in ipairs(q) do
		if v.ID==id then
			aktualnegp=pobierzGP(client)
			if aktualnegp>=v.koszt then
				idgracza=getElementData(client,"UID")
				takePlayerMoney(client,v.koszt)
				exports.db:zapytanie("update Konta set gp=gp-? where ID=? limit 1",v.koszt,idgracza)
				aktualnegp=pobierzGP(client)
				pokaz(client,false,true)
				item=getElementData(client,v.data)
				if item then
					setElementData(client,v.data,item+v.powieksz)
				else
					setElementData(client,v.data,v.powieksz)
				end
				outputChatBox("Pomyślnie kupiłeś "..v.nazwa.." za "..v.koszt.."gp. Aktualnie posiadasz "..aktualnegp.."gp",client,0,255,0)
				q=exports.db:pobierzTabeleWynikow("select * from Sklep_gp")
				triggerClientEvent(client,"sklep_gp_pokaz",client,q)
				exports.db:zapytanie("insert into Logi_sklep_gp values(NULL,NOW(),?,?,?,?)",idgracza,v.nazwa,v.koszt,pobierzGP(client))
				break
			end
		end
	end
end
addEvent("kup_przedmiot",true)
addEventHandler("kup_przedmiot",resourceRoot,kup_przedmiot)