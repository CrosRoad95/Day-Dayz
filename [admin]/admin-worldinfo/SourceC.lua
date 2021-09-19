local sw,sh=guiGetScreenSize()
local Config={}
Config[1]={MiniScale=0.5, MaxScale=1.2,Maxdistance=5}

function DrawVehicle()
for key, vehicle in ipairs(getElementsByType("vehicle", true)) do
	local x,y,z=getElementPosition(vehicle)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local rx,ry,rz = getElementRotation( vehicle )
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(vehicle)
					local VehType = getVehicleType(vehicle)
					local Health = getElementHealth(vehicle)
					local Model = getElementModel(vehicle)
					local Interior, Dimension = getElementInterior(vehicle),getElementDimension(vehicle)
					local Parent = getElementParent(vehicle)
					local Resource = getElementID( getElementParent( getElementParent(vehicle) ) )
					local PreReload = getElementID(Parent)
					local Radius =  getElementRadius(vehicle)
					local Max_Passengers = getVehicleMaxPassengers ( vehicle )
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nType: "..VehType
					Text = Text.."\nHealth: "..Health
					Text = Text.."\nModel: "..Model.." ("..getVehicleNameFromModel( Model )..")"
					Text = Text.."\nPreReload: "..PreReload
					Text = Text.."\nResource: "..Resource		
					Text = Text.."\nGame World: "..Game_World
					Text = Text.."\nMax Passengers: "..Max_Passengers
					Text = Text.."\nDistance: "..Distance
					Text = Text.."\nRadius: "..math.floor(Radius)
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nRotation: "..math.floor(rx)..", "..math.floor(ry)..", "..math.floor(rz)
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					----- Textury
					if textureModel then
						Text = Text.."\nTextures: "
						for key,name in ipairs( engineGetModelTextureNames( getElementModel(vehicle) ) ) do
    						Text = Text.."\n["..key.."] "..name
						end
					end
					-----------
					dxDrawText(Text, sx-(sw/5),sy,sx+(sw/5),sy, tocolor(166,164,164,255), wynik, "default-bold", "center","center",false,true)									
				end
			end
		end
		---- Komponenty
		if Components then
			for v in pairs ( getVehicleComponents(vehicle) ) do
				local x,y,z = getVehicleComponentPosition ( vehicle, v, "world" )
				local wx,wy,wz = getScreenFromWorldPosition ( x, y, z )
				if wx and wy then
					dxDrawText ( v, wx, wy, 0, 0, tocolor(166,164,164,255), 1, "default-bold" )
				end
			end
		end
		------------------------
	end
end


function DrawPlayer()
for key, Player in ipairs(getElementsByType("player", true)) do
	local x,y,z=getElementPosition(Player)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local rx,ry,rz = getElementRotation( Player )
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(Player)
					local Health = getElementHealth(Player)
					local Model = getElementModel(Player)
					local Interior, Dimension = getElementInterior(Player),getElementDimension(Player)
					local Parent = getElementParent(Player)
					local Resource = tostring(false)
					local PreReload = tostring(false)
					local Radius =  getElementRadius(Player)
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nHealth: "..Health
					Text = Text.."\nModel: "..Model
					Text = Text.."\nPreReload: "..PreReload
					Text = Text.."\nResource: "..tostring(Resource)	
					Text = Text.."\nGame World: "..Game_World	
					Text = Text.."\nDistance: "..Distance
					Text = Text.."\nRadius: "..math.floor(Radius)
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nRotation: "..math.floor(rx)..", "..math.floor(ry)..", "..math.floor(rz)
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					----- Textury
					if textureModel then
						Text = Text.."\nTextures: "
						for key,name in ipairs( engineGetModelTextureNames( getElementModel(Player) ) ) do
    						Text = Text.."\n["..key.."] "..name
						end
					end
					dxDrawText(Text, sx-(sw/5),sy,sx+(sw/5),sy, tocolor(166,164,164,255), wynik, "default-bold", "center","center",false,true)									
				end
			end
		end
	end
end

function DrawObject()
for key, Object in ipairs(getElementsByType("object", true)) do
	local x,y,z=getElementPosition(Object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local rx,ry,rz = getElementRotation( Object )
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(Object)
					local Scale = getObjectScale( Object )
					local Health = getElementHealth(Object)
					local Model = getElementModel(Object)
					local Interior, Dimension = getElementInterior(Object),getElementDimension(Object)
					local Parent = getElementParent(Object)
					local Resource = getElementID( getElementParent( getElementParent(Object) ) )
					local PreReload = getElementID(Parent)
					local Radius =  getElementRadius(Object)
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					local Collisions = tostring ( getElementCollisionsEnabled( Object ) )
					local DoubleSide = tostring (isElementDoubleSided ( Object ) )
					local Breakable = tostring ( isObjectBreakable( Object ) )
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nHealth: "..Health
					Text = Text.."\nModel: "..Model
					Text = Text.."\nPreReload:#00ffff"..PreReload
					Text = Text.."\n#a29fa5Resource:#00ffff"..Resource		
					Text = Text.."\n#a29fa5Game World:#00ffff"..Game_World
					Text = Text.."\n#a29fa5Distance: "..Distance
					Text = Text.."\nRadius: "..math.floor(Radius)
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nRotation: "..math.floor(rx)..", "..math.floor(ry)..", "..math.floor(rz)
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					Text = Text.."\nScale: "..Scale
					Text = Text.."\nCollisions: "..Collisions
					Text = Text.."\nDoubleSide: "..DoubleSide
					Text = Text.."\nBreakable: "..Breakable			

					----- Textury
					if textureModel then
						Text = Text.."\nTextures: "
						for key,name in ipairs( engineGetModelTextureNames( getElementModel(Object) ) ) do
    						Text = Text.."\n["..key.."] "..name
						end
					end
					-----------
					dxDrawText(Text, sx-(sw/5),sy+key/100,sx+(sw/5),sy, tocolor(162, 159, 165,255), wynik, "default-bold", "center","center",false,true,false,true)									
				end
			end
		end
	end
end


function DrawColShape()
for key, colshape in ipairs(getElementsByType("colshape", true)) do
	local x,y,z=getElementPosition(colshape)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(colshape)
					local Interior, Dimension = getElementInterior(colshape),getElementDimension(colshape)
					local Parent = getElementParent(colshape)
					local Resource = getElementID( getElementParent( getElementParent(colshape) ) )
					local PreReload = getElementID(Parent)
					local Radius =  getElementRadius(colshape)
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nPreReload: "..PreReload
					Text = Text.."\nResource: "..Resource		
					Text = Text.."\nGame World: "..Game_World
					Text = Text.."\nDistance: "..Distance
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					dxDrawText(Text, sx-(sw/5),sy,sx+(sw/5),sy, tocolor(166,164,164,255), wynik, "default-bold", "center","center",false,true)									
				end
			end
		end
	end
end

function DrawPed()
for key, ped in ipairs(getElementsByType("ped", true)) do
	local x,y,z=getElementPosition(ped)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local rx,ry,rz = getElementRotation( ped )
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(ped)
					local Health = getElementHealth(ped)
					local Model = getElementModel(ped)
					local Interior, Dimension = getElementInterior(ped),getElementDimension(ped)
					local Parent = getElementParent(ped)
					local Resource = getElementID( getElementParent( getElementParent(ped) ) )
					local PreReload = getElementID(Parent)
					local Radius =  getElementRadius(ped)
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nHealth: "..Health
					Text = Text.."\nModel: "..Model
					Text = Text.."\nPreReload: "..PreReload
					Text = Text.."\nResource: "..Resource		
					Text = Text.."\nGame World: "..Game_World
					Text = Text.."\nDistance: "..Distance
					Text = Text.."\nRadius: "..math.floor(Radius)
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nRotation: "..math.floor(rx)..", "..math.floor(ry)..", "..math.floor(rz)
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					----- Textury
					if textureModel then
						Text = Text.."\nTextures: "
						for key,name in ipairs( engineGetModelTextureNames( getElementModel(ped) ) ) do
    						Text = Text.."\n["..key.."] "..name
						end
					end
					-----------
					dxDrawText(Text, sx-(sw/5),sy,sx+(sw/5),sy, tocolor(166,164,164,255), wynik, "default-bold", "center","center",false,true)									
				end
			end
		end
	end
end


function DrawMarker()
for key, marker in ipairs(getElementsByType("marker", true)) do
	local x,y,z=getElementPosition(marker)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(marker)
					local Interior, Dimension = getElementInterior(marker),getElementDimension(marker)
					local Parent = getElementParent(marker)
					local Resource = getElementID( getElementParent( getElementParent(marker) ) )
					local PreReload = getElementID(Parent)
					local Radius =  getElementRadius(marker)
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					local r, g, b = getMarkerColor(marker)
					local icon = getMarkerIcon(marker)
					local size = getMarkerSize(marker)
					local TypeM = getMarkerType(marker)
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nType: "..TypeM
					Text = Text.."\nColor: ("..r..", "..g..", "..b..")"
					Text = Text.."\nSize: "..size
					Text = Text.."\nIcon: "..tostring(icon)
					Text = Text.."\nPreReload: "..PreReload
					Text = Text.."\nResource: "..Resource		
					Text = Text.."\nGame World: "..Game_World
					Text = Text.."\nDistance: "..Distance
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					dxDrawText(Text, sx-(sw/5),sy+key/100,sx+(sw/5),sy, tocolor(166,164,164,255), wynik, "default-bold", "center","center",false,true)									
				end
			end
		end
	end
end

function DrawPickUp()
for key, pickup in ipairs(getElementsByType("pickup", true)) do
	local x,y,z=getElementPosition(pickup)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
if distance < MaxDistance then
		local sx,sy = getScreenFromWorldPosition(x,y,z, 200)
			if (sx and sy) then
				if not getElementData(localPlayer,"radarOff") then
					local x,y,z = math.floor(x), math.floor(y), math.floor(z)
					local Wynik = interpolateBetween (Config[1].MaxScale,0,0,Config[1].MiniScale,0,0,distance/Config[1].Maxdistance,"OutQuad")
					local offsetY = dxGetFontHeight(Wynik,"defalut")
					local Type = getElementType(pickup)
					local Model = getElementModel(pickup)
					local Interior, Dimension = getElementInterior(pickup),getElementDimension(pickup)
					local Parent = getElementParent(pickup)
					local Resource = getElementID( getElementParent( getElementParent(pickup) ) )
					local PreReload = getElementID(Parent)
					local Distance = string.format("%0.2f",distance/100)
					local Game_World = getElementType(Parent)
					local PType = getPickupType(pickup)
					Text = "("..Type..") Server ID: "..tostring(key)
					Text = Text.."\nType: "..PType
					Text = Text.."\nModel: "..Model
					Text = Text.."\nPreReload: "..PreReload
					Text = Text.."\nResource: "..Resource		
					Text = Text.."\nGame World: "..Game_World
					Text = Text.."\nDistance: "..Distance
					Text = Text.."\nRadius: "..tostring(false)
					Text = Text.."\nPosition: "..x..", "..y..", "..z
					Text = Text.."\nInterior: "..Interior
					Text = Text.."\nDimension: "..Dimension
					dxDrawText(Text, sx-(sw/5),sy,sx+(sw/5),sy, tocolor(166,164,164,255), wynik, "default-bold", "center","center",false,true)									
				end
			end
		end
	end
end

function CollisionMode()
for i, object in ipairs(getElementsByType("vehicle", root, true)) do
	local x,y,z=getElementPosition(object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
		if distance < MaxDistance then
			showGridlines(object)
		end
	end
for i, object in ipairs(getElementsByType("player", root, true)) do
	local x,y,z=getElementPosition(object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
		if distance < MaxDistance then
			drawTheAreaElement(object)
		end
	end
for i, object in ipairs(getElementsByType("marker", root, true)) do
	local x,y,z=getElementPosition(object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
		if distance < MaxDistance then
			drawTheAreaElement(object)
		end
	end
for i, object in ipairs(getElementsByType("ped", root, true)) do
	local x,y,z=getElementPosition(object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
		if distance < MaxDistance then
			drawTheAreaElement(object)
		end
	end
for i, object in ipairs(getElementsByType("object", root, true)) do
	local x,y,z=getElementPosition(object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
		if distance < MaxDistance then
			showGridlines(object)
		end
	end	
for i, object in ipairs(getElementsByType("pickup", root, true)) do
	local x,y,z=getElementPosition(object)
	local rootx, rooty, rootz = getCameraMatrix()
	local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)
		if distance < MaxDistance then
			showGridlines(object)
		end
	end		
end

function EyeMode()
	textureModel = getElementData(getLocalPlayer(  ),"helper").texture
	Components = getElementData(getLocalPlayer(  ),"helper").components
	DrawMarker()
	DrawPed()
	DrawObject()
	DrawPlayer()
	DrawVehicle()
	DrawColShape()
	DrawPickUp()
end

function toggleCollisionMode(Toggle)
	if Toggle then
		MaxDistance = 10
		addEventHandler("onClientRender",getRootElement(),CollisionMode)
	else
		removeEventHandler("onClientRender",getRootElement(),CollisionMode)
	end
end
addEvent( "toggleCollisionMode", true )
addEventHandler( "toggleCollisionMode", root, toggleCollisionMode)

function toggleEyeMode(Toggle)
	if Toggle then
		MaxDistance = 10
		addEventHandler("onClientRender",getRootElement(),EyeMode)
	else
		removeEventHandler("onClientRender",getRootElement(),EyeMode)
	end
end
addEvent( "toggleEyeMode", true )
addEventHandler( "toggleEyeMode", root, toggleEyeMode)

function toggleDeveloperMode(Toggle)
	setDevelopmentMode( Toggle )
end
addEvent( "toggleDeveloperMode", true )
addEventHandler( "toggleDeveloperMode", root, toggleDeveloperMode)

--- # Obiekty dynamiczne sa czytane bezposrednio z tabliczy na obiekty Rootowalne lepiej uzyc showGridlines()
function drawTheAreaElement(Element)
local camX,camY,camZ = getCameraMatrix()
x, y, z = getElementPosition(Element) 
local thickness = (100/getDistanceBetweenPoints3D(camX,camY,camZ,x,y,z)) * .8
local Line = thickness/5
if getElementType(Element) == "marker" then
	renderGridlines(Element) 
else
local minx, miny, minz, mx, my, mz = getElementBoundingBox(Element)     
-- UP
                dxDrawLine3D(minx+x, miny+y, mz+z, minx+x, my+y ,mz+z, tocolor(200, 0, 0, 180), Line, false, 0)
                dxDrawLine3D(minx+x, miny+y, mz+z, mx+x, miny+y ,mz+z, tocolor(200, 0, 0, 180), Line, false, 0)
                dxDrawLine3D(mx+x, my+y, mz+z, minx+x, my+y ,mz+z, tocolor(200, 0, 0, 180), Line, false, 0)
                dxDrawLine3D(mx+x, miny+y, mz+z, mx+x, my+y ,mz+z, tocolor(200, 0, 0, 180), Line, false, 0)
--- DOWN
                dxDrawLine3D(minx+x, miny+y, minz+z, minx+x, my+y ,minz+z, tocolor(200, 0, 0, 180), Line, false, 0)
                dxDrawLine3D(minx+x, miny+y, minz+z, mx+x, miny+y ,minz+z, tocolor(200, 0, 0, 180), Line, false, 0)
               	dxDrawLine3D(mx+x, my+y, minz+z, minx+x, my+y ,minz+z, tocolor(200, 0, 0, 180), Line, false, 0)
                dxDrawLine3D(mx+x, miny+y, minz+z, mx+x, my+y ,minz+z, tocolor(200, 0, 0, 180), Line, false, 0)
-- Podpory oparte o punkty laczeniowe
				dxDrawLine3D(minx+x,miny+y,minz+z,minx+x,miny+y,mz+z,tocolor(200, 0, 0, 180), Line, false, 0)
				dxDrawLine3D(mx+x,my+y,minz+z,mx+x,my+y,mz+z,tocolor(200, 0, 0, 180), Line, false, 0)
				dxDrawLine3D(mx+x,miny+y,mz+z, mx+x,miny+y,minz+z,tocolor(200, 0, 0, 180), Line, false, 0)
				dxDrawLine3D(minx+x,my+y,mz+z, minx+x,my+y,minz+z,tocolor(200, 0, 0, 180), Line, false, 0)
	end
end
