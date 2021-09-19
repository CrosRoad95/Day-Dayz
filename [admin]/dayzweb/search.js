window.onload = function () {
    var search = document.querySelector('#search');
    var list = document.querySelector('.list').children;
    search.oninput = function () {
        try {
            search.style.border = "2px solid green"
            for (var i = 0, length = list.length; i < length; i++) {
                var n = list[i].querySelector('.nazwa').innerHTML.trim().toLowerCase();
				if (list[i].querySelector('.status')){
					var s = list[i].querySelector('.status').innerHTML.trim().toLowerCase();
					if (n.search(new RegExp(search.value.toLowerCase())) !== -1 || s.search(new RegExp(search.value.toLowerCase())) !== -1) {
						list[i].style.display = "table-row";
					} else {
						list[i].style.display = "none";
					}
				}else{
					if (n.search(new RegExp(search.value.toLowerCase())) !== -1) {
						list[i].style.display = "table-row";
					} else {
						list[i].style.display = "none";
					}
				}
            }
        } catch (e) {
            search.style.border = "2px solid red"
        }
    }
}