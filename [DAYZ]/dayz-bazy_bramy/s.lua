function start()
	q=exports.db:pobierzTabeleWynikow("select * from Bazy_bramy")
	bramy={}
	for i,v in ipairs(q) do
		x,y,z,r=unpack(split(v.pozycja,","))
		bramy[v.kod]=createObject(v.model,x,y,z,0,0,r)
		bramy[v.kod]:setData("grupa",v.gang,false)
	end
end
start()

function otworzZamknij(plr,cmd,status,kod)
	if status~="zamknij" and status~="otworz" and type(kod)~="number" then
		return plr:outputChat("Błąd, popraw na "..cmd.." otworz/zamknij kod",255,0,0)
	end
	if bramy[tonumber(kod)] then
		grupa=plr:getData("grupa")
		if not grupa then
			return plr:outputChat("Błędny kod!",255,0,0)
		end
		if grupa[2]~=bramy[tonumber(kod)]:getData("grupa") then
			return plr:outputChat("Błędny kod!",255,0,0)
		end
		if status=="otworz" then
			bramy[tonumber(kod)]:setDimension(65000)
			return plr:outputChat("Brama została otwarta! Pamietaj żeby ją zamknąć! W przeciwnym razie baza może zostać okradziona!",0,255,0)
		else
			bramy[tonumber(kod)]:setDimension(0)
			return plr:outputChat("Brama została zamknięta!",0,255,0)
		end
	else
		return plr:outputChat("Błędny kod!",255,0,0)
	end
end
addCommandHandler("brama",otworzZamknij,false,true)
addCommandHandler("bramy",otworzZamknij,false,true)
