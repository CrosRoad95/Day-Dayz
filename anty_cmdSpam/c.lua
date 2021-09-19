ignoruj={
["Toggle scoreboard 0"]=true,
["Toggle scoreboard 1"]=true,
["admin"]=true,
["grab"]=true,
["reload"]=true,
["reloadweapon"]=true,
["Reload weapon"]=true,
["repair"]=true,
["Toggle Driveby"]=true,
["Next driveby weapon 1"]=true,
["Previous driveby weapon -1"]=true,
["scoreboard"]=true,
["Open scoreboard settings 1"]=true,
["unglue"]=true,
}
x=0
function consoleCheck(text)
	if string.find(text,"Chat ") then return end
	if ignoruj[text] then return end
	x=x+1
	if x>25 then
		triggerServerEvent("cmd:spam",resourceRoot,text)
	end
	triggerServerEvent("cmd:log",resourceRoot,text)
end
addEventHandler("onClientConsole",getLocalPlayer(),consoleCheck)
setTimer(function() x=0 end,5000,0)