function zaladuj()
	job={}
	q=exports.db:pobierzTabeleWynikow("select * from Cron_job")
	for i,v in ipairs(q) do
		job[v.godzina..":"..v.minuta]={v.akcja,v.ID}
	end
end
--RESPAWN_PRZEDMIOTY, NOWE_POJAZD_LADOWY, NOWY_POJAZD_PLYWAJACY, NOWY_POJAZD_LATAJACY
function cron()
	zaladuj()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	jb=job[hours..":"..minutes]
	if jb then
		if jb[1]=="RESPAWN_PRZEDMIOTY" then
			outputChatBox("ZA MINUTĘ WSZYSTKIE PRZEDMIOTY ZOSTANĄ ODŚWIEŻONE!",getRootElement(),0,255,0)
			setTimer(function()
				outputChatBox("TRWA ODŚWIEŻANIE PRZEDMIOTÓW! MOŻLIWY LAG!",getRootElement(),0,255,0)
				setTimer(function()
					triggerEvent("przedmiot_odswiez",getRootElement())
					outputChatBox("Przedmioty zostały odświeżone!",getRootElement(),0,255,0)
				end,1000,1)
			end,60000,1)
		elseif jb[1]=="NOWE_POJAZD_LADOWY" then
			triggerEvent("pojazd_spawn",getRootElement(),"auta")
		elseif jb[1]=="NOWY_POJAZD_PLYWAJACY" then
			triggerEvent("pojazd_spawn",getRootElement(),"lodzie")
		elseif jb[1]=="NOWY_POJAZD_HELKI" then
			triggerEvent("pojazd_spawn",getRootElement(),"helki")
		elseif jb[1]=="NOWY_POJAZD_SAMOLOTY" then
			triggerEvent("pojazd_spawn",getRootElement(),"samoloty")
		
		elseif jb[1]=="AKTUALIZUJ_BAZY" then
			triggerEvent("aktualizuj_bazy",getRootElement())
		end
		
		exports.db:zapytanie("update Cron_job set wykonano=wykonano+1 where ID=?",jb[2])
	end
end
setTimer(cron,1000*60,0)