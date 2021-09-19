podmianki={
["Fundamenty_1"]=1515,
["Fundamenty_2"]=1830,
["Fundamenty_1_1"]=1856,

["Sciana_1"]=1831,
["Sciana_2"]=1832,
["Okno_1"]=1833,
["Podloga_1"]=1834,
["Podloga_2"]=1835,
["Rama_drzwi_1"]=1836,
["Rama_drzwi_2"]=1837,
["Schody_1"]=1838,
["Dach_1"]=1851,
["Dach_2"]=1852,
["Dach_3"]=1853,
["Drzwi_1"]=1854,
["Drzwi_2"]=1855,

}

function start()
	txd=engineLoadTXD("a.txd")
	for i,v in pairs(podmianki) do
		engineImportTXD(txd,v)  
		col=engineLoadCOL("podmianki/"..i..".col")
		dff=engineLoadDFF("podmianki/"..i..".dff")
		engineReplaceCOL(col,v)
		engineReplaceModel(dff,v)
		engineSetModelLODDistance(i,1000)
	end
end
start()