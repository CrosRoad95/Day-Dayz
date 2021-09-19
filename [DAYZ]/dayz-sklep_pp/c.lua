function stworzGui()
	gui=guiCreateWindow(0,0,450,350,"Sklep",false)
	opis=guiCreateLabel(0.02,0.68,0.96,0.2,"",true,gui)
	kup=guiCreateButton(0,320,200,25,"Kup",false,gui)
	zamknij=guiCreateButton(250,320,200,25,"Zamknij",false,gui)
	lista=guiCreateGridList(0.02,0.07,0.96,0.60,true,gui)
	guiGridListAddColumn(lista,"Produkt",0.6)
	guiGridListAddColumn(lista,"Cena w PP",0.3)
	guiSetVisible(gui,false)
	center(gui)
end
function center(center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end
stworzGui()
function sklep_pp_pokaz(dane,pp)
	if isCursorShowing() then return end
	guiSetVisible(gui,true)
	guiSetText(gui,"Sklep, posiadasz: "..pp.."pp")
	showCursor(true)
	guiGridListClear(lista)
	for i,v in ipairs(dane) do
		local r=guiGridListAddRow(lista)
		guiGridListSetItemText(lista,r,1,v.nazwa,false,false)
		guiGridListSetItemText(lista,r,2,v.koszt,false,false)
		guiGridListSetItemData(lista,r,1,v.opis)
		guiGridListSetItemData(lista,r,2,v.ID)
	end
end
addEvent("sklep_pp_pokaz",true)
addEventHandler("sklep_pp_pokaz",getRootElement(),sklep_pp_pokaz)
function click()
	if source==zamknij then
		guiSetVisible(gui,false)
		showCursor(false)
	elseif source==kup then
		r,c=guiGridListGetSelectedItem(lista)
		if c>-1 then
			id=guiGridListGetItemData(lista,r,2)
			if id then
				triggerServerEvent("kup_przedmiot",resourceRoot,id)
			end
		end
	elseif source==lista then
		r,c=guiGridListGetSelectedItem(source)
		if c>-1 then
			opiss=guiGridListGetItemData(source,r,1)
			if opiss then
				guiSetText(opis,string.gsub(opiss,"[[][E][]]","\n"))
			else
				guiSetText(opis,"")
			end
		else
			guiSetText(opis,"")
		end
	end
end
addEventHandler("onClientGUIClick",resourceRoot,click)