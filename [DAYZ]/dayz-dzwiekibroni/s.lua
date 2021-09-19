q=exports.db:pobierzTabeleWynikow("select * from bronie")
bronie={}
for i,v in ipairs(q) do
	if v.dzwiek_strzal~="" and v.dzwiek_przeladowanie~="" and v.dzwiek_zasieg>5 then
		bronie[v.id_broni]={dzwiek_strzal=v.dzwiek_strzal,dzwiek_przeladowanie=v.dzwiek_przeladowanie,dzwiek_zasieg=v.dzwiek_zasieg}
	end
end

addEventHandler ("onPlayerWeaponFire", root, 
	function (weapon, endX, endY, endZ, hitElement, startX, startY, startZ)
		if bronie[weapon] then
			exports["dayz-soundsystem"]:sound("weapon/"..bronie[weapon].dzwiek_strzal,startX, startY, startZ,bronie[weapon].dzwiek_zasieg,{})
		end
	end
)


addEvent("onPlayerReload",true)
addEventHandler("onPlayerReload",getRootElement(),
	function()
		bron=getPedWeapon(client)
		if bronie[bron] then
			x,y,z=getElementPosition(client)
			exports["dayz-soundsystem"]:sound("weapons/"..bronie[bron].dzwiek_przeladowanie,x,y,z,bronie[bron].dzwiek_zasieg/3,{})
		end
	end
)