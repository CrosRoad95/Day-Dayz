dzwieki={}

function usundzwiek(dzwik)
	for i,v in ipairs(getElementsByType("sound")) do
		if v==dzwik then
			stopSound(v)
			return true
		end
	end
end

function sound(dzwiekname,x,y,z,odleglosc,warunki)
	dis=getDistanceBetweenPoints3D(x,y,z,unpack({getElementPosition(localPlayer)}))
	if (warunki.playdis or 99999)>dis or warunki.alternatywa.odl<dis then
		if warunki.alternatywa then
			if warunki.alternatywa.odl>dis and odleglosc<dis then
				dzwiek=playSound3D("dzwieki/"..warunki.alternatywa.dzwiek,x,y,z,warunki.loop or false)
				setSoundVolume(dzwiek,warunki.volume or 1)
				setSoundMaxDistance(dzwiek,warunki.alternatywa.odl)
				setSoundMinDistance(dzwiek,warunki.alternatywa.odl/5)
			else
				dzwiek=playSound3D("dzwieki/"..dzwiekname,x,y,z,warunki.loop or false)
				setSoundVolume(dzwiek,warunki.volume or 1)
				setSoundMaxDistance(dzwiek,odleglosc)
				setSoundMinDistance(dzwiek,odleglosc/5)
			end
		else
			dzwiek=playSound3D("dzwieki/"..dzwiekname,x,y,z,warunki.loop or false)
			setSoundVolume(dzwiek,warunki.volume or 1)
			setSoundMaxDistance(dzwiek,odleglosc)
			setSoundMinDistance(dzwiek,odleglosc/5)
		end
		if warunki.deleteafter then
			setTimer(usundzwiek,warunki.deleteafter,1,dzwiek)
		elseif warunki.loop~=true then
			dlugosc=getSoundLength(dzwiek)*1000
			if dlugosc<50 then
				dlugosc=50
			end
			setTimer(usundzwiek,dlugosc,1,dzwiek)
		end
	end
end
addEvent("sound",true)
addEventHandler("sound",resourceRoot,sound)

tlodzwieki={
	dzien={"ambient/day/bats01.mp3","ambient/day/Crow01.mp3","ambient/day/Crow02.mp3","ambient/day/Crow1_1.mp3","ambient/day/Crow1_2.mp3","ambient/day/Crow1_3.mp3","ambient/day/Crow2_1.mp3","ambient/day/Crow2_2.mp3","ambient/day/Crow2_3.mp3","ambient/day/Crow2_4.mp3","ambient/day/Crow2_5.mp3","ambient/day/Crow2_6.mp3","ambient/day/ForestBird01.mp3","ambient/day/ForestBird02.mp3","ambient/day/ForestBird03.mp3","ambient/day/ForestBird04.mp3","ambient/day/ForestBird05.mp3","ambient/day/ForestBird06.mp3","ambient/day/ForestBird07.mp3","ambient/day/ForestBird08.mp3","ambient/day/ForestBird09.mp3","ambient/day/Insect_Cricket04.mp3","ambient/day/LittleBird1.mp3","ambient/day/LittleBird11.mp3","ambient/day/LittleBird12.mp3","ambient/day/LittleBird14.mp3","ambient/day/LittleBird15.mp3","ambient/day/LittleBird2.mp3","ambient/day/LittleBird3.mp3","ambient/day/LittleBird6.mp3","ambient/day/LittleBird7.mp3","ambient/day/LittleBird9.mp3","ambient/day/MeadowDay03.mp3","ambient/day/MeadowDay04.mp3","ambient/day/MeadowDay05.mp3","ambient/day/MeadowDay06.mp3","ambient/day/MountainBird01.mp3","ambient/day/MountainBird02.mp3","ambient/day/Skylark1.mp3","ambient/day/Skylark2.mp3","ambient/day/Skylark3.mp3","ambient/day/Skylark4.mp3","ambient/day/Skylark5.mp3","ambient/day/TreeBird01.mp3","ambient/day/TreeBird02.mp3","ambient/day/TreeBird03.mp3","ambient/day/TreeBird04.mp3","ambient/day/TreeBird05.mp3","ambient/day/TreeBird06.mp3"},
	noc={"ambient/night/Insect_Cricket09.mp3","ambient/night/Insect_Cricket10.mp3","ambient/night/MeadowNight03.mp3","ambient/night/MeadowNight05.mp3","ambient/night/MeadowNight06.mp3","ambient/night/N_gale1.mp3","ambient/night/N_gale2.mp3","ambient/night/N_gale3.mp3","ambient/night/OwlDistant1_1.mp3","ambient/night/OwlDistant1_2.mp3","ambient/night/OwlDistant2_1.mp3","ambient/night/OwlDistant2_2.mp3"},
}
function tlo()
	local dzwiek=true
	local config=getElementData(localPlayer,"config")
	if config and config["options"] and config["options"][1] then
		if config["options"][1]=="1" then
			dzwiek=false
		end
	end
	setTimer(tlo,math.random(3000,8000),1)
	if dzwiek then
		local hour = getTime()
		local x,y,z=getElementPosition(localPlayer)
		if hour<22 and hour>7 then
			sound(tlodzwieki.dzien[math.random(#tlodzwieki.dzien)],x+math.random(-10,10),y+math.random(-10,10),z+math.random(-10,10),100,{volume=math.random(60,90)/100,loop=false,playdis=100})
		else
			sound(tlodzwieki.noc[math.random(#tlodzwieki.noc)],x+math.random(-10,10),y+math.random(-10,10),z+math.random(-10,10),100,{volume=math.random(80,100)/100,loop=false,playdis=100})
		end
	end
end
tlo()
eksplozje={
[0]=true,
[1]=false,
[2]=true,
[3]=true,
[4]=true,
[5]=true,
[6]=true,
[7]=true,
[8]=true,
[9]=false,
[10]=true,
[11]=false,
[12]=false,
}
function ClientExplosionFunction(x,y,z,theType)
	if eksplozje[theType] then
		sound("explosion/explosion"..math.random(1,3)..".mp3",x,y,z,300,{volume=1,loop=false,playdis=1000,alternatywa={odl=900,dzwiek="explosion/expl_dist"..math.random(1,7)..".ogg"}})
	end
end
addEventHandler("onClientExplosion",getRootElement(),ClientExplosionFunction)
setWorldSoundEnabled(4,false)
setWorldSoundEnabled(5,false)
setWorldSoundEnabled(5,88,true)
setWorldSoundEnabled(5,86,true)
setWorldSoundEnabled(5,87,true)
setWorldSoundEnabled(5,47,true)

broniedzwieki={
[22]={"weapon/glock17.mp3",70},
}
function onClientPlayerWeaponFireFunc(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	dzwiekbroni=broniedzwieki[weapon]
	if dzwiekbroni then
		x1,y1,z1=getElementPosition(source)
		x2,y2,z2=getElementPosition(localPlayer)
		dis=getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
		if dis<500 then
		    sound(dzwiekbroni[1],x1,y1,z1,dzwiekbroni[2],{volume=math.random(60,90)/100,loop=false,playdis=1000})
		end
	end
end
-- Add this as a handler so that the function will be triggered every time a player fires.
addEventHandler("onClientPlayerWeaponFire", root, onClientPlayerWeaponFireFunc)