function ladujPodmianki()
	podmiankiWykluczone={}
	xml = xmlLoadFile(":dayz-panel/config.xml")
	if xml then
		podm=xmlFindChild(xml,"podmianki",0)
		podm=xmlNodeGetValue(podm)
		xmlUnloadFile(xml)
	end
	if podm then
		for i,v in ipairs(split(podm,",")) do
			podmiankaWlaczona=split(v,"=")
			if tonumber(podmiankaWlaczona[1]) and tonumber(podmiankaWlaczona[2]) then
				if podmiankaWlaczona[2]=="0" then	
					podmiankiWykluczone[tonumber(podmiankaWlaczona[1])]=true
				end
			else
				podmiankiWykluczone={}
				return
			end
		end
	end
end
ladujPodmianki()
function podmiankiWymaganeZaladuj()
	podmianki={
	[321]="kamien",
	[334]="bron_kilof",
	[13611]="crashsite",
	[3243]="tentcol",
	[281]="hazmat",
	[73]="73",
	[22]="22",
	[56]="56",
	[67]="67",
	[68]="68",
	[69]="69",
	[70]="70",
	[92]="92",
	[97]="97",
	[105]="105",
	[107]="107",
	[108]="108",
	[126]="126",
	[127]="127",
	[128]="128",
	[152]="152",
	[162]="162",
	[167]="167",
	[188]="188",
	[195]="195",
	[206]="206",
	[209]="209",
	[212]="212",
	[229]="229",
	[230]="230",
	[258]="258",
	[264]="264",
	[277]="277",
	[280]="280",
	[287]="287",
	[288]="288",
	[290]="290",
	[291]="291",
	[292]="292",
	[293]="293",
	[294]="294",
	[295]="295",
	[296]="296",
	[297]="297",
	[298]="298",
	[299]="299",
	[282]="282",
	[283]="283",
	[284]="284",
	[285]="285",
	[16098]="hangar",
	[1936]="sandbox",
	[1515]="con1",
	[496]="blistac",
	[602]="alpha",
	[587]="euros",
	[415]="cheetah",
	[527]="cadrona",
	[402]="buffalo",
	[541]="bullet",
	[1510]="luneta",
	[1008]="tankparts",
	[2683]="woda",
	[1578]="Bandage",
	[2673]="esc",
	[1579]="morphine",
	[1279]="tentz",
	[1277]="map",
	[2976]="GPS",
	[2710]="watch",
	[2804]="rawmeat",
	[1580]="blood",
	[1558]="hospitalbox",
	[2709]="painkiller",
	[1576]="hitpak",
	[2891]="fak",
	[2647]="soda_can",
	[2601]="beans_can",
	[2770]="pasta_can",
	[2806]="kukmit",
	[2969]="tulboks",
	[1463]="drynwo",
	[1650]="kanister",
	[929]="silnik",
	[933]="drut",
	[1073]="kolo",
	[3013]="pistol_ammo",
	[2039]="shotgun_ammo",
	[2041]="smg_ammo",
	[2358]="sniper_ammo",
	[1271]="assault_ammo",
	[3026]="backpack_small",
	[1248]="backpack_alice",
	[1252]="backpack_coyote",
	[1575]="backpack_czech",
	[2289]="backpack_marines",
	[2288]="backpack_military",
	[1318]="czerwonydom",
	[355]="ak47",
	[346]="colt",
	[356]="m4",
	[348]="magnum",
	[353]="mp5",
	[349]="shotgun",
	[358]="cz550",
	[352]="uzi",
	[339]="katana",
	[338]="baseball",
	[335]="knifecur",
	[347]="silen",
	[351]="spaz",
	[350]="off",
	[357]="lee",
	[400]="400",
	[417]="417",
	[422]="422",
	[424]="424",
	[428]="428",
	[437]="437",
	[445]="445",
	[448]="448",
	[452]="452",
	[463]="463",
	[468]="468",
	[470]="470",
	[471]="471",
	[473]="473",
	[483]="483",
	[484]="484",
	[487]="487",
	[490]="490",
	[492]="492",
	[495]="495",
	[497]="497",
	[500]="500",
	[507]="507",
	[523]="523",
	[536]="536",
	[542]="542",
	[543]="543",
	[549]="549",
	[562]="562",
	[568]="568",
	[579]="579",
	[601]="601",
	[14562]="ubranie",
	}
	int=0
	for i,v in pairs(podmianki) do
		if podmiankiWykluczone[i] then
			print("Niezaladowano",i,v)
		else
			f1,f2,f3=0,0,0
			if fileExists("podmianki_wymagane/"..v..".col") then
				col=engineLoadCOL("podmianki_wymagane/"..v..".col")
				if col then
					engineReplaceCOL(col,i)
				end
				f1=1
			end
			if fileExists("podmianki_wymagane/"..v..".txd") then
				txd=engineLoadTXD("podmianki_wymagane/"..v..".txd")
				if txd then
					engineImportTXD(txd,i)
				end
				f2=1
			end
			if fileExists("podmianki_wymagane/"..v..".dff") then
				dff=engineLoadDFF("podmianki_wymagane/"..v..".dff")
				if dff then
					engineReplaceModel(dff,i)
				end
				f3=1
			end
			sleep(50)
			int=int+1
		end
	end
end

function callFunctionWithSleeps(calledFunction, ...) 
    local co = coroutine.create(calledFunction)
    coroutine.resume(co, ...)
end 
  
function sleep(time) 
    local co = coroutine.running() 
    local function resumeThisCoroutine()
        coroutine.resume(co) 
    end 
    setTimer(resumeThisCoroutine, time, 1)
    coroutine.yield()
end 
callFunctionWithSleeps(podmiankiWymaganeZaladuj)