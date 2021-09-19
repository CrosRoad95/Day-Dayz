function forceReload(p)
	reloadPedWeapon(p)
end
addCommandHandler("Reload weapon",forceReload)

function bindPlayerReloadKey(p)
	bindKey(p,"r","down","Reload weapon")
end

addEvent("onPlayerReload",true)
addEventHandler("onPlayerReload",getRootElement(),
	function()
		reloadPedWeapon(client)
	end
)