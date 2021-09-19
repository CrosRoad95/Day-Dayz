auto={["automobile"]=true,["bike"]=true,["train"]=true,["trailer"]=true,["bmx"]=true,["quad"]=true}
helki={["helicopter"]=true}
samoloty={["plane"]=true}

lodzie={["boat"]=true}
function autoZapis()
	exports["dayz-zapis_pojazdy"]:zapisz()
end
addEventHandler("onResourceStop",resourceRoot,autoZapis)
function autoStart()
	id=exports.db:pobierzTabeleWynikow("SELECT MAX(ID) as ID FROM Zapis_pojazdy")
	exports["dayz-zapis_pojazdy"]:zaladuj(id[1].ID)
end
addEventHandler("onResourceStart",resourceRoot,autoStart)
function math.percentChance(percent, repeatTime)
  local hits = 0
  for i = 1, repeatTime do
    local number = math.random(0, 200) / 2
    if percent >= number then
      hits = hits + 1
    end
  end
  return hits
end
function zaladuj()
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Pojazdy")
	pojazdy={}
	pojazdy_typy={}
	for i,v in ipairs(q) do pojazdy[v.ID]=v end
	for i,v in ipairs(q) do
		v.typ=string.lower(v.typ)
		if auto[v.typ] then
			if not pojazdy_typy["auta"] then pojazdy_typy["auta"]={} end
			table.insert(pojazdy_typy["auta"],v)
		elseif helki[v.typ] then
			if not pojazdy_typy["helki"] then pojazdy_typy["helki"]={} end
			table.insert(pojazdy_typy["helki"],v)
		elseif samoloty[v.typ] then
			if not pojazdy_typy["samoloty"] then pojazdy_typy["samoloty"]={} end
			table.insert(pojazdy_typy["samoloty"],v)
		elseif lodzie[v.typ] then
			if not pojazdy_typy["lodzie"] then pojazdy_typy["lodzie"]={} end
			table.insert(pojazdy_typy["lodzie"],v)
		end
	end
	q=exports.db:pobierzTabeleWynikow("select * from Pojazdy_spawny")
	spawny={}
	for i,v in ipairs(q) do
		if auto[v.typ] then
			if not spawny["auta"] then spawny["auta"]={} end
			table.insert(spawny["auta"],{v.x,v.y,v.z,v.rx,v.ry,v.rz})
		elseif helki[v.typ] then
			if not spawny["helki"] then spawny["helki"]={} end
			table.insert(spawny["helki"],{v.x,v.y,v.z,v.rx,v.ry,v.rz})
		elseif lodzie[v.typ] then
			if not spawny["lodzie"] then spawny["lodzie"]={} end
			table.insert(spawny["lodzie"],{v.x,v.y,v.z,v.rx,v.ry,v.rz})
		end
	end
	przedmioty_={}
	q=exports.db:pobierzTabeleWynikow("SELECT Wartosc,ID_Objektu,Skala,Obroty FROM Przedmioty")
	for i,v in ipairs(q)do
		przedmioty_[v.Wartosc]={v.ID_Objektu,v.Skala,v.Obroty}
	end
	przedmioty={}
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Loot_przedmioty")
	for i,v in ipairs(q)do
		if not przedmioty[v.loot] then przedmioty[v.loot]={} end
		przedm=przedmioty_[v.przedmiot]
		table.insert(przedmioty[v.loot],{v.przedmiot,v.szansa,przedm[1],przedm[2],przedm[3]})
	end
end
zaladuj()
setTimer(zaladuj,1000*60*60,0)
--[{ silnikow":4,"paliwo":100,"kol":1,"ID": 445,"typ":"Automobile","zuzycie_paliwa":0.5,"zbiornikow":1}]
function stworzPojazd(model,x,y,z,rx,ry,rz,kolizja,limitslotow)
	dane=pojazdy[model]
	if not dane then return false end
	typ=getVehicleType(model)
	if typ=="Plane" or typ=="Helicopter" then
		z=z+1.5
	end
	veh=createVehicle(model,x,y,z,rx,ry,rz)
	if not veh then return false end
	if kolizja==0 then
		kolizja=pojazdy[model].kolizja
	end
	if limitslotow==0 then
		limit_slotow=pojazdy[model].limit_slotow
	end
	col=createColSphere(x,y,z,kolizja)
	attachElements(col,veh)
	setElementData(col,"itemloot", true)
	setElementData(veh,"pojazd", true)
	setElementData(col,"pojazd", true)
	setElementData(col,"kolizja",kolizja)
	setElementData(col,"parent",veh)
	setElementData(veh,"parent",col)
	setElementData(col,"_Limit_Slotow_",limitslotow)
	setElementData(col,"Opis","vehicleinfo")
	setElementData(col,"Nazwa","Pojazd")
	setElementData(col,"Opcje",{
	--{"Napraw","napraw"},
	{"Wsadź silnik","wsadz_silnik"},
	{"Wykręć silnik","wykrec_silnik"},
	{"Wsadź koło","wsadz_kolo"},
	{"Wykręć koło","wykrec_kolo"},
	{"Wsadź zbiornik","wsadz_zbiornik"},
	{"Wykręć zbiornik","wykrec_zbiornik"},
	{"Zatankuj","zatankuj"},
	{"Zatankuj kanister","zatankujkanister"},
	})
	if model==509 then
		setElementData(veh,"Dane",{
		["silnikow"]={0,0},
		["paliwo"]={0,0},
		["kol"]={0,0},
		["zbiornikow"]={0,0},
		["zuzycie_paliwa"]={0}
		})
	else
		setElementData(veh,"Dane",{
		["silnikow"]={dane.silnikow,math.random(dane.silnikow)},
		["paliwo"]={dane.paliwo,math.random(0,dane.paliwo)},
		["kol"]={dane.kol,math.random(0,dane.kol)},
		["zbiornikow"]={dane.zbiornikow,math.random(0,dane.zbiornikow)},
		["zuzycie_paliwa"]={dane.zuzycie_paliwa}
		})
	end
	for i, item in ipairs(przedmioty["military"]) do
		local value = math.percentChance(item[2], math.random(1, 2))
		setElementData(col, item[1], value)
	  end
	return veh
end
function stworzTypPojazdu(typ)
	if spawny[typ] then
		for i=1,5 do
			losowyspawn=spawny[typ][math.random(#spawny[typ])]
			local col=createColSphere(losowyspawn[1],losowyspawn[2],losowyspawn[3],5)
			if #getElementsWithinColShape(col,"vehicle")==0 then
				pojazd=pojazdy_typy[typ][math.random(#pojazdy_typy[typ])]
				stworzPojazd(pojazd.ID,losowyspawn[1],losowyspawn[2],losowyspawn[3],losowyspawn[4],losowyspawn[5],losowyspawn[6],pojazd.kolizja,pojazd.limit_slotow)
				destroyElement(col)
				return pojazd
			end
			destroyElement(col)
		end
	end
	return false
end
addEvent("pojazd_spawn", true)
addEventHandler("pojazd_spawn", getRootElement(),stworzTypPojazdu)