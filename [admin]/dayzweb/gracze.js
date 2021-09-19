function gracze_wiadomosc_(el) {
	wiadomosc=prompt("Wpisz wiadomość","")
	if (wiadomosc){
		gracze_wiadomosc(el.value,wiadomosc, 
			function (zwrot) {
				alert(zwrot);
			}
		);
	}
}

function aktualizuj(){
	el=document.querySelector(".list")
	while (el.firstChild) {
		el.removeChild(el.firstChild);
	}
	gracze_pobierz(function(gracze){
		console.log(gracze[0])
		var row = el.insertRow(0);
		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);
		cell1.innerHTML=gracze[0];
		cell2.innerHTML="fhhg";
	})
	
}
/*
	<button type="button" onclick="alert('<*=getPlayerName(v)*>')" class="btn btn-info">Info</button>
									<button type="button" value="<*=getPlayerName(v)*>" onclick="gracze_wiadomosc_(this)" class="btn btn-info">Wiadomość</button>
									<button type="button" onclick="alert('<*=getPlayerName(v)*>')" class="btn btn-warning">Kick</button>
									<button type="button" onclick="alert('<*=getPlayerName(v)*>')" class="btn btn-danger">1h ban</button>
								
*/
document.onreadystatechange = function () {
	aktualizuj()
}