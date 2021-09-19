antyrelog=0
function onClientPlayerWeaponFireFunc(weapon,ammo,ammoInClip,hitX,hitY,hitZ,hitElement)
	x_,y_,z_=getElementPosition(localPlayer)
	--dis=getDistanceBetweenPoints3D(-100,-275,0,x_,y_,z_)
	--if dis<200 then return end
	--dis=getDistanceBetweenPoints3D(0,0,-50,x_,y_,z_)
	--if dis<55 then return end
	
	if getElementInterior(source)==getElementInterior(localPlayer) and getElementDimension(source)==getElementDimension(localPlayer) then
		x1,y1,z1=getElementPosition(source)
		dis1=getDistanceBetweenPoints3D(x1,y1,z1,x_,y_,z_)
		dis2=getDistanceBetweenPoints3D(x_,y_,z_,hitX,hitY,hitZ)
		if dis1<100 or dis2<50 then
			if getZoneName(x_,y_,z_)=="Restricted Area" then
				antyrelog=25
			else
				antyrelog=15
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponFire",root,onClientPlayerWeaponFireFunc)
setTimer(function()
	if antyrelog>0 then
		antyrelog=antyrelog-1
		setElementData(localPlayer,"anty-relog",true)
	else
		setElementData(localPlayer,"anty-relog",false)
	end
end,1000,0)

w,h=guiGetScreenSize()
function updateAntyRelog()
	if antyrelog and antyrelog>0 then
		dxDrawText ("Anty Relog\nPozostało: "..antyrelog,w/2-100,h/8,w/2+100,100,tocolor(255,0,0,255),1.5,"sans","center")
	end
end
addEventHandler("onClientRender",root,updateAntyRelog)