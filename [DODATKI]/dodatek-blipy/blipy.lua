for i,v in ipairs(exports.db:pobierzTabeleWynikow("select * from Blipy")) do
	createBlip (v.x,v.y,v.z,v.typ,0,0,255,0,255,0,v.odleglosc)
end