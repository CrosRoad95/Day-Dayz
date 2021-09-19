col_floors=engineLoadCOL("szklanka1.col")
engineReplaceCOL(col_floors,3781)
col_floors=engineLoadCOL("szklanka2.col")
engineReplaceCOL(col_floors,4587)


snap=5.454

startposA = {1786.6528320313,-1300.0260009766,23.2109375}
startposB = {1787.7136230469,-1307.8233642578,28.671875}


TeleportNaDach={1786.7662353516,-1299.7864990234,121.265625}
TeleportZDachu={1781.61328125,-1302.5667724609,132.734375}
function wejscieNaDach(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,TeleportZDachu[1],TeleportZDachu[2]+3,TeleportZDachu[3])
	end
end
markerNaDach = createMarker(TeleportNaDach[1],TeleportNaDach[2],TeleportNaDach[3],"arrow",1.5,255,255,0,170)
addEventHandler("onClientMarkerHit",markerNaDach,wejscieNaDach)

function zejscieZDachu(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,TeleportNaDach[1],TeleportNaDach[2]+2,TeleportNaDach[3])
	end
end
markerZDachu = createMarker(TeleportZDachu[1],TeleportZDachu[2],TeleportZDachu[3],"arrow",1.5,255,255,0,170)
addEventHandler("onClientMarkerHit",markerZDachu,zejscieZDachu)


TeleportDoBudynku={1784.7156982422,-1297.5578613281,14.375}
TeleportZBudynku={1787.6082763672,-1307.1850585938,23.2109375}
function wejscieNaDach(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,TeleportZBudynku[1],TeleportZBudynku[2]-3,TeleportZBudynku[3])
	end
end
markerNaDach = createMarker(TeleportDoBudynku[1],TeleportDoBudynku[2],TeleportDoBudynku[3],"arrow",1.5,255,255,0,170)
addEventHandler("onClientMarkerHit",markerNaDach,wejscieNaDach)

function zejscieZDachu(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,TeleportDoBudynku[1],TeleportDoBudynku[2]+2,TeleportDoBudynku[3])
	end
end
markerZDachu = createMarker(TeleportZBudynku[1],TeleportZBudynku[2],TeleportZBudynku[3],"arrow",1.5,255,255,0,170)
addEventHandler("onClientMarkerHit",markerZDachu,zejscieZDachu)

function teleportujWGore(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,x,y+2,z+snap)
	end
end
function teleportujWDol(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,x,y-2,z-snap)
	end
end

markerWGore={}
markerWDol={}

for i=0,17 do
	markerWGore[i] = createMarker(startposA[1],startposA[2],startposA[3]+i*snap,"arrow",1.5,0,255,0,170)
	addEventHandler("onClientMarkerHit",markerWGore[i],teleportujWGore)
end

for i=0,17 do
	markerWDol[i] = createMarker(startposB[1],startposB[2],startposB[3]+i*snap,"arrow",1.5,255,0,0,170)
	addEventHandler("onClientMarkerHit",markerWDol[i],teleportujWDol)
end