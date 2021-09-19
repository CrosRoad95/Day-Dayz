function zaladuj()
	q=exports.db:pobierzTabeleWynikow("select * from Stacje_paliwowe")
	for i,v in ipairs(q) do
		--obj=createObject(1676,v.x,v.y,v.z,0,0,v.r)
		col=createColSphere(v.x,v.y,v.z,1.5)
		setElementData(col,"itemloot",true)
		--setElementData(col,"parent",obj)
		
		setElementData(col,"Opis","dystrybutor")
		setElementData(col,"Opcje",{{"Nalej paliwa do kanistra","tankuj_kanister"},})
	end
end
zaladuj()