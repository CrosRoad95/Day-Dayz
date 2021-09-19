m=5 -- co ile minut wyświetla informacje

x=0
function wyslij()
	q=exports.db:pobierzTabeleWynikow("select * from Informacje")
	x=x+1
	if x>#q then
		x=1 
	end
	r,g,b=unpack(split(q[x].rgb,","))
	outputChatBox(q[x].tresc,getRootElement(),tonumber(r),tonumber(g),tonumber(b))
end
wyslij()
setTimer(wyslij,1000*60*m,0)