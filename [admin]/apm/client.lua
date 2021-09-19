--[[
// copyrights //
ACL Permissions Manager by SoRa
Notice : needs admin rights
// copyrights //
--]]

GUIEditor = {
    gridlist = {},
    label = {},
    window = {},
}
apm =  guiCreateWindow(173, 33, 509, 447, "ACL Permissions Manager 1.0 by |S.s|SoRa", false)
guiWindowSetSizable(apm, false)
guiSetVisible(apm,false)
guiSetAlpha(apm, 1.00)

x = guiCreateButton(476, 26, 19, 24, "X", false, apm)
guiSetProperty(x, "NormalTextColour", "FFAAAAAA")
setright = guiCreateButton(195, 312, 86, 37, "Set right", false, apm)
guiSetProperty(setright, "NormalTextColour", "FF11FF00")
remove = guiCreateButton(194, 367, 86, 37, "Remove right", false, apm)
guiSetProperty(remove, "NormalTextColour", "FFFF0000")
refresh = guiCreateButton(404, 297, 86, 37, "Refresh", false, apm)
guiSetProperty(refresh, "NormalTextColour", "FFE0FF11")
acllist = guiCreateGridList(16, 63, 223, 223, false, apm)
ac = guiGridListAddColumn(acllist, "ACLs :", 0.9)
GUIEditor.label[3] = guiCreateLabel(16, 32, 138, 16, "ACLs :", false, apm)
rightslist = guiCreateGridList(270, 63, 223, 223, false, apm)
rc = guiGridListAddColumn(rightslist, "ACL rights :", 0.9)
GUIEditor.label[4] = guiCreateLabel(268, 32, 138, 16, "ACL rights :", false, apm)
GUIEditor.label[5] = guiCreateLabel(15, 344, 42, 19, "Right :", false, apm)
GUIEditor.label[6] = guiCreateLabel(14, 379, 46, 15, "Access :", false, apm)
GUIEditor.label[7] = guiCreateLabel(15, 309, 30, 18, "ACL :", false, apm)
acl = guiCreateEdit(72, 307, 109, 25, "", false, apm)
right = guiCreateEdit(72, 342, 109, 25, "", false, apm)
access = guiCreateComboBox(71, 378, 108, 80, "", false, apm)
guiComboBoxAddItem(access, "true")
guiComboBoxAddItem(access, "false")
reload = guiCreateButton(404, 352, 86, 37, "Reload ACL", false, apm)
guiSetProperty(reload, "NormalTextColour", "FFE0FF11")


addEvent("checkPermissions_response",true)
addEventHandler("checkPermissions_response",root,
function (response)
	if response == true then
	guiSetVisible(apm,true)
	showCursor(true)
	clear()
	triggerServerEvent ("getACLs", getLocalPlayer())
	else
		if guiGetVisible(apm) == true then
		guiSetVisible(apm,false)
		showCursor(false)
		end
	end
end
)



addEvent("show_apm",true)
addEventHandler("show_apm",root,
    function ()
	triggerServerEvent ("checkPermissions_a", getLocalPlayer())
	end
)


    function clear()
guiGridListClear (acllist)
guiGridListClear (rightslist)
    end


addEvent("refreshg",true)
addEventHandler("refreshg",root,
    function ()
    clear()
	end
)

addEvent("addACLs",true)
addEventHandler("addACLs",root,
    function (v)
    guiGridListSetItemText ( acllist, guiGridListAddRow ( acllist ), ac,v, false, false )
	end
)

addEvent("addRights",true)
addEventHandler("addRights",root,
    function (v,r,g,b)
	local row = guiGridListAddRow ( rightslist )
    guiGridListSetItemText ( rightslist,row, rc,v, false, false )
	guiGridListSetItemColor ( rightslist, row, rc, r, g, b )
	end
)


addEventHandler ( "onClientGUIClick",acllist,
function ()
sacl = guiGridListGetItemText ( acllist, guiGridListGetSelectedItem ( acllist ), 1 )
guiSetText(acl,sacl)
guiGridListClear (rightslist)
triggerServerEvent("getRights",getLocalPlayer(),sacl)
end
)

addEventHandler ( "onClientGUIClick",rightslist,
function ()
sright = guiGridListGetItemText ( rightslist, guiGridListGetSelectedItem ( rightslist ), 1 )
guiSetText(right,sright)
end
)




function onGuiClick (button, state, absoluteX, absoluteY)
    if (source == setright) then
    local acl = guiGetText(acl)
    local right = guiGetText(right)
    local access = guiComboBoxGetItemText(access, guiComboBoxGetSelected(access))
    if access == "true" then
    local access = true
    triggerServerEvent("set_a", getLocalPlayer(), acl,right,access)
    elseif access == "false" then
    local access = false
    triggerServerEvent("set_a", getLocalPlayer(), acl,right,access)
    end
	elseif (source == remove) then
	local acl = guiGetText(acl)
	local right = guiGetText(right)
	triggerServerEvent("remove_a", getLocalPlayer(), acl,right)
	guiGridListClear (rightslist)
    triggerServerEvent("getRights",getLocalPlayer(),sacl)
	elseif (source == refresh) then
	clear()
	triggerServerEvent ("getACLs", getLocalPlayer())
	elseif (source == reload) then
	triggerServerEvent("reload_acl",getLocalPlayer())
	elseif (source == x) then
	guiSetVisible(apm,false)
	showCursor(false)
	end
end
addEventHandler ("onClientGUIClick", getRootElement(), onGuiClick)



