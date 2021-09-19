function admin(plr)
	local accName = getAccountName ( getPlayerAccount ( plr ) )
	if not accName then return true end
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
		return false
	else
		return true
	end
end

local fonts = { [ "default" ] = true, [ "default-bold" ] = true,[ "clear" ] = true,[ "arial" ] = true,[ "sans" ] = true,
	  [ "pricedown" ] = true, [ "bankgothic" ] = true,[ "diploma" ] = true,[ "beckett" ] = true
};
function dxDraw3DText( text, x, y, z, scale, font, r, g, b, maxDistance )
	-- checking required arguments
	assert( type( text ) == "string", "Bad argument @ dxDraw3DText" );
	assert( type( x ) == "number", "Bad argument @ dxDraw3DText" );
	assert( type( y ) == "number", "Bad argument @ dxDraw3DText" );
	assert( type( z ) == "number", "Bad argument @ dxDraw3DText" );
	-- checking optional arguments
	if not scale or type( scale ) ~= "number" or scale <= 0 then
		scale = 2
	end
	if not font or type( font ) ~= "string" or not fonts[ font ] then
		font = "default"
	end
	if not r or type( r ) ~= "number" or r < 0 or r > 255 then
		r = 255
	end
	if not g or type( g ) ~= "number" or g < 0 or g > 255 then
		g = 255
	end
	if not b or type( b ) ~= "number" or b < 0 or b > 255 then
		b = 255
	end
	if not maxDistance or type( maxDistance ) ~= "number" or maxDistance <= 1 then
		maxDistance = 12
	end
	local textElement = createElement( "text" );
	-- checking if the element was created
	if textElement then 
		-- setting the element datas
		setElementData( textElement, "text", text );
		setElementData( textElement, "x", x );
		setElementData( textElement, "y", y );
		setElementData( textElement, "z", z );
		setElementData( textElement, "scale", scale );
		setElementData( textElement, "font", font );
		setElementData( textElement, "rgba", { r, g, b, 255 } );
		setElementData( textElement, "maxDistance", maxDistance );
		-- returning the text element
		return textElement
	end
	-- returning false in case of errors
	return false
end
function getPlayerFromPartialName(name,bol)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
				if admin(player) and bol then
					return false
				else
					return player
				end
            end
        end
    end
end

typyAut={["automobile"]=true,["plane"]=true,["bike"]=true,["helicopter"]=true,["boat"]=true,["train"]=true,["trailer"]=true,["bmx"]=true,["quad"]=true}
function dodajSpawn_pojazdy(plr,cmd,typ)
	if admin(plr) then return end
	x,y,z=getElementPosition(plr)
	_,_,rz=getElementRotation (plr)
	if typ and typyAut[string.lower(typ)] then
		exports.db:zapytanie("insert into Pojazdy_spawny (x,y,z,rx,typ)values(?,?,?,?,?)",x,y,z,rz,string.lower(typ))
		outputChatBox("Spawn dodany pomyślnie",plr,0,255,0)
	else
		outputChatBox("Zły typ pojazdu, dostępne:",plr,255,0,0)
		outputChatBox("automobile, plane, bike, helicopter, boat, train, trailer, bmx, quad",plr,255,0,0)
	end
end
addCommandHandler("spawn_pojazd",dodajSpawn_pojazdy)
function heal(plr,cmd,typ)
	if admin(plr) then return end
	outputChatBox("Uleczono",plr,0,255,0)
	setElementData(plr,"_Krew_",12000)
	setElementData(plr,"_Temperatura_",3660)
	setElementData(plr,"_Glod_",100)
	setElementData(plr,"_Pragnienie_",100)
	setElementData(plr,"_Krwawienie_",0)
	setElementData(plr,"_Zlamana_Kosc_",false)
	setElementData(plr,"_Bol_Glowy_",false)
end
addCommandHandler("heal",heal)
function wh(plr,cmd,typ)
	if admin(plr) then return end
	outputChatBox("wh włączono/wyłączono",plr,0,255,0)
	setElementData(plr,"SupportStatus",not getElementData(plr,"SupportStatus"))
end
addCommandHandler("wh",wh)
function usunwraki(plr,cmd)
	if admin(plr) then return end
	outputChatBox("Wraki usunięto",plr,0,255,0)
	for i,v in ipairs(getElementsByType("vehicle")) do
		if getElementHealth(v)<100  or isElementInWater(v) then 
			parent=getElementData(v,"parent")
			if parent then
				destroyElement(parent)
			end
			destroyElement(v)
		end
	end
end
addCommandHandler("usunwraki",usunwraki)
function pojazd(plr,cmd,typ,tpdomnie)
	if admin(plr) then return end
	if typ=="auta" or typ=="helki" or typ=="lodzie" then
		auto=exports["dayz-pojazdy"]:stworzTypPojazdu(typ)
		if auto then
			outputChatBox("Nowe auto dodane!",plr,0,255,0)
		else
			outputChatBox("Nie znaleziono miejsca w którym auto mogłoby bezpiecznie się pojawić, spróbuj ponownie",plr,255,0,0)
		end
	else
		outputChatBox("Błąd, zły typ pojazdu, dostępne: auta,helki,lodzie, drugi argument=1 powoduje że pojazd pojawia się na tobie",plr,255,0,0)
	end
end
addCommandHandler("pojazd",pojazd)
function pos(plr)
	if admin(plr) then return end
	outputChatBox(table.concat({getElementPosition(plr)},","),plr,0,255,0)
end
addCommandHandler("pos",pos)
function dodajcrashsity(plr)
	if admin(plr) then return end
	x,y,z=getElementPosition(plr)
	exports.db:zapytanie("insert into Crashsity values(null,?,?,?,?)",x,y,z,getPedRotation(plr))
	outputChatBox("*Dodano",plr,0,255,0)
end
addCommandHandler("crashsite",dodajcrashsity)
function ukryj(plr,cmd,b)
	if admin(plr) then return end
	if b=="on" then
		setElementData(plr,"UKRYTY",true,true)
		outputChatBox("Zostałeś ukryty!",plr)
	elseif b=="off" then
		setElementData(plr,"UKRYTY",false,true)
		outputChatBox("Już nie jesteś ukryty!",plr)
	end
end
addCommandHandler("ukryj",ukryj)

function nieskonczoneitemy(plr,cmd,ilosc)
	if admin(plr) then return end
	if ilosc and tonumber(ilosc) then
		ilosc=tonumber(ilosc)
		q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
		for i,v in ipairs(q) do
			setElementData(plr,v.Wartosc,ilosc)
		end
		outputChatBox("Otrzymałeś wszystkich przedmiotów po "..ilosc,plr,0,255,0)
	else
		outputChatBox("Podaj ilość!",plr,255,0,0)
	end
end
addCommandHandler("nieskoczoneitemy",nieskonczoneitemy)

function chglog(plr,cmd,...)
	if admin(plr) then return end
	zmiana=table.concat({...}," ")
	exports.db:zapytanie("INSERT INTO `Changelog` (`ID`, `data`, `tresc`) VALUES (NULL, CURRENT_TIMESTAMP,?);",zmiana)
	outputChatBox("*Dodano",plr,0,255,0)
end
addCommandHandler("chglog",chglog)

function usunlooty(plr,cmd,odleglosc)
	if admin(plr) then return end
	if not odleglosc or not tonumber(odleglosc) or tonumber(odleglosc)>50 or tonumber(odleglosc)<0 then
		return outputChatBox("Błąd, popraw na: /"..cmd.." odległość(0-50f)",plr,255,0,0)
	else
		odleglosc=tonumber(odleglosc)
	end
	ilosc=0
	x1,y1,z1=getElementPosition(plr)
	for i,v in ipairs(getElementsByType("colshape")) do
		if getElementData(v,"Nazwa")=="Przedmioty" then
			x2,y2,z2=getElementPosition(v)
			if getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)<odleglosc then
				ilosc=ilosc+1
				objekty=getElementData(v,"objectsINloot")
				for i=1,3 do
					if objekty[i] and isElement(objekty[i]) then
						destroyElement(objekty[i])
					end
				end
				destroyElement(v)
				x2,y2,z2=string.gsub(x2,"[.].*",""),string.gsub(y2,"[.].*",""),string.gsub(z2,"[.].*","")
				sql="DELETE FROM Loot_spawny WHERE x LIKE '%"..x2.."%' AND y LIKE '%"..y2.."%' AND z LIKE '%"..z2.."%' limit 1"
				exports.db:zapytanie(sql)
			end
		end
	end
	outputChatBox("Usunięto pomyślnie "..ilosc.." lootów!",plr,0,255,0)
end
addCommandHandler("usunlooty",usunlooty)

typyy={[1]="farm",[2]="industrial",[3]="military",[4]="residential",[5]="supermarket"}
function dodajLoot(plr,cmd,typ)
	if admin(plr) then return end
	if typ and tonumber(typ) and typyy[tonumber(typ)] then
		x,y,z=getElementPosition(plr)
		exports.db:zapytanie("insert into Loot_spawny values(NULL,?,?,?,?)",typyy[tonumber(typ)],x,y,z)
		outputChatBox("*Dodano",plr,0,255,0)
	else
		outputChatBox("Dostępne typy przedmiotów:",plr,0,255,0)
		for i,v in ipairs(typyy) do
			outputChatBox(tostring(i).."="..tostring(v),plr,0,255,0)
		end
	end
end
addCommandHandler("dodajloot",dodajLoot)

function testelement(plr,cmd,id)
	if admin(plr) then return end
	if not id or not tonumber(id) then return end
	x,y,z=getElementPosition(plr)
	obj=createObject(tonumber(id),x,y+2,z)
	setTimer(destroyElement,30000,1,obj)
	outputChatBox("Stworzono element, zniknie za 30s",plr,0,255,0)
end
addCommandHandler("testelement",testelement)

function autostart(plr)
	if admin(plr) then return end
	outputChatBox("Trwa przeładowywanie autostartu...",plr,0,255,0)
	exports.db:zapytanie("truncate Autostart")
	for i,v in ipairs(getResources()) do
		if getResourceState(v)=="running" then
			exports.db:zapytanie("insert into Autostart values(?)",getResourceName(v))
		end
	end
	outputChatBox("Autostart przeładowany pomyślnie!",plr,0,255,0)
end
addCommandHandler("autostartreload",autostart)

pojazdy={}
function testpojazdy(plr,cmd,usun)
	if admin(plr) then return end
	x,y,z=getElementPosition(plr)
	q=exports.db:pobierzTabeleWynikow("select * from Pojazdy order by typ asc")
	for i,v in ipairs(pojazdy) do
		destroyElement(v)
	end
	if usun=="usun" then
		pojazdy={}
		return outputChatBox("Usunięto!",plr,0,255,0)
	end
	pojazdy={}
	for i,v in ipairs(q) do
		pojazdy[i]=createVehicle(v.ID,x,y+i*8,z,0,0,90)
		setElementFrozen(pojazdy[i],true)
		setVehicleDamageProof(pojazdy[i],true)
	end
	outputChatBox("Pojazdy pokazane!",plr,0,255,0)
end
addCommandHandler("testpojazdy",testpojazdy)
objekty={}
teksty3d={}
function testobjekty(plr,cmd,usun)
	if admin(plr) then return end
	x,y,z=getElementPosition(plr)
	q=exports.db:pobierzTabeleWynikow("select Wartosc,ID,ID_Objektu,Obroty,Skala from Przedmioty order by ID asc")
	for i,v in ipairs(objekty) do
		destroyElement(v)
	end
	for i,v in ipairs(teksty3d) do
		destroyElement(v)
	end
	if usun=="usun" then
		objekty={}
		return outputChatBox("Usunięto!",plr,0,255,0)
	end
	objekty={}
	for i,v in ipairs(q) do
		objekty[i]=createObject(v.ID_Objektu,x+i,y+i,z,v.Obroty,0,0)
		teksty3d[i]=dxDraw3DText(v.Wartosc.."\n"..v.ID_Objektu,x+i,y+i,z,2,"sans",255,0,0,3)
		if objekty[i] then
			setObjectScale(objekty[i],v.Skala)
			setElementFrozen(objekty[i],true)
			setElementCollisionsEnabled(objekty[i],false)
		else
			outputChatBox("Błędne id: "..v.Wartosc.." ("..v.ID_Objektu..")",plr)
		end
	end
	outputChatBox("Przedmioty pokazane!",plr,0,255,0)
end
addCommandHandler("testprzedmioty",testobjekty)

zombiee={}
function testzombie(plr,cmd,usun)
	if admin(plr) then return end
	x,y,z=getElementPosition(plr)
	q=exports.db:pobierzTabeleWynikow("select * from Zombie_skiny order by typ asc")
	for i,v in ipairs(zombiee) do
		destroyElement(v)
	end
	if usun=="usun" then
		zombiee={}
		return outputChatBox("Usunięto!",plr,0,255,0)
	end
	zombiee={}
	typ=""
	typx=-3
	for i,v in ipairs(q) do
		if typ~=v.typ then
			typ=v.typ
			typx=typx+3
		end
		zombiee[i]=createPed(v.ID,x+typx,y+i*1,z)
		setElementFrozen(zombiee[i],true)
	end
	outputChatBox("Zombie pokazane!",plr,0,255,0)
end
addCommandHandler("testzombie",testzombie)

function dodajzombiezaladuj()
	q=exports.db:pobierzTabeleWynikow("select typ from Zombie_typy")
	typy={}
	typytxt=""
	for i,v in ipairs(q) do
		typy[v.typ]=true
		typytxt=typytxt..","..v.typ
	end
end
dodajzombiezaladuj()
function dodajzombie(plr,cmd,typ)
	if admin(plr) then return end
	if typy[typ] then
		x,y,z=getElementPosition(plr)
		exports.db:zapytanie("insert into Zombie_spawn values(null,?,?,?,?)",typ,x,y,z)
		outputChatBox("Spawn zombie "..typ.." został dodany pomyślnie! Aby się pojawiły wpisz /restart dayz-zombie",plr,0,255,0)
	else
		outputChatBox("Błąd, popraw na: /"..cmd.." ["..typytxt.."]",plr,255,0,0)
	end
end
addCommandHandler("dodajzombie",dodajzombie)
function dodajkamien(plr,cmd)
	if admin(plr) then return end
	x,y,z=getElementPosition(plr)
	exports.db:zapytanie("insert into Kamienie values(null,?)",x..","..y..","..z)
	outputChatBox("Spawn kamienia dodany pomyślnie!",plr,0,255,0)
end
addCommandHandler("dodajkamien",dodajkamien)

function adddd(plr)
	if admin(plr) then return end
	posy=getElementData(plr,"player:posy")
	if posy then
		outputChatBox("Posy wyłączono",plr)
		setElementData(plr,"player:posy",false)
	else
		outputChatBox("Posy włączono",plr)
		setElementData(plr,"player:posy",true)
	end
end
addCommandHandler("airbreak",adddd)