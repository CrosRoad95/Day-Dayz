function hit(loss)
	if getPedWeapon(localPlayer)~=3 then return end
	if math.random(1,7)==1 then
		triggerServerEvent("KamienHit",resourceRoot,source)
	end
end
addEventHandler("onClientObjectDamage",resourceRoot,hit)