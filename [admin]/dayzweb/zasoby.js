function zasoby_start_(skrypt) {
	zasoby_start(skrypt, 
		function (zwrot) {
			alert(zwrot);
		}
	);
	setTimeout(function(){ zasoby_status_(skrypt); }, 250);
}
function zasoby_stop_(skrypt) {
	zasoby_stop(skrypt, 
		function (zwrot) {
			alert(zwrot);
        
		}
	);
	setTimeout(function(){ zasoby_status_(skrypt); }, 250);
}
function zasoby_restart_(skrypt) {
	zasoby_restart(skrypt, 
		function (zwrot) {
			alert(zwrot);
        
		}
	);
	setTimeout(function(){ zasoby_status_(skrypt); }, 250);
}
function zasoby_status_(skrypt) {
	zasoby_status(skrypt, 
		function (skrypt,status,kolor) {
			glowny=document.getElementById("skrypt_"+skrypt),
			statusCell=glowny.getElementsByTagName('td')[1];
			statusCell.innerText=status;
			statusCell.style.color=kolor;
		}
	);
}