x={}
function onPreFunction( sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, ... )
	local resname = sourceResource and getResourceName(sourceResource)
	x[resname.."/"..luaFilename]=true
end
addDebugHook( "preFunction", onPreFunction,{"setElementPosition","setElementData"})

function table.size(tab)
    local length = 0
    for _ in pairs(tab) do length = length + 1 end
    return length
end
function test()
	outputChatBox(tostring(table.size(x)))
	for i,v in pairs(x) do
		outputChatBox(tostring(i))
	end
end
addCommandHandler("acccsd",test)