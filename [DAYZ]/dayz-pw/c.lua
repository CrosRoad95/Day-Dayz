gridlist = {}
window = {}
button = {}
edit = {}
memo = {}
nieodczytane={}
admin="Pomoc Administracji"
window[1] = guiCreateWindow(50, 50, 764, 587, "Prywatny chat F2", false)
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
--button[2] = guiCreateButton(10, 547, 135, 30, "Zgłoś naruszenie zasad - nieaktywne", false, window[1])

function aktualizujKontakty()
	lista={}
	for i,v in ipairs(getElementsByType("player")) do
		--if v~=localPlayer then
			lista[getPlayerName(v)]={v,getElementData(localPlayer,"PW:"..getPlayerName(v)) or ""}
		--end
	end
end
prywatnyChat={}

function aktualizujWiadomosc(plr,txt)
	sel = guiGridListGetItemData(gridlist[1],guiGridListGetSelectedItem(gridlist[1]),1)
    if sel==plr or sel==getPlayerName(localPlayer) then
		guiSetText(memo[1],txt or "")
	end
end
addEvent( "PrywatnyChat:odeslijj", true )
addEventHandler( "PrywatnyChat:odeslijj", localPlayer,aktualizujWiadomosc)

function odeslij (plr,txt)
	sel = guiGridListGetItemData(gridlist[1],guiGridListGetSelectedItem(gridlist[1]),1)
	prywatnyChat[plr]=txt
    if sel==plr or sel==getPlayerName(localPlayer) then
		prywatnyChat[plr]=txt
		guiSetText(memo[1],txt)
	end
	if not guiGetVisible(window[1]) then
		nieodczytane[plr]=true
		outputChatBox("Otrzymałeś prywatna wiadomość od "..plr.." - nacisnij F2 by odczytac",0,255,0)
	end
end
addEvent( "PrywatnyChat:odeslij", true )
addEventHandler( "PrywatnyChat:odeslij", localPlayer, odeslij)

function aktualizujo(t)
	prywatnyChat=t
end
addEvent( "PrywatnyChat:aktualizuja", true )
addEventHandler( "PrywatnyChat:aktualizuja", localPlayer, aktualizujo)

function wyswietlKontakty()
	guiGridListClear(gridlist[1])
	for i,v in pairs(lista) do
		r=guiGridListAddRow(gridlist[1])
		guiGridListSetItemText(gridlist[1],r,1,skipColorCode(i),false,false)
		guiGridListSetItemData(gridlist[1],r,1,i)
		if nieodczytane[i] then
			guiGridListSetItemColor(gridlist[1],r,1,0,255,0)
		end
	end
end

function wyslijWiadomosc(key,d)
	if d then return end
	if key and key~="enter" then return end
	if guiGetVisible(window[1])==true then
		txt=guiGetText(edit[1])
		if string.len(txt)>0 and string.len(txt)<255 then
			sel = guiGridListGetItemData(gridlist[1],guiGridListGetSelectedItem(gridlist[1]),1)
			if sel=="" then
				outputChatBox("Zaznacz do kogo chcesz wysłać wiadomość!")
				return
			end
			triggerServerEvent("PrywatnyChat:wiadomosc",resourceRoot,sel,txt)
			guiSetText(edit[1],"")
		else
		    if not isChatBoxInputActive then 
				outputChatBox("Twoja wiadomość jest za dług lub za krótka!",255,0,0)
				return
			end
		end
		return true
	end
	return false
end

function click()
	if source==gridlist[1] then
		row,column = guiGridListGetSelectedItem(source)
		sel = guiGridListGetItemData(gridlist[1],row,column,1)
		if row<=-1 then
			guiSetText(memo[1],"")
			return
		else
			triggerServerEvent("PrywatnyChat:pobierzwiadomosc",resourceRoot,sel)
		end
		if nieodczytane[sel] then
			guiGridListSetItemColor(gridlist[1],row,column,255,255,255)
			nieodczytane[sel]=nil
		end
		return
	elseif source==button[1] then
		wyslijWiadomosc()
	end
end
addEventHandler ( "onClientGUIClick",window[1],click)

function wlaczWylacz()
	if guiGetVisible(window[1])~=isCursorShowing() then return outputChatBox("Nope") end
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

function skipColorCode(s)
	return string.gsub(s,"(#%x%x%x%x%x%x)","")
end	

addEventHandler("onClientResourceStart", getResourceRootElement(),
function()
	guiSetInputMode("no_binds_when_editing")
end)