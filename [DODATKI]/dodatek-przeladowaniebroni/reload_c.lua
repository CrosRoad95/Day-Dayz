tick=getTickCount()+1800
addCommandHandler("Reload weapon",
	function()
		local task = getPedSimplestTask(localPlayer)
		
		-- Prevent instant reload while performing a jump
		if ((task == "TASK_SIMPLE_JUMP" or task == "TASK_SIMPLE_IN_AIR" or task == "TASK_SIMPLE_LAND") and not doesPedHaveJetPack(localPlayer)) then return end
		
		-- If you reload and press shift at the exact same time you're able to instant reload so temporarily disable jump
		if (isControlEnabled("jump")) then
			toggleControl("jump", false)
			addEventHandler("onClientRender", root, enableJump)
		end
		if tick<getTickCount() then
			triggerServerEvent("onPlayerReload",localPlayer)
			tick=getTickCount()+1800
		end
	end
)

bindKey("r","down","Reload weapon")

-- Disable jumping for at least 4 frames after pressing reload to prevent instant reload

local frames = 0

function enableJump()
	if (frames >= 3) then
		toggleControl("jump", true)
		removeEventHandler("onClientRender", root, enableJump)
		frames = 0
	else
		frames = frames + 1
	end
end