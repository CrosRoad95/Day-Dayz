function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function naliczajCzasGry()
	if getElementData(localPlayer,"Login") then
		czas1,czas2=getElementData(localPlayer,"_Czas_Gry(Aktualnie)_"),getElementData(localPlayer,"_Czas_Gry(W_Sumie)_")
		mord1,mord2=getElementData(localPlayer,"_Morderstwa(Aktualnie)_"),getElementData(localPlayer,"_Morderstwa(W_Sumie)_")
		setElementData(localPlayer,"_Czas_Gry(Aktualnie)_",czas1+1)
		setElementData(localPlayer,"_Czas_Gry(W_Sumie)_",czas2+1)
		setElementData(localPlayer,"_Czas_Gry(Wyswietl)_",math.round(czas1/3600,1).." ["..math.round(czas2/3600,1).."]")
		setElementData(localPlayer,"GP",getPlayerMoney())
		setElementData(localPlayer,"MORDERSTWA",mord1.." ["..mord2.."]")
	end	
end
setTimer(naliczajCzasGry,1000,0)