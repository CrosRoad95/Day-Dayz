addEventHandler( "onClientRender", root,
	function( )
		local texts = getElementsByType( "text" );
		if #texts > 0 then
			local pX, pY, pZ = getElementPosition( localPlayer );
			for i = 1, #texts do
				local text = getElementData( texts[i], "text" );
				local tX, tY, tZ = getElementData( texts[i], "x" ), getElementData( texts[i], "y" ), getElementData( texts[i], "z" );
				local font = getElementData( texts[i], "font" );
				local scale = getElementData( texts[i], "scale" );
				local color = getElementData( texts[i], "rgba" );
				local maxDistance = getElementData( texts[i], "maxDistance" );
				if not text or not tX or not tY or not tZ then
					return
				end
				if not font then font = "default" end
				if not scale then scale = 2 end
				if not color or type( color ) ~= "table" then
					color = { 255, 255, 255, 255 };
				end
				if not maxDistance then maxDistance = 12 end
				local distance = getDistanceBetweenPoints3D( pX, pY, pZ, tX, tY, tZ );
				if distance <= maxDistance then
					local x, y = getScreenFromWorldPosition( tX, tY, tZ );
					if x and y then
						dxDrawText( text, x, y, _, _, tocolor( color[1], color[2], color[3], color[4] ), scale, font, "center", "center" );
					end
				end
			end
		end
	end
);