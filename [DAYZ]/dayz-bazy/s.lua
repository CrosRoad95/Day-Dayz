function start()
	objekty=exports.db:pobierzTabeleWynikow("select * from Bazy_objekty order by ID asc")
	objekty_hp={}
	for i,v in ipairs(objekty) do
		objekty_hp[v.model]={v.wytrzymalosc,v.przedmiot_naprawczy}
	end
	setElementData(getRootElement(),"Bazy_objekty",objekty)
end
start()

objektybazy={}

function dodajLogBaz(plr,co)
	kto=getPlayerName(plr)..", "..getPlayerSerial(plr)..", "..getElementData(plr,"UID")
	exports.db:zapytanie("INSERT INTO Logi_bazy (`Data`, `Kto`, `Co`) VALUES (NOW(),?,?);",kto,co)
end

function pobierzPP(gracz)
	idgracza=getElementData(gracz,"UID")
	q=exports.db:pobierzTabeleWynikow("select pp from Konta where ID=? limit 1",idgracza)
	if #q==0 then return end
	return q[1].pp
end
function dodajPP(gracz,ilosc)
	idgracza=getElementData(gracz,"UID")
	q=exports.db:pobierzTabeleWynikow("update Konta set pp=pp+? where ID=? limit 1",ilosc,idgracza)
end
function pobierzGP(gracz)
	return getPlayerMoney(gracz)
end

domyslnePRawa = {
{["IDPos"]=0,["Nick"]="",["MozeBudowac"]=true,["Wlasciciel"]=true,["MozeOtwierac"]=true}
}

function dodajMiejscePodBudowe(x,y,z,s,dostep,nazwa,limit,id,data,przedluzenie,dodaj,darmowa)
	el = createElement("bazy")
	col=createColSphere(x,y,z,s)
	setElementPosition(el,x,y,z)
	setElementData(el,"ColBazy",{col,s})
	setElementData(el,"Nazwa",nazwa)
	setElementData(el,"Dostep",dostep)
	setElementData(el,"Limit",limit)
	setElementData(el,"ID",id)
	setElementData(el,"darmowa",darmowa)
	setElementData(el,"data",data)
	setElementData(el,"kosztprzedluzenia",przedluzenie)
	if dodaj then
		exports.db:zapytanie("INSERT INTO Bazy (ID,x,y,z,promien,limitobjektow,nazwa,prawadostepu,aktywnado,kosztprzedluzenia) values (?,?,?,?,?,?,?,?,?,?)",id,x,y,z,s,limit,nazwa,toJSON(dostep,true),data,przedluzenie)
	end
end

function usunBazy()
	for i,v in pairs(p or {}) do
		if v and isElement(v) then
			destroyElement(v)
		end
	end
	for i,v in ipairs(getElementsByType("bazy")) do
		col=getElementData(v,"ColBazy")
		if col then
			destroyElement(col[1])
		end
		destroyElement(v)
	end
	for i,v in ipairs(objektybazy) do
		destroyElement(v)
	end
	objektybazy={}
	p={}
end

function zaladujBazy()
	usunBazy()
	l=exports.db:pobierzTabeleWynikow("SELECT *,IF(aktywnado>now(),1,0) as aktywne,IF(aktywnado+interval 7 day>now(),1,0) as usunac,aktywnado+interval 7 day as dousuniecia FROM `Bazy`")
	p={}
	for i,v in pairs(l) do
		if v.usunac==1 then
			if v.aktywne==1 then
				p[i]=createPickup(v.x,v.y,v.z,3,1272,10)
				setElementData(p[i],"opis","Baza "..v.nazwa.." jest aktywna jeszcze do "..v.aktywnado)
				dodajMiejscePodBudowe(v.x, v.y, v.z, v.promien,fromJSON(v.prawadostepu),v.nazwa,v.limitobjektow,v.ID,v.aktywnado,v.kosztprzedluzenia,false,v.darmowa)
			else
				p[i]=createPickup(v.x,v.y,v.z,3,1318,10)
				setElementData(p[i],"opis","Baza "..v.nazwa.." jest nieopłacona. Dnia "..v.dousuniecia.." zostanie bezpowrotnie usunięta!")
				dodajMiejscePodBudowe(v.x, v.y, v.z, v.promien,fromJSON(v.prawadostepu),v.nazwa,v.limitobjektow,v.ID,v.aktywnado,v.kosztprzedluzenia,false,v.darmowa)
			end
		else
			l2=exports.db:pobierzTabeleWynikow("SELECT * FROM `Bazy_zapis`")
			print("A")
			for i,vv in pairs(l2) do
				if getDistanceBetweenPoints3D (vv.x,vv.y,vv.z,v.x, v.y, v.z)<v.promien then
					exports.db:zapytanie("delete from Bazy_zapis where ID=? limit 1",vv.ID)
				end
			end
		end
	end
	l=exports.db:pobierzTabeleWynikow("SELECT * FROM `Bazy_zapis`")
	for i,v in pairs(l) do
		obj=createObject(v.Model,v.x,v.y,v.z,v.rx,v.ry,v.rz)
		setElementDoubleSided(obj,true)
		setElementData(obj,"OBJEKT_BAZY",true)
		setElementData(obj,"Extra",fromJSON(v.extra))
		setElementData(obj,"hp",{objekty_hp[v.Model][1],objekty_hp[v.Model][1]})
		setElementData(obj,"hp_naprawa",objekty_hp[v.Model][2])
		table.insert(objektybazy,obj)
	end
end
zaladujBazy()

function zapisz(resource)
	if resource==getThisResource() then
		exports.db:zapytanie("truncate Bazy_zapis")
		for i,v in ipairs(objektybazy) do
			if v and isElement(v) then
				model=getElementModel(v)
				x,y,z = getElementPosition(v)
				rx,ry,rz = getElementRotation(v)
				exports.db:zapytanie("Insert into Bazy_zapis (`Model`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`extra`) values (?,?,?,?,?,?,?,?)",model,x,y,z,rx,ry,rz,toJSON(getElementData(v,"Extra") or {}))
			end
		end
	end
end 
addEventHandler( "onResourceStop",resourceRoot,zapisz)

function postawobjekt(model,x,y,z,rx,ry,rz)
	obj=createObject(model,x,y,z,rx,ry,rz)
	setElementDoubleSided(obj,true)
	setElementData(obj,"OBJEKT_BAZY",true)
	setElementData(obj,"hp",{objekty_hp[model][1],objekty_hp[model][1]})
	setElementData(obj,"hp_naprawa",objekty_hp[model][2])
	table.insert(objektybazy,obj)
	dodajLogBaz(client,"Postawienie objektu: {"..model..","..x..","..y..","..z..","..rx..","..ry..","..rz.."}")
end
addEvent("bazy:postawobjekt",true)
addEventHandler("bazy:postawobjekt",resourceRoot,postawobjekt)

function otworzbrame(objekt)
	if getElementModel(objekt)==1855 then
		outputChatBox("Brama zostanie otwarta za 1.5sekundy!",client,0,255,0)
		x,y,z=getElementPosition(objekt)
		rx,ry,rz=getElementRotation(objekt)
		setTimer(moveObject,1500,1,objekt,2000,x,y,z+6,0,0,0)
		setTimer(setElementCollisionsEnabled,1500,1,objekt,false)
		setTimer(moveObject,7000,1,objekt,2000,x,y,z,0,0,0)
		setTimer(setElementCollisionsEnabled,7000,1,objekt,true)
		dodajLogBaz(client,"Otwarcie bramy: {1855,"..x..","..y..","..z..","..rx..","..ry..","..rz.."}")
	elseif getElementModel(objekt)==1854 then
		x,y,z=getElementPosition(objekt)
		rx,ry,rz=getElementRotation(objekt)
		moveObject(objekt,500,x,y,z+3,0,0,0)
		setElementCollisionsEnabled(objekt,false)
		setTimer(moveObject,2300,1,objekt,500,x,y,z,0,0,0)
		setTimer(setElementCollisionsEnabled,2000,1,objekt,true)
		dodajLogBaz(client,"Otwarcie bramy: {1854,"..x..","..y..","..z..","..rx..","..ry..","..rz.."}")
	end
	--[[elseif getElementModel(objekt)==16773 then
		outputChatBox("Brama zostanie otwarta za 2.5sekundy!",client,0,255,0)
		x,y,z=getElementPosition(objekt)
		rx,ry,rz=getElementRotation(objekt)
		setTimer(moveObject,2500,1,objekt,1500,x,y,z+8,0,0,0)
		setTimer(setElementCollisionsEnabled,2500,1,objekt,false)
		setTimer(moveObject,15000,1,objekt,1500,x,y,z,0,00,0)
		setTimer(setElementCollisionsEnabled,9000,1,objekt,true)
		dodajLogBaz(client,"Otwarcie bramy: {16773,"..x..","..y..","..z..","..rx..","..ry..","..rz.."}")
	end]]
end
addEvent("bazy:otworzbrame",true)
addEventHandler("bazy:otworzbrame",resourceRoot,otworzbrame)

function ustawhaslo(object,haslo)
	data=getElementData(object,"Extra")
	if not data then data={} end
	x,y,z=getElementPosition(object)
	rx,ry,rz=getElementRotation(object)
	dodajLogBaz(client,"Zmiana hasła na "..haslo.." {"..x..","..y..","..z..","..rx..","..ry..","..rz.."}")
	data["Haslo"]=haslo
	setElementData(object,"Extra",data)
	outputChatBox("Hasło do drzwi/bramy zostało zmienione!",client,0,255,0)
end
addEvent("bazy:ustawhaslo",true)
addEventHandler("bazy:ustawhaslo",resourceRoot,ustawhaslo)

function zniszczobjekt(object,idprzedmiotu)
	for i,v in ipairs(objektybazy) do
		if v==object then
			if idprzedmiotu then
				x,y,z=getElementPosition(client)
				--[[l=exports.db:pobierzTabeleWynikow("SELECT * FROM `DAYZ_Items` WHERE ID=?",idprzedmiotu)
				item=fromJSON(l[1]["Item"])
				item["unique_key"]=getPlayerName(client).."byZnisczenieBazy"..math.random(1,999999)
				exports.dayz_worlditems:stworzDropItem(item,x,y,z-.8,1,client)]]
			end
			table.remove(objektybazy,i)
			x,y,z=getElementPosition(object)
			rx,ry,rz=getElementRotation(object)
			dodajLogBaz(client,"Zniszczenie objektu: {"..getElementModel(object)..","..x..","..y..","..z..","..rx..","..ry..","..rz.."}")
			destroyElement(object)
			return outputChatBox("Objekt został pomyślnie zniszczony!",client,0,255,0)
		end
	end
	outputChatBox("Błąd podczas niszczenia objektu!",client,255,0,0)
end
addEvent("bazy:zniszczobjekt",true)
addEventHandler("bazy:zniszczobjekt",resourceRoot,zniszczobjekt)

function dodajdobazy(baza,nick,postac,objectbazy)
	l=exports.db:pobierzTabeleWynikow("SELECT * FROM `Bazy` where ID=?",baza)
	v=fromJSON(l[1]["prawadostepu"])
	table.insert(v,{["IDPos"]=postac,["Nick"]=nick,["MozeBudowac"]=false,["Wlasciciel"]=false,["MozeOtwierac"]=false})
	exports.db:zapytanie("UPDATE Bazy set prawadostepu=? where ID=?",toJSON(v),baza)
	setElementData(objectbazy,"Dostep",v)
	outputChatBox(nick.." został poprawnie dodany do twojej bazy!",client,0,255,0)
	triggerClientEvent(client,"bazy:aktualizuj",client)
	dodajLogBaz(client,"Dodanie do bazy "..baza.." gracza: "..nick)
end
addEvent("bazy:dodajdobazy",true)
addEventHandler("bazy:dodajdobazy",resourceRoot,dodajdobazy)

function usunzbazy(baza,nick,postac,objectbazy)
	l=exports.db:pobierzTabeleWynikow("SELECT * FROM `Bazy` where ID=?",baza)
	val=fromJSON(l[1]["prawadostepu"])
	tabela={}
	for i,v in pairs(val) do
		if v["IDPos"]~=postac then
			table.insert(tabela,v)
		end
	end
	exports.db:zapytanie("UPDATE Bazy set prawadostepu=? where ID=?",toJSON(tabela),baza)
	setElementData(objectbazy,"Dostep",tabela)
	outputChatBox(nick.." został poprawnie usunięty z twojej bazy!",client,0,255,0)
	triggerClientEvent(client,"bazy:aktualizuj",client)
	dodajLogBaz(client,"Usunięcie z bazy "..baza.." gracza: "..nick)
end
addEvent("bazy:usunzbazy",true)
addEventHandler("bazy:usunzbazy",resourceRoot,usunzbazy)

function zmienprawa(baza,nick,postac,objectbazy,mozebudowac,mozeotwierac)
	l=exports.db:pobierzTabeleWynikow("SELECT * FROM `Bazy` where ID=?",baza)
	if #l>0 then
		val=fromJSON(l[1]["prawadostepu"])
		tabela={}
		for i,v in pairs(val) do
			tabela[i]=v
			if v["IDPos"]==postac then
				tabela[i]["MozeBudowac"]=mozebudowac
				tabela[i]["MozeOtwierac"]=mozeotwierac
			end
		end
		exports.db:zapytanie("UPDATE Bazy set prawadostepu=? where ID=?",toJSON(tabela),baza)
		setElementData(objectbazy,"Dostep",tabela)
		outputChatBox(nick.." prawa zostały zmienione!",client,0,255,0)
		triggerClientEvent(client,"bazy:aktualizuj",client)
		dodajLogBaz(client,"Zmiana praw bazy "..baza..", gracza: "..nick.." na Budowa:"..tostring(mozebudowac)..", Otwieranie:"..tostring(mozeotwierac))
	end
end
addEvent("bazy:zmienprawa",true)
addEventHandler("bazy:zmienprawa",resourceRoot,zmienprawa)

function przedluzBaze(id,iledni)
	exports.db:zapytanie("UPDATE Bazy set aktywnado=aktywnado+interval ? day where ID=?",iledni,id)
	czas=exports.db:pobierzTabeleWynikow("SELECT aktywnado FROM `Bazy` where ID=?",id)[1]["aktywnado"]
	return czas
end

function przedluz(id,elbazy,iloscdni,koszt,ppczymon)
	spec=getElementData(client,"SpecjalnaWaluta")
	if ppczymon then -- pp
		if spec[2]>=koszt then
			spec[2]=spec[2]-koszt
			czas=przedluzBaze(id,iloscdni)
			if czas and setElementData(client,"SpecjalnaWaluta",spec) and setElementData(elbazy,"data",czas) then
				triggerClientEvent(client,"bazy:aktualizuj",client)
				outputChatBox("Przedłużono pomyślnie!",client,0,255,0)
				dodajLogBaz(client,"przedłużenie id: "..id.." o "..iloscdni.." dni za punkty premium")
			else
				outputChatBox("Nieznany błąd",client,255,0,0)
			end
		else
			outputChatBox("Masz zbyt mało punktów premium!",client,255,0,0)
		end
	else -- gp
		if spec[1]>=koszt then
			spec[1]=spec[1]-koszt
			czas=przedluzBaze(id,iloscdni)
			if czas and setElementData(client,"SpecjalnaWaluta",spec) and setElementData(elbazy,"data",czas) then
				triggerClientEvent(client,"bazy:aktualizuj",client)
				outputChatBox("Przedłużono pomyślnie!",client,0,255,0)
				dodajLogBaz(client,"przedłużenie id: "..id.." o "..iloscdni.." dni za gp")
			else
				outputChatBox("Nieznany błąd",client,255,0,0)
			end
		else
			outputChatBox("Masz zbyt mało monet!",client,255,0,0)
		end
	end
end
addEvent("bazy:przedluz",true)
addEventHandler("bazy:przedluz",resourceRoot,przedluz)

function zwiekszLimit(id,iloscobjektow)
	exports.db:zapytanie("UPDATE Bazy set limitobjektow=limitobjektow+? where ID=?",iloscobjektow,id)
	aktualnylimit=exports.db:pobierzTabeleWynikow("SELECT limitobjektow FROM `Bazy` where ID=?",id)[1]["limitobjektow"]
	return aktualnylimit
end

function pobierzPP(gracz)
	idgracza=getElementData(gracz,"UID")
	q=exports.db:pobierzTabeleWynikow("select pp from Konta where ID=? limit 1",idgracza)
	if #q==0 then return end
	return q[1].pp
end

function ulepsz(typ,id,elbazy,data1,data2,data3)
	if typ=="limitobjektow" then
		koszt=data1
		iloscpp=pobierzPP(client)
		if iloscpp>=koszt then
			idgracza=getElementData(client,"UID")
			q=exports.db:zapytanie("update Konta set pp=pp-? where ID=? limit 1",koszt,idgracza)
			nowylimit=zwiekszLimit(id,5)
			setElementData(elbazy,"Limit",nowylimit)
			iloscpp=pobierzPP(client)
			dodajLogBaz(client,"Ulepszenie bazy, "..tostring(typ)..": id: "..id.." "..nowylimit-5 .."+5="..nowylimit..". Koszt: "..koszt.." ("..iloscpp..")")
			triggerClientEvent(client,"bazy:aktualizuj",client)
			outputChatBox("Limit bazy został zwiększony pomyślnie do "..nowylimit.." objektów! Posiadasz teraz "..iloscpp.." pp",client,0,255,0)
		else
			outputChatBox("Nie stać cię!",client,255,0,0)
		end
	end
end
addEvent("bazy:ulepsz",true)
addEventHandler("bazy:ulepsz",resourceRoot,ulepsz)

function Bazy_zniszczElement(objekt)
	if not objekt or not isElement(objekt) then return end
	x,y,z=getElementPosition(objekt)
	dodajLogBaz(client,"Zniszczenie objektu, "..math.floor(x)..","..math.floor(y).." "..math.floor(z).."")
	newobjekty={}
	for i,v in ipairs(objektybazy) do
		if v~=objekt then
			table.insert(newobjekty,v)
		end
	end
	objektybazy=newobjekty
	newobjekty=nil
	destroyElement(objekt)
end
addEvent("Bazy_zniszczElement",true)
addEventHandler("Bazy_zniszczElement",resourceRoot,Bazy_zniszczElement)
