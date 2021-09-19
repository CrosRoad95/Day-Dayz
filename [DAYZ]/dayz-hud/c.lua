sx,sy=guiGetScreenSize()
screenWidth,screenHeight=guiGetScreenSize()
render=false
sprint=10000
sprintdzielnik=100
sprintlimit=sprint
sprintregen=4
sprintwlaczony=true

function odnowSprint ( )
	sprint=sprintlimit
end
addEventHandler("onClientPlayerSpawn",getLocalPlayer(),odnowSprint)

function getText(lng,typ,data,rpl)
	return exports["dayz-jezyki"]:getText(lng,typ,data,rpl)
end

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end

function dxDrawEmptyRectangle(startX,startY,endX,endY,color,width,postGUI)
	dxDrawLine ( startX,startY,startX+endX,startY,color,width,postGUI )
	dxDrawLine ( startX,startY,startX,startY+endY,color,width,postGUI )
	dxDrawLine ( startX,startY+endY,startX+endX,startY+endY, color,width,postGUI )
	dxDrawLine ( startX+endX,startY,startX+endX,startY+endY,color,width,postGUI )
end
function getElementSpeed(theElement,unit)
    -- Check arguments for errors
    assert(isElement(theElement),"Bad argument 1 @ getElementSpeed (element expected,got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle","Invalid element type @ getElementSpeed (player/ped/object/vehicle expected,got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"),"Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- default-bold to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector,after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement))*mult).length
end
function math.round(number,decimals,method)
    decimals = decimals or 2
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number*factor)/factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end
function rysuj()
	if not isElement(getElementData(localPlayer,"AktualnyLoot")) or getPedOccupiedVehicle(localPlayer) then
		return pokazukryj(false)
	end
	xx,yy=getScreenFromWorldPosition(x,y,z,0,false)
	if xx then
		dxDrawRectangle(xx-100,yy-50,200,100,tocolor(50,50,50,200))
		aktualnakolizia=getElementData(localPlayer,"AktualnyLoot")
		extra=getElementData(aktualnakolizia,"extra") or {}
		parentelement=getElementData(aktualnakolizia,"parent")
		pojazdname=""
		if parentelement then
			if getElementType(parentelement)=="vehicle" then
				pojazdname=getVehicleName(parentelement)
			end
		end
		oppis=getText("detect","guitexts",opis,{{"$vehiclename",pojazdname},{"[[][E][]]","\n"}})
		if extra and extra.opis then
			oppisextra=getText("detect","items",extra.opis,{})
			if not string.find(oppisextra,"***TODO") then
				dxDrawText(oppis.."\n"..oppisextra,xx-100,yy-50,xx+100,yy+50,tocolor(255,255,255,255),1,"sans","center","center")
			else
				dxDrawText(oppis.."\n"..extra.opis,xx-100,yy-50,xx+100,yy+50,tocolor(255,255,255,255),1,"sans","center","center")
			end
		else
			dxDrawText(oppis,xx-100,yy-50,xx+100,yy+50,tocolor(255,255,255,255),1,"sans","center","center")
		end
	end
	if opcje then
		for i=1,#opcje do
			dxDrawRectangle(20,sy/2+i*20,220,19,tocolor(50,50,50,200))
			if i==zaznaczony then
				dxDrawEmptyRectangle(20,sy/2+i*20,220,19,tocolor(0,255,0,255))
			end
			dxDrawText(opcje[i][1],20,sy/2+i*20,220,(sy/2+i*20)+20,tocolor(255,255,255,255),1,"sans","center","center")
		end
		dxDrawRectangle(20,sy/2+(#opcje+1)*20,220,19,tocolor(0,0,0,255))
		dxDrawText(getText("detect","guitexts","select_x",{}),20,sy/2+(#opcje+1)*20,220,(sy/2+(#opcje+1)*20)+20,tocolor(0,255,0,255),1,"sans","center","center")
	end
end
function pokazukryj(bol)
	if bol then
		if not render then
			render=true
			addEventHandler("onClientRender",root,rysuj)
		end
	else
		if render then
			render=false
			removeEventHandler("onClientRender",root,rysuj)
		end
	end
end

function scrolup()
	if not zaznaczony then return false end
	zaznaczony=zaznaczony-1
	if zaznaczony<1 and opcje then
		zaznaczony=#opcje
	end
end
function scroldown()
	if not zaznaczony then return false end
	zaznaczony=zaznaczony+1
	if opcje and zaznaczony>#opcje then
		zaznaczony=1
	end
end
bindKey("mouse_wheel_up","down",scrolup)
bindKey("mouse_wheel_down","down",scroldown)
function uzyj()
	aktualnakolizja=getElementData(localPlayer,"AktualnyLoot")
	if aktualnakolizja then
		zaznaczone=opcje[zaznaczony][2]
		opcj=opcje[zaznaczony]
		triggerServerEvent("uzyj",resourceRoot,aktualnakolizja,zaznaczone,opcj)
	end
end
bindKey("x","down",uzyj)

function pokazInfo(theElement,md)
	if getElementInterior(theElement)==getElementInterior(source) and theElement and getElementDimension(theElement)==getElementDimension(source) then
		if md then
			if theElement==localPlayer and (getElementData(source,"itemloot") or getElementData(source,"pickup") or getElementData(source,"other")) then
				x,y,z=getElementPosition(source)
				opi=getElementData(source,"Opis")
				opcje=getElementData(source,"Opcje")
				zaznaczony=1
				setElementData(localPlayer,"Loot",true,false)
				setElementData(localPlayer,"AktualnyLoot",source,false)
				if opi then
					opis=opi
					pokazukryj(true)
				end
			end
		end
	end
end
function ukryjInfo(theElement,md)
	if md then
		if theElement==localPlayer then
			setElementData(localPlayer,"Loot",false,false)
			setElementData(localPlayer,"AktualnyLoot",false,false)
			pokazukryj(false)
		end
	end
end
addEventHandler("onClientColShapeHit",getRootElement(),pokazInfo)
addEventHandler("onClientColShapeLeave",getRootElement(),ukryjInfo)

nieograniczonePaliwo={
[509]=true,
}

function getVehicleSpeed( element,x,y,z )
	return (x^2+y^2+z^2) ^ 0.5
end
--[{"silnikow":[4,3],"kol":[1,1],"zuzycie_paliwa":[0.5],"paliwo":[100,67],"zbiornikow":[1,1]}]
tick=getTickCount()
function rysuj_hud_pojazdu()
	veh=getPedOccupiedVehicle(localPlayer)
	if not veh then
		return removeEventHandler("onClientRender",root,rysuj_hud_pojazdu)
	end
	if nieograniczonePaliwo[getElementModel(veh)] then
		setVehicleEngineState(veh,true)
		return
	end
	dane=getElementData(veh,"Dane")
	if not dane then return end
	if dane.silnikow[1]<=dane.silnikow[2] then
		silnik="#00ff00"..getText("detect","guitexts","engine",{})..":"..dane.silnikow[2].."/"..dane.silnikow[1]
	else
		silnik="#ff0000"..getText("detect","guitexts","engine",{})..":"..dane.silnikow[2].."/"..dane.silnikow[1]
	end
	if dane.kol[1]<=dane.kol[2] then
		kola="#00ff00"..getText("detect","guitexts","wheel",{})..":"..dane.kol[2].."/"..dane.kol[1]
	else
		kola="#ff0000"..getText("detect","guitexts","wheel",{})..":"..dane.kol[2].."/"..dane.kol[1]
	end
	if dane.zbiornikow[1]<=dane.zbiornikow[2] then
		zbiornik="#00ff00"..getText("detect","guitexts","tankpart",{})..":"..dane.zbiornikow[2].."/"..dane.zbiornikow[1]
	else
		zbiornik="#ff0000"..getText("detect","guitexts","tankpart",{})..":"..dane.zbiornikow[2].."/"..dane.zbiornikow[1]
	end
	predkosc=getText("detect","guitexts","speed",{})..":"..math.floor(getVehicleSpeed(veh,getElementVelocity(veh))*100*1.61)
	wytrzymalosc=getText("detect","guitexts","health",{})..": "..math.floor(getElementHealth(veh)/10).."%"
	if dane.paliwo[1]/10<=dane.paliwo[2] then
		paliwo="#00ff00"..getText("detect","guitexts","fuel",{})..":"..math.round(dane.paliwo[2],2).."/"..dane.paliwo[1]
	else
		paliwo="#ff0000"..getText("detect","guitexts","fuel",{})..":"..math.round(dane.paliwo[2],2).."/"..dane.paliwo[1]
	end
	if dane.paliwo[2]>0 then
		dane.paliwo[2]=dane.paliwo[2]-(getElementSpeed(veh,"km/h")/1000000)*dane.zuzycie_paliwa[1]
	else
		dane.paliwo[2]=0
	end
	if dane.paliwo[2]<=0 or dane.silnikow[1]~=dane.silnikow[2] or dane.kol[1]~=dane.kol[2] or dane.zbiornikow[1]~=dane.zbiornikow[2] then
		setVehicleEngineState(veh,false)
	else
		setVehicleEngineState(veh,true)
	end
	setElementData(veh,"Dane",dane,false)
	if tick+1000<getTickCount() then
		tick=getTickCount()
		setElementData(veh,"Dane",dane)
	end
	dxDrawText(silnik.."\n"..kola.."\n"..zbiornik.."\n"..paliwo.."\n"..predkosc.."\n"..wytrzymalosc,0,0,sx,40,tocolor(255,255,255,255),1.2,"sans","center","top",false,false,false,true)
end
function wejscie_do_pojazdu()
	addEventHandler("onClientRender",root,rysuj_hud_pojazdu)
end
addEventHandler("onClientPlayerVehicleEnter",localPlayer,wejscie_do_pojazdu)
function wyjscie_z_pojazdu()
	removeEventHandler("onClientRender",root,rysuj_hud_pojazdu)
end
addEventHandler("onClientPlayerVehicleExit",localPlayer,wyjscie_z_pojazdu)

function targetingActivated(target)
	nacelowanyGracz=target
end
addEventHandler("onClientPlayerTarget",getRootElement(),targetingActivated)

fading = 0
fading2 = "up"
tick1=getTickCount()
function hud()
	if getElementData(localPlayer,"Login")==false then return end
	playerState=getPedMoveState(localPlayer)
	if isElementInWater(localPlayer) then
		setFPSLimit(25)
	else
		setFPSLimit(100)
	end
	if isElementInWater(localPlayer) or isPedInVehicle(localPlayer) or playerState=="walk" or playerState=="crawl" or playerState=="crouch" or playerState=="stand" or playerState=="jog" then
		if math.floor(sprint/sprintdzielnik)>20 then
			sprint=sprint+sprintregen*(getTickCount()-tick1)/100*5
			tick1=getTickCount()
		else
			sprint=sprint+sprintregen*(getTickCount()-tick1)/100*10
			tick1=getTickCount()
		end
	else
		sprint=sprint-sprintregen*(getTickCount()-tick1)/100
		tick1=getTickCount()
	end
	if math.floor(sprint/sprintdzielnik)>20 and getElementData(localPlayer,"_Zlamana_Kosc_")==false then
		sprintwlaczony=true
	elseif math.floor(sprint/sprintdzielnik)<=0 then
		sprintwlaczony=false
	else
		if isPedInVehicle(localPlayer) or playerState=="walk" or playerState=="crawl" or playerState=="crouch" or playerState=="stand" or playerState=="jog" then
			sprintwlaczony=false
		end
	end
	if sprint>sprintlimit then
		sprint=sprintlimit
	end
	if sprint<0 then
		sprint=0
	end
	toggleControl("sprint",sprintwlaczony)
	if fading >= 0 and fading2 == "up" then
		fading = fading+5
	elseif fading <= 255 and fading2 == "down" then
		fading = fading-5
	end
	if fading == 0 then
		fading2 = "up"
	elseif fading == 255 then
		fading2 = "down"
	end
	dxDrawImage(screenWidth*0.9325,screenHeight*0.375,screenHeight*0.075,screenHeight*0.075,"ikony/sound.png",0,0,0,tocolor(0,255,0))
	local sound = getElementData(localPlayer,"volume")/20
	if sound > 1 then
		dxDrawImage(screenWidth*0.9075,screenHeight*0.375,screenHeight*0.075,screenHeight*0.075,"ikony/level_" .. sound .. ".png",0,0,0,tocolor(0,255,0))
	end
	dxDrawImage(screenWidth*0.9325,screenHeight*0.475,screenHeight*0.075,screenHeight*0.075,"ikony/eye.png",0,0,0,tocolor(0,255,0))
	local sound = getElementData(localPlayer,"visibly")/20
	if sound > 1 then
		dxDrawImage(screenWidth*0.9075,screenHeight*0.475,screenHeight*0.075,screenHeight*0.075,"ikony/level_" .. sound .. ".png",0,0,0,tocolor(0,255,0))
	end
	if getElementData(localPlayer,"_Zlamana_Kosc_") then
		dxDrawImage(screenWidth*0.9375,screenHeight*0.55,screenHeight*0.065,screenHeight*0.065,"ikony/brokenbone.png",0,0,0,tocolor(255,255,255))
	end
	local humanity = getElementData(localPlayer,"_Ludzkosc_")
	if (humanity or 0) > 0 then
		do
			local humanity = getElementData(localPlayer,"_Ludzkosc_")/9.8
			r,g,b = 255-humanity,humanity,0
		end
	else
		r,g,b = 255,0,0
	end
	dxDrawImage(screenWidth*0.925,screenHeight*0.6,screenHeight*0.1,screenHeight*0.1,"ikony/bandit.png",0,0,0,tocolor(r,g,b))
	local temperature = math.round(getElementData(localPlayer,"_Temperatura_")/100,2)
	r,g,b = 0,255,0
	if temperature <= 37 then
		value = (37-temperature)*42.5
		r,g,b = 0,255-value,value
	elseif temperature > 37 and temperature < 41 then
		r,g,b = 0,255,0
	elseif temperature>41 then
		r,g,b = 255,0,0
	end
	if value > 215 then
		dxDrawImage(screenWidth*0.94,screenHeight*0.7,screenHeight*0.065,screenHeight*0.065,"ikony/temperature.png",0,0,0,tocolor(r,g,b,fading))
	else
		dxDrawImage(screenWidth*0.94,screenHeight*0.7,screenHeight*0.065,screenHeight*0.065,"ikony/temperature.png",0,0,0,tocolor(r,g,b))
	end
	r,g,b = 0,255,0
	local blood = getElementData(localPlayer,"_Krew_")/47.2
	r,g,b = 255-blood,blood,0
	dxDrawImage(screenWidth*0.94,screenHeight*0.85,screenHeight*0.065,screenHeight*0.065,"ikony/blood.png",0,0,0,tocolor(r,g,b))
	if 0 < getElementData(localPlayer,"_Krwawienie_") then
		dxDrawImage(screenWidth*0.94,screenHeight*0.85,screenHeight*0.065,screenHeight*0.065,"ikony/medic.png",0,0,0,tocolor(255,255,255,fading))
	end
	r,g,b = 0,255,0
	local food = getElementData(localPlayer,"_Glod_")*2.55
	r,g,b = 255-food,food,0
	if food < 15 then
		dxDrawImage(screenWidth*0.94,screenHeight*0.925,screenHeight*0.065,screenHeight*0.065,"ikony/food.png",0,0,0,tocolor(r,g,b,fading))
	else
		dxDrawImage(screenWidth*0.94,screenHeight*0.925,screenHeight*0.065,screenHeight*0.065,"ikony/food.png",0,0,0,tocolor(r,g,b))
	end

	r,g,b = 0,255,0
	local thirst = getElementData(localPlayer,"_Pragnienie_")*2.55
	r,g,b = 255-thirst,thirst,0
	if thirst < 15 then
		dxDrawImage(screenWidth*0.9,screenHeight*0.92,screenHeight*0.065,screenHeight*0.065,"ikony/thirsty.png",0,0,0,tocolor(r,g,b,fading))
	else
		dxDrawImage(screenWidth*0.9,screenHeight*0.92,screenHeight*0.065,screenHeight*0.065,"ikony/thirsty.png",0,0,0,tocolor(r,g,b))
	end
	if math.floor(sprint/sprintdzielnik)>20 then
		dxDrawImage(screenWidth*0.94,screenHeight*0.775,screenHeight*0.065,screenHeight*0.065,"ikony/kondycja.png",0,0,0,tocolor(255-(sprint/sprintlimit)*255,(sprint/sprintlimit)*255,0,255))
	else
		dxDrawImage(screenWidth*0.94,screenHeight*0.775,screenHeight*0.065,screenHeight*0.065,"ikony/kondycja.png",0,0,0,tocolor(255-(sprint/sprintlimit)*255,(sprint/sprintlimit)*255,0,fading))
	end
	dxDrawText(math.floor(sprint/sprintdzielnik).."%",screenWidth*0.94,screenHeight*0.775,screenHeight*0.065,screenHeight*0.065)

	local x,y,z = getElementPosition(localPlayer)
	mojagrupa=getElementData(localPlayer,"grupa")
	sojusze=getElementData(getLocalPlayer(),"grupa_sojusze")
	if nacelowanyGracz and isElement(nacelowanyGracz) and getElementType(nacelowanyGracz)=="player" then
		local px,py,pz = getElementPosition(nacelowanyGracz)
		local w = dxGetTextWidth(text,1.03,"default-bold")
		local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
		if not sx then return end
		grupa=getElementData(nacelowanyGracz,"grupa")
		text=getPlayerName(nacelowanyGracz)
		if grupa and mojagrupa and mojagrupa[1] == grupa[1] then
			dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,255,0,200),1.00,"default-bold")
		elseif grupa and mojagrupa and sojusze[mojagrupa[1]..":"..grupa[1]] then
			dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,0,255,200),1.00,"default-bold")
		else
			dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(255,0,0,200),1.00,"default-bold")
		end
	end
	SupportStatus=getElementData(localPlayer,"SupportStatus")
	dim=getElementDimension(localPlayer)
	int=getElementInterior(localPlayer)
	for i,player in ipairs(getElementsByType("player",getRootElement,true)) do
		setPlayerNametagShowing(player,false)
		if player ~= localPlayer then
			if int==getElementInterior(player) and dim==getElementDimension(player) then
				local px,py,pz = getElementPosition(player)
				local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
				if pdistance <= 3 or SupportStatus == true and pdistance <= 100 then
					local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
					if sx and sy then
						text = string.gsub(getPlayerName(player),"#%x%x%x%x%x%x","")
						local w = dxGetTextWidth(text,1.03,"default-bold")
						grupa=getElementData(player,"grupa")
						if grupa and mojagrupa and mojagrupa[1] == grupa[1] then
							dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,255,0,200),1.00,"default-bold")
						elseif grupa and sojusze and sojusze[mojagrupa[1]..":"..grupa[1]] then
							dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(0,0,255,200),1.00,"default-bold")
						else
							dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(255,0,0,200),1.00,"default-bold")
						end
					end
				else
					local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
					if sx and sy and pdistance >= 100 and SupportStatus == true then
						text = "G"
						local w = dxGetTextWidth(text,1.03,"default-bold")
						dxDrawText(text,sx-w/2-30,sy,sx-w/2,sy+25,tocolor(255,0,0,200),1.00,"default-bold")
					end
				end
			end
		end
	end
	local x,y,z = getElementPosition(localPlayer)
	local vehicle = getPedOccupiedVehicle(localPlayer)
	for i,veh in ipairs(getElementsByType("vehicle",getRootElement(),true)) do
		if int==getElementInterior(veh) and dim==getElementDimension(veh) then
			local px,py,pz = getElementPosition(veh)
			local vehID = getElementModel(veh)
			if veh ~= vehicle and vehID ~= 548 then
				local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
				if pdistance <= 6 then
					local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
					if sx and sy then
						local w = dxGetTextWidth(getVehicleName(veh),1.02,"default-bold")
						dxDrawText(getVehicleName(veh),sx-w/2,sy,sx-w/2,sy,tocolor(100,255,100,255),1.02,"default-bold")
					end
				elseif SupportStatus == true then
					local sx,sy = getScreenFromWorldPosition(px,py,pz+0.95,0.06)
					if sx and sy then
						local w = dxGetTextWidth(getVehicleName(veh),1.02,"default-bold")
						dxDrawText("P",sx-w/2,sy,sx-w/2,sy,tocolor(100,255,100,255),1.02,"default-bold")
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,hud)

function playerStatsClientSite()
	toggleControl("radar",true)
	showPlayerHudComponent("all",false)
	showPlayerHudComponent("crosshair",true)
	showPlayerHudComponent("weapon",true)
	setPlayerHudComponentVisible("ammo",true)
	if getElementData(localPlayer,"Login")==false then return end
	toggleControl("radar",false)
	showPlayerHudComponent("clock",false)
	showPlayerHudComponent("radar",false)
	showPlayerHudComponent("money",false)
	showPlayerHudComponent("health",false)
	showPlayerHudComponent("breath",false)
	if getElementData(localPlayer,"Map") >= 1 then
		toggleControl("radar",true)
	else
		forcePlayerMap(false)
	end
	if 1 <= getElementData(localPlayer,"GPS") then
		showPlayerHudComponent("radar",true)
	end
	if 1 <= getElementData(localPlayer,"Watch") then
		showPlayerHudComponent("clock",true)
	end
end
playerStatsClientSite()
setTimer(playerStatsClientSite,1000,0)


statsLabel = {}

statsWindows = guiCreateStaticImage(0.85,0.18,0.15,0.20,"ikony/debugtlo.png",true)
guiSetAlpha(statsWindows,1)

-- FACEBOOK
statsLabel["label"] = guiCreateLabel(0,0,1,1,"",true,statsWindows)
guiSetFont(statsLabel["label"],"default-bold-small")
guiLabelSetColor(statsLabel["label"],255,255,255)
guiLabelSetVerticalAlign ( statsLabel["label"],"center" )
guiLabelSetHorizontalAlign ( statsLabel["label"],"center" )

if getElementData(localPlayer,"logedin") then
    guiSetVisible(statsWindows,true)
else
    guiSetVisible(statsWindows,false)
end

function showDebugMonitor ()
    local visible = guiGetVisible(statsWindows)
	if visible then
		guiSetVisible(statsWindows,true)
	else
		guiSetVisible(statsWindows,false)
		end
end
bindKey("F5","down",showDebugMonitor)

function showDebugMintorOnLogin ()
    guiSetVisible(statsWindows,true)
end
addEvent("onClientPlayerDayZLogin",true)
addEventHandler("onClientPlayerDayZLogin",root,showDebugMintorOnLogin)
function opis_namiotu(kolizja)
	edytowanaKolizja=kolizja
	opcje=false
	showCursor(true)
	local tempgui=guiCreateWindow(0,0,300,100,getText("detect","guitexts","change_desc",{}),false)
	local nowyopis=guiCreateEdit(10,30,280,25,"",false,tempgui)
	guiEditSetMaxLength(nowyopis,40)
	local zapisz_opis=guiCreateButton(10,65,100,25,getText("detect","guitexts","save",{}),false,tempgui)
	local anuluj_opis=guiCreateButton(190,65,100,25,getText("detect","guitexts","cancel",{}),false,tempgui)
	centerWindow(tempgui)
	function zapisz_opis_f()
		extra=getElementData(edytowanaKolizja,"extra") or {}
		extra.opis=guiGetText(nowyopis)
		setElementData(edytowanaKolizja,"extra",extra)
		outputChatBox(getText("detect","messages","desc_succes",{}),0,255,0)
		removeEventHandler("onClientGUIClick",zapisz_opis,zapisz_opis_f,false)
		removeEventHandler("onClientGUIClick",anuluj_opis,anuluj_opis_f,false)
		destroyElement(tempgui)
		showCursor(false)
	end
	function anuluj_opis_f()
		outputChatBox(getText("detect","messages","desc_cancel",{}),0,255,0)
		removeEventHandler("onClientGUIClick",zapisz_opis,zapisz_opis_f,false)
		removeEventHandler("onClientGUIClick",anuluj_opis,anuluj_opis_f,false)
		destroyElement(tempgui)
		showCursor(false)
	end
	addEventHandler("onClientGUIClick",zapisz_opis,zapisz_opis_f,false)
	addEventHandler("onClientGUIClick",anuluj_opis,anuluj_opis_f,false)
end
addEvent("opis_namiotu",true)
addEventHandler("opis_namiotu",root,opis_namiotu)
function haslo_skrzynki(kolizja)
	edytowanaKolizja=kolizja
	opcje=false
	showCursor(true)
	local tempgui=guiCreateWindow(0,0,300,150,getText("detect","guitexts","change_pass",{}),false)
	guiCreateLabel(10,35,80,25,getText("detect","guitexts","old_pass",{}),false,tempgui)
	local oldpass=guiCreateEdit(90,30,200,25,"",false,tempgui)
	guiEditSetMaxLength(oldpass,8)
	guiCreateLabel(10,65,80,25,getText("detect","guitexts","new_pass",{}),false,tempgui)
	local newpass=guiCreateEdit(90,60,200,25,"",false,tempgui)
	guiEditSetMaxLength(newpass,8)
	
	local zapisz_haslo=guiCreateButton(10,110,100,25,getText("detect","guitexts","save",{}),false,tempgui)
	local anuluj_haslo=guiCreateButton(190,110,100,25,getText("detect","guitexts","cancel",{}),false,tempgui)
	centerWindow(tempgui)
	function zapisz_haslo_f()
		extra=getElementData(edytowanaKolizja,"extra") or {}
		if tostring(extra.haslo)==guiGetText(oldpass) or extra.haslo==nil then
			extra.haslo=guiGetText(newpass)
			setElementData(edytowanaKolizja,"extra",extra)
			outputChatBox(getText("detect","messages","pass_succes",{{"$pass",guiGetText(newpass)}}),0,255,0)
			removeEventHandler("onClientGUIClick",zapisz_haslo,zapisz_haslo_f,false)
			removeEventHandler("onClientGUIClick",anuluj_haslo,anuluj_haslo_f,false)
			destroyElement(tempgui)
			showCursor(false)
		else
			outputChatBox(getText("detect","messages","pass_wrong",{}),0,255,0)
		end
	end
	function anuluj_haslo_f()
		outputChatBox(getText("detect","messages","pass_cancel",{}),0,255,0)
		removeEventHandler("onClientGUIClick",zapisz_haslo,zapisz_haslo_f,false)
		removeEventHandler("onClientGUIClick",anuluj_haslo,anuluj_haslo_f,false)
		destroyElement(tempgui)
		showCursor(false)
	end
	addEventHandler("onClientGUIClick",zapisz_haslo,zapisz_haslo_f,false)
	addEventHandler("onClientGUIClick",anuluj_haslo,anuluj_haslo_f,false)
	guiSetInputMode("no_binds_when_editing")
end
addEvent("haslo_skrzynki",true)
addEventHandler("haslo_skrzynki",root,haslo_skrzynki)

function refreshDebugMonitor()
    if getElementData(getLocalPlayer(),"Login") then
		local zombiealive = getElementData(getRootElement(),"zombiesalive") or 0
		local zombietotal = getElementData(getRootElement(),"zombiestotal") or 0
		local zabitezombie = getElementData(getLocalPlayer(),"_Zabite_Zombie(Aktualnie)_")
        local headshot = getElementData(getLocalPlayer(),"_Headshoty(Aktualnie)_")
        local morderstwa = getElementData(getLocalPlayer(),"_Morderstwa(Aktualnie)_")
        local krew = getElementData(getLocalPlayer(),"_Krew_")
        local temp = getElementData(getLocalPlayer(),"_Temperatura_")
        local ludzk = getElementData(getLocalPlayer(),"_Ludzkosc_")
		--local dorespu = getElementData(getLocalPlayer(),"DoRespawnu")
		
		guiSetText(statsLabel["label"],getText("detect","guitexts","blood",{})..": "..krew.."\n"..getText("detect","guitexts","murders",{})..": "..morderstwa.."\n"..getText("detect","guitexts","killedzombies",{})..": "..zabitezombie.."\n"..getText("detect","guitexts","zombie",{})..": "..zombiealive.."/"..zombietotal.."\n"..getText("detect","guitexts","temperature",{})..": "..math.round(temp/100,2).."\n"..getText("detect","guitexts","humanity",{})..": "..ludzk.."\n"..getText("detect","guitexts","debugmonitor_bottom",{{"[[][E][]]","\n"}}))
    end         
end
setTimer(refreshDebugMonitor,2000,0)
function showDebugMonitor()
  local visible = guiGetVisible(statsWindows)
  guiSetVisible(statsWindows,not visible)
end
bindKey("F5","down",showDebugMonitor)

function showDebugMintorOnLogin()
  guiSetVisible(statsWindows,true)
end
setTimer(refreshDebugMonitor,1000,0)

addEventHandler("onClientResourceStart", getResourceRootElement(),
function()
	guiSetInputMode("no_binds_when_editing")
end)