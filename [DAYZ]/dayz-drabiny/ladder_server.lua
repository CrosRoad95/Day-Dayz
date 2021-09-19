
function playFinishClimbingS ()
	if launch_available then
		setPedAnimation ( source, "ped", "CLIMB_jump_B", -1, false, true, false, false)
		local x,y,z = getElementPosition ( source )
			   local _, _, rotation = getElementRotation(source)
		x = x - math.sin(math.rad(-rotation)) * 1.3
		y = y + math.cos(math.rad(-rotation)) * 1.3
		setTimer(function(player,px,py,pz)
			setElementFrozen ( player, false)
			setElementPosition ( player, px, py, pz)
		end,950,1,source,x,y,z+0.8)
	end
end

addEvent( "playFinishClimbing", true )
addEventHandler( "playFinishClimbing", getRootElement(), playFinishClimbingS )

launch_available = true


function askLaunchAvail()
	triggerClientEvent ( source, "recieveLaunchAvail", source, launch_available )
end
addEvent( "askLaunchAvailC", true )
addEventHandler( "askLaunchAvailC", getRootElement(), askLaunchAvail )

function zaladuj()
	drabiny={}
	q=exports.db:pobierzTabeleWynikow("select * from Drabiny")
	for i,v in ipairs(q) do
		local x,y,z =v.x,v.y,v.z
		local rx,ry,rz=0,0,v.r
		for ii=1,v.wysokosc do
			wys=(ii-1)*3
			if v.objekt==1 then
				drabiny["object_"..i]=createObject(1428,x,y,z+wys,rx,ry,rz)
			end
			drabiny["tuba1_"..i] = createColTube(x,y,z-1.5+wys, 0.5, 3)
			drabiny["tuba2_"..i] = createColTube (x,y,z+1.5+wys, 0.5, 1)
			setElementData ( drabiny["tuba1_"..i], "ladder", true)
			setElementData ( drabiny["tuba1_"..i], "ladder_rz", rz)
			setElementData ( drabiny["tuba2_"..i], "ladder_down", true)
			setElementData ( drabiny["tuba1_"..i], "ladder_id", i)
			setElementData ( drabiny["tuba2_"..i], "ladder_id", i)
			setElementData ( drabiny["tuba2_"..i], "ladder_parent", drabiny["tuba1_"..i])
		end
	
	end
end
zaladuj()