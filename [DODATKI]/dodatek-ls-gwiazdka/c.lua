TeleportDoBudynku={1567.6796875,-1333.431640625,17.484375}
TeleportZBudynku={1548.4580078125,-1364.5009765625,327.2109375}
function wejscieNaDach(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,TeleportZBudynku[1],TeleportZBudynku[2]-2,TeleportZBudynku[3]-1)
	end
end
markerNaDach = createMarker(TeleportDoBudynku[1],TeleportDoBudynku[2],TeleportDoBudynku[3],"arrow",1.5,255,255,0,170)
addEventHandler("onClientMarkerHit",markerNaDach,wejscieNaDach)

function zejscieZDachu(player)
	if player==localPlayer and getPedOccupiedVehicle(player)==false then
		x,y,z=getElementPosition(localPlayer)
		setElementPosition(localPlayer,TeleportDoBudynku[1],TeleportDoBudynku[2]+2,TeleportDoBudynku[3]-1)
	end
end
markerZDachu = createMarker(TeleportZBudynku[1],TeleportZBudynku[2],TeleportZBudynku[3],"arrow",1.5,255,255,0,170)
addEventHandler("onClientMarkerHit",markerZDachu,zejscieZDachu)