function connect()
	SQL = dbConnect( "mysql", "dbname=db_20981;host=94.23.90.14", "db_20981", "oZ51IiSYtDLX", "share=1" )
	if (not SQL) then
		outputDebugString("BRAK POLACZENIA Z BAZA DANYCH!")
	else
		outputDebugString("POLACZONO POMYSLNIE!")
		zapytanie("SET NAMES utf8;")
	end
end

addEventHandler("onResourceStart",resourceRoot, connect)

function pobierzTabeleWynikow(...)
	zapytanie("SET NAMES utf8;")
	local h=dbQuery(SQL,...)
	if (not h) then 
		return nil
	end
	local rows = dbPoll(h, -1)
	return rows
end

function pobierzWyniki(...)
	zapytanie("SET NAMES utf8;")
	local h=dbQuery(SQL,...)
	if (not h) then 
		return nil
	end
	local rows = dbPoll(h, -1)
	if not rows then return nil end
	return rows[1]
end

function zapytanie(...)
	local h=dbQuery(SQL,...)
	local result,numrows=dbPoll(h,-1)
	return numrows
end

function getSQLLink()
	return SQL
end

function data(co)
	if co == 1 then
		return pobierzTabeleWynikow("SELECT CURDATE();")[1]["CURDATE()"]
	elseif co == 2 then
		return pobierzTabeleWynikow("SELECT CURTIME();")[1]["CURTIME()"]
	elseif co == 3 then
		dataa = pobierzTabeleWynikow("SELECT CURDATE();")[1]["CURDATE()"]
		time = pobierzTabeleWynikow("SELECT CURTIME();")[1]["CURTIME()"]
		return dataa.." "..time
	end
end

function now(dni)
	return pobierzTabeleWynikow("select now() + interval ? day as data;",dni)[1]["data"]
end