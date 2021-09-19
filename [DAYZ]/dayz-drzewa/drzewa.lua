local maleDrzewa={ 618, 617, 700} -- te tez sie nadaja 776, 732, 730, 729 
local duzeDrzewa={ 616, 615, 734, 733, 726}
local scieteDrzewa={ 848, 847,  834, 832, 831 }

function zaladujPunkty()
	punkty={}
	l=exports.db:pobierzTabeleWynikow("SELECT * FROM `Drzewa_spawny`")
	for i,v in pairs(l) do
		setElementPosition(createElement("drzewa"),v.x,v.y,v.z)
		table.insert(punkty,{v.x,v.y,v.z})
	end
end

zaladujPunkty()

local function czyMaleDrzewo(obiekt)
	local model=getElementModel(obiekt)
	for i,v in ipairs(maleDrzewa) do
		if v==model then return true end
	end
	return false
end

local function czyScieteDrzewo(obiekt)
	local model=getElementModel(obiekt)
	for i,v in ipairs(scieteDrzewa) do
		if v==model then return true end
	end
	return false
end

local function drzewaSpool()
	for i,v in ipairs(punkty) do
		if math.random(1,4)==1 or 1==1 then
			if not v.obiekt or not isElement(v.obiekt) or getElementType(v.obiekt)~="object" then	-- sadzimy male drzewko
				local oid=maleDrzewa[math.random(1,#maleDrzewa)]
				v.obiekt=createObject(oid, v[1],v[2],v[3]-1.3)
				setObjectScale(v.obiekt,0.4)
			elseif czyMaleDrzewo(v.obiekt) then
				local skala=getObjectScale(v.obiekt)
				if skala<0.99 then
					setObjectScale(v.obiekt,skala+0.2)
				else
					local oid=duzeDrzewa[math.random(1,#duzeDrzewa)]
					setElementModel(v.obiekt,oid)
                    setElementData(v.obiekt,"tartak:drzewo", true)

				end
			elseif czyScieteDrzewo(v.obiekt) then
				destroyElement(v.obiekt)
				v.obiekt=nil
			end
		end
	end
end
setTimer(drzewaSpool, 1000*60*60,0)

addCommandHandler("rozrosnijdrzewa", drzewaSpool)

-- triggerServerEvent("scieteDrzewo", scinane_drzewo)
addEvent("scieteDrzewo", true)
addEventHandler("scieteDrzewo", resourceRoot, function()
	x,y,z=getElementPosition(client)
	destroyElement(source)
	for i=1,math.random(1,4) do
		exports["dayz-pickup"]:createItemPickup("Wood Pile",1,x+math.random(-10,10)/10,y+math.random(-10,10)/10,z,getElementInterior(client),getElementDimension(client))
	end
	setPedAnimation(client)
	toggleControl(client,"fire",true)
end)

addEvent("setPedAnimation", true)
addEventHandler("setPedAnimation", root, function(block,anim,time,loop,updatePosition,interruptable, freezeLastFrame)
	if (time==nil) then time=-1 end
	if (loop==nil) then loop=true end
	if (updatePosition==nil) then updatePosition=true end
	if (interruptable==nil) then interruptable=true end
	if (freezeLastFrame==nil) then freezeLastFrame=true end
	setPedAnimation(source, block, anim, time, loop, updatePosition, interruptable, freezeLastFrame)
end)