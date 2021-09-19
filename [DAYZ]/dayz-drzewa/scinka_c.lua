local scinane_drzewo=nil
local scinanie_timer=nil

function findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end

local function zetnijDrzewo()
	if not scinane_drzewo then return end
	local c1,c2=getPedAnimation(localPlayer)
	triggerServerEvent("scieteDrzewo",scinane_drzewo)
	scinane_drzewo=nil
end

function menu_zetnij(drzewo)
	local x,y=getElementPosition(localPlayer)
	local x2,y2=getElementPosition(drzewo)
	if getDistanceBetweenPoints2D(x,y,x2,y2)>5 then return end
	if getPedWeapon(localPlayer)~=9 then return end
	triggerServerEvent("setPedAnimation", localPlayer)
	toggleControl("fire", false)
	setTimer(triggerServerEvent, 700, 1, "setPedAnimation", localPlayer, "CHAINSAW", "WEAPON_csaw", true)
	local rot = findRotation(x,y,x2,y2)
	setElementRotation(localPlayer, 0, 0, rot)
	scinane_drzewo=drzewo
	setElementFrozen(localPlayer, true)
	if isTimer(scinanie_timer) then killTimer(scinanie_timer) end
	scinanie_timer=setTimer(function(plr)
	zetnijDrzewo()
	setElementFrozen(plr, false)
	end, math.random(8000,16000), 1, localPlayer)
end

-- triggerClientEvent("setObjectBreakable", source, false)
addEvent("setObjectBreakable", true)
addEventHandler("setObjectBreakable", resourceRoot, function(state)
	setObjectBreakable(source, state)
end)

local function znajdzDrzewo()
  local x,y,z=getElementPosition(localPlayer)
  local drzewa=getElementsByType("object", resourceRoot)
  for i,v in ipairs(drzewa) do
    local x2,y2,z2=getElementPosition(v)
    if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)<5 then
      if getElementData(v,"tartak:drzewo") then return v end
    end
  end
  return nil
end

bindKey("fire", "down", function()
  if getPedWeaponSlot(localPlayer)~=1 or getPedWeapon(localPlayer)~=9 then return end
  local drzewo=znajdzDrzewo()
  if not drzewo then return end
  menu_zetnij(drzewo)
end)