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

function setVolume()
  value = 0
  if getPedMoveState(getLocalPlayer()) == "stand" then
    value = 0
  elseif getPedMoveState(getLocalPlayer()) == "walk" then
    value = 20
  elseif getPedMoveState(getLocalPlayer()) == "powerwalk" then
    value = 40
  elseif getPedMoveState(getLocalPlayer()) == "jog" then
    value = 80
  elseif getPedMoveState(getLocalPlayer()) == "sprint" then
    value = 100
  elseif getPedMoveState(getLocalPlayer()) == "crouch" then
    value = 0
  elseif not getPedMoveState(getLocalPlayer()) then
    value = 20
  end
  if getElementData(getLocalPlayer(), "shooting") and 0 < getElementData(getLocalPlayer(), "shooting") then
    value = value + getElementData(getLocalPlayer(), "shooting")
  end
  if isPedInVehicle(getLocalPlayer()) then
    value = 100
  end
  if value > 100 then
    value = 100
  end
	setElementData(getLocalPlayer(),"volume",value,false)
end
setTimer(setVolume, 100, 0)
function setVisibility()
  value = 0
  if getPedMoveState(getLocalPlayer()) == "stand" then
    value = 60
  elseif getPedMoveState(getLocalPlayer()) == "walk" then
    value = 60
  elseif getPedMoveState(getLocalPlayer()) == "powerwalk" then
    value = 60
  elseif getPedMoveState(getLocalPlayer()) == "jog" then
    value = 60
  elseif getPedMoveState(getLocalPlayer()) == "sprint" then
    value = 60
  elseif getPedMoveState(getLocalPlayer()) == "crouch" then
    value = 20
  elseif not getPedMoveState(getLocalPlayer()) then
    value = 20
  end
  if getElementData(getLocalPlayer(), "jumping") then
    value = 100
  end
  if isObjectAroundPlayer(getLocalPlayer(), 2, 4) then
    value = 0
  end
  if isPedInVehicle(getLocalPlayer()) then
    value = 0
  end
  setElementData(getLocalPlayer(),"visibly",value,false)
end
setTimer(setVisibility, 100, 0)
function debugJump()
  if getControlState("jump") then
	setElementData(getLocalPlayer(),"jumping",true,false)
    setTimer(debugJump2, 650, 1)
  end
end
setTimer(debugJump, 100, 0)
function debugJump2()
	setElementData(getLocalPlayer(),"jumping",false,false)
end
weaponNoiseTable = {
  {22, 20},
  {23, 0},
  {24, 60},
  {28, 40},
  {32, 40},
  {29, 40},
  {30, 60},
  {31, 60},
  {25, 40},
  {26, 60},
  {27, 60},
  {33, 40},
  {34, 60},
  {36, 60},
  {35, 60}
}
function getWeaponNoise(weapon)
  for i, weapon2 in ipairs(weaponNoiseTable) do
    if weapon == weapon2[1] then
      return weapon2[2]
    end
  end
  return 0
end
function debugShooting()
  if getControlState("fire") then
    local weapon = getPedWeapon(getLocalPlayer())
    local noise = getWeaponNoise(weapon) or 0
	
	setElementData(getLocalPlayer(),"shooting",noise,false)
    if shootTimer then
      killTimer(shootTimer)
    end
    shootTimer = setTimer(debugShooting2, 100, 1)
  end
end
setTimer(debugShooting, 100, 0)
function debugShooting2()
	setElementData(getLocalPlayer(),"shooting",0,false)
  shootTimer = false
end