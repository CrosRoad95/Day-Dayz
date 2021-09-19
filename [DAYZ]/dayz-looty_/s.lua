function start()
	magazynki={}
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM Magazynki")
	for i,v in ipairs(q) do
		magazynki[v.magazynek]=v.ilosc
	end
	function math.percentChance(percent, repeatTime)
		local hits = 0
		for i = 1, repeatTime do
			local number = math.random(0, 200) / 2
			if percent >= number then
				hits = hits + 1
			end
		end
		return hits
	end
end
start()

function ladujHospitalboxy()
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM `Hospitalbox_spawny`")
	qq=exports.db:pobierzTabeleWynikow("SELECT * FROM `Hospitalbox_przedmioty`")
	hospitalBoxy={}
	przedmioty={}
	for i,v in ipairs(qq) do
		if not przedmioty[v.Przedmiot] then przedmioty[v.Przedmiot]=0 end
		przedmioty[v.Przedmiot]=przedmioty[v.Przedmiot]+1
	end
	for i,v in pairs(q) do
		hospitalBoxy[i]=createObject(1558,v.x,v.y,v.z)
		col=createColSphere(v.x,v.y,v.z,1.5)
		attachElements(col,hospitalBoxy[i])
		setElementData(col,"itemloot", true)
		setElementData(col,"_Limit_Slotow_",20)
		setElementData(col,"parent",hospitalBoxy[i])
		setElementData(hospitalBoxy[i],"parent",col)
		for ii,vv in pairs(przedmioty) do
			outputDebugString(ii.." : "..vv)
			setElementData(col,ii,vv)
			setElementData(col,"Blood Bag",5)
			
		end
	end
	setTimer(function()
		for i,v in ipairs(hospitalBoxy) do
			parent=getElementData(v,"parent")
			for ii,vv in pairs(przedmioty) do
				setElementData(parent,ii,vv)
			end
		end
	end,1000*60*60*2,0)
end
ladujHospitalboxy()

function ladujCrashSity()
	if crashsite and isElement(crashsite) then
		if getElementData(crashsite,"parent") then
			destroyElement(getElementData(crashsite,"parent"))
		end
		destroyElement(crashsite)
	end
	q=exports.db:pobierzTabeleWynikow("select * from Crashsity")
	r=math.random(#q)
	v=q[r]
	crashsite=createObject(13611,v.x,v.y,v.z,0,0,v.r)
	col=createColSphere(v.x,v.y,v.z,2.5)
	attachElements(col,crashsite)
	setElementData(col,"itemloot", true)
	setElementData(col,"_Limit_Slotow_",50)
	setElementData(col,"parent",crashsite)
	setElementData(crashsite,"parent",col)
	zone=getZoneName(v.x,v.y,v.z,true)
	outputChatBox("Zlokalizowano nowy rozbity crashsite w lokalizacji "..zone,getRootElement(),0,255,0)
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM `Loot_przedmioty` where loot=?","military")
	for i,v in ipairs(q) do
		local value = math.percentChance(v.szansa*3,math.random(1,3))
		if magazynki[v.przedmiot] then
			setElementData(col,v.przedmiot,value*magazynki[v.przedmiot]*2)
		else
			setElementData(col,v.przedmiot,value*2)
		end
	end
end
ladujCrashSity()
setTimer(ladujCrashSity,1000*60*60,0)