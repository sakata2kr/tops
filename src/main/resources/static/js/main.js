//그리드의 특이생상표현을 위한 object
var ui_jqgrid_red = {'color':'red'};
var ui_jqgrid_specialrow = {'background':'#F0F4F7'};	//특이색상 로우 바탕색 (Special Row)
var ui_jqgrid_specialfontcolor = {'color':'#0094C8', 'background':'#F0F4F7'};			//밑줄 폰트 색, 그리드의 텍스트를 클릭하면 팝업화면이 뜨는 하이퍼링크 폰트


//Map 데이터타입 구현
Map = function(){
 this.map = {};
};   
Map.prototype = {   
    put : function(key, value){   
        this.map[key] = value;
    },   
    get : function(key){   
        return this.map[key];
    },
    containsKey : function(key){    
     return key in this.map;
    },
    containsValue : function(value){    
     for(var prop in this.map){
      if(this.map[prop] == value) return true;
     }
     return false;
    },
    isEmpty : function(key){    
     return (this.size() == 0);
    },
    clear : function(){   
     for(var prop in this.map){
      delete this.map[prop];
     }
    },
    remove : function(key){    
     delete this.map[key];
    },
    keys : function(){   
        var keys = [];
        for(var prop in this.map){   
            keys.push(prop);
        }   
        return keys;
    },
    values : function(){   
     var values = [];
        for(var prop in this.map){   
         values.push(this.map[prop]);
        }   
        return values;
    },
    size : function(){
      var count = 0;
      for (var prop in this.map) {
        count++;
      }
      return count;
    }
};

//공백제거
function trim(str) {
    str = str.replace(/(^\s*)|(\s*$)/, "");
    return str;
}

function replaceAll(value, a, b){
	return String(value).split(a).join(b);
}

function showModal(message){
	$("#modalMessage").text(message);
	//$("#alertModal").modal('show');
	
	$("#alertModal").modal({
		show : true,
		backdrop : false
	});
}

function connectFail(){

	//showModal("서버와의 접속이 끊어졌습니다.");
	//setInterval(function(){goLogin()}, 1000);
}

function goLogin(){
	if($("#alertModal").css("display") == "none"){
		document.location.href = "../login";
	}
}


//로딩중표시
var loading = $('<div id="loading" class="loading"><img id="loading_img" alt="loading" src="../resources/img/commons/ajax_loader_blue_64.gif" /></div>').appendTo($('.online-pro')).hide();
function showLoading(){
	$('.loading').show();
}
function hideLoading(){
	$('.loading').hide();
}

//로딩중 표시  spin.js 이용
function startSpin(targetID){
	var opts = {
		  lines: 13, // The number of lines to draw
		  length: 10, // The length of each line
		  width: 3, // The line thickness
		  radius: 15, // The radius of the inner circle
		  corners: 1, // Corner roundness (0..1)
		  rotate: 0, // The rotation offset
		  direction: 1, // 1: clockwise, -1: counterclockwise
		  color: '#000', // #rgb or #rrggbb or array of colors
		  speed: 1, // Rounds per second
		  trail: 60, // Afterglow percentage
		  shadow: false, // Whether to render a shadow
		  hwaccel: false, // Whether to use hardware acceleration
		  className: 'spinner', // The CSS class to assign to the spinner
		  zIndex: 2e9, // The z-index (defaults to 2000000000)
		  top: '50%', // Top position relative to parent
		  left: '50%' // Left position relative to parent
	};
	var target = document.getElementById(targetID);
	var spinner = new Spinner(opts).spin(target);
	return spinner;
}
function stopSpin(obj){
	obj.stop();
}

function sortByKey(array, key){
	return array.sort(
		function(a, b){
			var x = a[key];
			var y = b[key];
			return ((x < y) ? -1 : ((x > y) ? 1 : 0));
		}		
	);
}

function numberFormat(num){
	var pattern = /(-?[0-9]+)([0-9]{3})/;
	while(pattern.test(num)){
		num = num.replace(pattern, "$1,$2");
	}
	//console.log(num);
	return num;
}

function unNumberFormat(num){
	return (num.replace(/\,/g,""));
}

function submitFileForm(fileName){
	$('#fileName').val(fileName);
	document.fileForm.action = "/main/fileDownload";
	//alert(fileName);
	document.fileForm.submit();
}

function onlyNumber(evt){
	var code = evt.which?evt.which:event.keyCode;
	
	if(code < 48 || code > 57){
		return false;
	}
}

function setOperationBtn(){
	if(g_operationYn != "Y"){
		$(".btn_operation").hide();
	}
}

(function ($){
	$.each(['show', 'hide'], function(i, ev){
		var el = $.fn[ev];
		$.fn[ev] = function(){
			this.trigger(ev);
			return el.apply(this, arguments);
		};
	});
})(jQuery);
