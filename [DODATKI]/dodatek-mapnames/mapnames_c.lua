-- Settings variables
local textFont       = "default-bold"			-- The font of the tag text
local textScale      = 1						-- The scale of the tag text
local heightPadding  = 1						-- The amount of pixels the tag should be extended on either side of the vertical axis
local widthPadding   = 1						-- The amount of pixels the tag should be extended on either side of the horizontal axis
local xOffset        = 8						-- Distance between the player blip and the tag
local minAlpha       = 10						-- If blip alpha falls below this, the tag won't the shown
local textAlpha      = 255
local rectangleColor = tocolor(0,0,0,230)

-- Other variables
local floor          = math.floor
local w,h            = guiGetScreenSize()

local function drawMapStuff()
	if isPlayerMapVisible() then
		
		local sx,sy,ex,ey     = getPlayerMapBoundingBox()							-- Map positions
		local mw,mh           = ex-sx,sy-ey											-- Map width/height
		local cx,cy           = (sx+ex)/2,(sy+ey)/2									-- Center position of the map
		local ppuX,ppuY       = mw/6000,mh/6000										-- Pixels per unit
		local fontHeight      = dxGetFontHeight(textScale,textFont)					-- Height of the specified font
		local yOffset         = fontHeight/2										-- How much pixels the tag should be offsetted at
		local blips           = getElementsByType("blip")
		
		for k,v in ipairs(blips) do
			
			local attached=getElementAttachedTo(v)
			
			if isElement(attached) and getElementType(attached)=="player" then
				
				local px,py      = getElementPosition(attached)						-- Player's position
				local x          = floor(cx+px*ppuX+xOffset)						-- X for the nametag
				local y          = floor(cy+py*ppuY-yOffset)						-- Y for the nametag
				local pname      = getPlayerName(attached)							-- Player name
				local nameLength = dxGetTextWidth(pname,textScale,textFont)			-- Width of the playername
				local r,g,b      = getPlayerNametagColor(attached)					-- Player's nametag color
				local _,_,_,a    = getBlipColor(v)									-- Blip alpha
				
				if a>minAlpha then
					
					dxDrawRectangle(x-widthPadding,y+heightPadding,nameLength+widthPadding*2,fontHeight-heightPadding*2,rectangleColor,false)
					dxDrawText(pname,x,y,x+nameLength,y+fontHeight,tocolor(r,g,b,textAlpha),textScale,textFont,"left","top",false,false,false)
					
				end
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),drawMapStuff)