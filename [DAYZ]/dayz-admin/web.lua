function pobierzGraczy()
	gracze={}
	for i,v in ipairs(getElementsByType("player")) do
		table.insert(gracze,{nick=v.name,uid=(v:getData("UID") or "Niezalogowany"),login=(v:getData("Login_name") or "Nieznany")})
	end
	return gracze
end
function pobierzDaneGracza(uid)
	if not tonumber(uid) then return end
	local uid=tonumber(uid)
	local gracz=false
	local dane={}
	for i,v in ipairs(getElementsByType("player")) do
		if v:getData("UID")==uid then
			gracz=v
			break
		end
	end
	if gracz then
		local data=getAllElementData(gracz)
		for k,v in pairs(data) do
			if type(v)=="string" or type(v)=="number" then
				dane[k]=v
			end
		end
		dane["$"]={
			nick=gracz.name
		}
	end
	return dane
end
function setPlayerData(uid,klucz,wartosc)
	if not tonumber(uid) then return end
	local uid=tonumber(uid)
	local gracz=false
	for i,v in ipairs(getElementsByType("player")) do
		if v:getData("UID")==uid then
			gracz=v
			break
		end
	end
	local typ=type(gracz:getData(klucz))
	if typ=="number" or typ=="string" then
		if tonumber(wartosc) then
			wartosc=tonumber(wartosc)
		end
		gracz:setData(klucz,wartosc)
	end
end
function pobierzSpawnyPojazdow()
	return {exports.db:pobierzTabeleWynikow("select * from Pojazdy_spawny"),exports.db:pobierzTabeleWynikow("select * from Pojazdy")}
end