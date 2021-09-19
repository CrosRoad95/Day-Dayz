--[[
// copyrights //
ACL Permissions Manager by SoRa
Notice : needs admin rights
// copyrights //
--]]

-- // Settings //
allowedGroup = get("allowedGroup")
-- // Settings //


addEvent("getACLs",true)
addEventHandler("getACLs",root,
    function ()
	acls = {}
	        for i,acl in ipairs(aclList()) do
            table.insert(acls,aclGetName ( acl ))
			end
               for i,v in ipairs(acls) do
			   triggerClientEvent(source,"addACLs",source,v)
			   end
	end
)

function getRightColor(acl,right)
	if aclGetRight(acl,right) == true then
	return 0,255,0
	else
	return 255,0,0
	end
end

addEvent("getRights",true)
addEventHandler("getRights",root,
    function (acl)
	rights = {}
		for i,right in ipairs(aclListRights(aclGet(acl))) do
		table.insert(rights,right)
		end
		  for i,v in ipairs(rights) do
		  triggerClientEvent(source,"addRights",source,v,getRightColor(aclGet(acl),v))
	      end
	end
)

addEvent("reload_acl",true)
addEventHandler("reload_acl",root,
function ()
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)),aclGetGroup(allowedGroup)) then
	aclReload()
	outputChatBox("* APM : ACL Reloaded successfully",source,0,255,0,true)
	else
	outputChatBox("* APM : You're not allowed to do this.",source,255,0,0)
	triggerClientEvent(source,"checkPermissions_response",source,false)
	outputDebugString("* "..getPlayerName(source).." had attempted to hack the server.",2)
	end
end
)


addEvent("set_a",true)
addEventHandler("set_a",root,
function (acl,right,access)
	 if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)),aclGetGroup(allowedGroup)) then
		if access ~= aclGetRight(aclGet(acl),right) then
		aclSetRight (aclGet(acl),right,access)
		aclSave()
		outputChatBox("* APM : right "..right.." have been set to "..tostring(access).." in "..acl.." .",source,0,255,0,true)
		else
		outputChatBox("* APM : right "..right.." is already "..tostring(access).." .",source,0,255,0,true)
		end
		else
		outputChatBox("* APM : You're not allowed to do this.",source,255,0,0)
		triggerClientEvent(source,"checkPermissions_response",source,false)
		outputDebugString("* "..getPlayerName(source).." had attempted to hack the server.",2)
	end
end
)



addEvent("remove_a",true)
addEventHandler("remove_a",root,
function (acl,right)
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)),aclGetGroup(allowedGroup)) then
	aclRemoveRight(aclGet(acl),right)
	outputChatBox("* APM : right "..right.." have been removed from "..acl.." .",source,0,255,0,true)
	else
	outputChatBox("* APM : You're not allowed to do this.",source,255,0,0)
	triggerClientEvent(source,"checkPermissions_response",source,false)
	outputDebugString("* "..getPlayerName(source).." had attempted to hack the server.",2)
	end
end
)

addEvent("checkPermissions_a",true)
addEventHandler("checkPermissions_a",root,
function ()
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(source)),aclGetGroup(allowedGroup)) then
	triggerClientEvent(source,"checkPermissions_response",source,true)
	else
	triggerClientEvent(source,"checkPermissions_response",source,false)
	outputDebugString("* "..getPlayerName(source).." had attempted to hack the server.",2)
	end
end)


addCommandHandler("apm",
function (player)
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(player)),aclGetGroup(allowedGroup)) then
	triggerClientEvent(player,"show_apm",player)
	else
	outputChatBox ( "ACL: Access denied for 'apm'", player, 255, 168, 0 )
	end
end
)

