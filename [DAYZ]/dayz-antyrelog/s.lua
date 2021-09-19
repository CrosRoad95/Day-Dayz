function pobierzEQ(gracz)
	Przedmioty={}
	q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
	for i,v in ipairs(q) do
		table.insert(Przedmioty,v.Wartosc)
	end
	eq={}
	for i,v in ipairs(Przedmioty) do
		if not gracz then return {} end
		ilosc=getElementData(gracz,v)
		if ilosc and ilosc>0 then
			eq[v]=ilosc
		end
	end
	return eq
end

function antyrelog()
	if getElementData(source,"anty-relog") then
		outputChatBox(getPlayerName(source).." wylogował się podczas walki!!!",getRootElement(),255,0,0)
		x,y,z=getElementPosition(source)
		i,d=getElementInterior(source),getElementDimension(source)
		pos={x=math.floor(x),y=math.floor(y),z=math.floor(z),i=i,d=d}
		exports.db:zapytanie("insert into Logi_antyrelog values(null,?,?,now(),?,?)",getPlayerName(source).." |"..getElementData(source,"UID"),getPlayerSerial(source),toJSON(pos),toJSON(pobierzEQ(source),true))
		uid=getElementData(source,"UID")
		setTimer(function(id)
			exports.db:zapytanie("update Konta set krew=-99999 where ID=? limit 1",id)
		end,5000,1,uid)
	end
end
addEventHandler("onPlayerQuit",getRootElement(),antyrelog)