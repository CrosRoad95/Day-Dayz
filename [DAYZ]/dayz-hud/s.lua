function autoZapis()
	exports["dayz-zapis_pojazdy"]:zapisz()
end
addEventHandler("onResourceStop",resourceRoot,autoZapis)

function zaladuj()
	q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
	przedmioty={}
	for i,v in ipairs(q) do
		table.insert(przedmioty,v.Wartosc)
	end
end
zaladuj()

function animacja(kto,co)
	exports["dayz-ekwipunek"]:animacja(kto,co)
end

function maNarzedzia(gracz)
	tolbox=getElementData(gracz,"Toolbox")
	if tolbox and tolbox>0 then
		return true
	else
		outputChatBox("Brakuje ci odpowiednich narzędzi! (Toolbox)",gracz,255,0,0)
		return false
	end
end
zniszczItemy={
[3243]="Tent",
[983]="Wire Fence",
}
function uzyjOpcji(kolizja,akcja,opcj)
	if not kolizja then return end
	parent=getElementData(kolizja,"parent")
	--if type(parent)~="userdata" then return end
	if parent and getElementType(parent)=="vehicle" then
		if getElementHealth(parent)<150 then
			return outputChatBox("Pojazd jest zbyt zniszczony!",client,255,0,0)
		end
		if getVehicleOccupant(parent) then
			return outputChatBox("Nie możesz wykręcić/wkręcić części z pojazdu w którym ktoś siedzi!",client,255,0,0)
		end
		dane=getElementData(parent,"Dane")
		if akcja=="wykrec_silnik" then
			if dane.silnikow[2]>0 then
				if maNarzedzia(client) then
					x,y,z=getElementPosition(client)
					exports["dayz-pickup"]:createItemPickup("Engine",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(client),getElementDimension(client))
					dane.silnikow[2]=dane.silnikow[2]-1
					setElementData(parent,"Dane",dane)
					outputChatBox("Pomyślnie wykręciłeś silnik!",client,0,255,0)
					animacja(client,"uzywa")
				end
			else
				outputChatBox("W tym pojeździe nie ma ani jednego silnika!",client,255,0,0)
			end
		elseif akcja=="wsadz_silnik" then
			if dane.silnikow[1]>dane.silnikow[2] then
				if maNarzedzia(client) then
					if getElementData(client,"Engine")>0 then
						setElementData(client,"Engine",getElementData(client,"Engine")-1)
						dane.silnikow[2]=dane.silnikow[2]+1
						setElementData(parent,"Dane",dane)
						outputChatBox("Pomyślnie wkręciłeś silnik!",client,0,255,0)
						animacja(client,"uzywa")
					else
						outputChatBox("Potrzebujesz silnika!",client,255,0,0)
					end

				end
			else
				outputChatBox("Ten pojazd ma już maksymalną ilość silników!",client,255,0,0)
			end
		elseif akcja=="wykrec_kolo" then
			if dane.kol[2]>0 then
				if maNarzedzia(client) then
					x,y,z=getElementPosition(client)
					exports["dayz-pickup"]:createItemPickup("Tire",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(client),getElementDimension(client))
					dane.kol[2]=dane.kol[2]-1
					setElementData(parent,"Dane",dane)
					outputChatBox("Pomyślnie wykręciłeś koło!",client,0,255,0)
					animacja(client,"uzywa")
				end
			else
				outputChatBox("W tym pojeździe nie ma ani jednego koła!",client,255,0,0)
			end
		elseif akcja=="wsadz_kolo" then
			if dane.kol[1]>dane.kol[2] then
				if maNarzedzia(client) then
					if getElementData(client,"Tire")>0 then
						setElementData(client,"Tire",getElementData(client,"Tire")-1)
						dane.kol[2]=dane.kol[2]+1
						setElementData(parent,"Dane",dane)
						outputChatBox("Pomyślnie wkręciłeś koło!",client,0,255,0)
						animacja(client,"uzywa")
					else
						outputChatBox("Potrzebujesz koła!",client,255,0,0)
					end
				end
			else
				outputChatBox("Ten pojazd ma już maksymalną ilość kół!",client,255,0,0)
			end
		elseif akcja=="wykrec_zbiornik" then
			if dane.zbiornikow[2]>0 then
				if maNarzedzia(client) then
					x,y,z=getElementPosition(client)
					exports["dayz-pickup"]:createItemPickup("Tank Parts",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(client),getElementDimension(client))
					dane.zbiornikow[2]=dane.zbiornikow[2]-1
					setElementData(parent,"Dane",dane)
					outputChatBox("Pomyślnie wykręciłeś zbiornik z paliwem!",client,0,255,0)
					animacja(client,"uzywa")
				end
			else
				outputChatBox("W tym pojeździe nie ma ani jednego zbiornika z paliwem!",client,255,0,0)
			end
		elseif akcja=="wsadz_zbiornik" then
			if dane.zbiornikow[1]>dane.zbiornikow[2] then
				if maNarzedzia(client) then
					if getElementData(client,"Tank Parts")>0 then
						setElementData(client,"Tank Parts",getElementData(client,"Tank Parts")-1)
						dane.zbiornikow[2]=dane.zbiornikow[2]+1
						setElementData(parent,"Dane",dane)
						outputChatBox("Pomyślnie wkręciłeś zbiornik z paliwem!",client,0,255,0)
						animacja(client,"uzywa")
					else
						outputChatBox("Potrzebujesz zbiornika z paliwem!",client,255,0,0)
					end

				end
			else
				outputChatBox("Ten pojazd ma już maksymalną ilość zbiorników z paliwem!",client,255,0,0)
			end
		elseif akcja=="zatankuj" then
			if dane.paliwo[1]<=dane.paliwo[2] then
				return outputChatBox("Pojazd jest już zatankowany do pełna!",client,255,0,0)
			end
			kanister=getElementData(client,"Full Gas Canister")
			if kanister and kanister>0 then
				dane.paliwo[2]=dane.paliwo[2]+20
				setElementData(client,"Full Gas Canister",kanister-1)
				setElementData(client,"Empty Gas Canister",getElementData(client,"Empty Gas Canister")+1)
				if dane.paliwo[2]>dane.paliwo[1] then
					dane.paliwo[2]=dane.paliwo[1]
					outputChatBox("Pojazd został zatankowany do pełna!",client,0,255,0)
					animacja(client,"uzywa")
				else
					outputChatBox("Pojazd został zatankowany!",client,0,255,0)
				end
				setElementData(parent,"Dane",dane)
			else
				outputChatBox("Nie posiadasz paliwa który mógłbyś nalać do pojazdu!",client,255,0,0)
			end
		elseif akcja=="zatankujkanister" then
			if dane.paliwo[2]<20 then
				return outputChatBox("W pojeździe musi być minimum 20litrów paliwa aby zatankować kanister!",client,255,0,0)
			end
			kanister=getElementData(client,"Empty Gas Canister")
			if kanister<=0 then
				return outputChatBox("Potrzebujesz pustego kanistra!",client,255,0,0)
			end
			dane.paliwo[2]=dane.paliwo[2]-20
			setElementData(client,"Empty Gas Canister",kanister-1)
			setElementData(client,"Full Gas Canister",getElementData(client,"Full Gas Canister")+1)
			setElementData(parent,"Dane",dane)
			outputChatBox("Kanister został zatankowany!",client,0,255,0)
			animacja(client,"uzywa")
		end
	elseif parent and getElementType(parent)=="object" then
		if akcja=="nic" then
			outputChatBox("Ta funkcja nic nie robi, jest stworzona żebyś przypadkowo nie zniszczył objektu",client,0,255,0)
		elseif akcja=="zniszcz_objekt" then
			if maNarzedzia(client) then
				if parent then
					x,y,z=getElementPosition(kolizja)
					item=zniszczItemy[getElementModel(parent)]
					if item then
						pos=x..","..y..","..z..","..getElementInterior(kolizja)..","..getElementDimension(kolizja)
						exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Usunięcie objektu")
						exports["dayz-pickup"]:createItemPickup(item,1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(kolizja),getElementDimension(kolizja))
					end
				end
				destroyElement(parent)
				destroyElement(kolizja)
				animacja(client,"uzywa")
			end
		elseif akcja=="zniszcz_kolczatke" then
			if maNarzedzia(client) then
				if parent then
					x,y,z=getElementPosition(kolizja)
					kolizje=getElementData(kolizja,"kolizje_kolczatki")
					exports["dayz-pickup"]:createItemPickup("Kolczatka",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(kolizja),getElementDimension(kolizja))
					for i=1,5 do
						destroyElement(kolizje[i])
					end
					destroyElement(parent)
					animacja(client,"uzywa")
				end
			end
		elseif akcja=="zniszcz_objekt_" then
			if maNarzedzia(client) then
				if getElementData(kolizja,"parent") then
					x,y,z=getElementPosition(kolizja)
					pos=x..","..y..","..z..","..getElementInterior(kolizja)..","..getElementDimension(kolizja)
					exports.db:zapytanie("insert into Logi_namioty values(null,null,?,?,?,?)",getElementData(client,"UID"),getPlayerSerial(client),pos,"Usunięcie Tent1000")
					exports["dayz-pickup"]:createItemPickup("Tent1000",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(kolizja),getElementDimension(kolizja))
				end
				destroyElement(parent)
				destroyElement(kolizja)
				animacja(client,"uzywa")
			end
		elseif akcja=="zniszcz_element" then
			if maNarzedzia(client) then
				destroyElement(parent)
				destroyElement(kolizja)
				animacja(client,"uzywa")
			end
		elseif akcja=="ustaw_opis" then
			triggerClientEvent(client,"opis_namiotu",client,kolizja)
		elseif akcja=="ustaw_haslo" then
			triggerClientEvent(client,"haslo_skrzynki",client,kolizja)
		elseif akcja=="upiecz_mieso" then
			iloscr=getElementData(client,"Raw Meat")
			if iloscr>0 then
				iloscc=getElementData(client,"Cooked Meat")
				setElementData(client,"Raw Meat",iloscr-1)
				setElementData(client,"Cooked Meat",iloscc+1)
				outputChatBox("Mięso zostało upieczone!",client,0,255,0)
				animacja(client,"uzywa")
			else
				outputChatBox("Nie posiadasz surowego mięsa!",client,255,0,0)
			end
		end
	elseif parent and getElementType(parent)=="ped" or parent=="Zwłoki" then
		if opcj[1]=="Informacja" or opcj[1]=="Informacje" then
			outputChatBox(akcja,client,0,255,0)
		end
	else
		if akcja=="tankuj_kanister" then
			kanister=getElementData(client,"Empty Gas Canister")
			if kanister and kanister>0 then
				setElementData(client,"Empty Gas Canister",kanister-1)
				setElementData(client,"Full Gas Canister",getElementData(client,"Full Gas Canister")+1)
				outputChatBox("Kanister napełniony!",client,0,255,0)
				animacja(client,"uzywa")
			else
				outputChatBox("Potrzebujesz pustego kanistra (Empty Gas Canister)!",client,255,0,0)
			end
		end
	end
end
addEvent("uzyj",true)
addEventHandler("uzyj",resourceRoot,uzyjOpcji)