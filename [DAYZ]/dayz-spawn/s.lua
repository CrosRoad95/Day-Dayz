function zaladuj()
	q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
	przedmiotyDoZapisu={}
	for i,v in ipairs(q) do
		table.insert(przedmiotyDoZapisu,v.Wartosc)
	end
end
zaladuj()
function createZombieTable(player)
  setElementData(player, "playerZombies", {
    "no",
    "no",
    "no",
    "no",
    "no",
    "no",
    "no",
    "no",
    "no"
  })
  setElementData(player, "spawnedzombies", 0)
end
team=createTeam("Gracze")
function spawn(gracz,login)
	q=exports.db:pobierzTabeleWynikow("select * from Konta where login=? limit 1",login)
	if #q==0 then kickPlayer(gracz) return end
	exports.db:zapytanie("update Konta set ostatnio_widziany=now(),serial_ostatni=?,ip_ostatni=? where login=? limit 1",getPlayerSerial(gracz),getPlayerIP(gracz))
	q=q[1]
	createZombieTable(gracz)
	setElementData(gracz,"Login",true)
	setElementData(gracz,"Login_name",login)
	setElementData(gracz,"UID",q.ID)
	setElementData(gracz,"_Krew_",q.krew)
	setElementData(gracz,"_Temperatura_",q.temperatura)
	setElementData(gracz,"_Ludzkosc_",q.ludzkosc)
	setElementData(gracz,"_Limit_Slotow_",q.limit_slotow)
	setElementData(gracz,"_Glod_",q.glod)
	setElementData(gracz,"_Pragnienie_",q.pragnienie)
	setElementData(gracz,"_Gang_",q.gang)
	setElementData(gracz,"_Gang(Lider)_",q.lidergangu)
	setElementData(gracz,"_Gang(Vice-Lider)_",q.vicelidergangu)
	setElementData(gracz,"_Morderstwa(Aktualnie)_",q.morderstwa_aktualne)
	setElementData(gracz,"_Morderstwa(W_Sumie)_",q.morderstwa_wsumie)
	setElementData(gracz,"_Zabite_Zombie(Aktualnie)_",q.zabitezombie_aktualnie)
	setElementData(gracz,"_Zabite_Zombie(W_Sumie)_",q.zabitezombie_wsumie)
	setElementData(gracz,"_Czas_Gry(Aktualnie)_",q.czasgry_aktualnie)
	setElementData(gracz,"_Czas_Gry(W_Sumie)_",q.czasgry_wsumie)
	setElementData(gracz,"_Zabici_Bandyci(Aktualnie)_",q.zabicibandyci_aktualnie)
	setElementData(gracz,"_Zabici_Bandyci(W_Sumie)_",q.zabicibandyci_wsumie)
	setElementData(gracz,"_Krwawienie_",q.krwawienie)
	setElementData(gracz,"_Headshoty(Aktualnie)_",q.trafienia_w_glowe_wsumie)
	setElementData(gracz,"_Headshoty(W_Sumie)_",q.trafienia_w_glowe_aktualnie)
	setElementData(gracz,"_Aktualnabron_1_",q.aktualnabron_1)
	setElementData(gracz,"_Aktualnabron_2_",q.aktualnabron_2)
	setElementData(gracz,"_Aktualnabron_3_",q.aktualnabron_3)
	if not getElementData(gracz,"pasek_szybkiego_wyboru") then
		setElementData(gracz,"pasek_szybkiego_wyboru",fromJSON(q.pasek))
	end
	
	setElementVelocity(gracz,q.przyspieszenie_x,q.przyspieszenie_y,q.przyspieszenie_z)
	if q.zlamana_kosc==0 then
		setElementData(gracz,"_Zlamana_Kosc_",false)
	else
		setElementData(gracz,"_Zlamana_Kosc_",true)
	end
	if q.bol_glowy==0 then
		setElementData(gracz,"_Bol_Glowy_",false)
	else
		setElementData(gracz,"_Bol_Glowy_",true)
	end
	
	for i,v in ipairs(przedmiotyDoZapisu) do
		setElementData(gracz,v,0)
	end
	for i,v in pairs(fromJSON(q.ekwipunek)) do
		setElementData(gracz,i,v)
	end
	setPlayerMoney(gracz,q.gp)
	exports["dayz-grupy"]:aktualizujGracza(gracz)
	exports["dayz-attach"]:aktualizujAttachGracza(gracz)
	exports["dayz-system"]:aktualizujBronie(gracz)
	setPedFightingStyle(gracz,5)
	setPlayerTeam(gracz,team)
	setCameraTarget(gracz,gracz)
	spawnPlayer(gracz,q.x,q.y,q.z,q.r,q.skin,q.i,q.d,nil)
end
addEvent("gracz_zaloguj",true)
addEventHandler("gracz_zaloguj",getRootElement(),spawn)

function zapisz(gracz)
	if not getElementData(gracz,"Login") then return end
	ip,serial=getPlayerIP(gracz),getPlayerSerial(gracz)
	exports.db:zapytanie("update Konta set ostatnio_widziany=now(),serial_ostatni=?,ip_ostatni=? where login=? limit 1",ip,serial)
	x,y,z=getElementPosition(gracz)
	i,d=getElementInterior(gracz),getElementDimension(gracz)
	_,_,r=getElementRotation(gracz)
	skin=getElementModel(gracz)
	mordT,mordW=getElementData(gracz,"_Morderstwa(Aktualnie)_"),getElementData(gracz,"_Morderstwa(W_Sumie)_")
	zzombT,zzombW=getElementData(gracz,"_Zabite_Zombie(Aktualnie)_"),getElementData(gracz,"_Zabite_Zombie(W_Sumie)_")
	czsT,czsW=getElementData(gracz,"_Czas_Gry(Aktualnie)_"),getElementData(gracz,"_Czas_Gry(W_Sumie)_")
	zbbT,zbbW=getElementData(gracz,"_Zabici_Bandyci(Aktualnie)_"),getElementData(gracz,"_Zabici_Bandyci(W_Sumie)_")
	hsT,hsW=getElementData(gracz,"_Headshoty(Aktualnie)_"),getElementData(gracz,"_Headshoty(W_Sumie)_")
	krwawienie=getElementData(gracz,"_Krwawienie_")
	zlamana,bolglowy=getElementData(gracz,"_Zlamana_Kosc_"),getElementData(gracz,"_Bol_Glowy_")
	if bolglowy then bolglowy=1 else bolglowy=0 end
	if zlamana then zlamana=1 else zlamana=0 end
	krew,temp=getElementData(gracz,"_Krew_"),getElementData(gracz,"_Temperatura_")
	ludz,maxsl=getElementData(gracz,"_Ludzkosc_"),getElementData(gracz,"_Limit_Slotow_")
	glod,pragn=getElementData(gracz,"_Glod_"),getElementData(gracz,"_Pragnienie_")
	bron1,bron2,bron3=getElementData(gracz,"_Aktualnabron_1_"),getElementData(gracz,"_Aktualnabron_2_"),getElementData(gracz,"_Aktualnabron_3_")
	grupa=getElementData(gracz,"grupa")
	pasek=getElementData(gracz,"pasek_szybkiego_wyboru")
	
	gp=getPlayerMoney(gracz)
	vx,vy,vz=getElementVelocity(gracz)
	sql="update Konta set pasek=?,gp=?,gang=?,przyspieszenie_x=?,przyspieszenie_y=?,przyspieszenie_z=?,aktualnabron_1=?,aktualnabron_2=?,aktualnabron_3=?,krwawienie=?,trafienia_w_glowe_aktualnie=?,trafienia_w_glowe_wsumie=?,bol_glowy=?,zlamana_kosc=?,zabicibandyci_aktualnie=?,zabicibandyci_wsumie=?,czasgry_aktualnie=?,czasgry_wsumie=?,zabitezombie_aktualnie=?,zabitezombie_wsumie=?,glod=?,pragnienie=?,ludzkosc=?,limit_slotow=?,krew=?,temperatura=?,morderstwa_aktualne=?,morderstwa_wsumie=?,ostatnio_widziany=now(),x=?,y=?,z=?,r=?,i=?,d=?,skin=?,ekwipunek=?,serial_ostatni=?,ip_ostatni=? where login=? limit 1"
	przedmioty={}
	for i,v in ipairs(przedmiotyDoZapisu) do
		ilosc=getElementData(gracz,v)
		if ilosc and ilosc>0 then
			przedmioty[v]=ilosc
		end
	end
	exports.db:zapytanie(sql,toJSON(pasek or {},true),gp,grupa,vx,vy,vz,bron1,bron2,bron3,krwawienie,hsT,hsW,bolglowy,zlamana,zbbT,zbbW,czsT,czsW,zzombT,zzombW,glod,pragn,ludz,maxsl,krew,temp,mordT,mordW,x,y,z,r,i,d,skin,toJSON(przedmioty,true),serial,ip,getElementData(gracz,"Login_name"))
end
function saveOnQuit()
	zapisz(source)
end
addEventHandler("onPlayerQuit",getRootElement(),saveOnQuit)
function autosave()
	for i,v in ipairs(getElementsByType("player")) do
		zapisz(v)
	end
end
setTimer(autosave,60000,0)

for i,v in ipairs(getElementsByType("player")) do
	setPlayerTeam(v,team)
end