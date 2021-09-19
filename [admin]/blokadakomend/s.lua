q=exports.db:pobierzTabeleWynikow("select * from Blokada_komendy")
blokuj={}
for i,v in ipairs(q) do
	blokuj[string.lower(v.Komenda)]=true
end

function blokujkomendy(cmd)
	if blokuj[string.lower(cmd)] then cancelEvent() end
end
addEventHandler("onPlayerCommand",root,blokujkomendy)