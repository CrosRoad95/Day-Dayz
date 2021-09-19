function getPositionInfrontOfElement(element, rot)
    if not element or not isElement(element) then
        return false
    end
    if not meters then
        meters = 3
    end
    local posX, posY, posZ = getElementPosition(element)
    local _, _, rotation = getElementRotation(element)
    posX = posX - math.sin(math.rad(rotation)) * meters
    posY = posY + math.cos(math.rad(rotation)) * meters
    return posX, posY, posZ
end

function getCameraRotation ()
    local px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = 6.2831853071796 - math.atan2 ( ( lx - px ), ( ly - py ) ) % 6.2831853071796
    local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
    rotx = math.deg(rotx)
    rotz = -math.deg(rotz)	
    return rotx, 180, rotz
end

local lie = true

function updateCamera ()
	local state = getControlState ( "forwards" )
	if state and lie then
		local x,y,z = getElementPosition ( localPlayer )
		local rot2_x, rot_y, rot2_z = getCameraRotation()
		local anim_block, anim_name = getPedAnimation ( localPlayer )
		if tostring(anim_name) ~= "CS_Dead_Guy" then
			lie = false
			setElementData ( localPlayer, "liemove:crawling", false )
		end
		if isLineOfSightClear ( x, y, z, x - math.sin(math.rad(-rot2_z)) * 1, y + math.cos(math.rad(-rot2_z)) * 1, z ) then
			setElementRotation ( localPlayer, 0,0,-rot2_z )
			setElementPosition ( localPlayer, x - math.sin(math.rad(-rot2_z)) * move_speed, y + math.cos(math.rad(-rot2_z)) * move_speed,z,false)
		end
	end
end
addEventHandler ( "onClientRender", root, updateCamera )
changeNotAvail = false

function startMovingLie()
	if changeNotAvail or getElementData ( localPlayer, "inAction" ) then return true end
	changeNotAvail = true
	setTimer ( function () changeNotAvail = false end, 2000, 1 )
	if getPedMoveState ( localPlayer ) ~= "stand" then
		return true
	end
	if lie then
		lie = false
		setElementData ( localPlayer, "liemove:crawling", false )
		--setPedAnimation ( localPlayer, false )
		triggerServerEvent ("resetPlayerCrawlingAnimation",localPlayer)
	else
		lie = true
		triggerServerEvent ("startPlayerCrawlingAnimation",localPlayer)
		--setPedAnimation ( localPlayer, animation_block,animation_name, -1, addit_opt, false, false, true )
	end
end

bindKey ( "l", "down", startMovingLie )

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "player" then
            if getElementData ( source, "liemove:crawling" ) then
				setPedAnimation ( source, animation_block,animation_name, -1, addit_opt, false, false, true )
			end
        end
    end
);
