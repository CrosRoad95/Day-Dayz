restartResource(getResourceFromName("slothbot"))
createTeam("Zombies")
function zaladuj()
	--[[q=exports.db:pobierzTabeleWynikow("select * from Zombie_skiny")
	ZombiePedSkins={}
	dropZZombie={}
	for i,v in ipairs(q) do
		table.insert(ZombiePedSkins,v.ID)
	end
	q=exports.db:pobierzTabeleWynikow("select * from Zombie_przedmioty")
	for i,v in ipairs(q) do
		table.insert(dropZZombie,{v.przedmiot,v.szansa})
	end]]
	q=exports.db:pobierzTabeleWynikow("select * from Zombie_typy")
	zombiedata={}
	for i,v in ipairs(q) do
		zombiedata[v.typ]={}
		qq=exports.db:pobierzTabeleWynikow("select * from Zombie_skiny where typ=?",v.typ)
		zombiedata[v.typ].skiny=qq
		qq=exports.db:pobierzTabeleWynikow("select * from Zombie_przedmioty where typ=?",v.typ)
		zombiedata[v.typ].przedmioty=qq
		qq=exports.db:pobierzTabeleWynikow("select * from Zombie_spawn where typ=?",v.typ)
		zombiedata[v.typ].spawn=qq
		zombiedata[v.typ].data=v
	end
	zombiespawny=exports.db:pobierzTabeleWynikow("select * from Zombie_spawn")
	setElementData(getRootElement(), "zombiestotal", 0)
	setElementData(getRootElement(), "zombiesalive", 0)
	setElementData(resourceRoot, "$zombies",zombiedata)
	setElementData(resourceRoot, "$zombiesspawny",zombiespawny)
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
for i,v in ipairs(getElementsByType("player")) do
	createZombieTable(v)
end
stylechodzenia={120,123,134,137}
function createZomieForPlayer(idspawnu)
	spawnedzombies=getElementData(client,"spawnedzombies")
	if spawnedzombies and spawnedzombies<3 then
		local data=zombiedata[zombiespawny[idspawnu].typ]
		local skindata=data.skiny[math.random(#data.skiny)]
		local skin=skindata.ID
		if data.data.bron~=0 then
			local bron=data.data.bron
		else
			local bron=skindata.bron
		end
		local spawndata=zombiespawny[idspawnu]
		local zombie = call(getResourceFromName("slothbot"),"spawnBot",spawndata.x+math.random(-10,10)/10,spawndata.y+math.random(-10,10)/10,spawndata.z,math.random(0, 360),skin,0,0,getTeamFromName("Zombies"),bron)
		x,y,z=getElementPosition(zombie)
		call(getResourceFromName("slothbot"),"setBotGuard",x,y,z, false)
		setElementData(client,"spawnedzombies",spawnedzombies+1)
		setElementData(zombie,"zombie",true)
		setElementData(zombie,"_Krew_",skindata.hp)
		setElementData(zombie,"owner",client)
		setElementData(zombie,"obrazenia",skindata.obrazenia*(data.data.obrazenia/100))
		setElementData(zombie,"predkosc",data.data.predkosc)
		setElementData(zombie,"gp",data.data.gp,false)
		setElementData(zombie,"typ",zombiespawny[idspawnu].typ,false)
		setElementData(zombie,"sluch",data.data.sluch)
		setElementData(zombie,"wzrok",data.data.wzrok)	
		setPedWalkingStyle(zombie,stylechodzenia[math.random(#stylechodzenia)])		
	end
end
addEvent("stworz_zombie", true)
addEventHandler("stworz_zombie",resourceRoot, createZomieForPlayer)
function zombieCheck1()
  for i, ped in ipairs(getElementsByType("ped")) do
    if getElementData(ped, "zombie") then
      goReturn = false
      local zombieCreator = getElementData(ped, "owner")
      if not isElement(zombieCreator) then
        setElementData(ped, "status", "dead")
        setElementData(ped, "target", nil)
        setElementData(ped, "leader", nil)
        destroyElement(ped)
        goReturn = true
      end
      if not goReturn then
        local xZ, yZ, zZ = getElementPosition(getElementData(ped, "owner"))
        local x, y, z = getElementPosition(ped)
        if getDistanceBetweenPoints3D(x, y, z, xZ, yZ, zZ) > 100 then
          if getElementData(zombieCreator, "spawnedzombies") - 1 >= 0 then
            setElementData(zombieCreator, "spawnedzombies", getElementData(zombieCreator, "spawnedzombies") - 1)
          end
          setElementData(ped, "status", "dead")
          setElementData(ped, "target", nil)
          setElementData(ped, "leader", nil)
          destroyElement(ped)
        end
      end
    end
  end
end
setTimer(zombieCheck1, 20000, 0)
function botAttack(ped)
	call(getResourceFromName("slothbot"), "setBotFollow", ped, source)
end
addEvent("botAttack", true)
addEventHandler("botAttack", getRootElement(), botAttack)
function botStopFollow(ped)
  local x, y, z = getElementPositon(ped)
  call(getResourceFromName("slothbot"), "setBotGuard", ped, x, y, z, false)
end
addEvent("botStopFollow", true)
addEventHandler("botStopFollow", getRootElement(), botStopFollow)
--[[
function destroyTable()
  for i, ped in ipairs(getElementsByType("ped")) do
	owner=getElementData(ped, "owner")
    if getElementData(ped, "zombie") and owner == source then
      setElementData(owner, "spawnedzombies", getElementData(owner, "spawnedzombies") - 1)
      setElementData(ped, "status", "dead")
      setElementData(ped, "target", nil)
      setElementData(ped, "leader", nil)
      destroyElement(ped)
    end
  end
end]]
function destroyDeadZombie(ped, pedCol)
  destroyElement(ped)
  destroyElement(pedCol)
end
function math.percentChance(percent, repeatTime)
  local hits = 0
  for i = 1, repeatTime do
    local number = math.random(0, 200) / 2
    if percent >= number then
      hits = hits + 1
    end
  end
  return hits
end
function zombieKilled(killer, headshot)
  if killer then
    setElementData(killer, "_Zabite_Zombie(Aktualnie)_", getElementData(killer, "_Zabite_Zombie(Aktualnie)_") + 1)
    setElementData(killer, "_Zabite_Zombie(W_Sumie)_", getElementData(killer, "_Zabite_Zombie(W_Sumie)_") + 1)
    
	givePlayerMoney ( killer,getElementData(source,"gp") or 1)
	outputConsole("+"..(getElementData(source,"gp") or 1).." gp",killer)
  end
  local skin = getElementModel(source)
  local x, y, z = getElementPosition(source)
  local ped = createPed(skin, x, y, z)
  local pedCol = createColSphere(x, y, z, 1.5)
  killPed(ped)
  setTimer(destroyDeadZombie, 360000, 1, ped, pedCol)
  attachElements(pedCol, ped, 0, 0, 0)
  setElementData(pedCol, "parent", ped)
  setElementData(ped, "parent", pedCol)
  setElementData(pedCol, "playername", "Zombie")
  setElementData(pedCol, "deadman", true)
  setElementData(ped, "deadzombie", true)
  setElementData(pedCol, "deadman", true)
      setElementData(pedCol,"_Limit_Slotow_",getElementData(client,"_Limit_Slotow_"))
	  setElementData(pedCol,"itemloot", true)
	setElementData(pedCol,"Opis","zombiezwloki")
	setElementData(pedCol,"Nazwa",getPlayerName(client))
  local time = getRealTime()
  local hours = time.hour
  local minutes = time.minute
  setElementData(pedCol, "Opcje",{
  {"Informacja","Ten zombie zostal zabity o godzinie: " .. hours .. ":" .. minutes .. "!"}
  })
  for i, item in ipairs(zombiedata[getElementData(source,"typ")].przedmioty) do
    local value = math.percentChance(item.szansa, 1)
    setElementData(pedCol, item.przedmiot, value)
  end
  local zombieCreator = getElementData(source, "owner")
  destroyElement(source)
  setElementData(zombieCreator, "spawnedzombies", getElementData(zombieCreator, "spawnedzombies") - 1)
  if headshot == true then
    setElementData(killer, "headshots", (getElementData(killer, "headshots") or 0) + 1)
  end
end
addEvent("Zabij_zombie", true)
addEventHandler("Zabij_zombie", getRootElement(), zombieKilled)