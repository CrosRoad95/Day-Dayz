

m_gui=guiCreateWindow(595,249,607,395,"Administracja bazami",false)
guiWindowSetSizable(m_gui,false)
guiSetVisible(m_gui,false)
base_list=guiCreateComboBox(10,23,587,187,"Wybierz bazę",false,m_gui)
gridlist_1=guiCreateGridList(10,99,587,244,false,m_gui)
guiGridListAddColumn(gridlist_1,"###",0.1)
guiGridListAddColumn(gridlist_1,"Nick [ID Postaci]",0.2)
guiGridListAddColumn(gridlist_1,"Właściciel",0.2)
guiGridListAddColumn(gridlist_1,"Może budować",0.2)
guiGridListAddColumn(gridlist_1,"Może otwierać drzwi/bramy",0.25)
button_1=guiCreateButton(2,347,115,34,"Dodaj do bazy",false,m_gui)
button_2=guiCreateButton(125,347,115,34,"Zmien prawo",false,m_gui)
button_3=guiCreateButton(242,347,115,34,"Usuń z bazy",false,m_gui)
button_4=guiCreateButton(359,347,115,34,"Przedłuż bazę",false,m_gui)
button_5=guiCreateButton(476,347,115,34,"Ulepsz bazę",false,m_gui)
checkbox_1=guiCreateCheckBox (125,347,80,18,"Budowanie",false,false,m_gui)
checkbox_2=guiCreateCheckBox (125,367,80,18,"Otwieranie",false,false,m_gui)
button_ok=guiCreateButton(205,347,35,34,"OK",false,m_gui)
guiSetVisible(checkbox_1,false)
guiSetVisible(checkbox_2,false)
guiSetVisible(button_ok,false)


label_1=guiCreateLabel(11,52,586,47,"",false,m_gui)
gridlist_2=guiCreateGridList(9,20,186,323,false,m_gui)
guiGridListAddColumn(gridlist_2,"Gracz",0.9)
guiSetVisible(gridlist_2,false)

gridlist_3=guiCreateGridList(350,20,300,323,false,m_gui)
guiGridListAddColumn(gridlist_3,"Przedłuż o",0.8)
guiSetVisible(gridlist_3,false)

gridlist_4=guiCreateGridList(350,20,300,323,false,m_gui)
guiGridListAddColumn(gridlist_4,"Ulepszenia",0.9)
guiSetVisible(gridlist_4,false)

function aktualizujListeBaz()
	listabaz={}
	guiComboBoxClear(base_list)
	mojapostac=getElementData(localPlayer,"UID")
	elementBazy={}
	for i,v in ipairs (getElementsByType("bazy")) do
		elementBazy[getElementData(v,"ID")]=v
		dostep=getElementData(v,"Dostep")
		yes=false
		for ii,vv in ipairs(dostep) do
			if mojapostac==vv.IDPos then
				yes=true
				break
			end
		end
		if yes then
			listabaz[getElementData(v,"Nazwa")]=getElementData(v,"ID")
			guiComboBoxAddItem(base_list,getElementData(v,"Nazwa"))
		end
	end
	setElementData(localPlayer,"listabaz",listabaz)
end

function pokazZmianePraw(bool)
	if bool then
		guiSetVisible(button_2,false)
		guiSetVisible(checkbox_1,true)
		guiSetVisible(checkbox_2,true)
		guiSetVisible(button_ok,true)
	else
		guiSetVisible(button_2,true)
		guiSetVisible(checkbox_1,false)
		guiSetVisible(checkbox_2,false)
		guiSetVisible(button_ok,false)
	end
end

function pokazPrzedluzenieBazy(off)
	vis=guiGetVisible(gridlist_3)
	if vis or off then
		guiSetVisible(gridlist_3,false)
		guiSetText(button_4,"Przedłuż bazę")
	else
		guiSetVisible(gridlist_3,true)
		guiSetText(button_4,"Anuluj")
		elbazy=elementBazy[listabaz[tostring(guiGetText(base_list))]]
		guiGridListClear(gridlist_3)
		for i,v in pairs(fromJSON(getElementData(elbazy,"kosztprzedluzenia"))[1] or {}) do 
			if v[1]~=0 then
				row=guiGridListAddRow(gridlist_3)
				guiGridListSetItemText(gridlist_3,row,1,i.." dni za: "..v[1].." PP",false,false)
				guiGridListSetItemData(gridlist_3,row,1,{i,v[1],true})
			end
			if v[2]~=0 then
				row=guiGridListAddRow(gridlist_3)
				guiGridListSetItemText(gridlist_3,row,1,i.." dni za: "..v[2].." GP",false,false)
				guiGridListSetItemData(gridlist_3,row,1,{i,v[2],false})
			end
		end
	end
end

ulepszenia={
{"Limitu objektów +5 koszt: $koszt pp","zwieksz_limit"},
}

limityKoszt={
{100,10},
{150,20},
{200,30},
{250,40},
{300,50},
{99999,1000},
} 

function pobierzKosztUlepszenia(aktualnyLimit)
	for i,v in ipairs(limityKoszt) do
		if aktualnyLimit<v[1] then
			return v[2]
		end
	end
	return 9999999
end
function pokazUlepszeniaBazy(off)
	vis=guiGetVisible(gridlist_4)
	if vis or off then
		guiSetVisible(gridlist_4,false)
		guiSetText(button_5,"Ulepsz bazę")
	else
		guiSetVisible(gridlist_4,true)
		guiSetText(button_5,"Anuluj")
		elbazy=elementBazy[listabaz[tostring(guiGetText(base_list))]]
		guiGridListClear(gridlist_4)
		for i,v in ipairs(ulepszenia) do 
			row=guiGridListAddRow(gridlist_4)
			koszt=pobierzKosztUlepszenia(limitObjektow)
			if v[2]=="zwieksz_limit" then
				vx=string.gsub(v[1],"$koszt",koszt)
				guiGridListSetItemText(gridlist_4,row,1,vx,false,false)
			else
				guiGridListSetItemText(gridlist_4,row,1,v[1],false,false)
			end
			guiGridListSetItemData(gridlist_4,row,1,koszt)
		end
	end
end

function click()
	if source==base_list then
		pokazPrzedluzenieBazy(true)
		pokazZmianePraw(false)
		pokazUlepszeniaBazy(true)
	elseif source==gridlist_1 then
		pokazZmianePraw(false)
		pokazPrzedluzenieBazy(true)
	elseif source==button_1 then
		pokazZmianePraw(false)
		if not liderBazy then
			return outputChatBox("Tylko lider może dodawać ludzi do bazy!",255,0,0)
		end
		vis=guiGetVisible(gridlist_2)
		if not vis then
			aktualizujDaneBazy(tostring(guiGetText(base_list)))
			guiSetVisible(gridlist_2,true)
			guiSetText(button_1,"Anuluj")
			guiGridListClear(gridlist_2)
			for i,v in ipairs(getElementsByType("player")) do
				if not listaosobwbazie[getElementData(v,"UID")] then
					row=guiGridListAddRow(gridlist_2)
					guiGridListSetItemText(gridlist_2,row,1,getPlayerName(v),false,false)
					guiGridListSetItemData(gridlist_2,row,1,getElementData(v,"UID"))
				end
			end
			guiBringToFront(gridlist_2)
		else
			guiSetVisible(gridlist_2,false)
			guiSetText(button_1,"Dodaj do bazy")
		end
		return
	elseif source==button_2 then
		pokazPrzedluzenieBazy(true)
		pokazUlepszeniaBazy(true)
		if not liderBazy then
			return outputChatBox("Tylko lider może zmieniać prawa!",255,0,0)
		end
		row,col=guiGridListGetSelectedItem(gridlist_1)
		lider=guiGridListGetItemText(gridlist_1,row,3)
		if lider=="Tak" then
			return outputChatBox("Nie możesz edytować praw lidera!",255,0,0)
		end
		row,col=guiGridListGetSelectedItem(gridlist_1)
		mozebudowac=guiGridListGetItemText(gridlist_1,row,4)
		mozeotwierac=guiGridListGetItemText(gridlist_1,row,5)
		if mozebudowac=="Tak" then
			guiCheckBoxSetSelected(checkbox_1,true)
		else
			guiCheckBoxSetSelected(checkbox_1,false)
		end
		if mozeotwierac=="Tak" then
			guiCheckBoxSetSelected(checkbox_2,true)
		else
			guiCheckBoxSetSelected(checkbox_2,false)
		end
		pokazZmianePraw(true)
	elseif source==button_ok then
		check1=guiCheckBoxGetSelected(checkbox_1)
		check2=guiCheckBoxGetSelected(checkbox_2)
		idpos=guiGridListGetItemData(gridlist_1,guiGridListGetSelectedItem(gridlist_1))
		plr=guiGridListGetItemText(gridlist_1,row,2)
		idbazy=listabaz[tostring(guiGetText(base_list))]
		elbazy=elementBazy[idbazy]
		triggerServerEvent("bazy:zmienprawa",resourceRoot,idbazy,plr,idpos,elbazy,check1,check2)
		pokazZmianePraw(false)
	elseif source==button_3 then
		pokazZmianePraw(false)
		if not liderBazy then
			return outputChatBox("Tylko lider może usuwać ludzi z bazy!",255,0,0)
		end
		row,col=guiGridListGetSelectedItem(gridlist_1)
		if row==-1 then
			return outputChatBox("Zaznacz kogo chcesz wyrzucić!",255,0,0)
		end
		plr=guiGridListGetItemText(gridlist_1,row,2)
		lider=guiGridListGetItemText(gridlist_1,row,3)
		if lider=="Tak" then
			return outputChatBox("Lider nie może zostać wyrzucony z bazy!",255,0,0)
		end
		idpos=guiGridListGetItemData(gridlist_1,guiGridListGetSelectedItem(gridlist_1))
		idbazy=listabaz[tostring(guiGetText(base_list))]
		elbazy=elementBazy[idbazy]
		triggerServerEvent("bazy:usunzbazy",resourceRoot,idbazy,plr,idpos,elbazy)
	elseif source==button_4 then
		pokazZmianePraw(false)
		pokazUlepszeniaBazy(true)
		if guiComboBoxGetSelected(base_list)>=0 then
			pokazPrzedluzenieBazy()
			guiBringToFront(gridlist_3)
		else
			outputChatBox("Zaznacz bazę którą chcesz przedłużyć!",255,0,0)
		end
	elseif source==button_5 then
		pokazPrzedluzenieBazy(true)
		pokazZmianePraw(false)
		if guiComboBoxGetSelected(base_list)>=0 then
			pokazUlepszeniaBazy()
			guiBringToFront(gridlist_4)
		else
			outputChatBox("Zaznacz bazę którą chcesz ulepszyć!",255,0,0)
		end
		
	end
end
addEventHandler ( "onClientGUIClick",m_gui,click)

function clickd()
	if source==gridlist_2 then
		plr=guiGridListGetItemText(source,guiGridListGetSelectedItem(source))
		idpos=guiGridListGetItemData(source,guiGridListGetSelectedItem(source))
		if string.len(tostring(plr))>1 then
			idbazy=listabaz[tostring(guiGetText(base_list))]
			elbazy=elementBazy[idbazy]
			triggerServerEvent("bazy:dodajdobazy",resourceRoot,idbazy,plr,idpos,elbazy)
		end
	elseif source==gridlist_3 then
		sel=guiGridListGetSelectedItem(source)
		if sel>=0 then
			data=guiGridListGetItemData(gridlist_3,guiGridListGetSelectedItem(gridlist_3))--{i,v[2],false})
			spec=getElementData(localPlayer,"SpecjalnaWaluta")
			if data[3] then -- pp
				if spec[2]>=data[2] then
					idbazy=listabaz[tostring(guiGetText(base_list))]
					elbazy=elementBazy[idbazy]
					triggerServerEvent("bazy:przedluz",resourceRoot,idbazy,elbazy,data[1],data[2],data[3]) --id,elbazy,iloscdni,koszt,ppczymon
				else
					outputChatBox("Masz zbyt mało punktów premium!",255,0,0)
				end
			else -- monety
				if spec[1]>=data[2] then
					idbazy=listabaz[tostring(guiGetText(base_list))]
					elbazy=elementBazy[idbazy]
					triggerServerEvent("bazy:przedluz",resourceRoot,idbazy,elbazy,data[1],data[2],data[3]) --id,elbazy,iloscdni,koszt,ppczymon
				else
					outputChatBox("Masz zbyt mało monet!",255,0,0)
				end
			end
			idbazy=listabaz[tostring(guiGetText(base_list))]
			
		end
	elseif source==gridlist_4 then
		sel=guiGridListGetSelectedItem(source)
		if sel>=0 then
			idbazy=listabaz[tostring(guiGetText(base_list))]
			elbazy=elementBazy[idbazy]
			data=guiGridListGetItemData(source,guiGridListGetSelectedItem(source))
			triggerServerEvent("bazy:ulepsz",resourceRoot,"limitobjektow",idbazy,elbazy,data)
		end
	end
end
addEventHandler( "onClientGUIDoubleClick",m_gui,clickd)

function aktualizujDaneBazy(nazwa)
	mojeid=getElementData(localPlayer,"UID")
	listabaz=getElementData(localPlayer,"listabaz")
	liderBazy=false
	guiSetVisible(gridlist_2,false)
	guiSetText(button_1,"Dodaj do bazy")
	guiGridListClear(gridlist_1)
	for i,v in ipairs (getElementsByType("bazy")) do
		if nazwa==getElementData(v,"Nazwa") then
			limitObjektow=getElementData(v,"Limit")
			aktualnaIloscObjektow=policzObjektyWColizji(v) or 0
			txt=[[
			Baza aktywna do: ]]..tostring(getElementData(v,"data"))..[[.
			Znajduje się w ]]..getZoneName(getElementPosition(v))..[[.
			Obecnie w bazie jest ]]..tostring(aktualnaIloscObjektow)..[[/]]..tostring(limitObjektow)..[[ objektów.
			]]
			guiSetText(label_1,txt)
			guiGridListClear(gridlist_1)
			listaosobwbazie={}
			for i,v in pairs(getElementData(v,"Dostep")) do
				listaosobwbazie[v.IDPos]=true
				row=guiGridListAddRow(gridlist_1)
				guiGridListSetItemText(gridlist_1,row,1,i,false,false)
				guiGridListSetItemText(gridlist_1,row,2,v.Nick.." ["..v.IDPos.."]",false,false)
				guiGridListSetItemData(gridlist_1,row,1,v.IDPos)
				guiGridListSetItemText(gridlist_1,row,3,(v.Wlasciciel and "Tak" or "Nie"),false,false)
				guiGridListSetItemText(gridlist_1,row,4,(v.MozeBudowac and "Tak" or "Nie"),false,false)
				guiGridListSetItemText(gridlist_1,row,5,(v.MozeOtwierac and "Tak" or "Nie"),false,false)
				if v.IDPos==mojeid and v.Wlasciciel then
					liderBazy=true
				end
			end
			break
		end
	end
end

addEventHandler ( "onClientGUIComboBoxAccepted",base_list,
    function ( comboBox )
		pokazZmianePraw(false)
		pokazPrzedluzenieBazy(true)
		aktualizujDaneBazy(tostring(guiComboBoxGetItemText(source,guiComboBoxGetSelected(source))))
    end
)

antiSpam=getTickCount()-3000
function otworzZamknij()
	if guiGetVisible(m_gui)~=isCursorShowing() then return outputChatBox("Nope") end
	v=guiGetVisible(m_gui)
	if antiSpam+3000>getTickCount() and not v then
		guiSetVisible(m_gui,false)
		showCursor(false)
		return outputChatBox("Nie tak szybko,poczekaj jeszcze "..math.ceil(math.abs(getTickCount()-antiSpam-3000)/1000).." sekund/y !",255,0,0)
	end
	if not v then
		antiSpam=getTickCount()
		listaosobwbazie=false
		aktualizujListeBaz()
		guiSetText(label_1,"")
		guiGridListClear(gridlist_1)
	else
		if antiSpam+3000>getTickCount() and not v then
			antiSpam=getTickCount()-3000
		end
	end
	guiSetVisible(m_gui,not v)
	showCursor(not v)
	pokazZmianePraw(false)
	pokazUlepszeniaBazy(true)
end
bindKey("f3","down",otworzZamknij)

function wprowadzonohaslo(haslo)
	prawa,aktualnabaza=sprawdzPrawa()
	if prawa[aktualnabaza] then
		poprawne=getElementData(getElementData(localPlayer,"collision")[5],"Extra")
		if poprawne then
			poprawne=getElementData(getElementData(localPlayer,"collision")[5],"Extra")["Haslo"]
			if poprawne==haslo then
				triggerServerEvent ("bazy:otworzbrame",resourceRoot,getElementData(localPlayer,"collision")[5])
			else
				outputChatBox("Hasło niepoprawne!",255,0,0)
			end
		else
			outputChatBox("Na te drzwi nie ma jeszcze nałożonego hasła!",255,0,0)
		end
	else
		outputChatBox("Nie masz praw do otwierania tej bramy nawet podając prawidłowe hasło!",255,0,0)
	end
end
addEvent ( "bazy:wprowadzonohaslo",true )
addEventHandler ( "bazy:wprowadzonohaslo",root,wprowadzonohaslo )

function aktualizujWszystko()
	aktualizujDaneBazy(tostring(guiGetText(base_list)))
	pokazUlepszeniaBazy()
end
addEvent( "bazy:aktualizuj",true )
addEventHandler( "bazy:aktualizuj",localPlayer,aktualizujWszystko)