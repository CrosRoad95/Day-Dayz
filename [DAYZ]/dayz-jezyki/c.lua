dostepne_jezyki={
{"pl","Polski"},
{"en","English"},
}
function zaladuj()
	jezyki={}
	for i,v in ipairs(dostepne_jezyki) do
		v=v[1]
		jezyki[v]={}
		local xml=xmlLoadFile("jezyki/"..v..".xml")
		local typy=xmlNodeGetChildren(xml)
		for ii,vv in ipairs(typy) do
			local nodename=xmlNodeGetName(vv)
			if nodename~="server" then
				jezyki[v][nodename]={}
				local data=xmlNodeGetChildren(vv)
				for iii,vvv in ipairs(data) do
					jezyki[v][nodename][xmlNodeGetAttribute(vvv,"data")]=xmlNodeGetValue(vvv)
				end
			end
		end
		xmlUnloadFile(xml)
	end
end
zaladuj()

function getText(lng,typ,data,rpl)
	if lng=="detect" then
		lng=getElementData(localPlayer,"config")["jezyk"]
	end
	if jezyki[lng] and jezyki[lng][typ] and jezyki[lng][typ][data] then
		tekst=jezyki[lng][typ][data]
		for i,v in ipairs(rpl) do
			tekst=string.gsub(tekst,v[1],v[2])
		end
		return tekst
	else
		return "***TODO "..tostring(typ).."/"..tostring(data).."***";
	end
end
function getLanguages()
	return dostepne_jezyki
end