FPSLimit = 37
FPSMax = 1

function onClientResourceStart ( resource )
	if ( guiFPSLabel == nil ) then
		FPSLimit = 255 / FPSLimit
		guiFPSLabel	= guiCreateLabel ( 0.03, 0.97, 0.1, 0.1, "FPS: 0", true )
		FPSCalc = 0
		FPSTime = getTickCount() + 1000
		addEventHandler ( "onClientRender", getRootElement (), onClientRender )
	end
end
addEventHandler ( "onClientResourceStart", getRootElement (), onClientResourceStart )

function onClientRender ( )
	if ( getTickCount() < FPSTime ) then
		FPSCalc = FPSCalc + 1
	else
		if ( FPSCalc > FPSMax ) then FPSLimit = 255 / FPSCalc FPSMax = FPSCalc end
		guiSetText ( guiFPSLabel, "FPS: "..FPSCalc.." Max: "..FPSMax )
		guiLabelSetColor ( guiFPSLabel, 255 - math.ceil ( FPSCalc * FPSLimit ), math.ceil ( FPSCalc * FPSLimit ), 0 )
		FPSCalc = 0
		FPSTime = getTickCount() + 1000
	end
end