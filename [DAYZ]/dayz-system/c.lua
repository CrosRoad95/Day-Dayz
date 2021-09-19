function pobierzAmunicjePoBroni(bron)

end

function weaponSwitch(weapon)
	if source == localPlayer then
		local ammoName,_=pobierzAmunicjePoBroni(weapon)
		if ammoName and getElementData(localPlayer,ammoName) > 0 then
			setElementData(localPlayer,ammoName,getElementData(localPlayer,ammoName) - 1)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire",localPlayer,weaponSwitch)