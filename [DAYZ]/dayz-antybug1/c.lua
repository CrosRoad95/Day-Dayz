tick=getTickCount()
function onkey(button, press)
	if (press and button=="mouse1") and getPedMoveState(localPlayer)=="stand" then
		tick=getTickCount()
	end
    if (press and button=="c") then
		if tick+1500>getTickCount() then
			cancelEvent()
		end
		--outputChatBox(getPedMoveState(localPlayer))
    end
end
addEventHandler("onClientKey",root,onkey)