function join()
	local nick=getPlayerName(source)
	local nicko=getPlayerName(source)
	for i=1,10 do
		nick=string.gsub(nick,"#%x%x%x%x%x%x", "") 
	end
	if nick==nicko then return end
	setPlayerName(source,nick)
end
--addEventHandler("onPlayerJoin",getRootElement(),join)

function change(oldNick, newNick)
	local nick=getPlayerName(source)
	local nicko=getPlayerName(source)
	for i=1,10 do
		nick=string.gsub(nick,"#%x%x%x%x%x%x", "") 
	end
	if nick==nicko then return end
	setPlayerName(source,nick)
end
--addEventHandler("onPlayerChangeNick",getRootElement(),change)

-- skrypt nie działa prawidłowo, stuck overflow na 19 lini