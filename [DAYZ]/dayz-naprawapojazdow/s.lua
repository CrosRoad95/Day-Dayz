function animacjaStart()
	setPedAnimation(client,"SCRATCHING", "sclng_r", nil, true, false)
	setElementFrozen(client,true)
end
addEvent("animacjaNaprawy",true)
addEventHandler("animacjaNaprawy",resourceRoot,animacjaStart)
function animacjaStop()
	setPedAnimation(client,false)
	setElementFrozen(client,false)
end
addEvent("animacjaNaprawyStop",true)
addEventHandler("animacjaNaprawyStop",resourceRoot,animacjaStop)
