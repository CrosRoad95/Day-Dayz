function onSpawn()
if not getElementData(localPlayer,"Login") then return false end
removeEventHandler("onClientPlayerSpawn",localPlayer,onSpawn)
function getText(lng,typ,data,rpl)
	return exports["dayz-jezyki"]:getText(lng,typ,data,rpl)
end

dodajgracza = guiCreateWindow(100,100,400,400,"Dodaj gracza",false)
guiSetVisible(dodajgracza,false)
listagraczy2 = guiCreateGridList (0.01,0.05,0.98,0.85,true,dodajgracza)
guiGridListAddColumn(listagraczy2,"Gracz",0.9)
c={}
c[1]=guiCreateButton(0.01,0.91,0.24,0.07,"Dodaj",true,dodajgracza)
c[2]=guiCreateButton(0.76,0.91,0.24,0.07,"Odśwież",true,dodajgracza)
c[3]=guiCreateButton(0.27,0.91,0.24,0.07,"Zamknij",true,dodajgracza)
c[4]=guiCreateButton(0.51,0.91,0.24,0.07,"Zaproponuj dołączenie",true,dodajgracza)

edytujprawagui = guiCreateWindow(100,100,400,400,"Zmien prawa",false)
guiSetVisible(edytujprawagui,false)
p={}
for i=1,10 do
p[i] = guiCreateLabel(0.1,0.07*i,0.8,0.1,"",true,edytujprawagui)
guiLabelSetHorizontalAlign(p[i],"center")
guiSetFont(p[i],"default-bold-small")
end
p[99] = guiCreateLabel(0.1,0.07*11+0.02,0.4,0.065,"Ranga:\nMAX 16 znaków a-Z,0-9",true,edytujprawagui)
guiLabelSetHorizontalAlign(p[99],"center")
guiLabelSetVerticalAlign(p[99],"center")
guiSetFont(p[99],"default-bold-small")
guiLabelSetColor(p[99],0,255,0)
rangagracza=guiCreateEdit(0.5,0.07*11+0.02,0.4,0.06,"ranga",true,edytujprawagui)
guiEditSetMaxLength(rangagracza,16)
d={}
d[1]=guiCreateButton(0.02,0.91,0.3,0.07,"Zapisz",true,edytujprawagui)
d[2]=guiCreateButton(0.68,0.91,0.3,0.07,"Anuluj, zamknij",true,edytujprawagui)

gui = guiCreateWindow(100,100,550,500,"Zarządzanie grupą",false)
guiSetVisible(gui,false)

memo = guiCreateMemo(0.01,0.04,0.98,0.33,"",true,gui) -- 23 na 33
listagraczy = guiCreateGridList (0.01,0.40,0.98,0.435,true,gui)
guiGridListAddColumn(listagraczy,"Gracz",0.3)
guiGridListAddColumn(listagraczy,"Ranga",0.25)
guiGridListAddColumn(listagraczy,"Ostatnio widziany",0.35)

b={}

b[1]=guiCreateButton(0.02,0.85,0.23,0.06,"Wyrzuć",true,gui)
b[2]=guiCreateButton(0.02,0.92,0.23,0.06,"Dodaj nową osobę do grupy",true,gui)
b[3]=guiCreateButton(0.265,0.85,0.23,0.06,"Zmien prawa",true,gui)

b[4]=guiCreateButton(0.755,0.85,0.23,0.06,"Usun grupe",true,gui)
b[7]=guiCreateButton(0.265,0.92,0.23,0.06,"Historia aktywności grupy",true,gui) 
b[5]=guiCreateButton(0.51,0.85,0.23,0.06,"Sojusze",true,gui)
b[6]=guiCreateButton(0.51,0.92,0.23,0.06,"Informacje o zaznaczonej osobie",true,gui)

b[8]=guiCreateButton(0.755,0.92,0.23,0.06,"Opuść grupe",true,gui)

b[9]=guiCreateButton(0.01,0.37,0.98,0.035,"Zapisz",true,gui)

SojuszePanel = guiCreateWindow(653, 208, 536, 449, "Sojusze", false)
guiWindowSetSizable(SojuszePanel, false)
guiSetVisible(SojuszePanel,false)

listasojuszy = guiCreateGridList(10, 25, 516, 360, false, SojuszePanel)
guiGridListAddColumn(listasojuszy, "", 0.9)
SOJUSZE_Zamknij = guiCreateButton(10, 390, 122, 49, "Zamknij", false, SojuszePanel)
SOJUSZE_Dodaj = guiCreateButton(374, 390, 152, 49, "Zaproponuj sojusz z grupą o id wpisanym w polu po lewej stronie", false, SojuszePanel)
SOJUSZE_Edit = guiCreateEdit(259, 391, 105, 48, "", false, SojuszePanel)
guiEditSetMaxLength(SOJUSZE_Edit, 11)
SOJUSZE_Anuluj = guiCreateButton(132, 390, 122, 49, "Zerwij sojusz\nOdrzuć zaproszenie\nAnuluj zaproszenie", false, SojuszePanel)

przyciskiteksty={
[dodajgracza]=getText("detect","guitexts","gang_add_player",{}),
[c[1]]=getText("detect","guitexts","gang_add",{}),
[c[2]]=getText("detect","guitexts","gang_refresh",{}),
[c[3]]=getText("detect","guitexts","gang_close",{}),
[c[4]]=getText("detect","guitexts","gang_suggest_join",{}),
[edytujprawagui]=getText("detect","guitexts","gang_change_the_law",{}),
[p[99]]=getText("detect","guitexts","gang_info_1",{}),
[rangagracza]=getText("detect","guitexts","gang_rank",{}),
[d[1]]=getText("detect","guitexts","gang_save",{}),
[d[2]]=getText("detect","guitexts","gang_cancel",{}),
[gui]=getText("detect","guitexts","gang_gui_title",{}),
[b[1]]=getText("detect","guitexts","gang_gui_kick",{}),
[b[2]]=getText("detect","guitexts","gang_gui_add_new",{}),
[b[3]]=getText("detect","guitexts","gang_gui_change_law",{}),
[b[4]]=getText("detect","guitexts","gang_gui_delete_gang",{}),
[b[5]]=getText("detect","guitexts","gang_gui_alliances",{}),
[b[6]]=getText("detect","guitexts","gang_gui_info",{}),
[b[7]]=getText("detect","guitexts","gang_gui_history",{}),
[b[8]]=getText("detect","guitexts","gang_gui_quit",{}),
[b[9]]=getText("detect","guitexts","gang_gui_save",{}),
[SojuszePanel]=getText("detect","guitexts","gang_alliances",{}),
[SOJUSZE_Zamknij]=getText("detect","guitexts","gang_alliacnes_close",{}),
[SOJUSZE_Dodaj]=getText("detect","guitexts","gang_alliacnes_suggest",{}),
[SOJUSZE_Anuluj]=getText("detect","guitexts","gang_alliacnes_cancel",{}),
}

function tlumacz()
	for i,v in pairs(przyciskiteksty) do
		guiSetText(i,v)
	end
	guiGridListSetColumnTitle(listagraczy,1,getText("detect","guitexts","gang_gridlist_1_player",{}))
	guiGridListSetColumnTitle(listagraczy,2,getText("detect","guitexts","gang_gridlist_1_rank",{}))
	guiGridListSetColumnTitle(listagraczy,3,getText("detect","guitexts","gang_gridlist_1_lastseen",{}))
	
end

addEventHandler("onClientGUIChanged", SOJUSZE_Edit, function()
    local text = guiGetText(source) or ""
    if not tonumber(text) then
        guiSetText(source, string.gsub(text, "%a", ""))
    end
end)

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
 
		if day > 0 then table.insert( results, day .. "d" ) end
		if hou > 0 then table.insert( results, hou .. "h" ) end
		if min > 0 then table.insert( results, min .. "m" ) end
		if sec > 0 then table.insert( results, sec .. "s" ) end
 
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", " i ", 1 ) )
	end
	return ""
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

function czyMaPrawa(id)
	r = string.sub(getElementData(localPlayer,"grupa")[3][getElementData(localPlayer,"Login_name")]["PRAWA"],id,id)
	return (r=="1" and true or false)
end
function czyKtosMaPrawa(nick,id)
	r = string.sub(getElementData(localPlayer,"grupa")[3][nick]["PRAWA"],id,id)
	return (r=="1" and true or false)
end

function odswiezListeGraczy2()
	grupa = getElementData(localPlayer,"grupa")
	guiGridListClear(listagraczy2)
	for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"chcedolaczyc")==grupa[1] then
			r=guiGridListAddRow(listagraczy2)
			guiGridListSetItemText(listagraczy2,r,1,getPlayerName(v),false,false)
			guiGridListSetItemColor(listagraczy2,r,1,0,255,0)
			guiGridListSetItemData(listagraczy2,r,1,getElementData(v,"powoddolaczenia"))
		elseif getElementData(v,"grupa") then
			r=guiGridListAddRow(listagraczy2)
			guiGridListSetItemText(listagraczy2,r,1,getText("detect","guitexts","gang_alreadyingang",{{"$player",getPlayerName(v)}}),false,false)
			guiGridListSetItemColor(listagraczy2,r,1,255,0,0)
			guiGridListSetItemData(listagraczy2,r,1,v)
		else
			r=guiGridListAddRow(listagraczy2)
			guiGridListSetItemText(listagraczy2,r,1,getText("detect","guitexts","gang_nogang",{{"$player",getPlayerName(v)}}),false,false)
			guiGridListSetItemColor(listagraczy2,r,1,255,0,255)
			guiGridListSetItemData(listagraczy2,r,1,v)
		end
	end
end
--getText("detect","messages","gang_nogang",{{"$player",getPlayerName(v)}})
function odeslijlistesojuszy(A,B,C)
	guiGridListClear(listasojuszy)
	sojusze={}
	for i,v in pairs(A) do
		r=guiGridListAddRow(listasojuszy)
		sojusze[v.B]=r
		guiGridListSetItemText(listasojuszy,r,1,getText("detect","guitexts","gang_tryalliance",{{"$gang",v["NazwaB"]}}),false,false)
		guiGridListSetItemData(listasojuszy,r,1,v.ID)
	end
	for i,v in pairs(B) do
		if sojusze[v.A] then
			r=guiGridListAddRow(listasojuszy)
			
			guiGridListSetItemText(listasojuszy,r,1,getText("detect","guitexts","gang_alliance_confirm",{{"$gang",v["NazwaA"]},{"$id",v["A"]}}),false,false)
			guiGridListSetItemData(listasojuszy,r,1,{v.ID,guiGridListGetItemData(listasojuszy,sojusze[v.A],1)})
			guiGridListRemoveRow(listasojuszy,sojusze[v.A])
		else
			r=guiGridListAddRow(listasojuszy)
			guiGridListSetItemText(listasojuszy,r,1,getText("detect","guitexts","gang_like_alliance",{{"$gang",v["NazwaA"]},{"$id",v["A"]}}),false,false)
			guiGridListSetItemData(listasojuszy,r,1,v.ID)
		end
	end
end
addEvent( "grupy:odeslijlistesojuszy", true )
addEventHandler( "grupy:odeslijlistesojuszy",localPlayer,odeslijlistesojuszy)

function odswiezUstawianieRang(selected,ranga)
	setElementData(localPlayer,"grupa:edytowanaosoba",selected)
	guiSetText(rangagracza,string.gsub(ranga,"[ ][[].*]",""))
	guiSetText(edytujprawagui,getText("detect","guitexts","gang_law_info",{{"$player",selected}}))
	for i=1,10 do
		if czyKtosMaPrawa(selected,i) then
			guiSetText(p[i],prawa[i][1])
			setElementData(p[i],"bool",true)
			guiLabelSetColor(p[i],0,255,0)
		else
			guiSetText(p[i],prawa[i][2])
			setElementData(p[i],"bool",false)
			guiLabelSetColor(p[i],255,0,0)
		end
	end
end

prawa={
{[1]="Może używać czatu gangu.",[2]="Nie może używać czatu gangu."},
{[1]="Może edytować informacje o grupie.",[2]="Nie może edytować informacji o grupie."},
{[1]="Może dodawać nowe osoby do grupy.",[2]="Nie może nikogo dodawać do grupy."},
{[1]="Może wyrzucać innych z grupy.",[2]="Nie może nikogo wyrzucić."},
{[1]="Może zmienić tag grupy.",[2]="Nie może zmienić tagu grupy."},
{[1]="Może sprawdzać statystyki innych osób z grupy.",[2]="Nie może sprawdzać statystyk innych osób z grupy."},
{[1]="Może nadawać prawa innym osobą z grupy.",[2]="Nie może nadawać praw innym osobą z grupy."},
{[1]="Może zawierać sojusze z innymi grupami.",[2]="Nie może zawierać sojuszów z innymi grupami."},
{[1]="Może przeglądać historie aktywności grupy.",[2]="Nie może przeglądać historii aktywności grupy."},
{[1]="Może zostać wyrzucony, mieć zmienione prawa, range\ntylko przez lidera grupy.",[2]="Może być edytowany przez innych członków grupy\njeśli mają odpowiednie prawa."}
}

tickwyrzuc=getTickCount()
tickoposc=getTickCount()
tickusungrupe=getTickCount()
tickspam1=getTickCount()-60000
tickspam2=getTickCount()-30000
function zrob()
	grupa = getElementData(localPlayer,"grupa")
	if source==b[1] then
		if czyMaPrawa(4) then
			sel=guiGridListGetItemText(listagraczy,guiGridListGetSelectedItem(listagraczy),1)
			sel2=guiGridListGetItemText(listagraczy,guiGridListGetSelectedItem(listagraczy),2)
			if sel~="" then
				if tickwyrzuc+175>getTickCount() then
					tickwyrzuc=getTickCount()
					setElementData(localPlayer,"grupa:edytowanaosoba",sel)
					triggerServerEvent("gang:wyrzuczgrupy",resourceRoot,grupa[1],sel)
				else
					outputChatBox(getText("detect","messages","gang_kick_confirm",{{"$player",sel}}),0,255,0)
					tickwyrzuc=getTickCount()
				end
			end
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==b[2] then
		if czyMaPrawa(3) then
			guiSetVisible(dodajgracza,true)
			guiBringToFront(dodajgracza)
			guiSetText(dodajgracza,getText("detect","messages","gang_type_dolacz",{{"$gang",grupa[1]}}))
			odswiezListeGraczy2()
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==b[3] then
		if czyMaPrawa(7) then
			sel=guiGridListGetItemText(listagraczy,guiGridListGetSelectedItem(listagraczy),1)
			sel2=guiGridListGetItemText(listagraczy,guiGridListGetSelectedItem(listagraczy),2)
			setElementData(localPlayer,"grupa:edytowanaosoba",false)
			if sel~="" then
				guiSetVisible(edytujprawagui,true)
				guiBringToFront(edytujprawagui)
				odswiezUstawianieRang(sel,sel2)
			else
				outputChatBox(getText("detect","messages","gang_no_player_selected",{}),255,0,0)
			end
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==b[4] then
		if tickusungrupe+175>getTickCount() then
			tickusungrupe=getTickCount()
			grupa = getElementData(localPlayer,"grupa")
			triggerServerEvent("gang:usungrupe",resourceRoot,grupa[1])
		else
			outputChatBox(getText("detect","messages","gang_confirm_delete",{}),0,255,0)
			tickusungrupe=getTickCount()
		end
	elseif source==b[5] then
		if czyMaPrawa(8) then
			grupa = getElementData(localPlayer,"grupa")
			triggerServerEvent("gang:pobierzlistesojuszy",resourceRoot,grupa[1])
			guiSetVisible(SojuszePanel,true)
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==SOJUSZE_Zamknij then
		guiSetVisible(SojuszePanel,false)
	elseif source==SOJUSZE_Anuluj then
		sel=guiGridListGetItemData(listasojuszy,guiGridListGetSelectedItem(listasojuszy),1)
		if sel then
			grupa = getElementData(localPlayer,"grupa")
			triggerServerEvent("gang:zerwijsojusz",resourceRoot,grupa,sel)
		else
			outputChatBox("Zaznacz grupe z którą chcesz zerwać sojusz!",255,0,0)
		end
	elseif source==SOJUSZE_Dodaj then
		if string.len(guiGetText(SOJUSZE_Edit))>0 then
			grupa = getElementData(localPlayer,"grupa")
			if grupa[1]==tonumber(guiGetText(SOJUSZE_Edit)) then
				return outputChatBox(getText("detect","messages","gang_alliance_error_1",{}),255,0,0)
			end
			triggerServerEvent("gang:dodajsojusz",resourceRoot,grupa,tonumber(guiGetText(SOJUSZE_Edit)))
		else
			outputChatBox(getText("detect","messages","gang_alliance_error_2",{}),255,0,0)
		end
	elseif source==b[6] then
		if czyMaPrawa(6) then
			if tickspam2+1>getTickCount() then
				return outputChatBox("Poczekaj chwile! Nie tak szybko!",255,0,0)
			end
			sel=guiGridListGetItemText(listagraczy,guiGridListGetSelectedItem(listagraczy),1)
			if sel=="" then
				return outputChatBox(getText("detect","messages","gang_alliance_error_3",{}),255,0,0)
			else
				triggerServerEvent("gang:sprawdzgracza",resourceRoot,sel)
				tickspam2=getTickCount()
			end
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),0,255,0)
		end
	elseif source==b[7] then
		if czyMaPrawa(9) then
			if tickspam1+120000>getTickCount() then
				return outputChatBox(getText("detect","messages","gang_too_fast",{}),255,0,0)
			end
			tickspam1=getTickCount()
			grupa = getElementData(localPlayer,"grupa")
			triggerServerEvent("gang:historiaaktywnosci",resourceRoot,grupa[1])
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==b[8] then
		if tickoposc+175>getTickCount() then
			tickoposc=getTickCount()
			grupa = getElementData(localPlayer,"grupa")
			triggerServerEvent("gang:oposcgrupe",resourceRoot,grupa[1])
		else
			outputChatBox(getText("detect","messages","gang_quit_confirm",{}),0,255,0)
			tickoposc=getTickCount()
		end
	elseif source==b[9] then
		if czyMaPrawa(2) then
			text=guiGetText(memo)
			if string.len(text)<500 then
				grupa = getElementData(localPlayer,"grupa")
				triggerServerEvent("gang:zmienopis",resourceRoot,grupa[1],text)
			else
				outputChatBox(getText("detect","messages","gang_text_too_long",{}),255,0,0)
			end
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==c[1] then
		if czyMaPrawa(3) then
			sel=guiGridListGetItemText(listagraczy2,guiGridListGetSelectedItem(listagraczy2),1)
			grupa=getElementData(localPlayer,"grupa")
			triggerServerEvent("gang:dodajnowaosowe",resourceRoot,sel,grupa[1])
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==c[2] then
		outputChatBox("Odświeżono",0,255,0)
		odswiezListeGraczy2()
	elseif source==c[3] then
		guiSetVisible(dodajgracza,false)
	elseif source==c[4] then
		sel=guiGridListGetItemData(listagraczy2,guiGridListGetSelectedItem(listagraczy2),1)
		triggerServerEvent("gang:zaproponujdolaczenie",resourceRoot,sel)
	elseif source==d[1] then
		if czyMaPrawa(7) then
			grupa = getElementData(localPlayer,"grupa")
			prawal=""
			for i=1,10 do
				if getElementData(p[i],"bool") then
					prawal=prawal.."1"
				else
					prawal=prawal.."0"
				end
			end
			triggerServerEvent("gang:aktualizujprawa",resourceRoot,grupa[1],prawal,guiGetText(rangagracza))
			setTimer(aktualizujListeGraczy,123,1)
			guiSetVisible(edytujprawagui,false)
			setElementData(localPlayer,"grupa:edytowanaosoba",false)
		else
			outputChatBox(getText("detect","messages","gang_no_permission",{}),255,0,0)
		end
	elseif source==d[2] then
		guiSetVisible(edytujprawagui,false)
		setElementData(localPlayer,"grupa:edytowanaosoba",false)
	elseif source==listagraczy2 then
		sel=guiGridListGetItemText(listagraczy2,guiGridListGetSelectedItem(listagraczy2),1)
		powod=guiGridListGetItemData(listagraczy2,guiGridListGetSelectedItem(listagraczy2),1)
		if type(powod)=="string" then
			outputChatBox(getText("detect","messages","gang_like_join",{{"$player",sel},{"$reason",powod}}),0,255,0)
		end
	else
		for i=1,10 do
			if source==p[i] then
				if getElementData(source,"bool") then
					setElementData(source,"bool",false)
					guiSetText(source,prawa[i][2])
					guiLabelSetColor(source,255,0,0)
				else
					setElementData(source,"bool",true)
					guiSetText(source,prawa[i][1])
					guiLabelSetColor(source,0,255,0)
				end
				return
			end
		end
	end
end
addEventHandler ( "onClientGUIClick",resourceRoot,zrob)

function aktualizujListeGraczy()
	grupa = getElementData(localPlayer,"grupa")
	guiGridListClear(listagraczy)
	if not grupa then return end
	for i,v in pairs(grupa[3]) do
		r=guiGridListAddRow(listagraczy)
		guiGridListSetItemText(listagraczy,r,1,i,false,false)
		
		iloscPRaw=0
		for oo=1,10 do
			rrr = string.sub(v["PRAWA"],oo,oo)
			if rrr=="1" then
				iloscPRaw=iloscPRaw+1
			end
		end
		guiGridListSetItemText(listagraczy,r,2,v["RANGA"].." ["..iloscPRaw.."]",false,false)
		guiGridListSetItemText(listagraczy,r,3,getText("detect","messages","gang_player_was",{{"$time",secondsToTimeDesc(getTimestamp()-v["OSTATNIO_BYL"])}}),false,false)
		guiGridListSetItemColor(listagraczy,r,1,255,0,0)
		guiGridListSetItemColor(listagraczy,r,2,255,0,0)
		guiGridListSetItemColor(listagraczy,r,3,255,0,0)
		for ii,vv in ipairs(getElementsByType("player")) do
			if i==getElementData(vv,"Login_name") then
				guiGridListSetItemText(listagraczy,r,3,getText("detect","messages","gang_player_online",{{"$player",getPlayerName(vv)}}),false,false)
				guiGridListSetItemColor(listagraczy,r,1,0,255,0)
				guiGridListSetItemColor(listagraczy,r,2,0,255,0)
				guiGridListSetItemColor(listagraczy,r,3,0,255,0)
			end
		end
	end
end

antiSpam=getTickCount()-3000
function otworzZamknij()
	if guiGetVisible(gui)~=isCursorShowing() then return outputChatBox("Nope") end
	grupa = getElementData(localPlayer,"grupa")
	if grupa then
		prawa={
		{[1]="Może używać czatu gangu.",[2]="Nie może używać czatu gangu."},
		{[1]="Może edytować informacje o grupie.",[2]="Nie może edytować informacji o grupie."},
		{[1]="Może dodawać nowe osoby do grupy.",[2]="Nie może nikogo dodawać do grupy."},
		{[1]="Może wyrzucać innych z grupy.",[2]="Nie może nikogo wyrzucić."},
		{[1]="Może zmienić tag grupy.",[2]="Nie może zmienić tagu grupy."},
		{[1]="Może sprawdzać statystyki innych osób z grupy.",[2]="Nie może sprawdzać statystyk innych osób z grupy."},
		{[1]="Może nadawać prawa innym osobą z grupy.",[2]="Nie może nadawać praw innym osobą z grupy."},
		{[1]="Może zawierać sojusze z innymi grupami.",[2]="Nie może zawierać sojuszów z innymi grupami."},
		{[1]="Może przeglądać historie aktywności grupy.",[2]="Nie może przeglądać historii aktywności grupy."},
		{[1]="Może zostać wyrzucony, mieć zmienione prawa, range\ntylko przez lidera grupy.",[2]="Może być edytowany przez innych członków grupy\njeśli mają odpowiednie prawa."}
		}
		tlumacz()
		v=guiGetVisible(gui)
		if antiSpam+3000>getTickCount() and not v then
			guiSetVisible(gui,false)
			showCursor(false)
			return outputChatBox(getText("detect","messages","gang_too_fast_2",{{"$time",math.ceil(math.abs(getTickCount()-antiSpam-3000)/1000)}}),255,0,0)
		end
		if not v then
			antiSpam=getTickCount()
		else
			if antiSpam+3000>getTickCount() and not v then
				antiSpam=getTickCount()-3000
			end
		end
		guiSetVisible(dodajgracza,false)
		guiSetVisible(gui,not v)
		guiSetVisible(edytujprawagui,false)
		guiSetVisible(SojuszePanel,false)
		showCursor(not v)
		
		triggerServerEvent("gang:aktualizujmnie",resourceRoot)

		dane=grupa[4]
		guiSetText(gui,getText("detect","messages","gang_title",{{"$gang",grupa[2]},{"$tag",dane["TAG"]},{"$id",grupa[1]}}))
		
		guiSetText(memo,tostring(dane and dane["OPIS"] or ""))
		aktualizujListeGraczy()
	else
		outputChatBox(getText("detect","messages","gang_no_gang",{}),255,0,0)
	end
end
bindKey("f4","down",otworzZamknij)

typakcji={
[1] = "Chat",
[2] = "Edycja informacji",
[3] = "Dodawanie nowej osoby",
[4] = "Usuwanie osoby z grupy",
[5] = "Zmiana tagu",
[6] = "Sprawdzanie informacji",
[7] = "Zmiana uprawnien",
[8] = "Sojusze",
[9] = "Sprawdzanie logow",
[10] = "Ochrona",
[11] = "Usunięcie grupy",
[12] = "Odejście z grupy",
[13] = "Zawarcie sojuszu",
[14] = "Zerwanie sojuszu",

}
			
function pobierzlogi(logi,datatime)
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local monthday = time.monthday
	local month = time.month
	data = month.."-"..monthday.." "..hours.."-"..minutes

	f=fileCreate("logi/"..data..".html")
	code = ""
	grupa = getElementData(localPlayer,"grupa")[2]
	logix = ""
	for i,v in pairs(logi) do
		logix=logix..[[
			<tr bgcolor="#00FFFF">
				<td align="center" valign="center">]]..i..[[</td>
				<td align="center" valign="center">]]..v["Data"]..[[</td>
				<td align="center" valign="center">]]..string.gsub(v["Gracz"],", Serial: .*","")..[[</td>
				<td align="center" valign="center">]]..typakcji[tonumber(v["Typ_Akcji"])]..[[</td>
				<td align="center" valign="center">]]..v["Opis"]..[[</td>
			</tr>
]]
	end
	txt=[[
	<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title></title>
		<script>
			window.addEventListener('load', function(){
				
			});
		</script>
		<style>
			*{
				padding: 0;
				margin: 0;
			}
			td {
				padding: 5px 10px;
				word-break: break-word;
			}
		</style>
	</head>
	<body>
		<TABLE BORDER="0">
			<tbody bgcolor="#FFFF00">
				<tr bgcolor="#FFFF00" align="center"><th colspan="5">        Logi aktywności grupy: ]]..grupa..[[ z dnia: ]]..datatime..[[                </th></tr>
				<tr bgcolor="#00FF00">
					<td align="center" valign="center">ID</td>
					<td align="center" valign="center">Data</td>
					<td align="center" valign="center">Gracz</td>
					<td align="center" valign="center">Co zrobił</td>
					<td align="center" valign="center">Opis</td>
				</tr>
			]]..logix..[[
			</tbody>
		</TABLE>
	</body>
</html>
	]]
	fileWrite(f,txt)
	fileClose(f)
	outputChatBox("Ostatnie 1000 aktywności grupy zostało zapisane do pliku w folderze:",0,255,0)
	outputChatBox("FOLDER_Z_MTA/mods/deathmatch/resources/dayz_grupy/logi/"..data..".html",0,255,0)
	outputChatBox("Plik ten należy otworzyć w przeglądarce",0,255,0)
	
end
addEvent( "grupy:logi", true )
addEventHandler( "grupy:logi",localPlayer,pobierzlogi)

function aktualizujMojeKonto()
	aktualizujListeGraczy()
end
addEvent( "grupy:aktualizuj", true )
addEventHandler( "grupy:aktualizuj",localPlayer,aktualizujMojeKonto)
function wylacz()
	guiSetVisible(dodajgracza,false)
	guiSetVisible(gui,false)
	guiSetVisible(edytujprawagui,false)
	showCursor(false)
end
addEvent( "grupy:wylacz", true )
addEventHandler( "grupy:wylacz",localPlayer,wylacz)

playerBlips = {}
amount = 0
function updateGPS()
	amount = 0
	for i, blip in ipairs(playerBlips) do
		if isElement(blip) then
			destroyElement(blip)
		end
	end
	if not getElementData(localPlayer,"grupa") then return end	
	gangname=getElementData(getLocalPlayer(),"grupa")
	sojusze=getElementData(getLocalPlayer(),"grupa_sojusze")
	playerBlips = {}
	for i, player in ipairs(getElementsByType("player")) do
		if player~=localPlayer then
			grupa=getElementData(player,"grupa")
			if grupa and gangname[1] == grupa[1] then
				amount = amount+1
				playerBlips[amount] = createBlipAttachedTo(player,0,2,22,255,22)
				setBlipVisibleDistance(playerBlips[amount],1000)
			elseif grupa and sojusze[gangname[1]..":"..grupa[1]] then
				amount = amount+1
				playerBlips[amount] = createBlipAttachedTo(player,0,2,22,22,255)
				setBlipVisibleDistance(playerBlips[amount],1000)
			end
		end
	end
end
setTimer(updateGPS,1000,0)
updateGPS()
guiSetInputMode("no_binds_when_editing")
end
addEventHandler("onClientPlayerSpawn",localPlayer,onSpawn)
onSpawn()