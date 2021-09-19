function dodajMiejscePodBudowe(x,y,z,s,dostep,nazwa,limit,id,data,dodaj)
	el = exports["dayz-bazy"]:stworzElement()
	col=exports["dayz-bazy"]:stworzCol(x,y,z,s)
	setElementPosition(el,x,y,z)
	setElementData(el,"ColBazy",{col,s})
	setElementData(el,"Nazwa",nazwa)
	setElementData(el,"Dostep",dostep)
	setElementData(el,"Limit",limit)
	setElementData(el,"ID",id)
	setElementData(el,"data",data)
	setElementData(el,"darmowa",1)
	
	setElementData(el,"kosztprzedluzenia",fromJSON('[[{"30":[50,10000]}]]'))
	if dodaj then
		exports.db:zapytanie("INSERT INTO Bazy (ID,x,y,z,promien,limitobjektow,nazwa,prawadostepu,aktywnado,kosztprzedluzenia,darmowa) values (?,?,?,?,?,?,?,?,?,?,1)",id,x,y,z,s,limit,nazwa,toJSON(dostep,true),data,'[[{"30":[50,10000]}]]')
	end
end
p={}

function dodajLogBaz(plr,co)
	kto=getPlayerName(plr)..", "..getPlayerSerial(plr)..", "..getElementData(plr,"UID")
	exports.db:zapytanie("INSERT INTO Logi_bazy (`Data`, `Kto`, `Co`) VALUES (NOW(),?,?);",kto,co)
end

function stworzDarmowaBaze(gracz)
	ilosc=getElementData(gracz,"Blueprint")
	if not ilosc or ilosc<=0 then
		return gracz:outputChat("Nie masz planów budowy!",255,0,0)
	end
	x,y,z=getElementPosition(gracz)
	for i,v in ipairs(exports.db:pobierzTabeleWynikow("select x,y,z,promien from Bazy")) do
		if getDistanceBetweenPoints3D(x,y,z,v.x,v.y,v.z)<v.promien*3 then
			return gracz:outputChat("W pobliżu jest już inna baza!",255,0,0)
		end
	end
	for i,v in ipairs(exports.db:pobierzTabeleWynikow("select pozycja from Bazy_bramy")) do
		x1,y1,z1=unpack(split(v.pozycja,","))
		if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1)<150 then
			return gracz:outputChat("W pobliżu jest już inna baza!",255,0,0)
		end
	end
	domyslnePRawa = {{["IDPos"]=getElementData(gracz,"UID"),["Nick"]=getPlayerName(gracz),["MozeBudowac"]=true,["Wlasciciel"]=true,["MozeOtwierac"]=true}}
	rand=math.random(1000,99999999)
	p[-rand]=exports["dayz-bazy"]:stworzPickup()
	setElementPosition(p[-rand],x,y,z)
	nazwa="Darmowa "..rand
	setElementData(p[-rand],"opis","Baza "..nazwa.." jest aktywna jeszcze do "..exports.db:now(30))
	dodajMiejscePodBudowe(x,y,z,30,domyslnePRawa,nazwa,65,-rand,exports.db:now(30),true)
	outputChatBox("Baza została postawiona pomyślnie!",gracz,0,255,0)
	setElementData(gracz,"Blueprint",getElementData(gracz,"Blueprint")-1)
	dodajLogBaz(gracz,"Kupienie bazy darmowej "..rand)
end
addEvent("stworzDarmowaBaze",true)
addEventHandler("stworzDarmowaBaze",root,stworzDarmowaBaze)