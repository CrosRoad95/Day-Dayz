$(function() {

  $('#gracze').on('change', function(){
    var selected = $(this).find("option:selected").val();
    mta.triggerEvent("gracze_aktualizuj",selected)
  });
  
});

var podmianki={
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
function aktualizujPodmianki(){
	var podmiankiText='<li class="list-group-item"><h4>Aby podmianki się zaktualizowały, musisz ponownie wejść na serwer! Niektóre pojazdy nie mają podmianek!</h4></li>'
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

function zapiszconfig(){
	var jezyk=$("#jezyk option:selected").val()
	var idsInOrder = $("#sortable").sortable("toArray");
	var opcja1=$("#Switch1").is(':checked');
	var opcja2=$("#Switch2").is(':checked');
	podmianki1="";
	for(i=1;i<100;i++){
		var opcja=$("#Podmianka_switch_"+(i));
		if(opcja[0]==undefined){break;}
		model=opcja.attr("model")
		if(i==1){
			podmianki1+=(opcja.is(':checked')==true && model+"=1"||model+"=0");
		}else{
			podmianki1+=","+(opcja.is(':checked')==true && model+"=1"||model+"=0");
		}
	}
	mta.triggerEvent("zapisz_config",jezyk,JSON.stringify(idsInOrder),opcja1,opcja2,podmianki1);
}
window.onload=function(){
	$("lua").each(function() {	
		mta.triggerEvent("laduj_kod",this.id,this.innerHTML);
	})
}
var kody = {
	"2zł (2,46zł z VAT)":"<b>MSMS.IYW2</b> na numer <b>7255</b>",
	"4zł (4.92zł z VAT)":"<b>MSMS.IYW4</b> na numer <b>7455</b>",
	"6zł (7.38zł z VAT)":"<b>MSMS.IYW7</b> na numer <b>7636</b>",
	"11zł (12,30zł z VAT)":"<b>MSMS.IYW15</b> na numer <b>91055</b>",
	"19zł (23.37zł z VAT)":"<b>MSMS.IYW19</b> na numer <b>91955</b>",
	"25zł (30,75zł z VAT)":"<b>MSMS.IYW30</b> na numer <b>92555</b>",
};
var kodyotrzymasz = {
	"2zł (2,46zł z VAT)":"<b>2</b> punkty premium",
    "4zł (4.92zł z VAT)":"<b>5</b> punkty premium",
    "6zł (7.38zł z VAT)":"<b>15</b> punktów premium",
    "11zł (12,30zł z VAT)":"<b>30</b> punktów premium",
    "19zł (23.37zł z VAT)":"<b>55</b> punktów premium",
    "25zł (30,75zł z VAT)":"<b>100</b> punktów premium",
};

function sprawdzSMS(){
	if (typeof wybrany !== 'undefined'){
		mta.triggerEvent("sprawdz_sms",wybrany,$('#ex1').val());
		$('#ex1').val("");
	}
}
function napraw(){
	mta.triggerEvent("napraw_config");
}

$(function(){
  $('.selectpicker').on('change', function(){
    var selected = $(this).find("option:selected").val();
	if (kody[selected]){
		$("#tresc").html(kody[selected]);
		$("#koszt").html(selected);
		$("#otrzymasz").html(kodyotrzymasz[selected]);
		wybrany=selected;
	}
  });

  aktualizujPodmianki()
});