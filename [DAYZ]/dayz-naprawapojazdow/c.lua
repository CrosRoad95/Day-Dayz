function dxDrawLoading (x, y, width, height, x2, y2, size, color, color2, second)
    local now = getTickCount()
    local seconds = second or 5000
	local color = color or tocolor(0,0,0,170)
	local color2 = color2 or tocolor(255,255,0,170)
	local size = size or 1.00
    local with = interpolateBetween(0,0,0,width,0,0, (now - startTick) / ((startTick + seconds) - startTick), "Linear")
    local text = interpolateBetween(0,0,0,100,0,0,(now - startTick) / ((startTick + seconds) - startTick),"Linear")
    dxDrawRectangle(x, y ,width ,height -10, color)
    dxDrawRectangle(x, y, with ,height -10, color2)
    dxDrawText ( "Naprawianie... "..math.floor(text).."%", x2, y2 , width, height, tocolor ( 0, 255, 0, 255 ), size, "pricedown" )
end

function koniec()
	removeEventHandler("onClientRender",root,renderF)
	render=false
	pojazd=false
	triggerServerEvent("animacjaNaprawyStop",resourceRoot)
end

function renderF()
	if not pojazd then
		koniec()
		return
	end
	if getPedWeapon(localPlayer)~=7 then
		koniec()
		return outputChatBox("Musisz trzymać klucz francuski aby móc naprawiać pojazdy!",255,0,0)
	end
	local x1,y1,z1=getElementPosition(localPlayer)
	local x,y,z=getElementPosition(pojazd)
	if getDistanceBetweenPoints3D(x1,y1,z1,x,y,z)>2 then
		koniec()
		return
	end
	screenx,screeny=getScreenFromWorldPosition(x,y,z,0,false)
	czas=(getTickCount()-startTick)/15
	hppojazdu=getElementHealth(pojazd)
	if czas>=100 then
		hppojazdu=hppojazdu+50
		if hppojazdu>1000 then
			fixVehicle(pojazd) -- ewentualny dźwięk action_repair.ogg
		else
			setElementHealth(pojazd,hppojazdu)
		end
		koniec()
		return
	end
	if type(screenx)=="number" and type(screeny)=="number" then
		dxDrawText("Naprawianie... "..math.floor(czas).."%\nStan pojazdu: "..math.floor(hppojazdu/10).."%",screenx,screeny,0,0, tocolor ( 0, 255, 0, 255 ),1,"sans")
	end
end
render=false
function naprawiaj()
	x,y,z=getElementPosition(localPlayer)
	for i,v in ipairs(getElementsByType("vehicle",getRootElement(),true)) do
		x1,y1,z1=getElementPosition(v)
		if getDistanceBetweenPoints3D(x1,y1,z1,x,y,z)<2 then
			pojazd=v
			if #getVehicleOccupants(pojazd)>0 then
				return outputChatBox("Pojazd musi być pusty abyś mógł go naprawiać!",255,0,0)
			end
			if getPedWeapon(localPlayer)~=7 then
				return outputChatBox("Musisz trzymać klucz francuski aby móc naprawiać pojazdy!",255,0,0)
			end
			if not render then
				render=true
				startTick=getTickCount()
				addEventHandler("onClientRender",root,renderF)
				triggerServerEvent("animacjaNaprawy",resourceRoot)
			end
		end
	end
end
bindKey("mouse2","down",naprawiaj)
function zakoncz()
	if render then
		koniec()
	end
end
bindKey("mouse2","up",zakoncz)