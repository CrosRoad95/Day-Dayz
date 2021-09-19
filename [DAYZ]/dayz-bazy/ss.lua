prekonfiguracja={
{60,15,25,{{[7]={20,2000},[14]={35,0},[30]={60,0}}}}, -- koszt, promien, limit objektów, przedłużenie
{80,25,50,{{[7]={30,4000},[14]={50,0},[30]={80,0}}}},
{100,30,80,{{[7]={40,5000},[14]={60,0},[30]={100,0}}}},
{120,50,120,{{[7]={60,0},[14]={80,0},[30]={120,0}}}}
}
function prawa(plr)
	local accName=getAccountName(getPlayerAccount(plr)) 
    if isObjectInACLGroup("user."..accName,aclGetGroup("Admin")) then
		return true
	end
	return false
end

pickupy={}
function zaladujBazyDoKupna()
	for i,v in ipairs(pickupy) do
		destroyElement(v)
	end
	l=exports.db:pobierzTabeleWynikow("SELECT * FROM `Bazy_zakup`")
	pickupy={}
	for i,v in pairs(l) do
		pickupy[i]=createPickup(v.x,v.y,v.z,3,1273,10)
		setElementData(pickupy[i],"Pickup_Bazy",v)
	end
end
zaladujBazyDoKupna()

function pokazinformacje(plr,matchingDimension)
	opis=getElementData(source,"opis")
	if opis then
		return outputChatBox(opis,plr,0,255,0)
	end
	d=getElementData(source,"Pickup_Bazy")
	if d then
		outputChatBox("Teren pod budowę bazy",plr,255,255,0)
		outputChatBox("Nazwa: "..d.Nazwa,plr,0,255,0)
		outputChatBox("Rozmiar: ".. math.floor(6.28318*d.Promien).."m2 (promień: "..d.Promien..")",plr,0,255,0)
		outputChatBox("Limit objektów: "..d.LimitObjektow,plr,0,255,0)
		outputChatBox("Koszt zakupu na 30dni: "..d.Koszt.." punktów premium",plr,0,255,0)
		outputChatBox("Aby zakupić wpisz: /kupbaze "..d.ID,plr,0,255,0)
	end
end
addEventHandler("onPickupHit",resourceRoot,pokazinformacje)


function kupbazef(plr,cmd,id)
	if id and tonumber(id) then
		l=exports.db:pobierzTabeleWynikow("SELECT *,now()+interval 30 day as aktywnado FROM `Bazy_zakup` WHERE ID=?",id)
		if #l>0 then
			v=l[1]
			ilosc=pobierzPP(plr)
			if ilosc>=v.Koszt then
				ilosc=ilosc-v.Koszt
				exports.db:zapytanie("DELETE FROM Bazy_zakup WHERE ID=?",id)
				dodajPP(plr,-v.Koszt)
				zaladujBazyDoKupna()
				domyslnePRawa = {{["IDPos"]=getElementData(plr,"UID"),["Nick"]=getPlayerName(plr),["MozeBudowac"]=true,["Wlasciciel"]=true,["MozeOtwierac"]=true}}
				p[id]=createPickup(v.x,v.y,v.z,3,1272,10)
				setElementData(p[id],"opis","Baza "..v.Nazwa.." jest aktywna jeszcze do "..v.aktywnado)
				dodajMiejscePodBudowe(v.x, v.y, v.z, v.Promien ,domyslnePRawa,v.Nazwa,v.LimitObjektow,v.ID,exports.db:now(30),v.KosztPrzedluzenia,true,0)
				outputChatBox("Baza została kupiona!",plr,0,255,0)
				dodajLogBaz(plr,"Kupienie bazy "..id)
			else
				outputChatBox("Nie stać cię!",plr,255,0,0)
			end
		else
			outputChatBox("Nie ma takiej bazy na sprzedaż!",plr,255,0,0)
		end
	else
		outputChatBox("Popraw na: /kupbaze ID",plr,255,0,0)
	end
end
addCommandHandler("kupbaze",kupbazef)

function dodajBazeDoKupna(plr,cmd,id,nazwa)
	if not prawa(plr) then return end
	if id and tonumber(id) and nazwa then
		id=tonumber(id)
		x,y,z=getElementPosition(plr)
		exports.db:zapytanie("INSERT INTO Bazy_zakup (`Promien`,`LimitObjektow`,`Nazwa`,`Koszt`,`KosztPrzedluzenia`,`x`,`y`,`z`) VALUES (?,?,?,?,?,?,?,?);",prekonfiguracja[id][2],prekonfiguracja[id][3],nazwa,prekonfiguracja[id][1],toJSON(prekonfiguracja[id][4],true),x,y,z)
		outputChatBox("Baza dodana pomyślnie!",plr)
		zaladujBazyDoKupna()
		dodajLogBaz(plr,"Dodanie bazy do zakupu "..id.." ("..nazwa..")")
	else
		outputChatBox("Popraw na: "..cmd.." typ(1-4) nazwa",plr,0,255,0)
	end
end
addCommandHandler("dbb",dodajBazeDoKupna)

function aktualizujBazy()
	zaladujBazy()
end
addEvent("aktualizuj_bazy", true)
addEventHandler("aktualizuj_bazy", getRootElement(),aktualizujBazy)
--addCommandHandler("testbb",zaladujBazy)

function stworzPickup()
	return createPickup(0,0,0,3,1272,10)
end
function stworzElement()
	return createElement("bazy")
end
function stworzCol(x,y,z,s)
	return createColSphere(x,y,z,s)
end
