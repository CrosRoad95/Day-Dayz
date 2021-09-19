function zaladuj()
	q=exports.db:pobierzTabeleWynikow("select * from Jedzenie")
	jedzenie={}
	for i,v in ipairs(q) do
		jedzenie[v.przedmiot]={v.dodac_krew,v.dodac_glod,v.dodac_pragnienie}
	end
	q=exports.db:pobierzTabeleWynikow("select * from Skiny")
	skinyNI={}
	skinyIN={}
	for i,v in ipairs(q) do
		skinyNI[v.nazwa]=v.id_skinu
		skinyIN[v.id_skinu]=v.nazwa
	end
	q=exports.db:pobierzTabeleWynikow("select * from Plecaki")
	plecakNS={}
	plecakSN={}
	for i,v in ipairs(q) do
		plecakNS[v.nazwa]=v.sloty
		plecakSN[v.sloty]=v.nazwa
	end
	q=exports.db:pobierzTabeleWynikow("select * from bronie")
	bronamunicja={}
	for i,v in ipairs(q) do
		bronamunicja[v.bron]=v
	end
	
end
zaladuj()

function zniszczElementy(e1,e2,e3,e4,e5)
	if e1 and isElement(e1) then
		destroyElement(e1)
	end
	if e2 and isElement(e2) then
		destroyElement(e2)
	end
	if e3 and isElement(e3) then
		destroyElement(e3)
	end
	if e4 and isElement(e4) then
		destroyElement(e4)
	end
	if e5 and isElement(e5) then
		destroyElement(e5)
	end
end

function animacja(kto,animacja)
	if animacja=="uzywa" then
		setPedAnimation(kto,"BOMBER","BOM_Plant",1200,false,false,nil,false)
	elseif animacja=="jedz" then
		setPedAnimation(kto, "FOOD", "EAT_Burger",1000, false, false, nil, false)
	end
end

function odswiezEkwipunek(kto)
	triggerClientEvent(kto,"refreshInventoryManual",kto)
	exports["dayz-attach"]:aktualizujAttachGracza(kto)
end

function getPointFromDistanceRotation(x, y, dist, angle)
 
    local a = math.rad(90 - angle);
 
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
 
    return x+dx, y+dy;
 
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function uzyciePrzedmiotu(przedmiot,akcja)
	item=getElementData(client,przedmiot)
	if item and item>0 then
		--outputChatBox(tostring(przedmiot)..":"..tostring(item).."  ("..tostring(akcja)..")",client,0,255,0)
		if akcja=="Uzyj" then
			if przedmiot=="Bandage" then
				if getElementData(client,"_Krwawienie_")>0 then
					animacja(client,"uzywa")
					setElementData(client,"_Krwawienie_",0)
					setElementData(client,przedmiot,item-1)
					odswiezEkwipunek(client)
				else
					outputChatBox("Nie krwawisz! Nie musisz użyć bandaża!",client,255,0,0)
				end
			elseif przedmiot=="Heat Pack" then
				animacja(client,"uzywa")
				setElementData(client,"_Temperatura_",3660)
				setElementData(client,przedmiot,item-1)
				outputChatBox("Twoja temperatura została ustabilizowana!",client,0,255,0)
				odswiezEkwipunek(client)
			elseif przedmiot=="Blueprint" then
				triggerEvent("stworzDarmowaBaze",getResourceRootElement(getResourceFromName("dayz-bazy_darmowe")),client)
			elseif przedmiot=="Painkiller" then
				if getElementData(client,"_Bol_Glowy_") then
					animacja(client,"uzywa")
					setElementData(client,"_Bol_Glowy_",false)
					setElementData(client,przedmiot,item-1)
					odswiezEkwipunek(client)
				else
					outputChatBox("Nie boli cię głowa, nie musisz zażywać painkillera!",client,0,255,0)
				end
			elseif przedmiot=="Morphine" then
				if getElementData(client,"_Zlamana_Kosc_") then
					animacja(client,"uzywa")
					setElementData(client,"_Zlamana_Kosc_",false)
					setElementData(client,przedmiot,item-1)
					odswiezEkwipunek(client)
				else
					outputChatBox("Nie masz złamanej nogi, nie musisz zażywać morfiny!",client,0,255,0)
				end
			elseif przedmiot=="Medic Kit" then
				animacja(client,"uzywa")
				setElementData(client,"_Krwawienie_",0)
				setElementData(client,"_Temperatura_",3660)
				setElementData(client,"_Bol_Glowy_",false)
				setElementData(client,"_Zlamana_Kosc_",false)
				setElementData(client,"_Krew_",12000)
				outputChatBox("Zostałeś wyleczony!",client,0,255,0)
				setElementData(client,przedmiot,item-1)
				odswiezEkwipunek(client)
			end
		elseif akcja=="Poloz" then
			if przedmiot=="Roadflare" then
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				local x, y, z = getElementPosition(client)
				i,d=getElementInterior(client),getElementDimension(client)
				local object = createObject(354, x, y, z - 0.6)
				setElementInterior(object,i)
				setElementDimension(object,d)
				setTimer(destroyElement,300000,1,object)
			end
		elseif akcja=="Postaw" then
			if przedmiot=="Wire Fence" then
				local x,y,z=getElementPosition(client)
				i,d=getElementInterior(client),getElementDimension(client)
				x2,y2=getPointFromDistanceRotation(x,y,1,-getPedRotation(client))
				r=findRotation(x,y,x2,y2) 
				wirefance = createObject(983,x2,y2,z,0,0,r+90)
				col=createColSphere(x2,y2,z,1)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(wirefance,i)
				setElementDimension(wirefance,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"parent",wirefance)
				setElementData(col,"Opis","ogrodzenie")
				setElementData(col,"Opcje",{{"Zniszcz","zniszcz_objekt"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
			elseif przedmiot=="Tent" then
				local x,y,z=getElementPosition(client)
				x2,y2=getPointFromDistanceRotation(x,y,1,-getPedRotation(client))
				i,d=getElementInterior(client),getElementDimension(client)
				r=findRotation(x,y,x2,y2) 
				tent,col=exports["dayz-zapis_namioty"]:stworzElementyNamiotu(x2,y2,z,r)
				--tent = createObject(3243,x2,y2,z-.875,0,0,r)
				--col=createColSphere(x2,y2,z,1)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(tent,i)
				setElementDimension(tent,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"namiot",true,false)
				setElementData(col,"parent",tent)
				setElementData(col,"Opis","Namiot")
				setElementData(col,"_Limit_Slotow_",100)
				setElementData(col,"Opcje",{{"-","nic"},{"Zniszcz","zniszcz_objekt"},{"Ustaw opis","ustaw_opis"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				pos=x2..","..y2..","..z..","..i..","..z
				exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Postawienie namiotu")
			elseif przedmiot=="Tent medic" then
				local x,y,z=getElementPosition(client)
				x2,y2=getPointFromDistanceRotation(x,y,1,-getPedRotation(client))
				i,d=getElementInterior(client),getElementDimension(client)
				r=findRotation(x,y,x2,y2) 
				tent,col=exports["dayz-zapis_namioty"]:stworzElementyNamiotu(x2,y2,z,r)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(tent,i)
				setElementDimension(tent,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"namiot",true,false)
				setElementData(col,"parent",tent)
				setElementData(col,"Opis","Namiot")
				setElementData(col,"_Limit_Slotow_",100)
				setElementData(col,"Opcje",{{"-","nic"},{"Zniszcz","zniszcz_objekt"},{"Ustaw opis","ustaw_opis"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				itemy={
					["Medic Kit"]=10,
					["Bandage"]=20,
					["Morphine"]=10,
					["Painkiller"]=10,
					["Heat Pack"]=10,
					["Blood Bag"]=5,
					["Milk"]=20,
					["Pizza"]=10,
					["Burger"]=10,
				}
				for i,v in pairs(itemy) do
					setElementData(col,i,v)
				end
				pos=x2..","..y2..","..z..","..i..","..z
				exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Postawienie namiotu medic")
			elseif przedmiot=="Tent technic" then
				local x,y,z=getElementPosition(client)
				x2,y2=getPointFromDistanceRotation(x,y,1,-getPedRotation(client))
				i,d=getElementInterior(client),getElementDimension(client)
				r=findRotation(x,y,x2,y2) 
				tent,col=exports["dayz-zapis_namioty"]:stworzElementyNamiotu(x2,y2,z,r)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(tent,i)
				setElementDimension(tent,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"namiot",true,false)
				setElementData(col,"parent",tent)
				setElementData(col,"Opis","Namiot")
				setElementData(col,"_Limit_Slotow_",100)
				setElementData(col,"Opcje",{{"-","nic"},{"Zniszcz","zniszcz_objekt"},{"Ustaw opis","ustaw_opis"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				itemy={
					["Engine"]=15,
					["Tire"]=22,
					["Tank Parts"]=10,
					["Toolbox"]=10,
					["Full Gas Canister"]=5,
					["Map"]=5,
					["GPS"]=5,
					["Full Gas Canister"]=5,
					
				}
				for i,v in pairs(itemy) do
					setElementData(col,i,v)
				end
				pos=x2..","..y2..","..z..","..i..","..z
				exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Postawienie namiotu technic")
			elseif przedmiot=="Tent army" then
				local x,y,z=getElementPosition(client)
				x2,y2=getPointFromDistanceRotation(x,y,1,-getPedRotation(client))
				i,d=getElementInterior(client),getElementDimension(client)
				r=findRotation(x,y,x2,y2) 
				tent,col=exports["dayz-zapis_namioty"]:stworzElementyNamiotu(x2,y2,z,r)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(tent,i)
				setElementDimension(tent,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"namiot",true,false)
				setElementData(col,"parent",tent)
				setElementData(col,"Opis","Namiot")
				setElementData(col,"_Limit_Slotow_",100)
				setElementData(col,"Opcje",{{"-","nic"},{"Zniszcz","zniszcz_objekt"},{"Ustaw opis","ustaw_opis"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				itemy={
					["Hatchet"]=10,
					["Hunting Knife"]=5,
					["M4"]=20,
					["AK-47"]=20,
					["CZ 550"]=5,
					["M4 Mag"]=900,
					["AK Mag"]=900,
					["CZ 550 Mag"]=100,
					["Map"]=15,
					["GPS"]=15,
				}
				for i,v in pairs(itemy) do
					setElementData(col,i,v)
				end
				pos=x2..","..y2..","..z..","..i..","..z
				exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Postawienie namiotu army")
			elseif przedmiot=="Tent1000" then
				local x,y,z=getElementPosition(client)
				x2,y2=getPointFromDistanceRotation(x,y,1,-getPedRotation(client))
				i,d=getElementInterior(client),getElementDimension(client)
				r=findRotation(x,y,x2,y2) 
				tent,col=exports["dayz-zapis_namioty"]:stworzElementyNamiotu(x2,y2,z,r)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(tent,i)
				setElementDimension(tent,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"namiot",true,false)
				setElementData(col,"parent",tent)
				setElementData(col,"Opis","Namiot")
				setElementData(col,"_Limit_Slotow_",1000)
				setElementData(col,"Opcje",{{"-","nic"},{"Zniszcz","zniszcz_objekt_"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				pos=x2..","..y2..","..z..","..i..","..z
				exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Postawienie namiotu 1000")
			elseif przedmiot=="Skrzynia" then
				local x,y,z=getElementPosition(client)
				x2,y2=getPointFromDistanceRotation(x,y,0.8,-getPedRotation(client))
				i,d=getElementInterior(client),getElementDimension(client)
				r=findRotation(x,y,x2,y2) 
				tent,col=exports["dayz-zapis_namioty"]:stworzElementyNamiotu(x2,y2,z,r,964)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(tent,i)
				setElementDimension(tent,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"namiot",true,false)
				setElementData(col,"parent",tent)
				setElementData(col,"_Limit_Slotow_",40)
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				haslodoskrzynki=math.random(1000,9999)
				setElementData(col,"extra",{haslo=haslodoskrzynki})
				odswiezEkwipunek(client)
				outputChatBox("Hasło do tej skrzynki to: "..haslodoskrzynki.." zapisz je aby nie stracić przedmiotów!",client,0,255,0)
				pos=x2..","..y2..","..z..","..i..","..z
				exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Postawienie skrzyni")
			elseif przedmiot=="Krzak" then
				local x,y,z=getElementPosition(client)
				i,d=getElementInterior(client),getElementDimension(client)
				krzak=createObject(647,x,y,z,0,0,math.random(360))
				col=createColSphere(x,y,z,1)
				setElementInterior(col,i)
				setElementDimension(col,d)
				setElementInterior(krzak,i)
				setElementDimension(krzak,d)
				setElementData(col,"itemloot",true)
				setElementData(col,"parent",krzak)
				setElementData(col,"Opis","krzak")
				setElementData(col,"Opcje",{{"Zniszcz","zniszcz_element"},})
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
			elseif przedmiot=="Bear Trap" then
				outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
			elseif przedmiot=="Plapka" then
				outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
			elseif przedmiot=="Barykada" then
				outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
			elseif przedmiot=="Kolczatka" then
				setElementData(client,przedmiot,item-1)
				animacja(client,"uzywa")
				odswiezEkwipunek(client)
				x,y,z=getElementPosition(client)
				_,_,r=getElementRotation(client)
				x,y=getPointFromDistanceRotation(x,y,1,-r)
				exports["dayz-kolczatka"]:stworzKolczatke(x,y,z-.8,r+90)
				--outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
			end
		elseif akcja=="Rozpakuj" then
			if przedmiot=="Zapakowana Pizza" then
				setElementData(client,"Pizza",getElementData(client,"Pizza")+1)
				setElementData(client,"Puste opakowanie",getElementData(client,"Puste opakowanie")+1)
				setElementData(client,przedmiot,item-1)
				odswiezEkwipunek(client)
			elseif przedmiot=="Zapakowany Burger" then
				setElementData(client,"Burger",getElementData(client,"Burger")+1)
				setElementData(client,"Puste opakowanie",getElementData(client,"Puste opakowanie")+1)
				setElementData(client,przedmiot,item-1)
				odswiezEkwipunek(client)
			end
		elseif akcja=="Podpal" then
			if przedmiot=="Puste opakowanie" then
				podpal=false
				if getElementData(client,"Zapalniczka") and getElementData(client,"Zapalniczka")>0 then
					podpal=true
				elseif getElementData(client,"Box of Matches") and getElementData(client,"Box of Matches")>0 then
					setElementData(client,"Box of Matches",getElementData(client,"Box of Matches")-1)
					podpal=true
				else
					podpal=false
				end
				if podpal then
					x,y,z=getElementPosition(client)
					local fire = createObject(3525,x,y,z - 0.75, 0, 0, 0)
					setObjectScale(fire, 0)
					setElementCollisionsEnabled(fire, false)
					setTimer(destroyElement,10000,1,fire)
					setElementData(client,przedmiot,item-1)
					odswiezEkwipunek(client)
				else
					outputChatBox("Potrzebujesz zapałek (Box of Matches) lub zapalniczki aby podpalić puste opakowanie",client,255,0,0)
				end
			elseif przedmiot=="Wood Pile" then
				podpal=false
				if getElementData(client,"Zapalniczka") and getElementData(client,"Zapalniczka")>0 then
					podpal=true
				elseif getElementData(client,"Box of Matches") and getElementData(client,"Box of Matches")>0 then
					setElementData(client,"Box of Matches",getElementData(client,"Box of Matches")-1)
					podpal=true
				else
					podpal=false
				end
				if podpal then
					x,y,z=getElementPosition(client)
					local drzewo = createObject(1463,x,y,z - 0.75, 0, 0, 0)
					setObjectScale(drzewo, 0.55)
					local fire = createObject(3525,x,y,z - 0.75, 0, 0, 0)
					col=createColSphere(x,y,z,1)
					setObjectScale(fire,0)
					setElementCollisionsEnabled(fire,false)
					setElementCollisionsEnabled(drzewo,false)
					setTimer(zniszczElementy,1000*60*20,1,fire,drzewo,col)
					setElementData(col,"itemloot",true)
					setElementData(col,"parent",drzewo)
					setElementData(col,"Opis","ognisko")
					setElementData(col,"Opcje",{{"Upiecz mięso","upiecz_mieso"},{"Ogrzej się","ogrzej_sie"},})
					setElementData(client,przedmiot,item-1)
					odswiezEkwipunek(client)
				else
					outputChatBox("Potrzebujesz zapałek (Box of Matches) lub zapalniczki aby podpalić puste opakowanie",client,255,0,0)
				end
			end
		elseif akcja=="Zjedz" or akcja=="Wypij" then
			dane=jedzenie[przedmiot]
			if dane then
				setElementData(client,"_Krew_",getElementData(client,"_Krew_")+dane[1])
				setElementData(client,"_Glod_",getElementData(client,"_Glod_")+dane[2])
				setElementData(client,"_Pragnienie_",getElementData(client,"_Pragnienie_")+dane[3])
				if getElementData(client,"_Krew_")>12000 then
					setElementData(client,"_Krew_",12000)
				end
				if getElementData(client,"_Glod_")>100 then
					setElementData(client,"_Glod_",100)
				end
				if getElementData(client,"_Pragnienie_")>100 then
					setElementData(client,"_Pragnienie_",100)
				end
				if przedmiot=="Soda Bottle" then
					setElementData(client,"Empty Soda Cans",getElementData(client,"Empty Soda Cans")+1)
				end
				setElementData(client,przedmiot,item-1)
				odswiezEkwipunek(client)
				animacja(client,"jedz")
			end
		elseif akcja=="Zaloz" then
			if skinyNI[przedmiot] then
				aktualny=getElementModel(client)
				skinaktualny=skinyIN[aktualny]
				nowyskin=skinyNI[przedmiot]
				setElementModel(client,nowyskin)
				setElementData(client,przedmiot,getElementData(client,przedmiot)-1)
				setElementData(client,skinaktualny,getElementData(client,skinaktualny)+1)
				odswiezEkwipunek(client)
				animacja(client,"uzywa")
			elseif przedmiot=="Pancerz" then
				outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
			elseif przedmiot=="Tarcza" then
				outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
			end
		elseif akcja=="Napelnij" then
			if isElementInWater(client) then
				setElementData(client,przedmiot,item-1)
				setElementData(client,"Water Bottle",getElementData(client,"Water Bottle")+1)
				odswiezEkwipunek(client)
				outputChatBox("Butelka napełniona!",client,0,255,0)
			else
				outputChatBox("Brak wody",client,255,0,0)
			end
		elseif akcja=="Zloz CZ550, Luneta + Lee Enfield + ToolBox" then
			luneta=getElementData(client,"Luneta")
			lee=getElementData(client,"Lee Enfield")
			toolbox=getElementData(client,"Toolbox")
			if luneta and luneta>0 then
				if lee and lee>0 then
					if toolbox and toolbox>0 then
						setElementData(client,"Luneta",luneta-1)
						setElementData(client,"Lee Enfield",lee-1)
						setElementData(client,"CZ 550",getElementData(client,"CZ 550")+1)
						outputChatBox("Stworzyłeś CZ 550!",client,0,255,0)
						odswiezEkwipunek(client)
					else
						outputChatBox("Potrzebujesz Toolboxa!",client,255,0,0)
					end
				else
					outputChatBox("Potrzebujesz Lee Enfield'a!",client,255,0,0)
				end
			else
				outputChatBox("Potrzebujesz lunety!",client,255,0,0)
			end
		elseif akcja=="Zaloz plecak" then
			if plecakNS[przedmiot] then
				aktualny=getElementData(client,"_Limit_Slotow_")
				plecakaktualny=plecakSN[aktualny]
				nowesloty=plecakNS[przedmiot]
				if aktualny>=nowesloty then
					return outputChatBox("Masz już taki lub większy plecak",client,255,0,0)
				end
				setElementData(client,"_Limit_Slotow_",nowesloty)
				setElementData(client,przedmiot,getElementData(client,przedmiot)-1)
				setElementData(client,plecakaktualny,getElementData(client,plecakaktualny)+1)
				odswiezEkwipunek(client)
				animacja(client,"uzywa")
				outputChatBox("Założyłeś większy plecak!",client,0,255,0)
			end
		elseif akcja=="Ekwipuj bron glowna" then
			setElementData(client,"_Aktualnabron_1_",przedmiot)
			exports["dayz-system"]:aktualizujBronie(client)
		elseif akcja=="Ekwipuj bron poboczna" then
			setElementData(client,"_Aktualnabron_2_",przedmiot)
			exports["dayz-system"]:aktualizujBronie(client)
		elseif akcja=="Ekwipuj bron specjalna" then
			setElementData(client,"_Aktualnabron_3_",przedmiot)
			exports["dayz-system"]:aktualizujBronie(client)
		elseif akcja=="Uzyj Antybiotyku" then
			outputChatBox("Ten przedmiot nie posiada jeszcze żadnego zastosowania",client,255,0,0)
		end
	end
end
addEvent("przedmiot_uzycie", true)
addEventHandler("przedmiot_uzycie",resourceRoot,uzyciePrzedmiotu)