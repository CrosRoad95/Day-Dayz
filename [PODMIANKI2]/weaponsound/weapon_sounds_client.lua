function onClientPlayerWeaponFire ( weapon )
	local wX, wY, wZ = getPedWeaponMuzzlePosition ( getLocalPlayer() )
	if weapon == 22 then--colt45
		playSound ( "sounds/Colt45.wav", false )
	elseif weapon == 23 then--silenced
		playSound ( "sounds/Silenced.wav", false )
	elseif weapon == 24 then--deagle
		playSound ( "sounds/Deagle.wav", false )
	elseif weapon == 25 then--shotgun
		playSound ( "sounds/Shotgun.wav", false )
	elseif weapon == 26 then--sawn-off
		playSound ( "sounds/Sawed-Off.wav", false )
	elseif weapon == 27 then--combat shotgun
		playSound ( "sounds/Combat Shotgun.wav", false )
	elseif weapon == 28 or weapon == 32 then--uzi/tec-9
		playSound ( "sounds/UZI_Tec9.wav", false )
	elseif weapon == 29 then--mp5
		playSound ( "sounds/MP5.wav", false )
	elseif weapon == 30 or weapon == 31 then--ak47/m4
		playSound ( "sounds/M4_AK47.wav", false )
	elseif weapon == 33 then--rifle
		playSound ( "sounds/Rifle.wav", false )
	elseif weapon == 34 then--sniper
		playSound ( "sounds/Sniper.wav", false )
	end 
end

addEventHandler ( "onClientPlayerWeaponFire", getRootElement(), onClientPlayerWeaponFire )