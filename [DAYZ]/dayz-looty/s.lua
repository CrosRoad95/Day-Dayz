szansa=2.5
function laduj()
	przedmioty_={}
	q=exports.db:pobierzTabeleWynikow("SELECT Wartosc,ID_Objektu,Skala,Obroty FROM Przedmioty")
	for i,v in ipairs(q)do
		przedmioty_[v.Wartosc]={v.ID_Objektu,v.Skala,v.Obroty}
	end
	spawny={}
	przedmioty={}
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Loot_spawny")
	for i,v in ipairs(q)do
		if not spawny[v.Typ] then spawny[v.Typ]={} end
		table.insert(spawny[v.Typ],{v.x,v.y,v.z})
	end
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Loot_przedmioty")
	for i,v in ipairs(q)do
		if not przedmioty[v.loot] then przedmioty[v.loot]={} end
		przedm=przedmioty_[v.przedmiot]
		if przedm then
			table.insert(przedmioty[v.loot],{v.przedmiot,v.szansa,przedm[1],przedm[2],przedm[3]})
		else
			print("Coś nie tak z ",inspect(przedm),v.przedmiot)
		end
	end
	magazynki={}
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Magazynki")
	for i,v in ipairs(q) do
		magazynki[v.magazynek]=v.ilosc
	end
	looty={}
end
laduj()

function callFunctionWithSleeps(calledFunction, ...)
    local co = coroutine.create(calledFunction)
    coroutine.resume(co, ...)
end
 
function sleep(time)
    local co = coroutine.running()
    local function resumeThisCoroutine()
        coroutine.resume(co)
    end
    setTimer(resumeThisCoroutine, time, 1)
    coroutine.yield()
end

function table.size(tab)
  local length = 0
  for _ in pairs(tab) do
    length = length + 1
  end
  return length
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
function createItemLoot(typ,x,y,z)
	col = createColSphere(x, y, z, 1)
	table.insert(looty,col)
	setElementData(col,"itemloot", true)
	setElementData(col,"parent",false)
	setElementData(col,"_Limit_Slotow_", 50)
	setElementData(col,"Opis","Kliknij 'J' aby przeszukać")
	setElementData(col,"Nazwa","Przedmioty")

	for i, item in ipairs(przedmioty[typ]) do
		local value = math.percentChance(item[2]*szansa, math.random(1, 2))
		if value>0 then
			if magazynki[item[1]] then
				setElementData(col, item[1], value*magazynki[item[1]])
			else
				setElementData(col, item[1], value)
			end
		end
	end
	refreshItemLoot(col, lootPlace)
	return col
end

function usunlooty()
	for i,col in ipairs(looty) do
		local objects = getElementData(col, "objectsINloot")
		if objects then
			if objects[1] ~= nil and isElement(objects[1]) then
				destroyElement(objects[1])
			end
			if objects[2] ~= nil and isElement(objects[2]) then
				destroyElement(objects[2])
			end
		end
		destroyElement(col)
	end
	looty={}
end
function refreshItemLoot(col, place)
	if getElementData(col,"parent") then return end
  local objects = getElementData(col, "objectsINloot")
  if objects then
    if objects[1] ~= nil then
      destroyElement(objects[1])
    end
    if objects[2] ~= nil then
      destroyElement(objects[2])
    end
  end
  local counter = 0
  local obejctItem = {}
  for i, item in ipairs(przedmioty.other) do
    if getElementData(col, item[1]) and getElementData(col, item[1]) > 0 then
      if counter == 2 then
        break
      end
      counter = counter + 1
      local x, y, z = getElementPosition(col)
      obejctItem[counter] = createObject(item[3],x+math.random(-5,5)/10,y+math.random(-5,5)/10, z - 0.875,item[5],0,0,true)
      setObjectScale(obejctItem[counter],item[4])
      setElementFrozen(obejctItem[counter], true)
    end
  end
  setElementData(col, "objectsINloot", {
    obejctItem[1],
    obejctItem[2]
  },false)
end
addEvent("refreshItemLoot", true)
addEventHandler("refreshItemLoot", getRootElement(), refreshItemLoot)
function spawnItemy()
	laduj()
	callFunctionWithSleeps(function()
		x=0
		for typ,lista in pairs(spawny) do
			x=x+1
			for i,v in ipairs(lista) do
				createItemLoot(typ,v[1],v[2],v[3])
			end
			if x>5 then
				sleep(300)
				x=0
			end
		end
	end)
end
function respawnItemy()
	restartResource(getThisResource())
end
addEvent("przedmiot_odswiez", true)
addEventHandler("przedmiot_odswiez", getRootElement(),respawnItemy)
spawnItemy()

function admin(plr)
	local accName = getAccountName ( getPlayerAccount ( plr ) )
	if not accName then return true end
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
		return false
	else
		return true
	end
end

function odswiezLooty(plr,cmd)
	if admin(plr) then return end
	laduj()
	outputChatBox("Dane odnośnie lootów zostały zaktualizowane!",plr,0,255,0)
end
addCommandHandler("odswiezLooty",odswiezLooty)
--addCommandHandler("resp",spawnItemy)