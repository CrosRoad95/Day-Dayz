objektyAttach = {}
objektyAttach["Plecaki"] = {}
objektyAttach["BronieNaPlecachA"] = {}
objektyAttach["BronieNaPlecachB"] = {}
objektyAttach["BronieNaPlecachC"] = {}
objektyAttach["TrzymaneBronie"] = {}

function laduj()
	tabelaPlecakowS={}
	tabelaBronie={}
	q=exports.db:pobierzTabeleWynikow("select * from Plecaki")
	for i,v in ipairs(q) do
		tabelaPlecakowS[v.sloty]={v.nazwa,v.objekt,v.offset}
	end
	q=exports.db:pobierzTabeleWynikow("SELECT * FROM bronie")
	for i,v in ipairs(q) do
		tabelaBronie[v.bron]=v
	end
	
end
laduj()
function aktualizujAttachGracza(plr,usun,arg1,arg2,arg3)
	--if source then plr=source end
	for i,v in pairs(objektyAttach) do
		if objektyAttach[i][plr] then
			exports.bone_attach:detachElementFromBone(objektyAttach[i][plr])
			destroyElement(objektyAttach[i][plr])
			objektyAttach[i][plr] = false
		end
	end
	if usun then return end
	--outputConsole(getPlayerName(plr).."("..getElementType(source)..") : "..tostring(usun).." : "..tostring(arg1).." : "..tostring(arg2).." : "..tostring(arg3).." ")
	local x, y, z = getElementPosition(plr)
	local rx, ry, rz = getElementRotation(plr)
	-- PLECAK
	plecak=tabelaPlecakowS[getElementData(plr,"_Limit_Slotow_")]
	if not plecak then plecak=tabelaPlecakowS[8] end
	objektyAttach["Plecaki"][plr] = createObject(plecak[2], x, y, z)
	--	setObjectScale(objektyAttach["Plecaki"][plr],0.2)
	exports.bone_attach:attachElementToBone(objektyAttach["Plecaki"][plr],plr,3,unpack(fromJSON(plecak[3])))--unpack(fromJSON(plecak[3]))

	local bron=getElementData(plr,"_Aktualnabron_1_")
	if bron and bron~="" then
		local bronT = tabelaBronie[bron]
		if bronT and bronT.id_broni~=arg2 or not arg2 then
			objektyAttach["BronieNaPlecachA"][plr] = createObject(bronT.id_objektu, x, y, z)
			setObjectScale(objektyAttach["BronieNaPlecachA"][plr], 0.875)
			exports.bone_attach:attachElementToBone(objektyAttach["BronieNaPlecachA"][plr],plr, 3, 0.17,-0.05,0.2,176,240,0)
		end
	end
	local bron=getElementData(plr,"_Aktualnabron_2_")
	if bron and bron~="" then
		local bronT = tabelaBronie[bron]
		if bronT and bronT.id_broni~=arg2 or not arg2 then
			objektyAttach["BronieNaPlecachB"][plr] = createObject(bronT.id_objektu, x, y, z)
			setObjectScale(objektyAttach["BronieNaPlecachB"][plr], 0.875)
			exports.bone_attach:attachElementToBone(objektyAttach["BronieNaPlecachB"][plr],plr, 3, -0.18, -0.05, -0.1, 180,-90, 90)
		end
	end
end

function start()
	for i,v in ipairs(getElementsByType("player")) do
		aktualizujAttachGracza(v)
	end
end
setTimer(start,100,1)
function spawnGracza()
	aktualizujAttachGracza(source)
end
addEventHandler("onPlayerSpawn",getRootElement(),spawnGracza)

timeout={}
function zmianaBroni(pre,cur)
	if timeout[source] then
		if timeout[source]+400>getTickCount() then
			cancelEvent()
			--iprint(source,"spam switch")
			return
		end
	end
	timeout[source]=getTickCount()
	aktualizujAttachGracza(source,false,pre,cur)
end
addEventHandler("onPlayerWeaponSwitch",getRootElement(),zmianaBroni)
function quitPlayer()
	aktualizujAttachGracza(source,true)
	timeout[source]=nil
end
addEventHandler("onPlayerQuit",getRootElement(),quitPlayer)
