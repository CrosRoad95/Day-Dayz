gui={}

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end

size={750,600}
function stworzgui()
	gui["gui1"]=guiCreateWindow(0,0,size[1],size[2],"",false)
	centerWindow(gui["gui1"])
	guiWindowSetMovable(gui["gui1"],false)
	guiSetAlpha(gui["gui1"],0)
	guiWindowSetSizable(gui["gui1"],false)
	gui["przegladarka"]=guiCreateBrowser(0,20,size[1],size[2]-20,true,true,false,gui["gui1"])
	addEventHandler("onClientBrowserCreated",gui["przegladarka"], 
	function()
		przegladarka=source
		loadBrowserURL(source, "http://mta/local/html/index.html")
		--setDevelopmentMode(true,true)
		--toggleBrowserDevTools(source,true)
	end)
end

function wlaczPanel()
	guiSetVisible(gui["gui1"],true)
end
function wylaczPanel()
	guiSetVisible(gui["gui1"],false)
end

function openClose()
	if not guiGetVisible(gui["gui1"]) then
		wlaczPanel()
	else
		wylaczPanel()
	end
end
bindKey("h","down",openClose)
stworzgui()
wylaczPanel()
