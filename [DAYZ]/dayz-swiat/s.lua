setWeaponProperty("m4", "poor", "maximum_clip_ammo", 30)
setWeaponProperty("m4", "std", "maximum_clip_ammo", 30)
setWeaponProperty("m4", "pro", "maximum_clip_ammo", 30)
setGlitchEnabled("fastsprint",true)

local handsUp = false
local siting = false
local lying = false
function funcBindHandsup(player, key, keyState)
  if handsUp then
    setPedAnimation(player, false)
    handsUp = false
  else
    if isPedInVehicle(player) then
      return
    end
    setPedAnimation(player, "BEACH", "ParkSit_M_loop", nil, true, false, false, false)
    handsUp = true
  end
end
function funcBindSit(player, key, keyState)
  if siting then
    setPedAnimation(player, false)
    siting = false
  else
    if isPedInVehicle(player) then
      return
    end
    setPedAnimation(player, "SHOP", "SHP_Rob_HandsUp", nil, true, true, false, false)
    siting = true
  end
end
function funcBindLie(player, key, keyState)
  if lying then
    setPedAnimation(player, false)
    lying = false
  else
    if isPedInVehicle(player) then
      return
    end
    setPedAnimation(player, "WUZI", "CS_Dead_Guy", nil, true, false, false)
    lying = true
    function setVisibility()
      value = 0
    end
  end
end

function funcBindLiee(plr,key,kst)
	lying=true
	funcBindLie(plr,key,kst)
end

function bindTheKeys(plr)
	if plr and type(plr)=="userdata" and getElementType(plr)=="player" then
		source=plr
	end
	if getElementData(source,"zbindowaneAnimacje") then return end
  bindKey(source, ",", "down", funcBindHandsup)
  bindKey(source, ".", "down", funcBindSit)
  bindKey(source, "l", "down", funcBindLie)
  bindKey(source, "mouse2", "down", funcBindLiee)  
  setElementData(source,"zbindowaneAnimacje",true,false)
end
for i,v in ipairs(getElementsByType("player")) do
	bindTheKeys(v)
end
addEventHandler("onPlayerSpawn",getRootElement(),bindTheKeys)