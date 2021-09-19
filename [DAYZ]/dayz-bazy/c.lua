function getText(lng,typ,data,rpl)
	return exports["dayz-jezyki"]:getText(lng,typ,data,rpl)
end

function xmlSkrzynkiHasla()
	bramyhasla={}
	local xml=xmlLoadFile("bazyhasla.xml")
	if not xml then
		local xml=xmlCreateFile("bazyhasla.xml","xml")
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
		return
	else
		passlist=xmlNodeGetChildren(xml)
		for i,v in ipairs(passlist) do
			val=xmlNodeGetValue(v)
			decode=teaDecode(val,"hasloBazy6953")
			frjs=fromJSON(decode)
			if frjs then
				bramyhasla[frjs[1]..frjs[2]..frjs[3]]=frjs[4]
			end
		end
	end
	xmlUnloadFile(xml)
end
xmlSkrzynkiHasla()
function dodajHasloDoBramy(skrzynka)
	xmlSkrzynkiHasla()
	local xml=xmlLoadFile("bazyhasla.xml")
	local NewNode = xmlCreateChild(xml,"skrzynka")
	xmlNodeSetValue(NewNode,teaEncode(toJSON(skrzynka,true),"hasloBazy6953"),true)
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
	xmlSkrzynkiHasla()
end
function hasloBramy(cmd,dodajhaslo)
	if dodajhaslo then
		local pozycja=getElementData(localPlayer,"haslo_baza")
		if pozycja then
			if string.len(dodajhaslo)>0 and string.len(dodajhaslo)<9 then
				x,y,z=pozycja[1],pozycja[2],pozycja[3]
				dodajHasloDoBramy({x,y,z,dodajhaslo})
				outputChatBox("Hasło zostało pomyślnie zapisane",0,255,0)
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
addCommandHandler("haslo_baza",hasloBramy)
objekty={}
dodatkowozajmuja={}
for i,v in ipairs(getElementData(getRootElement(),"Bazy_objekty")) do
	x1,x2,x3,x4,x5,x6=unpack(split(v.offset,","))
	table.insert(objekty,{v.model,x1,x2,x3,x4,x5,x6,v.przedmiot,v.model,v.wytrzymalosc})
	dodatkowozajmuja[v.model]=v.zajmuje
end

hasloGui = guiCreateWindow (0.45,0.45,0.1,0.1,"Wprowadź hasło",true)
hasloE = guiCreateEdit(0.05,0.2,0.9,0.35,"",true,hasloGui)
guiEditSetMaxLength(hasloE,16)
anulujhaslo = guiCreateButton(0.55,0.6,0.4,0.6,"Anuluj",true,hasloGui)
anulujok = guiCreateButton(0.05,0.6,0.4,0.6,"OK",true,hasloGui)
guiSetVisible(hasloGui,false)

function stworzInformacje()
i=guiCreateLabel(0.68,0.70,0.2,0.2,[[Sterowanie:
A oraz D -- Zmiana objektu który chcesz ustawić.
W -- Włącza/wyłącza przeskakiwanie objektu co 1 metr.
S -- Włącza/wyłącza wspomaganie budowania.
Scroll -- Obracanie objektu.
Z -- Włącza tryb budowania względem zaznaczonego objektu.
C -- Zmienia oś budowania względnego.

Prawy przycisk myszy ( na objekcie ) -- Wyświetla lista akcji.

Spacja -- Stawia objekt.
]],true)
guiSetFont(i,"default-bold-small")
wybr=guiCreateLabel(0.68,0.35,0.2,0.5,"",true)
guiSetFont(wybr,"default-bold-small")

end

function wykonajopcjee()
	if source==anulujhaslo then
		guiSetVisible(hasloGui,false)
	elseif source==anulujok then
		haslo=guiGetText(hasloE)
		if string.len(haslo)>2 then
			triggerServerEvent ("bazy:ustawhaslo",resourceRoot,zaznaczonyobjekt,haslo)
			guiSetVisible(hasloGui,false)
		else
			outputChatBox("Hasło jest za krótkie!",localPlayer)
		end
	end
end
addEventHandler("onClientGUIClick",anulujhaslo,wykonajopcjee)
addEventHandler("onClientGUIClick",anulujok,wykonajopcjee)

function pobierzidprzedmiotu(model)
	for i,v in ipairs(objekty) do
		if v[1]==model then return v[9] end
	end
end

function wykonajopcje()
	wybrane=guiGetText(source)
	if wybrane=="Zniszcz" then
		triggerServerEvent ("bazy:zniszczobjekt",resourceRoot,zaznaczonyobjekt,pobierzidprzedmiotu(getElementModel(zaznaczonyobjekt)))
	elseif wybrane=="Ustaw hasło" then
		guiSetVisible(hasloGui,true)
		guiSetText(hasloE,"")
	elseif wybrane=="Sprawdź stan" then
		stanA,stanB=unpack(getElementData(zaznaczonyobjekt,"hp"))
		outputChatBox("Aktualny stan: "..(stanA or "-").."/"..(stanB or "-").."",0,255,0)
	elseif wybrane=="Napraw" then
		tick=getElementData(zaznaczonyobjekt,"ostatnie_obrazenia")
		if tick then
			if tick+1000*60*5>getTickCount() then
				return outputChatBox("Nie możesz naprawić tego elementu! Był on nie dawno atakowany!",255,0,0)
			end
		end
		if not getElementData(localPlayer,"Toolbox") or getElementData(localPlayer,"Toolbox")<=0 then
			return outputChatBox("Potrzebujesz narzędzi aby naprawić bazę!",255,0,0)
		end
		itemNaprawy=getElementData(zaznaczonyobjekt,"hp_naprawa")
		itemilosc=getElementData(localPlayer,itemNaprawy)
		if itemilosc and itemilosc>0 then
			hp=getElementData(zaznaczonyobjekt,"hp")
			hp[1]=hp[1]+5000
			if hp[1]>hp[2] then
				hp[1]=hp[2]
			end
			setElementData(zaznaczonyobjekt,"hp",hp)
			setElementData(localPlayer,itemNaprawy,itemilosc-1)
			outputChatBox("Częściowo naprawiono pomyślnie!",0,255,0)
		else
			outputChatBox("Potrzebujesz drewna aby naprawić bazę!",255,0,0)
		end
	
	elseif wybrane=="Otwórz" then
		x,y,z=getElementPosition(zaznaczonyobjekt)
		poprawne=getElementData(zaznaczonyobjekt,"Extra")["Haslo"]
		if bramyhasla[x..y..z]==nil then
			setElementData(localPlayer,"haslo_baza",{x,y,z},false)
			return outputChatBox("Nie podałeś hasła do tej bramy! Dodaj ją wpisując komende: haslo_baza [hasło]",255,0,0)
		else
			if tostring(bramyhasla[x..y..z])==tostring(poprawne) then
				triggerServerEvent("bazy:otworzbrame",resourceRoot,zaznaczonyobjekt)
			else
				outputChatBox("Błędne hasło! Popraw je komendą: haslo_baza [hasło]",255,0,0)
			end
		end
	end
end

function aktualizujTekstWybranegoItemu()
	txt=""
	offpos = {0,0,0,0,0,0}
	for i,v in ipairs(objekty) do
		i=#objekty-i+1
		if i==wybranyObjekt then
			txt=v[8].." <===\n"..txt
			setElementModel(object,v[1])
			offpos = {v[2],v[3],v[4],v[5],v[6],v[7]}
		else
			txt=v[8].."\n"..txt
		end
	end
	guiSetText(wybr,txt)
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function resetujPrzyciski()
	for i,v in ipairs(opcja or {}) do
		removeEventHandler("onClientGUIClick",v,wykonajopcje)
		destroyElement(v)
	end
	opcja={}
end

function resetujDane()
	wybranyObjekt=0
	minimum=0
	limit=#objekty
	offpos = {0,0,0,0,0,0}
	obroty = 0
	snap=false
	wspomaganie=false
	nacelowanyObjekt=false
	zaznaczonyobjekt=false
	mozebudowac=false
	budowaniewzgledneOS=false
	resetujPrzyciski()
end
resetujDane()

function budowanieBindy(key)
	if guiGetVisible(hasloGui) then return end
	if key=="a" then
		wybranyObjekt=wybranyObjekt-1
		if wybranyObjekt<minimum then
			wybranyObjekt=limit
		end
		aktualizujTekstWybranegoItemu()
		resetujPrzyciski()
	elseif key=="d" then
		wybranyObjekt=wybranyObjekt+1
		if wybranyObjekt>limit then
			wybranyObjekt=minimum
		end
		aktualizujTekstWybranegoItemu()
		resetujPrzyciski()
	elseif key=="w" then
		if not snap then
			snap=1
		else
			snap=false
		end
	elseif key=="s" then
		wspomaganie=not wspomaganie
	elseif key=="c" then
		budowaniewzgledneOS=not budowaniewzgledneOS
		outputChatBox("Zmieniono oś budowania",0,255,0)
	elseif key=="z" then
		if nacelowanyObjekt then
			outputChatBox("Budowanie względem objektu włączone",0,255,0)
			budowaniewzgledne=nacelowanyObjekt
		else
			outputChatBox("Budowanie względem objektu wyłączone",0,255,0)
			budowaniewzgledne=false
		end
	elseif key=="mouse_wheel_up" then
		obroty=obroty+5
		resetujPrzyciski()
	elseif key=="mouse_wheel_down" then
		obroty=obroty-5
		resetujPrzyciski()
	elseif key=="space" then
		itemname=objekty[limit-wybranyObjekt+1][8]
		iloscitemow=getElementData(localPlayer,itemname)
		if iloscitemow and iloscitemow>0 then
			setElementData(localPlayer,itemname,iloscitemow-1)
			if limitbudowaniaosiagniety then
				return outputChatBox("Limit objektów osiągnięty!",255,0,0)
			end
			local x,y,z = getElementPosition(object)
			local xr,yr,zr = getElementRotation(object)
			triggerServerEvent ("bazy:postawobjekt",resourceRoot,getElementModel(object),x,y,z,xr,yr,zr,objekty[limit-wybranyObjekt+1][9])
			resetujPrzyciski()
		else
			outputChatBox("Nie posiadasz odpowiedniego przedmiotu w ekwipunku aby postawić ten objekt!",255,0,0)
		end
	elseif key=="mouse2" and mozebudowac then
		if not nacelowanyObjekt then
			zaznaczonyobjekt=false
			return outputChatBox("Najedź myszką na objekt który chcesz edytować!",255,0,0)
		end
		zaznaczonyobjekt=nacelowanyObjekt
		if getElementModel(nacelowanyObjekt)==1854 or getElementModel(nacelowanyObjekt)==1855 then
			opcje={"Zniszcz","Ustaw hasło","Otwórz","Sprawdź stan","Napraw"}
		else
			opcje={"Zniszcz","Sprawdź stan","Napraw"}
		end
		x,y=getCursorPosition()
		resetujPrzyciski()
		for i,v in pairs(opcje) do
			opcja[i]=guiCreateButton(x+0.01,y+(i-1)*0.022+0.01,0.08,0.02,v,true)
			setElementData(opcja[i],"opcja",v)
			addEventHandler("onClientGUIClick",opcja[i],wykonajopcje)
		end
	elseif key=="mouse1" then
		setTimer(resetujPrzyciski,100,1)
	end
end

function ileSlotowWymaga(id)
	if dodatkowozajmuja[id] then
		return dodatkowozajmuja[id]
	else
		for ii,vv in ipairs(objekty) do
			if vv[1]==model then
				return 1
			end
		end
	end
end

--[[
function policzObjektyWColizji(kolizja)
	iloscObjektow=0
	for i,v in ipairs(getElementsWithinColShape(kolizja,"object")) do
		if v~=object then
			model=getElementModel(v)
			if dodatkowozajmuja[model] then
				iloscObjektow=iloscObjektow+dodatkowozajmuja[model]
			else
				for ii,vv in ipairs(objekty) do
					if vv[1]==model then
						iloscObjektow=iloscObjektow+1
						break
					end
				end
			end
		end
	end
	return iloscObjektow
end]]

tickAntyLag=getTickCount()
function policzObjektyWColizji(kolizja)
	if tickAntyLag+2000<getTickCount() then
		tickAntyLag=getTickCount()
		iloscObjektow=0
		rozmiar=getElementData(kolizja,"ColBazy")[2]
		x,y,z=getElementPosition(kolizja)
		for i,v in ipairs(getElementsByType("object")) do
			xx,yy,zz=getElementPosition(v)
			dis=getDistanceBetweenPoints3D(x,y,z,xx,yy,zz)
			if dis<rozmiar then
				if v~=object then
					model=getElementModel(v)
					if dodatkowozajmuja[model] then
						iloscObjektow=iloscObjektow+dodatkowozajmuja[model]
					else
						for ii,vv in ipairs(objekty) do
							if vv[1]==model then
								iloscObjektow=iloscObjektow+1
								break
							end
						end
					end
				end
			end
		end
		return iloscObjektow
	end
end

function usunInformacje()
	destroyElement(i)
	destroyElement(wybr)
	guiSetVisible(hasloGui,false)
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function czyMoznaTuStawiac(x,y,z)
	daty=false
	for i,v in ipairs(getElementsByType("bazy")) do
		colbazy=getElementData(v,"ColBazy")
		xa,xb,xc=getElementPosition(v)
		ya,yb,yc=getElementPosition(colbazy[1])
		if x then
			dis=getDistanceBetweenPoints3D(x,y,z,ya,yb,yc)
			if dis<500 then
				ascX,ascY=getScreenFromWorldPosition(ya,yb,yc)
				UID=getElementData(localPlayer,"UID")
				for ii,vv in pairs(getElementData(v,"Dostep")) do
					if tonumber(vv["IDPos"])==tonumber(UID) then
						objektowWKolizjiJest=policzObjektyWColizji(v) or objektowWKolizjiJest
						objektyLimit={objektowWKolizjiJest,getElementData(v,"Limit")}
						if ascX then
							plus=1
							dod=ileSlotowWymaga(getElementModel(object))
							if wybranyObjekt>0 and dod then
								plus=dod
							end
							if objektyLimit and plus and objektyLimit[1] and objektyLimit[2] and objektyLimit[1]+plus>objektyLimit[2] then
								dxDrawText(getElementData(v,"Nazwa").."\n"..objektyLimit[1].."/"..objektyLimit[2].."\nPostawienie tego objektu przekroczyło\nby limit objektów w bazie!",ascX,ascY,0,0,tocolor(0,255,0,255),1.5,"sans")
								limitbudowaniaosiagniety=true
							else
								dxDrawText(getElementData(v,"Nazwa").."\n"..(objektyLimit[1] or "-").."/"..(objektyLimit[2] or "-"),ascX,ascY,0,0,tocolor(0,255,0,255),1.5,"sans")
								limitbudowaniaosiagniety=false
							end
						end
						if dis<colbazy[2] then
							daty=v
						end
						iX,iY,wys=getElementPosition(colbazy[1])
						iiX=false
						for i=0,36 do
							ux,uy=getPointFromDistanceRotation(iX,iY,colbazy[2],10*i)
							if iiX then
								dxDrawLine3D(iiX,iiY,wys+1,ux,uy,wys+1, tocolor ( 255, 0, 0, 230 ),10)
							end
							if i/4==math.floor(i/4) then
								dxDrawLine3D(ux,uy,wys-50,ux,uy,wys+50, tocolor ( 0, 0, 255, 230 ),10)
							end
							iiX,iiY=ux,uy
						end
						break
					end
				end
			end
		end
	end
	if daty then
		return daty
	else
		return false
	end
end
screenX, screenY = guiGetScreenSize()
function renderuj()
	local xcursor,ycursor = getCursorPosition()
	if object and xcursor then
		if budowaniewzgledne then
			wzglX,wzglY,wzglZ=getElementPosition(budowaniewzgledne)
			for i=1,4 do
				wzglXX,wzglYY=getPointFromDistanceRotation(wzglX,wzglY,50,i*90)
				dxDrawLine3D(wzglX,wzglY,wzglZ,wzglXX,wzglYY,wzglZ, tocolor (255, 0, 255, 230 ),10)
			end
		end
		local x,y = xcursor*screenX,ycursor*screenY
		local sX,sY,sZ = getWorldFromScreenPosition(x,y,0)
		local sX2,sY2,sZ2 = getWorldFromScreenPosition(x,y,200)
		local rx,ry,rz = getElementRotation(object)
		local hit,oX,oY,oZ,hitElement = processLineOfSight(sX,sY,sZ,sX2,sY2,sZ2,true,false,false,true,false,true,false,false,object)
		nacelowanyObjekt=hitElement
		st = czyMoznaTuStawiac(oX,oY,oZ)
		if st then
			if wybranyObjekt==0 and nacelowanyObjekt then
				_,_,rot=getElementRotation(nacelowanyObjekt)
				dxDrawText("Obroty: "..math.round(rot),x,y-15)
			elseif wybranyObjekt~=0 then
				colbazy=getElementData(st,"ColBazy")
				dxDrawText("Obroty: "..math.round(rz),x,y-15)
			end
			mozebudowac=true
		else
			dxDrawImage(x-50,y-50,100,100, 'X.png')
			dxDrawText("W tym miejscu nie możesz budować!",x-100,y-80,x+100,y-80,tocolor(255,0,0,255),2,"sans","center","center")
			setElementPosition(object,0,0,-50)
			mozebudowac=false
			return
		end
		if not oX then return end
		if wybranyObjekt==minimum then
			setElementPosition(object,0,0,-100)
			return
		end
		if budowaniewzgledne then
			if snap==1 then
				wzgledneX,wzgledneY,wzgledneZ=getElementPosition(budowaniewzgledne)
				if budowaniewzgledneOS then
					setElementPosition(object,math.floor(oX+offpos[1]),math.floor(wzgledneY),wzgledneZ)
				else
					setElementPosition(object,math.floor(wzgledneX),math.floor(oY+offpos[2]),wzgledneZ)
				end
			else
				wzgledneX,wzgledneY,wzgledneZ=getElementPosition(budowaniewzgledne)
				if budowaniewzgledneOS then
					setElementPosition(object,oX+offpos[1],wzgledneY,wzgledneZ)
				else
					setElementPosition(object,wzgledneX,oY+offpos[2],wzgledneZ)
				end
			end
		elseif not wspomaganie then
			if snap==1 then
				setElementPosition(object,math.floor(oX+offpos[1]),math.floor(oY+offpos[2]),math.ceil(oZ+offpos[3]))
				setElementRotation(object,offpos[4],offpos[5],offpos[6]+obroty)
			else
				setElementPosition(object,oX+offpos[1],oY+offpos[2],oZ+offpos[3])
				setElementRotation(object,offpos[4],offpos[5],offpos[6]+obroty)
			end
		else
			if hitElement then
				x,y,z=getElementPosition(hitElement)
				xr,yr,zr=getElementRotation(hitElement)
				p1x,p1y=getPointFromDistanceRotation(x,y,5,zr)
				p2x,p2y=getPointFromDistanceRotation(x,y,5,zr+90)
				p3x,p3y=getPointFromDistanceRotation(x,y,5,zr+180)
				p4x,p4y=getPointFromDistanceRotation(x,y,5,zr+270)
				dis={getDistanceBetweenPoints3D(x,y,0,p1x,p1y,0),getDistanceBetweenPoints3D(x,y,0,p2x,p2y,0),getDistanceBetweenPoints3D(x,y,0,p3x,p3y,0),getDistanceBetweenPoints3D(x,y,0,p4x,p4y,0)}
				najdalsze=table.sort(dis)
				setElementPosition(object,p1x,p1y,z)
			else
				setElementPosition(object,0,0,-100)
			end
		end
	end
end

function sprawdzPrawa()
	dostep={}
	x,y,z=getElementPosition(localPlayer)
	for i,v in ipairs(getElementsByType("bazy")) do
		colbazy=getElementData(v,"ColBazy")
		ya,yb,yc=getElementPosition(colbazy[1])
		dis=getDistanceBetweenPoints3D(x,y,z,ya,yb,yc)
		if dis<colbazy[2] then
			aktualnabaza=v
		end
		UID=getElementData(localPlayer,"UID")
		qui=false
		for ii,vv in pairs(getElementData(v,"Dostep")) do
			if tonumber(vv["IDPos"])==tonumber(UID) then
				if vv.MozeOtwierac then
					qui=true
				end
			end
		end
		dostep[v]=qui
	end
	return dostep,aktualnabaza
end

function start()
	stworzInformacje()
	dodajBindy()
	resetujDane()
	addEventHandler("onClientRender",root,renderuj)
	object=createObject(1337,0,0,0)
	setElementCollisionsEnabled(object,false)
	--setElementAlpha(object,150)
	aktualizujTekstWybranegoItemu()
end
function usun()
	usunInformacje()
	usunBindy()
	removeEventHandler("onClientRender",root,renderuj)
	if object then
		destroyElement(object)
		object=false
	end
end

przyciskiup = {"A","W","S","D","Z","C","space","mouse1","mouse2"}
przyciskidown={"mouse_wheel_up","mouse_wheel_down"}
function usunBindy()
	for i,v in ipairs(przyciskiup) do
		unbindKey(v,"up",budowanieBindy)
	end
	for i,v in ipairs(przyciskidown) do
		unbindKey(v,"down",budowanieBindy)
	end
end
function dodajBindy()
	for i,v in ipairs(przyciskiup) do
		bindKey(v,"up",budowanieBindy)
	end
	for i,v in ipairs(przyciskidown) do
		bindKey(v,"down",budowanieBindy)
	end
end
renders=false
function rozpocznijBudowe()
	if renders~=isCursorShowing() then
		return outputChatBox("Nope")
	end
	showCursor(not isCursorShowing())
	resetujPrzyciski()
	if isCursorShowing() then
		start()
		renders=true
	else
		usun()
		renders=false
	end
end
bindKey("b","down",rozpocznijBudowe)