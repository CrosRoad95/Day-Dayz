addEventHandler('onClientPlayerJoin', root,
	function()
		outputChatBox(getPlayerName(source):gsub("#%x%x%x%x%x%x","") .. ' dołączył do gry', 0, 255, 0)
	end
)

addEventHandler('onClientPlayerChangeNick', root,
	function(oldNick, newNick)
		outputChatBox(oldNick .. ' zmienił nick na ' .. newNick, 0, 255, 0)
	end
)

addEventHandler('onClientPlayerQuit', root,
	function(reason)
		outputChatBox(getPlayerName(source):gsub("#%x%x%x%x%x%x","") .. ' wyszedł z gry [' .. reason .. ']', 0, 255, 0)
	end
)