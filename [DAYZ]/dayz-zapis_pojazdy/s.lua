function start()
	q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
	przedmiotyDoZapisu={}
	for i,v in ipairs(q) do
		table.insert(przedmiotyDoZapisu,v.Wartosc)
	end
end
start()

function zapisz()
	start()
	pojazdy={}
	for i,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v,"pojazd") then
			pojazd={}
			parent=getElementData(v,"parent")
			x,y,z=getElementPosition(v)
			i,d=getElementInterior(v),getElementDimension(v)
			rx,ry,rz=getElementRotation(v)
			sloty=getElementData(parent,"_Limit_Slotow_")
			kolizja=getElementData(parent,"kolizja")
			dane=getElementData(v,"Dane")
			przedmioty={}
			for ii,vv in ipairs(przedmiotyDoZapisu) do
				item=getElementData(parent,vv)
				if item and item>0 then
					przedmioty[vv]=item
				end
			end
			pojazd={["pos"]={x,y,z,i,d,rx,ry,rz},["model"]=getElementModel(v),["sloty"]=sloty,["kolizja"]=kolizja,["dane"]=dane,["itemy"]=przedmioty}
			table.insert(pojazdy,toJSON(pojazd,true))
		end
	end
	exports.db:zapytanie("insert into Zapis_pojazdy values(NULL,now(),?)",table.concat(pojazdy,"&&&"))
end

function zaladuj(id)
	for i,v in ipairs(getElementsByType("vehicle")) do
		parent=getElementData(v,"parent")
		if parent then
			destroyElement(parent)
			destroyElement(v)
		end
	end
	q=exports.db:pobierzTabeleWynikow("select * from Zapis_pojazdy where ID=?",id)
	if #q==0 then return false end
	for i,v in ipairs(split(q[1].zapis,"&&&")) do
		v=fromJSON(v)
		x,y,z,i,d,rx,ry,rz=unpack(v.pos)
		pojazd=exports["dayz-pojazdy"]:stworzPojazd(v.model,x,y,z,rx,ry,rz,v.kolizja,v.sloty)
		if pojazd then
			col=getElementData(pojazd,"parent")
			setElementData(pojazd,"Dane",v.dane)
			for ii,vv in ipairs(przedmiotyDoZapisu) do
				setElementData(col,vv,0)
			end
			for item,ilosc in pairs(v.itemy) do
				setElementData(col,item,ilosc)
			end
		end
	end
end

function autoStart()
	id=exports.db:pobierzTabeleWynikow("SELECT MAX(ID) as ID FROM Zapis_pojazdy")
	zaladuj(id[1].ID)
end
addEventHandler("onResourceStart",resourceRoot,autoStart)
function autoZapis()
	zapisz()
end
addEventHandler("onResourceStop",resourceRoot,autoZapis)
setTimer(zapisz,1000*60*60,0)