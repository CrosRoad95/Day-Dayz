sql="INSERT INTO Logi_cmd VALUES (NULL,?,NOW(),?);"
function cmdlog(txt)
	exports.db:zapytanie(sql,tostring(getElementData(client,"UID")),txt)
end
addEvent("cmd:log",true)
addEventHandler("cmd:log",resourceRoot,cmdlog)
function cmdspam(cmd)
	outputDebugString("Spam komendami: "..getPlayerName(client)..", serial: "..getPlayerSerial(client)..", komenda: "..cmd)
	kickPlayer(client)
end
addEvent("cmd:spam",true)
addEventHandler("cmd:spam",resourceRoot,cmdspam)
