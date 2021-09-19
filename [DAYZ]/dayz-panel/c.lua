gui={}
nazwa="config.xml"
--[[
podmianki={
"400":["Landstalker",1],
"402":["Buffalo",1],
"415":["Cheetah",1],
"417":["Leviathan",1],
"422":["Bobcat",1],
"424":["BF Injection",1],
"428":["Securicar",1],
"433":["Barracks",1],
"437":["Coach",1],
"445":["Admiral",1],
"448":["Pizza Boy",1],
"452":["Speeder",1],
"453":["Reefer",1],
"461":["PCJ-600",1],
"462":["Faggio",1],
"463":["Freeway",1],
"468":["Sanchez",1],
"470":["Patriot",1],
"471":["Quadbike",1],
"473":["Dinghy",1],
"483":["Camper",1],
"484":["Marquis",1],
"487":["Maverick",1],
"490":["FBI Rancher",1],
"492":["Greenwood",1],
"495":["Sandking",1],
"496":["Blista Compact",1],
"497":["Police Maverick	",1],
"500":["Mesa",1],
"504":["Bloodring Banger",1],
"505":["Rancher",1],
"507":["Elegant",1],
"508":["Journey",1],
"509":["Bike",1],
"511":["Beagle",1],
"516":["Nebula",1],
"518":["Buccaneer",1],
"523":["HPV1000",1],
"527":["Cadrona",1],
"531":["Tractor",1],
"535":["Slamvan",1],
"536":["Blade",1],
"541":["Bullet",1],
"542":["Clover",1],
"545":["Hustler",1],
"549":["Tampa",1],
"562":["Elegy",1],
"568":["Bandito",1],
"579":["Huntley",1],
"587":["Euros",1],
"593":["Dodo",1],
"596":["Police LS",1],
"601":["S.W.A.T.",1],
"602":["Alpha",1],
"605":["Damaged Sadler",1],
};
]]

function ladujConfig()
	opcje={}
	xml = xmlLoadFile(nazwa)
	if xml then
		local jezyk=xmlFindChild(xml,"language",0)
		opcje["jezyk"]=xmlNodeGetValue(jezyk)
		local podm=xmlFindChild(xml,"podmianki",0)
		if podm then
			val=xmlNodeGetValue(podm)
			podmianki={}
			for i,v in ipairs(split(val,",")) do
				f=split(v,"=")
				l1,l2=tonumber(f[1]),tonumber(f[2])
				if l1 and l2 then
					anazwa=getVehicleNameFromModel(l1)
					if anazwa then
						txt="\""..l1.."\":[\""..anazwa.."\","..l2.."],"
						table.insert(podmianki,txt)
					else
						podmianki={}
						break
					end
				else
					podmianki={}
					break
				end
			end
			if #podmianki>0 then
				str=table.concat(podmianki,"\n")
				tekstPodmianek="podmianki={"..str.."};"
			end
		end
		local options=xmlFindChild(xml,"options",0)
		opcje["options"]=split(xmlNodeGetValue(options),",")
		opcje["ekwipunek"]={}
		opcje["ekwipunek"]["sortowanie"]={}
		local inv=xmlFindChild(xml,"inventory",0)
		local sort=xmlFindChild(inv,"sorting",0)
		local sort_=xmlNodeGetChildren(sort)
		for i,v in ipairs(sort_) do
			table.insert(opcje["ekwipunek"]["sortowanie"],{xmlNodeGetAttribute(v,"category"),xmlNodeGetAttribute(v,"subcategory")})
		end
	else
		xml=xmlCreateFile(nazwa,"config")
		local jezyk=xmlCreateChild(xml,"language")
		xmlNodeSetValue(jezyk,"pl")
		local opcjee=xmlCreateChild(xml,"options")
		xmlNodeSetValue(opcjee,"0,0,0,0,0,0,0,0,0,0,0,0,0")
		local inv=xmlCreateChild(xml,"inventory")
		local sort=xmlCreateChild(inv,"sorting")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Weapons")
		xmlNodeSetAttribute(sort_,"subcategory","Primary Weapon")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Weapons")
		xmlNodeSetAttribute(sort_,"subcategory","Secondary Weapon")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Weapons")
		xmlNodeSetAttribute(sort_,"subcategory","Specially Weapon")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Food")
		xmlNodeSetAttribute(sort_,"subcategory","")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Items")
		xmlNodeSetAttribute(sort_,"subcategory","")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Toolbelt")
		xmlNodeSetAttribute(sort_,"subcategory","")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Ammo")
		xmlNodeSetAttribute(sort_,"subcategory","")
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category","Items")
		xmlNodeSetAttribute(sort_,"subcategory","Bases")
		opcje["jezyk"]="pl"
		opcje["ekwipunek"]={}
		opcje["ekwipunek"]["sortowanie"]={
		{"Weapons","Primary Weapon"},
		{"Weapons","Secondary Weapon"},
		{"Weapons","Specially Weapon"},
		{"Food",""},
		{"Items",""},
		{"Toolbelt",""},
		{"Ammo",""},
		{"Items","Bases"},
		}
	end
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
	setElementData(localPlayer,"config",opcje,false)
end
ladujConfig()
size={750,600}
function stworzgui()
	gui["gui1"]=guiCreateWindow(0,0,size[1],size[2],"",false)
	guiWindowSetMovable(gui["gui1"],false)
	guiSetAlpha(gui["gui1"],0)
	guiWindowSetSizable(gui["gui1"],false)
	gui["przegladarka"]=guiCreateBrowser(0,20,size[1],size[2]-20,true,true,false,gui["gui1"])
	addEventHandler("onClientBrowserCreated",gui["przegladarka"], 
	function()
		przegladarka=source
		loadBrowserURL(source,"http://mta/local/html/index.html")
		if getPlayerName(localPlayer)=="CrosRoad95" then
			--toggleBrowserDevTools(source,true)
		end
		setTimer(aktualizuj,200,1)
	end)
end

antyspam1=getTickCount()
antyspam2=getTickCount()
regulamin=[[
<p style="margin-left:40px;"><span style="font-size:18px;"><span style="color:#ff0000;"><strong>Rozdział 1. Postanowienia ogólne</strong></span></span><br>
&nbsp;<br>
§ 1. Regulamin i inne treści dotyczy tylko i wyłącznie serwera Dayz mta-itsyourworld.pl<br>
§ 1.1 Wszelkie próby kopiowania regulaminu na potrzeby własne lub publiczne są zakazane.<br>
§ 1.2 Wszelkie próby kopiowania innych treści na potrzeby własne lub publiczne są zakazane.<br>
§ 2. Rejestrując się bądź przebywając na serwerze dayz akceptujesz niniejszy regulamin.<br>
§ 3. Nad przestrzeganiem regulaminu czuwają Administratorzy.<br>
§ 4. Administracja może w szczególnych przypadkach nie przestrzegać tabeli kar.<br>
§ 5. Spory mogą być rozstrzygane przez Administracje.<br>
§ 6. Administracja zastrzega sobie prawo do zmiany regulaminy w każdej chwili.</p>
<p style="margin-left:40px;">&nbsp;<br><span style="font-size:18px;"><span style="color:#ff0000;"><strong>Rozdział 2. Kultura</strong></span></span><br>
&nbsp;<br>
§ 1. Za nie kulturalne uważa się:<br>
§ 1.1 Posiadania nicku o charakterze nawołującym do agresji lub nietolerancji rasowej,poglądowej oraz religijnej.<br>
§ 1.2 Posiadanie nicku zawierające wulgaryzmy.<br>
§ 1.3 Używanie wulgarnego słownictwa.<br>
&nbsp;<br><span style="font-size:18px;"><span style="color:#ff0000;"><strong>Rozdział 3. Gra</strong></span></span><br>
&nbsp;<br>
§ 1. Administracja nie odpowiada za stracenie przedmiotów lub pojazdów jeśli nie jest to z winy serwera.<br>
§ 2. Administracja nie zwraca przedmiotów jeżeli nie jest to spowodowane błędem serwera.<br>
§ 3. Zabrania się wykorzystywania błędów serwera do własnych korzyści.<br>
§ 3.1 Jeśli taki przypadek zostanie stwierdzony i nie zgłoszony, graczowi może zostać nadana blokada dostępu do serwera.<br>
§ 4. Zabrania się kopiowania przedmiotów.<br>
§ 5. Zabrania się Kampienia na bazy graczy w terenie (jeżeli zostaną wprowadzone) oraz na GreenZone jeżeli nie ma przynajmniej jednego bezpiecznego wyjazdu.<br>
§ 6. Administracja nie rozdaje przedmiotów w grze.<br>
§ 7. Zakaz Spamowania na chacie.<br>
§ 8. Zakazuje się bezpodstawnego oskarżania o kradzieże przez graczy oraz Administracji o spectowanie gracza w celu zabicia go.</p>
<p style="margin-left:40px;">§ 9. Zakaz kradnięcia pojazdów w GZ<br>
&nbsp;<br>
&nbsp;<br><span style="color:#ff0000;"><span style="font-size:18px;"><strong>Rozdział 4. Grupy</strong></span></span><br>
&nbsp;<br><span style="color:#ff8c00;"><strong>Aby założyć grupę należy wpisać komendę:</strong></span><br>
/grupa [Nazwa grupy] [Tag]<br>
&nbsp;<br><span style="color:#ff8c00;"><strong>Aby dołączyć do grupy należy wpisać komendę:</strong></span><br>
/dolacz [ID Grupy] [Dlaczego chcesz dołączyc?]<br>
&nbsp;<br><span style="color:#008000;"><strong>Regulamin grup:</strong></span><br>
&nbsp;<br>
1. Zakazuje się posiadania obraźliwych nazw grup lub posiadanie obraźliwego tagu.<br>
2. Nazwy grupy i tagu nie można zmienić.<br>
3. Właściciel grupy odpowiada za grupę.<br>
4. Zakazuje się grupowo kampienia na nowych graczy.<br>
5. Właściciel odpowiada za prawa które nadaje poszczególnym członkom grupy.<br>
6. Zakładanie grup jest darmowe.<br>
7. Zabrania się dodawanie do grupy tylko po to żeby kogoś zabić.<br>
8. Grupa może otrzymać dział na forum. ( wymagane 10 aktywnych osó <img src='http://niceshot.eu/public/style_emoticons/default/cool.png' class='bbc_emoticon' alt='B)' /><br>
&nbsp;<br><span style="color:#008000;"><strong>Objaśnienie funkcji panelu grup</strong></span><br>
&nbsp;<br>
1. Wyrzuć - funkcja pozwalająca na wyrzucenie zaznaczonej osoby z grupy.<br>
2. Zmień prawa - funkcja pozwalająca ( jeżeli posiadasz odpowiednie prawa )<br>
&nbsp; &nbsp; na zmianę praw oraz tagu poszczególnych osób z grupy.<br>
3. Sojusze - Pozwala założyć sojusz pomiędzy grupami. Aby sojusz doszedł<br>
&nbsp; &nbsp; do skutku, obie grupy muszą zaproponować między sobą sojusz. Po zawarcia<br>
&nbsp; &nbsp; sojuszu obie grupy widzą siebie nawzajem na mapie na kolor niebieski<br>
4. Usuń grupę - Usuwa grupę, nieodwracalne.<br>
5. Dodaj nową osobę do grupy - Pozwala dodać nowe osoby do grupy jeżeli<br>
&nbsp; &nbsp; wcześniej wybrana osoba wpisała komendę odpowiadającą za<br>
&nbsp; &nbsp; dołączenie do grupy.<br>
6. Historia aktywności grupy - Pobiera plik z 1000 ostatnimi aktywnościami<br>
&nbsp; &nbsp; grupy.<br>
7. Informacje o zaznaczonej osobie - Wyświetla podstawowe informacje o<br>
&nbsp; &nbsp; zaznaczonej osobie.<br>
8. Opuść grupę - Pozwala opuścić grupę, nie może zrobić tego właściciel.<br>
&nbsp;<br><span style="color:#008000;"><strong>Objaśnienie innych funkcji panelu grup</strong></span><br>
&nbsp;<br>
1. Chat grupowy - znajduje się pod przyciskiem Y, po napisaniu wiadomości<br>
&nbsp; &nbsp; zostaje wyświetlona tylko osobą które należą do twojej grupy. Jeżeli<br>
&nbsp; &nbsp; przed wiadomością napiszesz wykrzyknik (!) wiadomość zostanie<br>
&nbsp; &nbsp; wysłana do wszystkich osób które są z twojej grupy i sojuszy<br>
&nbsp; &nbsp; twojej grupy.<br>
2. Informacje o grupie ( białe pole w panelu grup ) - miejsce w którym<br>
&nbsp; &nbsp; uprawnione osoby mogą napisać dowolną rzecz.</p>
<p style="margin-left:40px;">&nbsp;</p>]]
function aktualizuj()
	if antyspam1+5000<getTickCount() then
		triggerServerEvent("aktualizuj_panel",resourceRoot)		
		antyspam1=getTickCount()
	end
	if tekstPodmianek then
		executeBrowserJavascript(przegladarka,tekstPodmianek..[[
function aktualizujPodmianki(){
	var podmiankiText='<li class="list-group-item"><h2>Aby podmianki się zaktualizowały, musisz ponownie wejść na serwer! Niektóre pojazdy nie mają podmianek!</h2></li>'
	var idPodmianki=0
	$.each(podmianki,function(index,value){
		idPodmianki++
		//mta.triggerEvent("log",value[1]);
		if(value[1]==0){
			podmiankiText+='<li class="list-group-item">'+value[0]+'<div class="material-switch pull-right"><input id="Podmianka_switch_'+idPodmianki+'" model="'+index+'" name="Podmianka_switch_'+idPodmianki+'" type="checkbox" /><label for="Podmianka_switch_'+idPodmianki+'" class="label-success"></label></div></li>'
		}else{
			podmiankiText+='<li class="list-group-item">'+value[0]+'<div class="material-switch pull-right"><input id="Podmianka_switch_'+idPodmianki+'" model="'+index+'" name="Podmianka_switch_'+idPodmianki+'" type="checkbox" checked /><label for="Podmianka_switch_'+idPodmianki+'" class="label-success"></label></div></li>'
		}
	});
	$("#listapodmianek").html(podmiankiText);
}
aktualizujPodmianki()
		]])	
	end
	--regulamin=getElementData(resourceRoot,"$Regulamin$")
	if regulamin then
		kod=[[$html=$(`]]..regulamin..[[`);
		regulamin=$html.find('.post.entry-content').add($html.filter('.post.entry-content')); 
		$("#tab2").html(`]]..regulamin..[[`);
		$("p").css("margin-left",0);
		]]
		executeBrowserJavascript(przegladarka,kod)
	end
	changelog=getElementData(resourceRoot,"$Changelog$")
	if changelog then
		zmiany='<table class="table table-bordered"><thead><tr><th>Data</th><th>Zmiana</th></tr></thead><tbody>'
		for i,v in ipairs(changelog) do
			zmiany=zmiany.."<tr><td class='span1'>"..v.data.."</td><td class='span2'>"..v.tresc.."</td></tr>"
		end
		zmiany=zmiany.."</tbody></table>"
		kod=[[
		htmlkod=`]]..zmiany..[[`;
		$("#changelog").html(htmlkod);
		]]
		executeBrowserJavascript(przegladarka,kod)
	end
	pojazdy=getElementData(resourceRoot,"$Pojazdy$")
	if pojazdy then
		pojazd=""
		for i,v in ipairs(pojazdy) do
			pojazd=pojazd.."<tr><td>"..getVehicleNameFromModel(v.ID).."</td><td>"..v.silnikow.."</td><td>"..v.kol.."</td><td>"..v.zbiornikow.."</td><td>"..v.paliwo.."</td><td>"..v.limit_slotow.."</td></tr>"
		end
		kod=[[
		htmlkod=`]]..pojazd..[[`;
		$("#pojazdy_").html(htmlkod);
		]]
		executeBrowserJavascript(przegladarka,kod)
	end
	opcje=getElementData(localPlayer,"config")
	if opcje then
		jezyki=""
		dostepne_jezyki=exports["dayz-jezyki"]:getLanguages()
		for i,v in ipairs(dostepne_jezyki) do
			if v[1]~=opcje["jezyk"] then
				jezyki=jezyki..[[<option data-subtext=" - ]]..v[1]..[[" value="]]..v[1]..[[">]]..v[2]..[[</option>]]
			else
				jezyki=jezyki..[[<option selected data-subtext=" - ]]..v[1]..[[" value="]]..v[1]..[[">]]..v[2]..[[</option>]]
			end
		end
		kod=[[
		htmlkod=`]]..jezyki..[[`;
		$("#jezyk").html(htmlkod);
		]]
		executeBrowserJavascript(przegladarka,kod)
		kateg={}
		for i,v in ipairs(opcje["ekwipunek"]["sortowanie"]) do
			table.insert(kateg,[[<li id="]]..v[1]..[[,]]..v[2]..[[" class="btn btn-primary" style="display:block">]]..v[1]..(v[2]=="" and "" or " - "..v[2])..[[</li>]])
		end
		kod=[[
		htmlkod=`]]..table.concat(kateg)..[[`;
		$("#sortable").html(htmlkod);
		]]
		executeBrowserJavascript(przegladarka,kod)
		
		if opcje["options"] and opcje["options"][1] then
			kod=[[
			var opcja1=$("#Switch1").prop('checked',]]..(opcje["options"][1]=="1" and "true" or "false")..[[);
			var opcja1=$("#Switch2").prop('checked',]]..(opcje["options"][2]=="1" and "true" or "false")..[[);
			]]
			executeBrowserJavascript(przegladarka,kod)
			
		end
	end
end
function wlaczPanel()
	guiSetVisible(gui["gui1"],true)
	showCursor(true)
	aktualizuj()
end
function wylaczPanel()
	guiSetVisible(gui["gui1"],false)
	showCursor(false)
end

function openClose()
	if guiGetVisible(gui["gui1"])~=isCursorShowing() then return outputChatBox("Nope") end
	if not guiGetVisible(gui["gui1"]) then
		wlaczPanel()
	else
		wylaczPanel()
	end
end
bindKey("f1","down",openClose)
stworzgui()
wylaczPanel()
function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return guiSetPosition(center_window, x, y, false)
end
centerWindow(gui["gui1"])
function gracze_aktualizuj(wybrane)
	if antyspam2+2000<getTickCount() then
		triggerServerEvent("aktualizuj_panel_pobierzranking",resourceRoot,wybrane)		
		antyspam2=getTickCount()
	else
		outputChatBox("Poczekaj chwile...",255,0,0)
	end
end
addEvent("gracze_aktualizuj", true)
addEventHandler("gracze_aktualizuj",resourceRoot,gracze_aktualizuj)
function zapisz_config(jezykn,invsort,opcja1,opcja2,podmianki)
	ninvsort=fromJSON("["..invsort.."]")
	xml=xmlCreateFile(nazwa,"config")
	local podm=xmlCreateChild(xml,"podmianki")
	xmlNodeSetValue(podm,podmianki)
	local jezyk=xmlCreateChild(xml,"language")
	xmlNodeSetValue(jezyk,jezykn)
	local options=xmlCreateChild(xml,"options")
	xmlNodeSetValue(options,opcja1..","..opcja2)
	local inv=xmlCreateChild(xml,"inventory")
	local sort=xmlCreateChild(inv,"sorting")
	opcje["jezyk"]="pl"
	opcje["options"]=split(opcja1..","..opcja2,",")
	opcje["ekwipunek"]={}
	opcje["ekwipunek"]["sortowanie"]={}
	for i,v in ipairs(ninvsort) do
		kateg_=split(v,",")[1]
		skateg_=split(v,",")[2]
		table.insert(opcje["ekwipunek"]["sortowanie"],{kateg_,skateg_ or ""})
		local sort_=xmlCreateChild(sort,"sort")
		xmlNodeSetAttribute(sort_,"category",kateg_)
		xmlNodeSetAttribute(sort_,"subcategory",skateg_ or "")
	end
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
	setElementData(localPlayer,"config",opcje,false)
	outputChatBox("Zapisano pomyślnie!",0,255,0)
end
addEvent("zapisz_config", true)
addEventHandler("zapisz_config",resourceRoot,zapisz_config)

function odeslij_ranking(typ,ranking,mojranking)
	local mojlogin=getElementData(localPlayer,"Login_name")
	local rnk=""
	for i,v in ipairs(ranking) do
		if v.l==mojlogin then
			rnk=rnk.."<tr class='ja'><td>"..i.."</td><td>"..v.l.."</td><td>"..v.m.."</td></tr>"
		else
			rnk=rnk.."<tr><td>"..i.."</td><td>"..v.l.."</td><td>"..v.m.."</td></tr>"
		end
	end
	kod=[[
	htmlkod=`]]..rnk..[[`;
	$("#ranking").html(htmlkod);
	]]
	executeBrowserJavascript(przegladarka,kod)
end
addEvent("odeslij_ranking", true)
addEventHandler("odeslij_ranking",localPlayer,odeslij_ranking)
function laduj_kod(id,kod)
	r=loadstring("return "..kod)()
	kod=[[
	htmlkod=`]]..tostring(r)..[[`;
	$("#]]..id..[[").html(htmlkod);
	]]
	executeBrowserJavascript(przegladarka,kod)
end
addEvent("laduj_kod", true)
addEventHandler("laduj_kod",resourceRoot,laduj_kod)

function sprawdzSms(id,kod)
	triggerServerEvent("SprawdzKodSMS",resourceRoot,id,kod)
end
addEvent("sprawdz_sms", true)
addEventHandler("sprawdz_sms",resourceRoot,sprawdzSms)

function log(tresc)
	outputChatBox(tresc)
end
addEvent("log", true)
addEventHandler("log",resourceRoot,log)

function napraw_config(tresc)
	if fileExists(nazwa) then
		fileDelete(nazwa)
	end
	ladujConfig()
	aktualizuj()
	outputChatBox("Przywrócono konfiguracje do domyślnych ustawień!",0,255,0)
end
addEvent("napraw_config", true)
addEventHandler("napraw_config",resourceRoot,napraw_config)

