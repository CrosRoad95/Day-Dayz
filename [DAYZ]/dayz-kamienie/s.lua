function start()
	for i,v in ipairs(exports.db:pobierzTabeleWynikow("select * from Kamienie")) do
		if kamienie[v.ID] and isElement(kamienie[v.ID]) then
			destroyElement(kamienie[v.ID])
			kamienie[v.ID]=nil
		end
		if math.random(1,2)==2 then
			x,y,z=unpack(split(v.pozycja,","))
			kamienie[v.ID]=createObject(321,x,y,z,math.random(0,20)-10,math.random(0,20)-10,math.random(360))
			setElementData(kamienie[v.ID],"IloscKamienia",math.random(4,9),false)
			setElementData(kamienie[v.ID],"ID",v.ID,false)
			
		end
	end
end
kamienie={}
start()
setTimer(start,1000*60*60,0)

function KamienHit(element)
	id=getElementData(element,"ID")
	if id then
		kamien=getElementData(element,"IloscKamienia")
		if kamien>0 then
			setElementData(element,"IloscKamienia",kamien-1)
			x,y,z=getElementPosition(client)
			exports["dayz-looty"]:createItemPickup("Kamien",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(client),getElementDimension(client))
		else
			id=getElementData(element,"ID")
			destroyElement(kamienie[id])
			kamienie[id]=nil
		end
	end
end
addEvent("KamienHit",true)
addEventHandler("KamienHit",resourceRoot,KamienHit)