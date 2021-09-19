zombiespawny=getElementData(resourceRoot,"$zombiesspawny")
dataz=getElementData(resourceRoot,"$zombies")

function checkZombies()
  zombiesalive = 0
  zombiestotal = 0
  for i, ped in ipairs(getElementsByType("ped")) do
    if getElementData(ped, "zombie") then
      zombiesalive = zombiesalive + 1
    end
    if getElementData(ped, "deadzombie") then
      zombiestotal = zombiestotal + 1
    end
  end
  setElementData(getRootElement(), "zombiesalive", zombiesalive)
  setElementData(getRootElement(), "zombiestotal", zombiestotal + zombiesalive)
  
end
setTimer(checkZombies, 5000, 0)
function checkZombies3()
  local x, y, z = getElementPosition(getLocalPlayer())
  for i, ped in ipairs(getElementsByType("ped")) do
    if getElementData(ped, "zombie") then
      local sound = (getElementData(getLocalPlayer(),"volume")/5)*(getElementData(ped,"sluch")/100)
      local visibly = (getElementData(getLocalPlayer(),"visibly")/5)*(getElementData(ped,"wzrok")/100)
      local xZ, yZ, zZ = getElementPosition(ped)
      if getDistanceBetweenPoints3D(x, y, z, xZ, yZ, zZ) < sound + visibly then
        if getElementData(ped, "leader") == nil then
          triggerServerEvent("botAttack", getLocalPlayer(), ped)
        end
      else
        if getElementData(ped, "target") == getLocalPlayer() then
          setElementData(ped, "target", nil)
        end
        if getElementData(ped, "leader") == getLocalPlayer() then
          triggerServerEvent("botStopFollow", getLocalPlayer(), ped)
        end
      end
    end
  end
end
setTimer(checkZombies3, 500, 0)
function getGroundMaterial(x, y, z)
  local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z, x, y, z - 10, true, false, false, true, false, false, false, false, nil)
  return material
end
function isInBuilding(x, y, z)
  local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z, x, y, z + 10, true, false, false, true, false, false, false, false, nil)
  if hit then
    return true
  end
  return false
end
function isObjectAroundPlayer2(thePlayer, distance, height)
  material_value = 0
  local x, y, z = getElementPosition(thePlayer)
  for i = math.random(0, 360), 360 do
    local nx, ny = getPointFromDistanceRotation(x, y, distance, i)
    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z + height, nx, ny, z + height, true, false, false, false, false, false, false, false)
    if material == 0 then
      material_value = material_value + 1
    end
    if material_value > 40 then
      return 0, hitX, hitY, hitZ
    end
  end
  return false
end
function isObjectAroundPlayer(thePlayer, distance, height)
  local x, y, z = getElementPosition(thePlayer)
  for i = math.random(0, 360), 360 do
    local nx, ny = getPointFromDistanceRotation(x, y, distance, i)
    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material = processLineOfSight(x, y, z + height, nx, ny, z + height)
    if material == 0 then
      return material, hitX, hitY, hitZ
    end
  end
  return false
end
function getPointFromDistanceRotation(x, y, dist, angle)
  local a = math.rad(90 - angle)
  local dx = math.cos(a) * dist
  local dy = math.sin(a) * dist
  return x + dx, y + dy
end
function zombieSpawning()
	local x, y, z = getElementPosition(getLocalPlayer())
	spawny={}
	for i,v in ipairs(zombiespawny) do
		dis=getDistanceBetweenPoints3D(x,y,z,v.x,v.y,v.z)
		if dis>50 and dis <100 then
			local dat=dataz[v.typ].data
			szansa=math.random(1,100)
			if szansa>=dat.czestotliwosc then
				table.insert(spawny,i)
			end
		end
	end
	if #spawny>0 then
		i=spawny[math.random(#spawny)]
		triggerServerEvent("stworz_zombie",resourceRoot,i)
	end
end
setTimer(zombieSpawning, 1000, 0)
function stopZombieSound()
  local zombies = getElementsByType("ped")
  for theKey, theZomb in ipairs(zombies) do
    setPedVoice(theZomb, "PED_TYPE_DISABLED")
  end
end
setTimer(stopZombieSound, 5000, 0)