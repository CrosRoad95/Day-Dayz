gridlist = {}
window = {}
button = {}
edit = {}
memo = {}
admin="Pomoc Administracji"
window[1] = guiCreateWindow(0, 0, 764, 587, "Prywatny chat F2", false)
guiSetVisible(window[1],false)
guiWindowSetSizable(window[1], false)

gridlist[1] = guiCreateGridList(529, 26, 225, 551, false, window[1])
guiGridListSetSortingEnabled(gridlist[1],false)
guiGridListAddColumn(gridlist[1], "Kontakty", 0.9)
memo[1] = guiCreateMemo(11, 25, 504, 477, "", false, window[1])
guiMemoSetReadOnly(memo[1],true)
edit[1] = guiCreateEdit(11, 507, 442, 37, "", false, window[1])
guiEditSetMaxLength(edit[1],255)
button[1] = guiCreateButton(458, 507, 57, 37, "Wyślij\n[Enter]", false, window[1])
function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end
centerWindow(window[1])
function aktualizujKontakty()
	lista={}
	--[[for i,v in ipairs(getElementsByType("player")) do
		if getElementData(v,"Support") then
			if lista[admin] then
				lista[admin]=table.insert(lista[admin],{v,getElementData(localPlayer,"PW:SUPPORT_TEAM") or ""})
			else
				lista[admin]={v,getElementData(localPlayer,"PW:"..getPlayerName(v)) or ""}
			end
		end
	end]]
	for i,v in ipairs(getElementsByType("player")) do
		if v~=localPlayer then
			--if not getElementData(v,"Support") then
			lista[getPlayerName(v)]={v,getElementData(localPlayer,"PW:"..getPlayerName(v)) or ""}
			--end
		end
	end
	
end

prywatnyChat={}

function odeslij (plr,txt)
	sel = guiGridListGetItemText(gridlist[1],guiGridListGetSelectedItem(gridlist[1]),1)
	prywatnyChat[plr]=txt
    if sel==plr or sel==getPlayerName(localPlayer) then
		prywatnyChat[plr]=txt
		guiSetText(memo[1],txt)
	end
	if not guiGetVisible(window[1]) then
		outputChatBox("Otrzymałeś nową wiadomość od "..plr,0,255,0)
	end
end
addEvent( "PrywatnyChat:odeslij", true )
addEventHandler( "PrywatnyChat:odeslij", localPlayer, odeslij)

function aktualizujo(t)
	prywatnyChat = t
end
addEvent( "PrywatnyChat:aktualizuja", true )
addEventHandler( "PrywatnyChat:aktualizuja", localPlayer, aktualizujo)

function wyswietlKontakty()
	guiGridListClear(gridlist[1])
	for i,v in pairs(lista) do
		if i==admin then
			r=guiGridListAddRow(gridlist[1])
			guiGridListSetItemText(gridlist[1],r,1,i,false,false)
			r=guiGridListAddRow(gridlist[1])
			guiGridListSetItemText(gridlist[1],r,1,"",false,false)
			if v[2] then
				guiGridListSetItemColor(gridlist[1],r-1,1,0,255,0)
			end
		else
			r=guiGridListAddRow(gridlist[1])
			guiGridListSetItemText(gridlist[1],r,1,i,false,false)
			if v[2] then
				guiGridListSetItemColor(gridlist[1],r,1,0,255,0)
			end
		end
	end
end

function wyslijWiadomosc(key,d)
	if d then return end
	if key and key~="enter" then return end
	if guiGetVisible(window[1])==true then
		txt=guiGetText(edit[1])
		if string.len(txt)>0 and string.len(txt)<255 then
			sel = guiGridListGetItemText(gridlist[1],guiGridListGetSelectedItem(gridlist[1]),1)
			if sel=="" then
				outputChatBox("Zaznacz do kogo chcesz wysłać wiadomość!")
				return
			end
			triggerServerEvent("PrywatnyChat:wiadomosc",resourceRoot,sel,txt)
			guiSetText(edit[1],"")
		else
			outputChatBox("Twoja wiadomość jest za dług lub za krótka!",255,0,0)
		end
		return true
	end
	return false
end

function click()
	if source==gridlist[1] then
		row,column = guiGridListGetSelectedItem(source)
		sell=guiGridListGetItemText(source,row,column,1)
		if sell==admin then
			guiSetText(memo[1],prywatnyChat[getPlayerName(localPlayer)] or "")
			return
		end
		if sell~="" then
			guiSetText(memo[1],prywatnyChat[getPlayerName(localPlayer).." : "..sell] or "")
		else
			guiSetText(memo[1],"")
		end
		return
	elseif source==button[1] then
		wyslijWiadomosc()
	end
end
addEventHandler ( "onClientGUIClick",window[1],click)

function wlaczWylacz()
	vis = guiGetVisible(window[1])
	guiSetVisible(window[1],not vis)
	showCursor(not vis)
	if not vis then
		guiSetInputMode("no_binds_when_editing")
		aktualizujKontakty()
		wyswietlKontakty()
		triggerServerEvent("PrywatnyChat:aktualizuj",resourceRoot)
	end
end
bindKey("F2","down",wlaczWylacz)
addEventHandler ( "onClientKey",getRootElement(),wyslijWiadomosc)