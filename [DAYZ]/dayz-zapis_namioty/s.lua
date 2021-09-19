function start()
	q=exports.db:pobierzTabeleWynikow("select Wartosc from Przedmioty")
	przedmiotyDoZapisu={}
	for i,v in ipairs(q) do
		table.insert(przedmiotyDoZapisu,v.Wartosc)
	end
end
start()

modelopcje={
[3243]={[1]={{"-","nic"},{"Zniszcz","zniszcz_objekt"},{"Ustaw opis","ustaw_opis"}},[2]="Namiot"},
[964]={[1]={{"-","nic"},{"Zniszcz","zniszcz_objekt"},{"Ustaw opis","ustaw_opis"},{"Ustaw hasło","ustaw_haslo"}},[2]="Skrzynia"},
}

function zapisz()
	start()
	namioty={}
	ilosc=0
	for i,v in ipairs(getElementsByType("colshape")) do
		if getElementData(v,"namiot") then
			parent=getElementData(v,"parent")
			ilosc=ilosc+1
			namiot={}
			x,y,z=getElementPosition(v)
			i,d=getElementInterior(v),getElementDimension(v)
			rx,ry,rz=getElementRotation(parent)
			sloty=getElementData(v,"_Limit_Slotow_")
			przedmioty={}
			for ii,vv in ipairs(przedmiotyDoZapisu) do
				item=getElementData(v,vv)
				if item and item>0 then
					przedmioty[vv]=item
				end
			end
			extradata=getElementData(v,"extra") or {}
			namiot={
				["pos"]={x,y,z,rx,ry,rz,i,d},
				["slt"]=sloty,
				["itemy"]=przedmioty,
				["extra"]=toJSON(extradata,true),
				["model"]=getElementModel(parent),
			}
			table.insert(namioty,toJSON(namiot,true))
		end
	end
	exports.db:zapytanie("insert into Zapis_namioty values(NULL,now(),?)",table.concat(namioty,"&&&"))
	return true
end
function zaladuj(id)
	q=exports.db:pobierzTabeleWynikow("select * from Zapis_namioty where ID=?",id)
	if #q==0 then return false end
	for i,v in ipairs(split(q[1].zapis,"&&&")) do
		zapis=fromJSON(v)
		if zapis then
			x,y,z,rx,ry,rz,i,d=unpack(zapis.pos)
			tent = createObject(zapis.model,x,y,z-.875,rx,ry,rz)
			col=createColSphere(x,y,z,1.15)
			setElementInterior(col,i)
			setElementDimension(col,d)
			setElementInterior(tent,i)
			setElementDimension(tent,d)
			setElementData(col,"itemloot",true)
			setElementData(col,"namiot",true,false)
			setElementData(col,"parent",tent)
			setElementData(col,"Opis",modelopcje[zapis.model][2] or modelopcje[3243][2])
			setElementData(col,"_Limit_Slotow_",zapis.slt)
			if zapis.extra then
				setElementData(col,"extra",fromJSON(zapis.extra))
			else
				setElementData(col,"extra",{})
			end
			setElementData(col,"Opcje",modelopcje[zapis.model][1] or modelopcje[3243][1])
			for ii,vv in ipairs(przedmiotyDoZapisu) do
				setElementData(col,vv,0)
			end
			for ii,vv in pairs(zapis.itemy) do
				setElementData(col,ii,vv)
			end
		end
	end
end

function autoStart()
	id=exports.db:pobierzTabeleWynikow("SELECT MAX(ID) as ID FROM Zapis_namioty")
	zaladuj(id[1].ID)
end
addEventHandler("onResourceStart",resourceRoot,autoStart)
function autoZapis()
	zapisz()
end
addEventHandler("onResourceStop",resourceRoot,autoZapis)
setTimer(zapisz,1000*60*60,0)

function stworzElementyNamiotu(x2,y2,z,r,id)
	if not id then id=3243 end
	tent = createObject(id,x2,y2,z-.875,0,0,r)
	col=createColSphere(x2,y2,z,1.15)
	setElementData(col,"Opis",modelopcje[id][2] or modelopcje[3243][2])
	setElementData(col,"Opcje",modelopcje[id][1] or modelopcje[3243][1])
	return tent,col
end