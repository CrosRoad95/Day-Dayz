addCommandHandler("sting",
function(player)
if (player) then
local x, y, z = getElementPosition(player)
spike = createObject(2892,x+2,y+2,z-1)
local x2, y2, z2 = getElementPosition(spike)
blow = createColRectangle(x2, y2, z2, 3.0,3.0)
if (getElementType("vehicle")) then
local pveh = getPedOccupiedVehicle(player)
if (getVehicleWheelStates(pveh) == false) then
 setVehicleWheelStates(pveh,1,1,1,1)
elseif (getVehicleWheelStates(pveh)[1] == 1) then
setVehicleWheelStates(pveh,2,2,2,2)
end
end
end
end)


function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end

function kolczatkacol(el)
	if getElementType(el)=="vehicle" then
		a,b,c,d=getVehicleWheelStates(el)
		if a==0 or b==0 or c==0 or d==0 then
			if a==0 and math.random(1,2)==1 then
				a=1
			end
			if b==0 and math.random(1,2)==1 then
				b=1
			end
			if c==0 and math.random(1,2)==1 then
				c=1
			end
			if d==0 and math.random(1,2)==1 then
				d=1
			end
			setVehicleWheelStates(el,a,b,c,d)
			vx,vy,vz=getVehicleTurnVelocity(el)
			vz=vz+math.random(-10,10)/25
			setVehicleTurnVelocity(el,vx,vy,vz)
		end
	end
end
addEventHandler("onColShapeHit",resourceRoot,kolczatkacol)

function stworzKolczatke(x,y,z,r)
	spike=createObject(2892,x,y,z,0,0,r)
	col={}
	z=z+1
	col[1]=createColSphere(x,y,z,1)
	x,y=getPointFromDistanceRotation(x,y,2,-r-180)
	col[2]=createColSphere(x,y,z,1)
	x,y=getPointFromDistanceRotation(x,y,2,-r-180)
	col[3]=createColSphere(x,y,z,1)
	x,y=getPointFromDistanceRotation(x,y,6,-r)
	col[4]=createColSphere(x,y,z,1)
	x,y=getPointFromDistanceRotation(x,y,2,-r)
	col[5]=createColSphere(x,y,z,1)
	cols={col[1],col[2],col[3],col[4],col[5]}
	
	for i=1,5 do
		setElementData(col[i],"parent",spike)
		setElementData(col[i],"other",true)
		
		setElementData(col[i],"Opis","kolczatka")
		setElementData(col[i],"Opcje",{{"Zniszcz kolczatke","zniszcz_kolczatke"},})
		setElementData(col[i],"kolczatka",true)
		setElementData(col[i],"kolizje_kolczatki",cols)
	end
end	

function kolczatka(plr)
	x,y,z=getElementPosition(plr)
	_,_,r=getElementRotation(plr)
	x,y=getPointFromDistanceRotation(x,y,1,-r)
	stworzKolczatke(x,y,z-.8,r+90)
end
addCommandHandler("kolczatka",kolczatka)