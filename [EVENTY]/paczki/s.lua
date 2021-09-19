przedmioty=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")

function info()
	outputChatBox("Zlokalizowano nową paczke pełną prezentów!",getRootElement(),0,255,0)
end

niema={
["Tent1000"]=true,
["Tent medic"]=true,
["Tent technic"]=true,
["Tent army"]=true,
}
function event(source)
	accountname = getAccountName(getPlayerAccount(source))
	if isObjectInACLGroup("user." .. accountname, aclGetGroup("Admin")) then
		local x, y, z = getElementPosition( source )
		object = createObject(1558, x, y, z-0.1, nil, nil, nil)
		col=createColSphere(x,y,z,2)
		attachElements(col,object)
		setElementData(col,"itemloot", true)
		setElementData(col,"_Limit_Slotow_",20)
		setElementData(col,"parent",object)
		setElementData(object,"parent",col)
		myBlip = createBlip ( x, y, z, 19)
		info()
		for _, items in ipairs(przedmioty) do
			local randomNumber = math.random(1, 100)
			if randomNumber <= 25 then
				setElementData(col, items.Wartosc, math.random(0, 15))
			end
			for i,v in pairs(niema) do
				setElementData(col,i,0)
			end
		end
	end
end
addCommandHandler("event#1", event)
function event2(source)
accountname = getAccountName(getPlayerAccount(source))
if isObjectInACLGroup("user." .. accountname, aclGetGroup("Admin")) then
    local x, y, z = getElementPosition( source )
    object = createObject(944, x, y, z-0.1, nil, nil, nil)
    col=createColSphere(x,y,z,2)
	attachElements(col,object)
	setElementData(col,"itemloot", true)
	setElementData(col,"_Limit_Slotow_",20)
	setElementData(col,"parent",object)
	setElementData(object,"parent",col)
	myBlip = createBlip ( x, y, z, 19)
	info()
		for _, items in ipairs(przedmioty) do
			local randomNumber = math.random(1, 100)
			if randomNumber <= 25 then
				setElementData(col, items.Wartosc, math.random(0, 40))
			end
			for i,v in pairs(niema) do
				setElementData(col,i,0)
			end
		end
end
end
addCommandHandler("event#2", event2)
function event3(source)
accountname = getAccountName(getPlayerAccount(source))
if isObjectInACLGroup("user." .. accountname, aclGetGroup("Admin")) then
    local x, y, z = getElementPosition( source )
    object = createObject(2991, x, y, z-0.1, nil, nil, nil)
    col=createColSphere(x,y,z,2)
	attachElements(col,object)
	setElementData(col,"itemloot", true)
	setElementData(col,"_Limit_Slotow_",20)
	setElementData(col,"parent",object)
	setElementData(object,"parent",col)
	myBlip = createBlip ( x, y, z, 19)
	info()
		for _, items in ipairs(przedmioty) do
			local randomNumber = math.random(1, 100)
			if randomNumber <= 25 then
				setElementData(col, items.Wartosc, math.random(0, 80))
			end
			for i,v in pairs(niema) do
				setElementData(col,i,0)
			end
		end
end
end
addCommandHandler("event#3", event3)