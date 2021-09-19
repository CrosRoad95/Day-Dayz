local function isElementStreamedOut ( theElement )
	return getElementDimension(theElement)==65256
end

function streamOutElement2(theElement)
	if  (getElementType(theElement) == element ) and not getElementDimension(theElement)==65256 then
		local currentDimension = getElementDimension( theElement )
		setElementDimension(theElement, 65256)
		setElementData(theElement, "streamer:"..element..":dimension", currentDimension, false)
	end
end

function streamInElement2(theElement)
	if  (getElementType(theElement) == element ) and getElementDimension(theElement)==65256 then
		local destinationDimension = getElementData(theElement, "streamer:"..element..":dimension") or 0
		setElementDimension(theElement, destinationDimension)
		setElementData(theElement, "streamer:"..element..":dimension", false, false)
	end
end

addEventHandler("onClientElementStreamOut",getRootElement(),
	function ()
		streamOutElement2( source )
	end
);
addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		streamInElement2(source)
	end
);