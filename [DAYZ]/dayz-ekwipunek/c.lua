--[[setElementData(localPlayer,"M4",4)
setElementData(localPlayer,"GPS",2)
setElementData(localPlayer,"M4 Mag",20)
setElementData(localPlayer,"_Limit_Slotow_",20)]]

function onSpawn()
if not getElementData(localPlayer,"Login") then return false end
removeEventHandler("onClientPlayerSpawn",localPlayer,onSpawn)
function xmlSkrzynkiHasla()
	skrzynkihasla={}
	local xml=xmlLoadFile("skrzynkihasla.xml")
	if not xml then
		local xml=xmlCreateFile("skrzynkihasla.xml","xml")
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
		return
	else
		passlist=xmlNodeGetChildren(xml)
		for i,v in ipairs(passlist) do
			val=xmlNodeGetValue(v)
			decode=teaDecode(val,"hasloSkrzynki6953")
			frjs=fromJSON(decode)
			if frjs then
				skrzynkihasla[frjs[1]..frjs[2]..frjs[3]]=frjs[4]
			end
		end
	end
	xmlUnloadFile(xml)
end
xmlSkrzynkiHasla()
function dodajHasloDoSkrzynki(skrzynka)
	xmlSkrzynkiHasla()
	local xml=xmlLoadFile("skrzynkihasla.xml")
	local NewNode = xmlCreateChild(xml,"skrzynka")
	xmlNodeSetValue(NewNode,teaEncode(toJSON(skrzynka,true),"hasloSkrzynki6953"),true)
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
	xmlSkrzynkiHasla()
end
function hasloSkrzynka(cmd,dodajhaslo)
	if dodajhaslo then
		local loot=isPlayerInLoot()
		if loot then
			if string.len(dodajhaslo)>0 and string.len(dodajhaslo)<9 then
				x,y,z=getElementPosition(loot)
				dodajHasloDoSkrzynki({x,y,z,dodajhaslo})
				outputChatBox(getText("detect","messages","command_haslo_succes",{{"$pass",dodajhaslo}}),0,255,0)
			else
				outputChatBox(getText("detect","messages","command_haslo_pass_needed",{{"$cmd",cmd}}),255,0,0)
			end
		else
			outputChatBox(getText("detect","messages","command_haslo_not_loot",{}),255,0,0)
		end
	else
		outputChatBox(getText("detect","messages","command_haslo_pass_needed",{{"$cmd",cmd}}),255,0,0)
	end
end
addCommandHandler("haslo",hasloSkrzynka)

function getText(lng,typ,data,rpl)
	return exports["dayz-jezyki"]:getText(lng,typ,data,rpl)
end
inventoryItems=getElementData(resourceRoot,"$data_ekwipunek")
przedmiotywaga=getElementData(resourceRoot,"$data_ekwipunek_przedmioty")
pojazdy=getElementData(resourceRoot,"$data_pojazdy_dane")
wszystkie_przedmioty=getElementData(resourceRoot,"$data_przedmioty")
function pobierzConfig()
	local cfg=getElementData(localPlayer,"config")
	if cfg then
		ekwipunek_kolejnosc=cfg["ekwipunek"]["sortowanie"]
		if isTimer(timer) then
			killTimer(timer)
			timer=nil
		end
	end
end
timer=setTimer(pobierzConfig,500,20)
--INVENTORY
local etykieta={}
local gridlist={}
local przyciski={}

okno_ekwipunku=guiCreateWindow(0.15,0.28,0.72,0.63,getText("detect","guitexts","inventory_title",{}) or "",true)

tlo=guiCreateStaticImage(0.01,0.03,1.99,100,"obrazy/tlo.jpg",true,okno_ekwipunku)
etykieta["loot"]=guiCreateLabel(0.06,0.05,0.34,0.09,"Poza ekwipunkiem",true,okno_ekwipunku)
guiLabelSetHorizontalAlign(etykieta["loot"],"center")
guiSetFont(etykieta["loot"],"default-bold-small")
guiLabelSetColor(etykieta["loot"],0,255,0)

etykieta["inventory"]=guiCreateLabel(0.60,0.05,0.34,0.09,"Ekwipunek",true,okno_ekwipunku)
guiLabelSetHorizontalAlign(etykieta["inventory"],"center")
guiSetFont(etykieta["inventory"],"default-bold-small")
guiLabelSetColor(etykieta["inventory"],0,255,0)
guiSetAlpha(tlo,1)
guiSetProperty(tlo,"Disabled","true")

gridlist.loot=guiCreateGridList(0.01,0.1,0.39,0.83,true,okno_ekwipunku)
gridlist.loot_colum=guiGridListAddColumn(gridlist.loot,"Przedmiot",0.7)
gridlist.loot_colum_amount=guiGridListAddColumn(gridlist.loot,"",0.2)

gridlist.inventory=guiCreateGridList(0.60,0.11,0.39,0.83,true,okno_ekwipunku)
gridlist.inventory_colum=guiGridListAddColumn(gridlist.inventory,"Ekwipunek",0.7)
gridlist.inventory_colum_amount=guiGridListAddColumn(gridlist.inventory,"",0.2)

gridlist.crafting=guiCreateGridList(0.01,0.1,0.39,0.83,true,okno_ekwipunku)
gridlist.crafting_colum=guiGridListAddColumn(gridlist.crafting,"Dostępne craftingi - craftuj klikając »»  [ zużywa (wymaga) = otrzymujesz ]",0.9)
guiSetAlpha(gridlist.crafting,1)
guiSetVisible(gridlist.crafting,false)

przyciski.loot=guiCreateButton(0.40,0.17,0.08,0.69,"»»",true,okno_ekwipunku)
przyciski.crafting=guiCreateStaticImage(0.47,0.9,0.06,0.09, "obrazy/crafting.png",true,okno_ekwipunku)
przyciski.inventory=guiCreateButton(0.52,0.17,0.08,0.69,"««",true,okno_ekwipunku)

etykieta.slots=guiCreateLabel(0.62,0.94,0.29,0.04,"",true,okno_ekwipunku)
guiLabelSetHorizontalAlign(etykieta.slots,"center")
guiLabelSetVerticalAlign(etykieta.slots,"center")
guiSetFont(etykieta.slots,"default-bold-small")

etykieta.slots_loot=guiCreateLabel(0.07,0.94,0.29,0.04,"",true,okno_ekwipunku)
guiLabelSetHorizontalAlign(etykieta.slots_loot,"center")
guiLabelSetVerticalAlign(etykieta.slots_loot,"center")
guiSetFont(etykieta.slots_loot,"default-bold-small")

guiSetVisible(okno_ekwipunku,false)

function aktualizujTlumaczenie()
	aktualizujTekstCraftingu()
	aktualizujTlumacz={
	{okno_ekwipunku,getText("detect","guitexts","inventory_title",{})},
	{etykieta["loot"],getText("detect","guitexts","inventory_title_loot",{})},
	{etykieta["inventory"],getText("detect","guitexts","inventory_title_eq",{})},
	}
	for i,v in ipairs(aktualizujTlumacz) do
		guiSetText(v[1],v[2])
	end
end

function showInventory(key,keyState)
	if keyState == "down" then
		if guiGetVisible(okno_ekwipunku)~=isCursorShowing() then
			return outputChatBox("Nope")
		end
		local loot=isPlayerInLoot()
		if loot and guiGetVisible(okno_ekwipunku)==false then
			extra=getElementData(loot,"extra") or {}
			if extra.haslo then
				x,y,z=getElementPosition(loot)
				if skrzynkihasla[x..y..z]==nil then
					return outputChatBox(getText("detect","messages","pass_to_case",{}),255,0,0)
				end
				if tostring(skrzynkihasla[x..y..z])~=tostring(extra.haslo) then
					return outputChatBox(getText("detect","messages","pass_to_case_wrong",{{"$pass",skrzynkihasla[x..y..z]}}),255,0,0)
				end
			end
		end
		guiSetVisible(gridlist.crafting,false)
		guiSetVisible(gridlist.loot,true)
		
		pobierzConfig()
		guiSetVisible(okno_ekwipunku,not guiGetVisible(okno_ekwipunku))
		showCursor(not isCursorShowing())
		refreshInventory()
		if guiGetVisible(okno_ekwipunku) == true then
			onClientOpenInventoryStopMenu()
		else
			hideRightClickInventoryMenu()
			triggerServerEvent("aktualizuj_bronie",getRootElement())
		end
		if loot then
			nazwa=getElementData(loot,"Nazwa")
			refreshLoot(loot,nazwa)
		else
			guiGridListClear(gridlist["loot"])
			guiSetText(etykieta.slots_loot,"")
		end
		aktualizujTlumaczenie()
	end
end
bindKey("j","down",showInventory)

function podnies()
	loot=isPlayerInLoot()
	if loot then
		triggerServerEvent("podnies",resourceRoot,loot)
	end
	aktualnyloot=getElementData(localPlayer,"pickup")
end
bindKey("-","down",podnies)
bindKey("mouse3","down",podnies)

function showInventoryManual()
  guiSetVisible(okno_ekwipunku,not guiGetVisible(okno_ekwipunku))
  showCursor(not isCursorShowing())
  refreshInventory()
  if guiGetVisible(okno_ekwipunku) == true then
    onClientOpenInventoryStopMenu()
  end
end
function hideInventoryManual()
  guiSetVisible(okno_ekwipunku,false)
  showCursor(false)
  hideRightClickInventoryMenu()
end
addEvent("hideInventoryManual",true)
addEventHandler("hideInventoryManual",localPlayer,hideInventoryManual)
function refreshInventoryManual()
  refreshInventory()
end
addEvent("refreshInventoryManual",true)
addEventHandler("refreshInventoryManual",localPlayer,refreshInventoryManual)
function refreshLootManual(loot)
  refreshLoot(loot)
end
addEvent("refreshLootManual",true)
addEventHandler("refreshLootManual",localPlayer,refreshLootManual)
function aktualizujTekstCraftingu()
	craftingi_={}
	crft=getElementData(resourceRoot,"$craftingi")
	for i,v in ipairs(crft) do
		potrzebne={}
		potrzebne_={}
		
		if v.item_1~="" then
			table.insert(potrzebne,getText("detect","items",v.item_1,{}))
			table.insert(potrzebne_,v.item_1)
		end
		if v.item_2~="" then
			table.insert(potrzebne,getText("detect","items",v.item_2,{}))
			table.insert(potrzebne_,v.item_2)
		end
		if v.item_3~="" then
			table.insert(potrzebne,getText("detect","items",v.item_3,{}))
			table.insert(potrzebne_,v.item_3)
		end
		if v.item_4~="" then
			table.insert(potrzebne,getText("detect","items",v.item_4,{}))
			table.insert(potrzebne_,v.item_4)
		end
		otrzymuje={}
		otrzymuje_={}
		if v.otrzymuje_1~="" then
			table.insert(otrzymuje,getText("detect","items",v.otrzymuje_1,{}))
			table.insert(otrzymuje_,v.otrzymuje_1)
		end
		if v.otrzymuje_2~="" then
			table.insert(otrzymuje,getText("detect","items",v.otrzymuje_2,{}))
			table.insert(otrzymuje_,v.otrzymuje_2)
		end
		if v.otrzymuje_3~="" then
			table.insert(otrzymuje,getText("detect","items",v.otrzymuje_3,{}))
			table.insert(otrzymuje_,v.otrzymuje_3)
		end
		if v.otrzymuje_4~="" then
			table.insert(otrzymuje,getText("detect","items",v.otrzymuje_4,{}))
			table.insert(otrzymuje_,v.otrzymuje_4)
		end
		wymaga={}
		wymaga_={}
		if v.wymaga_1 and v.wymaga_1~="" then
			table.insert(wymaga,getText("detect","items",v.wymaga_1,{}))
			table.insert(wymaga_,v.wymaga_1)
		end
		if v.wymaga_2 and v.wymaga_2~="" then
			table.insert(wymaga,getText("detect","items",v.wymaga_2,{}))
			table.insert(wymaga_,v.wymaga_2)
		end
		craftingi_[v.ID]={potrzebne=potrzebne,potrzebne_=potrzebne_,otrzymuje=otrzymuje,otrzymuje_=otrzymuje_,wymaga=wymaga,wymaga_=wymaga_}
	end
end
function refreshInventory()
	gridIt=gridlist["inventory"]
	local r,c=guiGridListGetSelectedItem(gridIt)
	guiGridListClear(gridIt)
	if ekwipunek_kolejnosc then
		u=0
		for o,p in ipairs(ekwipunek_kolejnosc) do
			for i,v in pairs(inventoryItems) do
				if i==p[1] then
					local r=guiGridListAddRow(gridIt)
					guiGridListSetItemText(gridIt,r,1,"-> "..getText("detect","guitexts",i,{}),true,false)
					for ii,vv in pairs(v) do
						if p[2]=="" and type(vv[1])=="string" then
							item=getElementData(localPlayer,vv[1])
							if item and item >= 1 then
								local r=guiGridListAddRow(gridIt)
								guiGridListSetItemText(gridIt,r,1,getText("detect","items",vv[1],{}),false,false)
								guiGridListSetItemText(gridIt,r,2,item,false,false)
								guiGridListSetItemData(gridIt,r,1,vv[1])
							end
						end
						if ii==p[2] then
							if type(ii)=="string" then
								local r=guiGridListAddRow(gridIt)
								guiGridListSetItemText(gridIt,r,1,"     -> "..getText("detect","guitexts",ii,{}),true,false)
							end
							for iii,vvv in pairs(vv) do
								if vvv[1] then
									item=getElementData(localPlayer,vvv[1])
									if item and item >= 1 then
										local r=guiGridListAddRow(gridIt)
										guiGridListSetItemText(gridIt,r,1,getText("detect","items",vvv[1],{}),false,false)
										guiGridListSetItemText(gridIt,r,2,item,false,false)
										guiGridListSetItemData(gridIt,r,1,vvv[1])
									end
								end
							end
						end
					end
					break
				end
			end
		end
	end
	setTimer(function(r,c,gridIt)
		if r and c and gridIt then
			guiGridListSetSelectedItem(gridIt,r,c)
		end
	end,50,1,r,c,gridIt)
	guiSetText(etykieta["slots"],getText("detect","guitexts","slots",{})..": "..getPlayerCurrentSlots().." / "..getPlayerMaxAviableSlots())
end
function refreshLoot(loot,gearName)
	local gridIt=gridlist["loot"]
	if not loot or loot == false or not getElementData(loot,"itemloot") then
		guiGridListClear(gridIt)
		guiSetText(etykieta["loot"],getText("detect","guitexts","empty",{}))
		return
	end
	local r,c=guiGridListGetSelectedItem(gridIt)
	guiGridListClear(gridIt)
	if ekwipunek_kolejnosc then
		u=0
		for o,p in ipairs(ekwipunek_kolejnosc) do
			for i,v in pairs(inventoryItems) do
				if i==p[1] then
					local r=guiGridListAddRow(gridIt)
					guiGridListSetItemText(gridIt,r,1,"-> "..getText("detect","guitexts",i,{}),true,false)
					for ii,vv in pairs(v) do
						if p[2]=="" and type(vv[1])=="string" then
							item=getElementData(loot,vv[1])
							if item and item >= 1 then
								local r=guiGridListAddRow(gridIt)
								guiGridListSetItemText(gridIt,r,1,getText("detect","items",vv[1],{}),false,false)
								guiGridListSetItemText(gridIt,r,2,item,false,false)
								guiGridListSetItemData(gridIt,r,1,vv[1])
							end
						end
						if ii==p[2] then
							if type(ii)=="string" then
								local r=guiGridListAddRow(gridIt)
								guiGridListSetItemText(gridIt,r,1,"     -> "..getText("detect","guitexts",ii,{}),true,false)
							end
							for iii,vvv in pairs(vv) do
								if vvv[1] then
									item=getElementData(loot,vvv[1])
									if item and item >= 1 then
										local r=guiGridListAddRow(gridIt)
										guiGridListSetItemText(gridIt,r,1,getText("detect","items",vvv[1],{}),false,false)
										guiGridListSetItemText(gridIt,r,2,item,false,false)
										guiGridListSetItemData(gridIt,r,1,vvv[1])
									end
								end
							end
						end
					end
					break
				end
			end
		end
	end
	setTimer(function(r,c,gridIt)
		if r and c and gridIt then
			guiGridListSetSelectedItem(gridIt,r,c)
		end
	end,50,1,r,c,gridIt)
	guiSetText(etykieta["slots_loot"],getText("detect","guitexts","slots",{})..": "..getLootCurrentSlots(loot).." / "..(getLootMaxAviableSlots(loot)or 0))
end

function getPlayerMaxAviableSlots()
return getElementData(localPlayer,"_Limit_Slotow_")
end

function getLootMaxAviableSlots(loot)
return getElementData(loot,"_Limit_Slotow_")
end

function getPlayerCurrentSlots()
	local zajecieEkwipunku=0
	for i,v in pairs(przedmiotywaga) do
		item=getElementData(localPlayer,i)
		if item and item >= 1 then
			zajecieEkwipunku=zajecieEkwipunku+v*item
		end
	end
    return zajecieEkwipunku
end

function isPlayerInLoot()
	if getPedOccupiedVehicle(localPlayer) then return false end
	if getElementData(localPlayer,"Loot") then
		local lootelement=getElementData(localPlayer,"AktualnyLoot")
		if isElement(lootelement) then
			x,y,z=getElementPosition(lootelement)
			xx,yy,zz=getElementPosition(localPlayer)
			if getDistanceBetweenPoints3D(x,y,z,xx,yy,zz)>5 then
				setElementData(localPlayer,"Loot",false)
				setElementData(localPlayer,"AktualnyLoot",false)
				return false
			end
			return lootelement
		else
			return false
		end
	end
	return false
end


function getLootCurrentSlots(loot)
	local zajecieEkwipunku=0
	for i,v in pairs(przedmiotywaga) do
		item=getElementData(loot,i)
		if item and item >= 1 then
			zajecieEkwipunku=zajecieEkwipunku+v*item
		end
	end
    return zajecieEkwipunku
end

function getItemSlots(itema)
	return przedmiotywaga[itema]
end

function isToolbeltItem(itema)
local current_SLOTS=0
    for id,item in ipairs(inventoryItems["Toolbelt"]) do
        if itema == item[1] then 
            return true
        end
    end 
    return false
end

function onPlayerMoveItemOutOfInventory()
	local przedmiot=guiGridListGetItemData(gridlist["inventory"],guiGridListGetSelectedItem(gridlist["inventory"]),1)
	if przedmiot and getElementData(localPlayer,przedmiot) and getElementData(localPlayer,przedmiot) >= 1 then
		loot=isPlayerInLoot()
		if loot and getElementData(loot,"_Limit_Slotow_") then
			triggerServerEvent("przeniesPrzedmiotDoLootu",resourceRoot,loot,przedmiot)
		else
			triggerServerEvent("wyrzuc",resourceRoot,przedmiot)
		end
	else
		outputChatBox(getText("detect","messages","error",{}),255,0,0)
	end
end
addEventHandler("onClientGUIClick",przyciski["inventory"],onPlayerMoveItemOutOfInventory)

function onPlayerMoveItemInInventory()
	if guiGetVisible(gridlist["loot"]) then
		loot=isPlayerInLoot()
		if loot then
			local przedmiot=guiGridListGetItemData(gridlist["loot"],guiGridListGetSelectedItem(gridlist["loot"]),1)
			if getElementData(loot,przedmiot) and getElementData(loot,przedmiot) >= 1 then
				triggerServerEvent("przeniesPrzedmiotDoEkwipunku",resourceRoot,loot,przedmiot)
			end
		end
	elseif guiGetVisible(gridlist.crafting) then
		local crafting=guiGridListGetItemData(gridlist.crafting,guiGridListGetSelectedItem(gridlist.crafting),1)
		if crafting then
			local potrzeba={}
			local wymaga={}
			local otrzyma={}
			local otrzyma_={}
			for i,v in ipairs(crafting.potrzebne_) do
				if potrzeba[v] then
					potrzeba[v]=potrzeba[v]+1
				else
					potrzeba[v]=1
				end
			end
			for i,v in ipairs(crafting.wymaga_) do
				if wymaga[v] then
					wymaga[v]=wymaga[v]+1
				else
					wymaga[v]=1
				end
			end
			for i,v in ipairs(crafting.otrzymuje_) do
				if otrzyma[v] then
					otrzyma[v]=otrzyma[v]+1
				else
					otrzyma[v]=1
				end
			end
			for i,v in ipairs(crafting.otrzymuje) do
				if otrzyma_[v] then
					otrzyma_[v]=otrzyma_[v]+1
				else
					otrzyma_[v]=1
				end
			end
			for i,v in pairs(potrzeba) do
				if getElementData(localPlayer,i)<v then
					return outputChatBox(getText("detect","messages","crafting_not_enough_items",{{"$item",getText("detect","items",i,{})}}),255,0,0)
				end
			end
			for i,v in pairs(wymaga) do
				if getElementData(localPlayer,i)<v then
					return outputChatBox(getText("detect","messages","crafting_not_enough_items_needed",{{"$item",getText("detect","items",i,{})}}),255,0,0)
				end
			end
			txtotrzyma={}
			for i,v in pairs(otrzyma_) do
				table.insert(txtotrzyma,i.." x"..v)
			end
			for i,v in pairs(potrzeba) do
				ilosc=getElementData(localPlayer,i)
				setElementData(localPlayer,i,ilosc-v)
			end
			for i,v in pairs(otrzyma) do
				ilosc=getElementData(localPlayer,i)
				setElementData(localPlayer,i,ilosc+v)
			end
			refreshInventory()
			return outputChatBox(getText("detect","messages","crafting_succes",{{"$items",table.concat(txtotrzyma,", ")}}),0,255,0)
		else
			outputChatBox(getText("detect","messages","select_crafting",{}),255,0,0)
		end
	end
end
addEventHandler("onClientGUIClick",przyciski["loot"],onPlayerMoveItemInInventory)

function pokazCrafting() -- data= craftingi
	vis=guiGetVisible(gridlist.crafting)
	if vis then
		guiSetVisible(gridlist.crafting,false)
		guiSetVisible(gridlist.loot,true)
	else
		guiSetVisible(gridlist.crafting,true)
		guiSetVisible(gridlist.loot,false)
		guiBringToFront(gridlist.crafting)
		guiGridListClear(gridlist.crafting)
		for i,v in ipairs(craftingi_) do
			local r=guiGridListAddRow(gridlist.crafting)
			guiGridListSetItemText(gridlist.crafting,r,1,table.concat(v.potrzebne,"+").." ("..table.concat(v.wymaga,"+")..") = "..table.concat(v.otrzymuje,","),false,false)
			guiGridListSetItemData(gridlist.crafting,r,1,v)
		end
	end
end
addEventHandler("onClientGUIClick",przyciski["crafting"],pokazCrafting,false)

function onClientOpenInventoryStopMenu()
	triggerEvent("disableMenu",localPlayer)
end

function onPlayerPressRightKeyInInventory()
	local itemName=guiGridListGetItemData(gridlist.inventory,guiGridListGetSelectedItem(gridlist.inventory),1)
	local opcja=getInventoryInfosForRightClickMenu(itemName)
	if isCursorShowing() and guiGetVisible(okno_ekwipunku) and opcja then
		showRightClickInventoryMenu(itemName,opcja)
	end
end
bindKey("mouse2","down",onPlayerPressRightKeyInInventory)

function getInventoryInfosForRightClickMenu(itemName)
	for i,v in pairs(wszystkie_przedmioty) do
		if i==itemName then
			opcja=v.Opcje
			if opcja=="" then
				return false
			else
				return opcja
			end
		end
	end
end

rightclickWindow=guiCreateStaticImage(0,0,0.05,0.0215,"obrazy/rcmenu.png",true)
etykieta.rightclickmenu=guiCreateLabel(0,0,1,1,"",true,rightclickWindow)
guiLabelSetHorizontalAlign(etykieta.rightclickmenu,"center")
guiLabelSetVerticalAlign(etykieta.rightclickmenu,"center")
guiSetFont(etykieta.rightclickmenu,"default-bold-small")
guiSetVisible(rightclickWindow,false)

function showRightClickInventoryMenu(itemName,itemInfo)
	if itemInfo then
		local screenx,screeny,worldx,worldy,worldz=getCursorPosition()
		guiSetVisible(rightclickWindow,true)
		guiSetText(etykieta.rightclickmenu,getText("detect","guitexts",itemInfo,{}))
		local whith=guiLabelGetTextExtent(etykieta.rightclickmenu)
		guiSetPosition(rightclickWindow,screenx,screeny,true)
		local x,y=guiGetSize(rightclickWindow,false)
		guiSetSize(rightclickWindow,whith,y,false)
		guiBringToFront(rightclickWindow)
		setElementData(rightclickWindow,"iteminfo",{itemName,itemInfo},false)
	end
end

function hideRightClickInventoryMenu()
  guiSetVisible(rightclickWindow,false)
end
function onPlayerClickOnRightClickMenu(button,state)
  if button == "left" then
    local itemName,itemInfo=getElementData(rightclickWindow,"iteminfo")[1],getElementData(rightclickWindow,"iteminfo")[2]
    hideRightClickInventoryMenu()
    playerUseItem(itemName,itemInfo)
  end
end
addEventHandler("onClientGUIClick",etykieta.rightclickmenu,onPlayerClickOnRightClickMenu,false)

function doubleClick(button)
	if button=="left" then
		local config=getElementData(localPlayer,"config")
		if config and config["options"] and config["options"][2] then
			if config["options"][2]=="1" then
				local itemName=guiGridListGetItemData(gridlist.inventory,guiGridListGetSelectedItem(gridlist.inventory),1)
				local opcja=getInventoryInfosForRightClickMenu(itemName)
				if isCursorShowing() and guiGetVisible(okno_ekwipunku) and opcja then
					playerUseItem(itemName,opcja)
				end
			end
		end
	end
end
addEventHandler("onClientGUIDoubleClick",gridlist.inventory,doubleClick,false)

function remoteUseItem(itemName)
	local opcja=getInventoryInfosForRightClickMenu(itemName)
	if not guiGetVisible(okno_ekwipunku) and opcja then
		playerUseItem(itemName,opcja)
	end
end
function isInventoryVisible()
	return guiGetVisible(okno_ekwipunku)
end

function bindItem(key)
	if guiGetVisible(okno_ekwipunku) then
		local slot=tonumber(key)
		if not slot then return end
		slot=slot-1
		local pasek=(getElementData(localPlayer,"pasek_szybkiego_wyboru") or {})
		if getKeyState("lshift") then
			pasek[slot]=nil
			--outputChatBox("Przedmiot został usunięty z slotu "..slot.."!",0,255,0)
		else
			local itemName=guiGridListGetItemData(gridlist.inventory,guiGridListGetSelectedItem(gridlist.inventory),1)
			if itemName then
				pasek[slot]=itemName
				--outputChatBox("Przedmiot został ustawiony na slot "..slot.."!",0,255,0)
			end
		end
		setElementData(localPlayer,"pasek_szybkiego_wyboru",pasek)
	end
end
bindKey("1","down",bindItem)
bindKey("2","down",bindItem)
bindKey("3","down",bindItem)
bindKey("4","down",bindItem)
bindKey("5","down",bindItem)

end
addEventHandler("onClientPlayerSpawn",localPlayer,onSpawn)
onSpawn()