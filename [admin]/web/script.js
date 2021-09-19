var currentResourceName = "";
var currentPageName = "";
var thisResource;

getThisResource (
	function (returnedResource)
	{
		thisResource = returnedResource;
	}
);

function resourceListUpdate () {
    //document.getElementById ( "resourceListLoading" ).style.display = "inline";
    setTimeout ( "resourceListUpdate()" , 5000 )
	
    getResourcesByState ( "running",
   
        function ( resourceTable ) /* called when the results arrive, each result in a seperate variable */
        {
			var htmlOut = "";
			
			if ( resourceTable.length == 0 )
				htmlOut = "No resources?!"
			else
			{   
				resourceTable = resourceTable.sort(
					function(a,b) 
					{ 
						if ( a.name.toLowerCase() < b.name.toLowerCase() )
							return -1;
						else if ( a.name.toLowerCase() > b.name.toLowerCase() ) 
							return 1;
						else
							return 0; 
					}
				);
				
				for ( i = 0; i < resourceTable.length; i++ )
				{
					if ( resourceTable[i].resource != thisResource )
					{
						var resname = resourceTable[i].name;
						if ( resname == false ) 
							resname = resourceTable[i].resource.name;
						

						var onclick = "onclick=\"setCurrentResource('" + resourceTable[i].resource.name + "')\"";
						var classname="inactive";
						if ( resourceTable[i].resource.name == currentResourceName && currentPageName == "" ) 
							classname="active";
						
						if ( resourceTable[i].noDefaultPage ) {
							classname += "_noDefaultPage";
							onclick = "";
						}
						
						htmlOut += "<div id='resource-" + resourceTable[i].resource.name + "' class='" + classname + 
						"' title='" + resourceTable[i].description + "' " + onclick + " >" + resname + "</div>\n"
						
						if ( resourceTable[i].pages != false ) {
							var pages = resourceTable[i].pages.split(",");
							for ( j = 0; j < pages.length; j++ )
							{
								var parts = pages[j].split("|");
								var name = parts[0];
								var pagename = parts[0];
								if ( parts.length == 2 )
									name = parts[1];
								var classname = "inactive_subpage";
								if ( currentPageName != "" && pagename == currentPageName )
									classname = "active_subpage";
									
								var onclick = "onclick=\"setCurrentPage('" + resourceTable[i].resource.name + "','" + pagename + "')\"";
								
								htmlOut += "<div id='resource-" + resourceTable[i].resource.name + "-" + pagename + "' class='" + classname + 
								"' " + onclick + " >" + name + "</div>\n"
							}
						}
					}
				}
			}
			
			document.getElementById ( "tabmenu" ).innerHTML = htmlOut;

            //document.getElementById ( "resourceListLoading" ).style.display = "none";
        }
	);
}

function setCurrentResource ( resourceName )
{
	deselectMenuItem();

    currentResourceName = resourceName;
	currentPageName = "";
    current = document.getElementById('resource-' + currentResourceName);
    if ( current != undefined )
    {
        current.className='active';
    }

    frames['content'].location ="/" + currentResourceName + "/";
}

function setCurrentPage ( resourceName, pageName )
{

	deselectMenuItem();
    currentResourceName = resourceName;
	currentPageName = pageName;
	
    current = document.getElementById('resource-' + currentResourceName + '-' + pageName);
    if ( current != undefined )
    {
        current.className='active_subpage';
    }

    frames['content'].location ="/" + currentResourceName + "/" + pageName;
}

function deselectMenuItem()
{

	if ( currentPageName != "" )
	{
	    current = document.getElementById('resource-' + currentResourceName + '-' + currentPageName);
	    if ( current != undefined )
	    {
	        current.className='inactive_subpage';
	    }
	}
	else
	{
	    current = document.getElementById('resource-' + currentResourceName);
	    if ( current != undefined )
	    {
	        current.className='inactive';
	    }
	}
	
}

function timeConverter(UNIX_timestamp){
  var a = new Date(UNIX_timestamp * 1000);
  var months = ['styczenia','lutego','marzeca','kwietnia','maja','czerwca','lipieca','sierpnia','wrzesienia','października','listopada','grudnia'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
}
setInterval(function(){getAdmins(function(admins){
	var adminslist="<table id='tableadmins'><tr><td>Administrator</td><td>Ostatnia aktywność</td></tr>";
	for (var key in admins) {
		if (admins.hasOwnProperty(key)) {
			adminslist+="<tr><td>"+key+"</td><td>"+timeConverter(admins[key])+"</td></tr>";
		}
	}
	adminslist+="</table>";
	element=document.querySelector("#admins");
	element.innerHTML=adminslist;
});},1000);
