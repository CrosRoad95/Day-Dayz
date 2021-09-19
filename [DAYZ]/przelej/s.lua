function przelej(plr,cmd,gracz,kwota)
	if gracz and tonumber(kwota) then
		kwota=tonumber(kwota)
		gracz=getPlayerFromName(gracz)
		if kwota and gracz then
			kwota=math.floor(kwota)
			if getPlayerMoney(plr)>=kwota then
				if kwota>=10 then
					takePlayerMoney(plr,kwota)
					givePlayerMoney(gracz,kwota)
					outputChatBox(getPlayerName(plr).." przelał ci "..kwota.." GP!",gracz,0,255,0)
					outputChatBox("Przelałeś "..kwota.." gp do "..getPlayerName(gracz).."!",plr,0,255,0)
					exports.db:zapytanie("insert into Logi_przelewy_gp values(null,null,?,?,?)",getPlayerName(plr),getPlayerName(gracz),kwota)
				else
					outputChatBox("Możesz przelać minimum 10GP!",plr,255,0,0)
				end
			else
				outputChatBox("Nie możesz przelać więcej niż masz!",plr,255,0,0)
			end
			return
		end
	end
	outputChatBox("Popraw na /"..cmd.." nick kwota",plr,255,0,0)
end
addCommandHandler("przelej",przelej)