modele={
["wyspa_1"]={2918,{3500,3500,-12}},
}
function laduj()
	txd=engineLoadTXD("wyspy/tekstura.txd")
	for i,v in pairs(modele) do
		col=engineLoadCOL("wyspy/"..i..".col") 
		dff=engineLoadDFF("wyspy/"..i..".dff")
		if txd and col and dff then
			engineReplaceCOL(col,v[1])
			engineImportTXD(txd,v[1])
			engineReplaceModel(dff,v[1])
			engineSetModelLODDistance(v[1],1000)
			a=createObject(v[1],v[2][1],v[2][2],v[2][3],0,0,0,true)
			b=createObject(v[1],v[2][1],v[2][2],v[2][3],0,0,0)
			setLowLODElement(a,b)
		end
		txd=nil
		col=nil
		dff=nil
	end
end
	laduj()
