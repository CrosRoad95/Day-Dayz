function start()
	setTimer(function()
		if getElementData(localPlayer,"Login") then
			sx,sy=guiGetScreenSize()
			szerokosc=180
			maxszer=5*(szerokosc+15)
			left=(sx-maxszer)/2
			addEventHandler("onClientRender",root,rysuj)
			removeEventHandler("onClientPlayerSpawn",localPlayer,start)
		end
	end,100,1)
end

function getText(lng,typ,data,rpl)
	return exports["dayz-jezyki"]:getText(lng,typ,data,rpl)
end

liczby={
	[0]="①",
	[1]="②",
	[2]="③",
	[3]="④",
	[4]="⑤",
}
function rysuj()
	pasek=(getElementData(localPlayer,"pasek_szybkiego_wyboru") or {})
	for i=0,4 do
		x,y=left+i*(szerokosc+15),sy-25
		dxDrawRectangle(x,y,szerokosc,20,tocolor(80,80,80,200),false,true)
		dxDrawText(liczby[i],x,y-3,x+szerokosc,y+20,tocolor(255,255,255,255),2,"sans","left","center")
		dxDrawText(getText("detect","items",(pasek[i] or pasek[tostring(i)]) or "-",{}) or "-",x,y,x+szerokosc,y+20,tocolor(255,255,255,255),1,"sans","right","center")
	end
end
start()
addEventHandler("onClientPlayerSpawn",getLocalPlayer(),start)

function uzyjSlotu(key)
	if not exports["dayz-ekwipunek"]:isInventoryVisible() then
		local slot=tonumber(key)
		if not slot then return end
		slot=slot-1
		local pasek=(getElementData(localPlayer,"pasek_szybkiego_wyboru") or {})
		if pasek[slot] then
			if getElementData(localPlayer,pasek[slot]) and getElementData(localPlayer,pasek[slot])>0 then
				exports["dayz-ekwipunek"]:remoteUseItem(pasek[slot])
			end
		end
	end
end
bindKey("1","down",uzyjSlotu)
bindKey("2","down",uzyjSlotu)
bindKey("3","down",uzyjSlotu)
bindKey("4","down",uzyjSlotu)
bindKey("5","down",uzyjSlotu)