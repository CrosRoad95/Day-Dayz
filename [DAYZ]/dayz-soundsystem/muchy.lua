function dzwiekMuch()
	x,y,z=getElementPosition(localPlayer)
	for i,v in ipairs(getElementsByType("ped",true)) do
		x1,y1,z1=getElementPosition(v)
		if getDistanceBetweenPoints3D(x1,y1,z1,x,y,z)<120 then
			if getElementHealth(v)<=1 then
				sound("effects/hive.ogg",x1,y1,z1,100,{})
			end
		end
	end
end
setTimer(dzwiekMuch,3000,0)
dzwiekMuch()