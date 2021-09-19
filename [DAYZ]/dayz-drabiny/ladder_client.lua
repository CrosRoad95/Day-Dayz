
		dff = engineLoadDFF ( "ladder.dff", 1428 )
		engineReplaceModel ( dff, 1428 )
		inladder = false
		setElementFrozen ( localPlayer, false)
		setPedAnimation ( localPlayer )
		ladder_id = 0
		current_ladder = nil
		inladder_down = false
		going_up = false
		ladder_x, ladder_y, ladder_z = 0,0,0
		ladder_rz = 0
		child_ladder = nil
		launch_available = false
function updateCamera ()
	if inladder and launch_available then
		local state = getControlState ( "forwards" )
		local state_back = getControlState ( "backwards" )
		if state and not going_down then
			setElementCollisionsEnabled ( localPlayer, false )
			local x,y,z = getElementPosition ( localPlayer )
			setElementPosition ( localPlayer, ladder_x, ladder_y,z+0.1)
			local rx,ry,rz = getElementRotation ( localPlayer )
			setElementRotation ( localPlayer, rx,ry, ladder_rz)
			going_up = true
			return true
		elseif state_back then	
			local x,y,z = getElementPosition ( localPlayer )
			local z_ground = getGroundPosition ( x,y,z )
			if z-z_ground >= 2 then
				setElementCollisionsEnabled ( localPlayer, false )
				--setElementCollidableWith ( localPlayer, current_ladder, false )
				local pos = setElementPosition ( localPlayer, ladder_x, ladder_y,z-0.1)
				local rx,ry,rz = getElementRotation ( localPlayer )
				setElementRotation ( localPlayer, rx,ry, ladder_rz)
				wasClimbing = true
				return true
			else
				inladder = false
				going_down = false
				going_up = false
				current_ladder = nil
				ladder_id = 0
				child_ladder = nil
				setElementCollisionsEnabled ( localPlayer, true )
			end
		end
		setElementCollisionsEnabled ( localPlayer, true )
	end
end
addEventHandler ( "onClientRender", root, updateCamera )

function onClientColShapeHit( theElement, matchingDimension )
	--outputChatBox ( "enter: "..tostring (getElementData ( source, "ladder_id")))
    if ( theElement == getLocalPlayer() )  then
		if getElementData ( source, "ladder") then
			inladder = true
			ladder_id = getElementData ( source, "ladder_id" ) or 0 
			current_ladder = source
			local posX, posY, posZ = getElementPosition ( source )
			local rotation = getElementData ( source, "ladder_rz")
			posX = posX + math.sin(math.rad(rotation)) * 0.2
			posY = posY - math.cos(math.rad(rotation)) * 0.2
			ladder_x, ladder_y = posX, posY
			ladder_z = posZ
			going_down = false
			ladder_rz = -getElementData ( source, "ladder_rz")
		elseif getElementData ( source, "ladder_down") and ent_avail then
			local parent = getElementData ( source, "ladder_parent" )
			setElementCollidableWith ( localPlayer, parent, false )
			if not going_up then
				going_down = true
				inladder = true
				ladder_id = getElementData ( source, "ladder_id" ) or 0 
				current_ladder = parent
				local posX, posY, posZ = getElementPosition ( parent )
				local rotation = getElementData ( parent, "ladder_rz ")
				posX = posX - math.sin(math.rad(rotation)) * 0.2
				posY = posY + math.cos(math.rad(rotation)) * 0.2
				ladder_x, ladder_y = posX, posY
				ladder_z = posZ
				child_ladder = source
				ladder_rz = -getElementData ( parent, "ladder_rz ")
			end
		end
    end
end
addEventHandler("onClientColShapeHit",getRootElement(),onClientColShapeHit)


function onClientColShapeLeave (theElement)
	if ( theElement == getLocalPlayer() and getElementData ( source, "ladder") and inladder )  then
		local x,y,z = getElementPosition ( localPlayer )
		setTimer ( checkStillInLadder, 200, 1, ladder_id,z-1.5)
		going_down = false
    --elseif theElement == getLocalPlayer() and getElementData ( source, "ladder_down" )and inladder and not isElementWithinColShape (localPlayer, current_ladder )
	end
end

addEventHandler("onClientColShapeLeave",getRootElement(),onClientColShapeLeave)

function checkStillInLadder ( lad_id, posZ )
	if lad_id == ladder_id and not isElementWithinColShape (localPlayer, current_ladder ) then 
		inladder = false
		going_down = false
		going_up = false
		child_ladder = nil
		setElementCollisionsEnabled ( localPlayer, true )
		if ladder_z < posZ then
			setElementFrozen ( localPlayer, true )
			triggerServerEvent ("playFinishClimbing", localPlayer)
			ent_avail = false
			setTimer ( function () ent_avail = true end, 3000, 1)
		end
	end

end


function displayLoadedRes ( res )
	for i, v in ipairs ( getElementsByType ( 'drabiny')) do
		local rx,ry,rz = getElementRotation(v)
		local x,y,z=getElementPosition(v)
		createObject(1428,x,y,z,rx,ry,rz)
		local tube = createColTube (tonumber(getElementData (v, "posX")), tonumber(getElementData (v, "posY")), tonumber(getElementData (v, "posZ"))-1.5, 0.5, 3)
		local tube_down = createColTube (tonumber(getElementData (v, "posX")), tonumber(getElementData (v, "posY")), tonumber(getElementData (v, "posZ"))+1.5, 0.5, 1)
		setElementData ( tube, "ladder", true)
		setElementData ( tube, "ladder_rz", rz)
		setElementData ( tube_down, "ladder_down", true)
		setElementData ( tube, "ladder_id", i)
		setElementData ( tube_down, "ladder_id", i)
		setElementData ( tube_down, "ladder_parent", tube)
	end
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(), displayLoadedRes )

triggerServerEvent ("askLaunchAvailC", localPlayer)

function recieveLaunchAvailC(avail)
	launch_available = avail
end

addEvent( "recieveLaunchAvail", true )
addEventHandler( "recieveLaunchAvail", getRootElement(), recieveLaunchAvailC )
