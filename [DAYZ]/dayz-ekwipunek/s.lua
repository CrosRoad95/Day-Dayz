function zaladujEkwipunek()
	pojazdy={}
	ekwipunek_przedmioty={}
	ekwipunek_przedmioty_={}
	magazynki={}
	wszystkieprzedmioty={}
	craftingi={}
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Magazynki")
	for i,v in ipairs(q) do
		magazynki[v.magazynek]=v.ilosc
	end
	craftingi=exports.db:pobierzTabeleWynikow("SELECT * FROM Crafting")
	q=exports.db:pobierzTabeleWynikow("select * from Przedmioty")
	for i,v in ipairs(q) do
		wszystkieprzedmioty[v.Wartosc]=v
		if not ekwipunek_przedmioty[v.Kategoria] then
			ekwipunek_przedmioty[v.Kategoria]={}
		end
		if not ekwipunek_przedmioty[v.Kategoria][v.SubKategoria] and v.SubKategoria~="" then
			ekwipunek_przedmioty[v.Kategoria][v.SubKategoria]={}
		end
		if v.SubKategoria~="" then
			table.insert(ekwipunek_przedmioty[v.Kategoria][v.SubKategoria],{v.Wartosc,v.Zajmuje,v.Opcje})
		else
			table.insert(ekwipunek_przedmioty[v.Kategoria],{v.Wartosc,v.Zajmuje,v.Opcje})
		end
		ekwipunek_przedmioty_[v.Wartosc]=v.Zajmuje
	end
	q=exports.db:pobierzTabeleWynikow("select * from Pojazdy")
	for i,v in ipairs(pojazdy) do
		pojazdy[v.ID]={silnikow=v.silnikow,zbiornikow=v.zbiornikow,kol=v.kol,paliwo=v.paliwo,zuzycie_paliwa=v.zuzycie_paliwa}
	end
	setElementData(resourceRoot,"$data_ekwipunek",ekwipunek_przedmioty)
	setElementData(resourceRoot,"$data_ekwipunek_przedmioty",ekwipunek_przedmioty_)
	setElementData(resourceRoot,"$data_pojazdy_dane",pojazdy)
	setElementData(resourceRoot,"$data_przedmioty",wszystkieprzedmioty)
	setElementData(resourceRoot,"$data_magazynki",magazynki)
	setElementData(resourceRoot,"$craftingi",craftingi)
end
zaladujEkwipunek()

function refreshLoot(loot)
	triggerEvent("refreshItemLoot",getRootElement(),loot)
end

function getItemSlots(itema)
	return ekwipunek_przedmioty_[itema]
end

function getElementCurrentSlots(loot)
	local zajecieEkwipunku=0
	for i,v in pairs(ekwipunek_przedmioty_) do
		item=getElementData(loot,i)
		if item and item >= 1 then
			zajecieEkwipunku=zajecieEkwipunku+v*item
		end
	end
    return zajecieEkwipunku
end

function przeniesDoLootu(loot,przedmiot)
	itemg=getElementData(client,przedmiot)
	if itemg>0 then
		ilosc=1
		if magazynki[przedmiot] then
			ilosc=magazynki[przedmiot]
		end
		maxslots=getElementData(loot,"_Limit_Slotow_")
		if getElementCurrentSlots(loot)+getItemSlots(przedmiot)*ilosc>maxslots then
			outputChatBox("Brak miejsca",client,255,0,0)
		else
			item=getElementData(loot,przedmiot)
			if not item or type(item)~="number" then
				setElementData(loot,przedmiot,0)
				item=0
			end
			setElementData(loot,przedmiot,item+ilosc)
			setElementData(client,przedmiot,itemg-ilosc)
			refreshLoot(loot)
		end
	else
		outputChatBox("Błąd, próbujesz przenieść przedmiot którego nie masz",client,255,0,0)
	end
	triggerClientEvent(client,"refreshInventoryManual",client)
	triggerClientEvent(client,"refreshLootManual",client,loot)
end
addEvent("przeniesPrzedmiotDoLootu", true)
addEventHandler("przeniesPrzedmiotDoLootu",resourceRoot,przeniesDoLootu)
function przeniesDoEkwipunku(loot,przedmiot)
	iteml=getElementData(loot,przedmiot)
	if iteml>0 then
		ilosc=1
		if magazynki[przedmiot] then
			ilosc=magazynki[przedmiot]
		end
		if getElementCurrentSlots(client)+getItemSlots(przedmiot)*ilosc>getElementData(client,"_Limit_Slotow_") then
			outputChatBox("Brak miejsca",client,255,0,0)
		else
			itemg=getElementData(client,przedmiot)
			if not itemg or type(itemg)~="number" then
				setElementData(client,przedmiot,0)
				itemg=0
			end
			setElementData(client,przedmiot,itemg+ilosc)
			setElementData(loot,przedmiot,iteml-ilosc)
			refreshLoot(loot)
		end
	else
		outputChatBox("Błąd, próbujesz przenieść przedmiot którego nie ma",client,255,0,0)
	end
	triggerClientEvent(client,"refreshInventoryManual",client)
	triggerClientEvent(client,"refreshLootManual",client,loot)
end
addEvent("przeniesPrzedmiotDoEkwipunku", true)
addEventHandler("przeniesPrzedmiotDoEkwipunku",resourceRoot,przeniesDoEkwipunku)
function wyrzuc(przedmiot)
	itemg=getElementData(client,przedmiot)
	if itemg>0 then
		local x,y,z=getElementPosition(client)
		ilosc=1
		if magazynki[przedmiot] then
			ilosc=magazynki[przedmiot]
		end
		exports["dayz-pickup"]:createItemPickup(przedmiot,ilosc,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(client),getElementDimension(client))
		setElementData(client,przedmiot,itemg-ilosc)
	else
		outputChatBox("Błąd, próbujesz wyrzucić przedmiot którego nie masz",client,255,0,0)
	end
	triggerClientEvent(client,"refreshInventoryManual",client)
	triggerClientEvent(client,"refreshLootManual",client,loot)
end
addEvent("wyrzuc", true)
addEventHandler("wyrzuc",resourceRoot,wyrzuc)

function podnies(loot)
	if isElement(loot) then
		przedmiot=getElementData(loot,"*przedmiot*")
		if przedmiot then
			ilosc=getElementData(loot,"*ilosc*")
			if getElementCurrentSlots(client)+getItemSlots(przedmiot)*ilosc>getElementData(client,"_Limit_Slotow_") then
				outputChatBox("Błąd, brak miejsca!",client,255,0,0)
			else
				destroyElement(getElementData(loot,"parent"))
				destroyElement(loot)
				setElementData(client,przedmiot,getElementData(client,przedmiot)+ilosc)
				setElementData(client,"Loot",false)
			end
		else
			--outputChatBox("Błąd, próbujesz podnieść nieistniejący przedmiot!",client,255,0,0)
		end
	else
		outputChatBox("Błąd, próbujesz podnieść nieistniejący przedmiot!",client,255,0,0)
	end
	triggerClientEvent(client,"refreshInventoryManual",client)
	triggerClientEvent(client,"refreshLootManual",client,loot)
end
addEvent("podnies", true)
addEventHandler("podnies",resourceRoot,podnies)