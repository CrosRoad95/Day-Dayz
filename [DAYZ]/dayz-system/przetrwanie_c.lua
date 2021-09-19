damageTable=getElementData(resourceRoot,"damageTable")
bronamunicja=getElementData(resourceRoot,"bronamunicja")

function strzelanie(weapon)
	local ammo=bronamunicja[weapon]
	if not ammo then return end
	ammoIlosc=getElementData(localPlayer,ammo.amunicja)
	if ammoIlosc>0 then
		setElementData(localPlayer,ammo.amunicja,ammoIlosc-1)
	end
end
addEventHandler("onClientPlayerWeaponFire",localPlayer,strzelanie)
function uderz(attacker, weapon, bodypart, loss)
	cancelEvent()
	if getElementData(localPlayer,"_Krew_")<=0 then
		triggerServerEvent("gracz_zabij",getLocalPlayer(), false, false)
	end
	local x, y, z = getElementPosition(getLocalPlayer())
	--dis=getDistanceBetweenPoints3D(-100,-275,0,x,y,z)
	--if dis<200 then return end
	if weapon == 37 then return end
	if loss >= 100 then
		triggerServerEvent("gracz_zabij", getLocalPlayer(), false, false)
	end
	if loss > 30 then
		setElementData(localPlayer,"_Zlamana_Kosc_",true)
		setControlState("jump", true)
	end
	traci=getElementData(getLocalPlayer(), "_Krew_")
	if attacker and getElementType(attacker) == "ped" then
		traci=traci-math.random(300,600)
	end
	if weapon and weapon > 1 and attacker and getElementType(attacker) == "player" then
		local number = math.random(1, 8)
		if number >= 6 or number <= 8 then
			kraw = getElementData(getLocalPlayer(), "_Krwawienie_") + math.floor(loss * 10)
			setElementData(localPlayer,"_Krwawienie_",kraw)
		end
		local number = math.random(1, 7)
		damage = damageTable[weapon]
		headshot=0
		if bodypart ==9 then
			damage=damage*2
			headshot=1
		end
		if damage then
			utrata = math.random(damage * 0.8, damage * 1.2)
		else
			utrata = math.random(100, 1000)
		end
		if bodypart == 7 or bodypart == 8 then
			setElementData(localPlayer,"_Zlamana_Kosc_",true)
		end
		if number == 2 then
			setElementData(localPlayer,"_Bol_Glowy_",true)
		end
		traci =traci-utrata
	else
		traci=traci-loss*10
	end
	setElementData(localPlayer,"_Krew_",math.floor(traci))
	if traci<0 then
		triggerServerEvent("gracz_zabij",getLocalPlayer(),attacker,weapon,headshot)
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), uderz)

function pedGetDamageDayZ(attacker, weapon, bodypart, loss)
  cancelEvent()
  if attacker and attacker == getLocalPlayer() then
    damage = 100
    if weapon == 37 then
      return
    end
    if weapon == 63 or weapon == 51 or weapon == 19 then
      setElementData(source, "_Krew_", 0)
      if 0 >= getElementData(source, "_Krew_") then
        triggerServerEvent("Zabij_zombie", source, attacker)
      end
    elseif weapon and weapon > 1 and attacker and getElementType(attacker) == "player" then
      damage = damageTable[weapon]
      if bodypart == 9 then
        damage = damage * 1.1
        headshot = true
      end
      setElementData(source, "_Krew_", getElementData(source, "_Krew_") - math.random(damage * 0.75, damage * 1.25))
      if 0 >= getElementData(source, "_Krew_") then
        triggerServerEvent("Zabij_zombie", source, attacker, headshot)
      end
    end
  end
end
addEventHandler("onClientPedDamage", getRootElement(), pedGetDamageDayZ)

function createBloodForBleedingPlayers()
  if getElementData(getLocalPlayer(), "Login") then
    local x, y, z = getElementPosition(getLocalPlayer())
    for i, player in ipairs(getElementsByType("player")) do
      local bleeding = getElementData(player, "_Krwawienie_") or 0
      if bleeding > 0 then
        local px, py, pz = getPedBonePosition(player, 3)
        local pdistance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        if bleeding > 600 then
          number = 5
        elseif bleeding > 300 then
          number = 3
        elseif bleeding > 100 then
          number = 1
        else
          number = 0
        end
        if pdistance <= 120 then
          fxAddBlood(px, py, pz, 0, 0, 0, number, 1)
        end
      end
    end
end
end
i=0
function check()
	if not getElementData(localPlayer,"Login") then return end
	i=i+1
	krew=getElementData(localPlayer,"_Krew_")
	krwawienie=getElementData(localPlayer,"_Krwawienie_")
	if i>60 then
		glod=getElementData(localPlayer,"_Glod_")
		pragnienie=getElementData(localPlayer,"_Pragnienie_")
		if glod<0 then glod=1 end
		if pragnienie<0 then glod=1 end
		if math.random(1,2)==1 then
			setElementData(localPlayer,"_Glod_",glod-1)
		end
		setElementData(localPlayer,"_Pragnienie_",pragnienie-1)
		i=0
	end
	if getElementData(localPlayer,"_Zlamana_Kosc_") then
		toggleControl("jump",false)
		toggleControl("sprint",false)
	else
		toggleControl("jump",true)
		toggleControl("sprint",true)
	end
	if getElementData(localPlayer,"_Bol_Glowy_") then
		local x, y, z = getElementPosition(localPlayer)
		createExplosion(x, y, z + 15, 8, false, 1, false)
	end
	createBloodForBleedingPlayers()
	if getElementData(localPlayer,"_Glod_")<0 or getElementData(localPlayer,"_Pragnienie_")<0 or krwawienie>0 then
		setElementData(localPlayer,"_Krew_",krew-5-krwawienie)
	end
	if krew and krew<=0 then
		triggerServerEvent("gracz_zabij",getLocalPlayer(), false, false)
	end
end
setTimer(check,1000,0)

function dayZDeathInfo()
  fadeCamera(false, 1, 0, 0, 0)
  showDayZDeathScreen()
end
addEvent("onClientPlayerDeathInfo", true)
addEventHandler("onClientPlayerDeathInfo", getRootElement(), dayZDeathInfo)
function showDayZDeathScreen()
  setTimer(fadeCamera, 1000, 1, true, 1.5)
  deadBackground = guiCreateStaticImage(0, 0, 1, 1, "zdjecie/zgon.jpg", true)
  deathText = guiCreateLabel(0, 0.8, 1, 0.2, [[
Zginąłeś! 
Odrodzisz się za 5 sekund!]], true)
  guiLabelSetHorizontalAlign(deathText, "center")
  setTimer(destroyElement, 5000, 1, deathText)
  setTimer(destroyElement, 5000, 1, deadBackground)
end

function abortAllStealthKills(targetPlayer)
    cancelEvent()
end
addEventHandler("onClientPlayerStealthKill", getLocalPlayer(), abortAllStealthKills)