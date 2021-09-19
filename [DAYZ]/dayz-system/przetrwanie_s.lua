function zaladuj()
	ListaPlecakow={}
	q=exports.db:pobierzTabeleWynikow("select * from Plecaki")
	for i,v in ipairs(q) do
		ListaPlecakow[v.sloty]=v.nazwa
	end
	Magazynki={}
	q=exports.db:pobierzTabeleWynikow("select * from Magazynki")
	for i,v in ipairs(q) do
		Magazynki[v.magazynek]=v.ilosc
	end
	Przedmioty={}
	q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
	for i,v in ipairs(q) do
		table.insert(Przedmioty,v.Wartosc)
	end
	Spawny={}
	q=exports.db:pobierzTabeleWynikow("select * from Spawny")
	for i,v in ipairs(q) do
		table.insert(Spawny,{v.x,v.y,v.z})
	end
	skinTable={}
	q=exports.db:pobierzTabeleWynikow("select * from Skiny")
	for i,v in ipairs(q) do
		table.insert(skinTable,{v[1],v[2]})
	end
	damageTable={}
	q=exports.db:pobierzTabeleWynikow("select * from Bronie_obrazenia")
	for i,v in ipairs(q) do
		damageTable[tonumber(v.bron)]=v.obrazenia
	end
	setElementData(resourceRoot,"damageTable",damageTable)
	q=exports.db:pobierzTabeleWynikow("select * from bronie")
	bronamunicja={}
	for i,v in ipairs(q) do
		bronamunicja[v.id_broni]=v
	end
	setElementData(resourceRoot,"bronamunicja",bronamunicja)
	domyslneDane={}
	q=exports.db:pobierzTabeleWynikow("select * from Spawn_domyslne_dane")
	for i,v in ipairs(q) do
		if v.wartosc=="false" then
			v.wartosc=false
		elseif v.wartosc=="true" then
			v.wartosc=true
		elseif tonumber(v.wartosc) then
			v.wartosc=tonumber(v.wartosc)
		end
		domyslneDane[v.klucz]=v.wartosc
	end
	q=exports.db:pobierzTabeleWynikow("select * from bronie")
	bronamunicja={}
	for i,v in ipairs(q) do
		bronamunicja[v.bron]=v
	end
end
zaladuj()

function destroyDeadPlayer(ped, pedCol)
  destroyElement(ped)
  destroyElement(pedCol)
end

function getSkinIDFromName(name)
  for i, skin in ipairs(skinTable) do
    if name == skin[1] then
      return skin[2]
    end
  end
end
function getSkinNameFromID(id)
  for i, skin in ipairs(skinTable) do
    if id == skin[2] then
      return skin[1]
    end
  end
end

function spawnDayZPlayer(player)
	if player then
		--spawnPlayer(player, 0,10,3, math.random(0, 360), 73, 0, 0)
		triggerClientEvent(player,"hideInventoryManual",player)
		szansa=math.random(1,100)
		if szansa<=50 then
			rand = math.random(1,4)
			if rand == 1 then
			spawnPlayer(player, 2907, math.random(-2644, 3009), 1000, math.random(0, 360), 73, 0, 0)
			elseif rand == 2 then
			spawnPlayer(player, math.random(-2964, 2940), 3009, 1000, math.random(0, 360), 73, 0, 0)
			elseif rand == 3 then
			spawnPlayer(player, -2964, math.random(-2948, 2939), 1000, math.random(0, 360), 73, 0, 0)
			elseif rand == 4 then
			spawnPlayer(player, math.random(-2920, 94), -2948, 1000, math.random(0, 360), 73, 0, 0)
			end
		else
			szansa_=math.random(1,3)
			if szansa_==1 then
				spawnPlayer(player,1658.4677734375,1746.435546875,1000, math.random(0, 360), 73, 0, 0)
			elseif szansa_==2 then
				spawnPlayer(player,1686.4208984375,-1541.694335937,1000, math.random(0, 360), 73, 0, 0)
			elseif szansa_==3 then
				spawnPlayer(player,-2016.73828125,300.4169921875,1000, math.random(0, 360), 73, 0, 0)
			end
		end
		fadeCamera(player, true)
		giveWeapon(player, 46, 1)
		outputChatBox("Wypadłeś z samolotu! OTWÓRZ SPADOCHRON ABY PRZEŻYĆ!",player,0,255,0)
		setPedFightingStyle(player,5)
		setPedFightingStyle(player,5)
		setElementData(player,"_Czas_Gry(Aktualnie)_",0)
		setCameraTarget(player, player)
		local x,y,z = getElementPosition( player )
		--[[playerCol = createColSphere(x, y, z, 1.5)
		setElementData(player, "playerCol", playerCol)
		attachElements(playerCol, player, 0, 0, 0)
		setElementData(playerCol, "parent", player)
		setElementData(playerCol, "player", true)]]
		setElementData(player, "isDead", false)
		setElementData(player, "logedin", true)
		for i,v in ipairs(Przedmioty) do
			setElementData(player,v,0)
		end
		for i,v in pairs(domyslneDane) do
			if i=="skin" then
				setElementModel(player,v)
			else
				setElementData(player,i,v)
			end
		end
	end
end

function pobierzEQ(gracz)
	eq={}
	for i,v in ipairs(Przedmioty) do
		if not gracz then return {} end
		ilosc=getElementData(gracz,v)
		if ilosc and ilosc>0 then
			eq[v]=ilosc
		end
	end
	return eq
end

function gracz_zabij(killer,weapon,headshot,wybuchWPojezdzie)
	if not client then client=source end
	if (getElementData(client,"tick_zgonu") or 0)+5000>getTickCount() then
		return false
	end
	setElementData(client,"tick_zgonu",getTickCount())
	sql="INSERT INTO Logi_zabic VALUES (NULL,NOW(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);"
	a1=getElementData(client,"_Czas_Gry(Aktualnie)_")
	a2=getElementData(client,"_Morderstwa(Aktualnie)_")
	a3=getElementData(client,"_Zabite_Zombie(Aktualnie)_")
	a4=getElementData(client,"_Headshoty(Aktualnie)_")
	if killer and killer~=nil and killer~=client then
		x,y,z=getElementPosition(killer)
		x_,y_,z_=getElementPosition(client)
		dis=getDistanceBetweenPoints3D(x,y,z,x_,y_,z_)
		i,d=getElementInterior(killer),getElementDimension(killer)
		i_,d_=getElementInterior(client),getElementDimension(client)
		if killer then
			eq2=pobierzEQ(killer)
		else
			eq=""
		end
		eq1=pobierzEQ(client)
		exports.db:zapytanie(sql,getElementData(killer,"Login_name") or "nieznany",getElementData(client,"Login_name"),getWeaponNameFromID(weapon),dis,headshot,x,y,z,i,d,x_,y_,z_,i_,d_,toJSON(eq1,true),toJSON(eq2,true),a1,a2,a3,a4)
		local gracz1=string.gsub(tostring(getPlayerName(killer)),"#%x%x%x%x%x%x","")
		local gracz2=string.gsub(tostring(getPlayerName(client)),"#%x%x%x%x%x%x","")
		if gracz2~="false" then
			if dis<50 then
				dystans="mniej niż 50m"
			elseif dis>50 and dis<100 then
				dystans="pomiędzy 50-100 metrów"
			elseif dis>100 and dis<150 then
				dystans="pomiędzy 100-150 metrów"
			elseif dis>150 and dis<200 then
				dystans="pomiędzy 150-200 metrów"
			elseif dis>200 and dis<250 then
				dystans="pomiędzy 200-250 metrów"
			elseif dis>250 and dis<300 then
				dystans="pomiędzy 250-300 metrów"
			elseif dis>300 then
				dystans="więcej niż 300 metrów"
			end
			if gracz1~="false" then
				outputChatBox(gracz1.." #ff0000zabił:#ffffff "..gracz2.." ( Broń "..tostring(getWeaponNameFromID(weapon))..", odległość: "..dystans..")",getRootElement(),255,255,255,true)
			end
			givePlayerMoney(killer,50)
		end
	else
		x,y,z=0,0,0
		x_,y_,z_=getElementPosition(client)
		i,d=0,0
		i_,d_=getElementInterior(client),getElementDimension(client)
		eq1=pobierzEQ(client)
		exports.db:zapytanie(sql,"***SAMOBOJ***",getElementData(client,"Login_name"),0,0,0,x,y,z,i,d,x_,y_,z_,i_,d_,toJSON(eq1,true),"",a1,a2,a3,a4)
	end
	pedCol=false
	killPed(client)
	triggerClientEvent(client,"hideInventoryManual",client)
	triggerClientEvent(client,"onClientPlayerDeathInfo",client)
	setTimer(spawnDayZPlayer,1000,1,client)
	setElementData(client,"isDead",true)
  if wybuchWPojezdzie then return end
  if getElementData(client,"_Czas_Gry(Aktualnie)_")>120 then
    local x,y,z=getElementPosition(client)
    if getDistanceBetweenPoints3D(x,y,z,6000,6000,0) > 200 then
      local x,y,z=getElementPosition(client)
      local rotX,rotY,rotZ=getElementRotation(client)
      local skin=getElementModel(client)
      local ped=createPed(skin,x,y,z,rotZ)
      pedCol=createColSphere(x,y,z,1.5)
      killPed(ped)
      setTimer(destroyDeadPlayer,5400000,1,ped,pedCol)
      attachElements(pedCol,ped,0,0,0)
      setElementData(pedCol,"parent",ped)
	  setElementData(ped,"parent",pedCol)
      setElementData(pedCol,"deadman",true)
      setElementData(pedCol,"_Limit_Slotow_",getElementData(client,"_Limit_Slotow_"))
	  setElementData(pedCol,"itemloot", true)
	setElementData(pedCol,"Opis","Kliknij 'J' aby przeszukać\nzwłoki")
	setElementData(pedCol,"Nazwa",getPlayerName(client))
      local time=getRealTime()
      local hours=time.hour
      local minutes=time.minute
      setElementData(pedCol,"Opcje",{{"Informacje",getPlayerName(client).." nie żyje,zginął z broni "..(weapon or "nieznanej")..". Czas Zgonu: "..hours..":"..minutes}})
    end
  end
	if killer and killer~=client and isElement(killer) then
		setElementData(killer,"_Morderstwa(Aktualnie)_",(getElementData(killer,"_Morderstwa(Aktualnie)_") or 0)+1)
		setElementData(killer,"_Morderstwa(W_Sumie)_",(getElementData(killer,"_Morderstwa(W_Sumie)_") or 0)+1)
		if getElementData(client,"bandit") == true then
			setElementData(killer,"_Zabici_Bandyci(Aktualnie)_",(getElementData(killer,"_Zabici_Bandyci(Aktualnie)_") or 0)+1)
			setElementData(killer,"_Zabici_Bandyci(W_Sumie)_",(getElementData(killer,"_Zabici_Bandyci(W_Sumie)_") or 0)+1)
		end
		if headshot == true then
			setElementData(killer,"_Headshoty_",getElementData(killer,"_Headshoty_")+1)
		end
	end
  if pedCol then
    for i,data in ipairs(Przedmioty) do
      local plusData=getElementData(client,data)
      setElementData(pedCol,data,plusData)
    end
    local skinID=getElementData(client,"skin")
    local skin=getSkinNameFromID(skinID)
	if skin then
		setElementData(pedCol,skin,1)
	end
    local backpackSlots=getElementData(client,"_Limit_Slotow_")
	setElementData(pedCol,ListaPlecakow[backpackSlots],1)
	setElementData(pedCol,"Basic Backpack",0)
	
  end
  --destroyElement(getElementData(client,"playerCol"))
 
end
addEvent("gracz_zabij",true)
addEventHandler("gracz_zabij",getRootElement(),gracz_zabij)

function wybuchPojazdu()
	for i,v in pairs(getVehicleOccupants(source)) do
		triggerEvent("gracz_zabij",v,false,false,false,true)
	end
end
addEventHandler("onVehicleExplode",getRootElement(),wybuchPojazdu)

function kill(plr)
	triggerEvent("gracz_zabij",plr)
end
addCommandHandler("kill",kill)

function aktualizujBronie(gracz)
	if not gracz then gracz=client end
	bron1=getElementData(gracz,"_Aktualnabron_1_")
	bron2=getElementData(gracz,"_Aktualnabron_2_")
	bron3=getElementData(gracz,"_Aktualnabron_3_")
	takeAllWeapons(gracz)
	
	if getElementData(gracz,bron1) and getElementData(gracz,bron1)<=0 then
		bron1=false
	end
	if getElementData(gracz,bron2) and getElementData(gracz,bron2)<=0 then
		bron2=false
	end
	if getElementData(gracz,bron3) and getElementData(gracz,bron3)<=0 then
		bron3=false
	end
	if bron1 and bron1~="" then
		ammo=bronamunicja[bron1]
		if ammo then
			if ammo.amunicja=="" then
				giveWeapon(gracz,ammo.id_broni,1)
			else
				if getElementData(gracz,ammo.amunicja)>0 then
					giveWeapon(gracz,ammo.id_broni,getElementData(gracz,ammo.amunicja))
				end
			end
		end
	else
		setElementData(gracz,"_Aktualnabron_1_","")
	end
	if bron2 and bron2~="" then
		ammo=bronamunicja[bron2]
		if ammo then
			if ammo.amunicja=="" then
				giveWeapon(gracz,ammo.id_broni,1)
			else
				if getElementData(gracz,ammo.amunicja)>0 then
					giveWeapon(gracz,ammo.id_broni,getElementData(gracz,ammo.amunicja))
				end
			end
		end
	else
		setElementData(gracz,"_Aktualnabron_2_","")
	end
	if bron3 and bron3~="" then
		ammo=bronamunicja[bron3]
		if ammo then
			if ammo.amunicja=="" then
				giveWeapon(gracz,ammo.id_broni,1)
			else
				if getElementData(gracz,ammo.amunicja)>0 then
					giveWeapon(gracz,ammo.id_broni,getElementData(gracz,ammo.amunicja))
				end
			end
		end
	else
		setElementData(gracz,"_Aktualnabron_3_","")
	end
	poprzednie=getElementData(gracz,"_Aktualnabron_poprzednie_")
	setElementData(gracz,"_Aktualnabron_poprzednie_",{bron1,bron2,bron3},false)
	if poprzednie and poprzednie[1]==bron1 and poprzednie[2]==bron2 and poprzednie[3]==bron3 then
		return
	end
	exports["dayz-attach"]:aktualizujAttachGracza(gracz)
end
addEvent("aktualizuj_bronie", true)
addEventHandler("aktualizuj_bronie",getRootElement(),aktualizujBronie)

function onStealthKill(targetPlayer)
     cancelEvent(true, "Nope")
end
addEventHandler("onPlayerStealthKill", getRootElement(), onStealthKill)