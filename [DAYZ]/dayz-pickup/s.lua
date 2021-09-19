function laduj()
	przedmioty_={}
	q=exports.db:pobierzTabeleWynikow("SELECT Wartosc,ID_Objektu,Skala,Obroty FROM Przedmioty")
	for i,v in ipairs(q)do
		przedmioty_[v.Wartosc]={v.ID_Objektu,v.Skala,v.Obroty}
	end
end
laduj()
function createItemPickup(item,ilosc,x,y,z,i,d)
	if item and x and y and z then 
		local object = createObject(przedmioty_[item][1],x,y,z,przedmioty_[item][3],0,math.random(0, 360),true)
		if not object then
			object = createObject(2675,x,y,z,przedmioty_[item][3],0,math.random(0, 360),true)
		end
		if not object then
			if isElement(object) then
				destroyElement(object)
			end
			return
		end
		moveObject(object,500,x,y,z-0.875,0,0,0,"OutBounce")
		setObjectScale(object,przedmioty_[item][2])
		setElementFrozen(object, true)
		local col = createColSphere(x, y, z, 0.75)
		setElementData(col,"*przedmiot*",item)
		setElementData(col,"*ilosc*",ilosc)
		setElementData(col,"parent",object,false)
		setElementData(col,"pickup",true)
		setElementData(col,"Opis","pickit")
		setElementData(col,"extra",{opis=item})
		setElementInterior(col,i)
		setElementDimension(col,d)
		setElementInterior(object,i)
		setElementDimension(object,d)
		setTimer(function(c,o)
			if isElement(c) then
				destroyElement(c)
				destroyElement(o)
			end
		end, 900000, 1,col,object)
		return object
	end
end

function admin(plr)
	local accName = getAccountName ( getPlayerAccount ( plr ) )
	if not accName then return true end
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
		return false
	else
		return true
	end
end

function odswiezPickupy(plr,cmd)
	if admin(plr) then return end
	laduj()
	outputChatBox("Dane odnośnie pickupow zostały zaktualizowane!",plr,0,255,0)
end
addCommandHandler("odswiezPickupy",odswiezPickupy)