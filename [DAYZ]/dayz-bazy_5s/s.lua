function start()
	q=exports.db:pobierzTabeleWynikow("select * from Bazy_5sekund")
	for i,v in ipairs(q) do
		x,y,z=unpack(split(v.pozycja,","))
		createColSphere(x,y,z,v.zasieg)
	end
	q=nil
end
start()

timers={}
function hit(plr,matchingDimension)
	if getElementType(plr)=="player" then
		if timers[plr] then
			if isTimer(timers[plr]) then
				killTimer(timers[plr])
			end
			timers[plr]=nil
		end
		outputChatBox("Masz 5 sekund na opuszczenie terenu bazy!",plr,255,0,0)
		timers[plr]=setTimer(function(gracz)
			x,y,z=getElementPosition(gracz)
			exports.db:zapytanie("insert into Logi_5sekundowka values(null,null,?,?,?)",getPlayerName(gracz),getPlayerSerial(gracz),x..","..y..","..z)
			setElementData(gracz,"_Krew_",-69845)
		end,5000,1,plr)
	end
end
addEventHandler("onColShapeHit",resourceRoot,hit)
function leave(plr,matchingDimension)
	if getElementType(plr)=="player" then
		if timers[plr] then
			if isTimer(timers[plr]) then
				killTimer(timers[plr])
			end
			timers[plr]=nil
		end
	end
end
addEventHandler("onColShapeLeave",resourceRoot,leave)