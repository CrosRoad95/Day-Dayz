function czyPozycjaJestWBazie(x,y,z)
	for i,v in ipairs(getElementsByType("bazy")) do
		Bx,By,Bz=getElementPosition(v)
		radius=getElementData(v,"ColBazy")[2]
		dis=getDistanceBetweenPoints3D(Bx,By,Bz,x,y,z)
		if dis<radius then
			return v
		end
	end
end

addEventHandler("onClientPlayerVehicleExit", getRootElement(),
	function (vehicle, seat)
		x,y,z=getElementPosition(vehicle)
		if czyPozycjaJestWBazie(x,y,z) then
			setElementFrozen(vehicle,true)
		end
	end
)
function odmroz(veh)
	setElementFrozen(veh,false)
end
addEventHandler("onClientPlayerVehicleEnter",getRootElement(),odmroz)

function anulujWybuchyWBazach(x,y,z,theType)
	if czyPozycjaJestWBazie(x,y,z) then
		cancelEvent()
		if getElementType(source)=="player" and source==localPlayer then
			outputChatBox("System ochrony bazy zneutralizował twój wybuch!",255,0,0)
		end
		return
	end
end
addEventHandler("onClientExplosion",getRootElement(),anulujWybuchyWBazach)

function czyJestNaTerenieBazy(element)
	ID_Postaci=getElementData(localPlayer,"ID_Postaci")
	x,y,z=getElementPosition(element)
	bylNaTerenie=false
	for i,v in ipairs(getElementsByType("bazy")) do
		Bx,By,Bz=getElementPosition(v)
		radius=getElementData(v,"ColBazy")[2]
		dis=getDistanceBetweenPoints3D(Bx,By,Bz,x,y,z)
		if dis<radius then
			bylNaTerenie=true
			baza=v
			for ii,vv in pairs(getElementData(v,"Dostep")) do
				if tonumber(vv["IDPos"])==tonumber(ID_Postaci) then
					return true,v
				end
			end
		end
	end
	if bylNaTerenie then
		return false,baza
	end
end

function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end
function renderText()
	if isPedAiming(localPlayer) then
		if not cel or not isElement(cel) then
			rendText=false
			removeEventHandler("onClientRender",root,renderText)
		else
			local x,y=getScreenFromWorldPosition(getElementPosition(cel))
			if x and y then
				hp=getElementData(cel,"hp")
				if hp then
					dxDrawText(hp[1].."/"..hp[2].."HP",x,y,0,0,tocolor(255,255,255,255),2,"sans")
				end
			end
		end
	end
end

rendText=false
function blokadaCelowania(target)
	cel=target
	if target then
		if not rendText then
			rendText=true
			addEventHandler("onClientRender",root,renderText)
		end
		targBazaA,targBazaA_=czyJestNaTerenieBazy(target)
		targBazaB,targBazaB_=czyJestNaTerenieBazy(localPlayer)
		if targBazaA_ and getElementData(targBazaA_,"darmowa")==1 then
			return
		end
		if targBazaB_ and getElementData(targBazaB_,"darmowa")==1 then
			return
		end
		if czyJestNaTerenieBazy(target)==false or czyJestNaTerenieBazy(localPlayer) then
			toggleControl("fire",false)
			toggleControl("aim_weapon",false)
		end
	else
		if rendText then
			rendText=false
			removeEventHandler("onClientRender",root,renderText)
		end
		toggleControl("fire",true)
		toggleControl("aim_weapon",true)
	end
end
addEventHandler("onClientPlayerTarget",getRootElement(),blokadaCelowania)

function blokadaObrazen()
	if czyJestNaTerenieBazy(source) then
		cancelEvent()
	end
end
addEventHandler("onClientVehicleDamage",root,blokadaObrazen)
addEventHandler("onClientPlayerDamage",root,blokadaObrazen)

bronieDamage={
[22]={1,2},
[23]={1,2},
[24]={3,5},
[25]={20,24},
[26]={16,22},
[27]={16,22},
[28]={2,4},
[32]={2,4},
[29]={4,6},
[30]={15,21},
[31]={18,25},
[33]={40,60},
[34]={50,70},
[38]={500,700},

}
function hit(loss,attacker)
	if attacker~=localPlayer then return end
	obrazenia=bronieDamage[getPedWeapon(localPlayer)]
	if obrazenia and obrazenia[1] then
		obrazenia=math.random(obrazenia[1],obrazenia[2])
		obrazenia=obrazenia/20
		hp=getElementData(source,"hp")
		if hp then
			hp[1]=hp[1]-math.floor(obrazenia)
			if hp[1]>0 then
				setElementData(source,"hp",hp)
				setElementData(source,"ostatnie_obrazenia",getTickCount())
			else
				triggerServerEvent("Bazy_zniszczElement",resourceRoot,source)
			end
		end
	end
end
addEventHandler("onClientObjectDamage",resourceRoot,hit)
