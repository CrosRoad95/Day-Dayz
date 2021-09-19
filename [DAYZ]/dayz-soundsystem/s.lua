function sound(dzwiek,x,y,z,odleglosc,warunki)
	--for i,v in ipairs(getElementsByType("player")) do
	triggerClientEvent(getElementsByType("player"),"sound",resourceRoot,dzwiek,x,y,z,odleglosc,warunki)
	--end
end