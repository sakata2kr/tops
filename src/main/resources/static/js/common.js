$(function() {
});


var showCase = {
	
	init : function(){
	},
	
	proc : function(obj, type){
		var _id;
		switch(type){
			case 'open' :
				_id = $(obj).parents().eq(5)[0].id;
				this.open(_id);
			break;
			case 'closed' :
				_id = $(obj).parents().eq(5)[0].id;
				this.closed(_id);				
			break;
			case 'del' :
				_id = $(obj).parents().eq(5)[0].id;
				this.del(_id);				
			break;
			case 'layerOpen' :
				_id = $(obj).parents().eq(5)[0].id;
				this.layerOpen(_id);				
			break;
			case 'favorites' :
				_id = $(obj).parents().eq(5)[0].id;
				this.favorites(obj);				
			break;
		}
	},
	
	open : function(_id){
		$('#'+_id).css('overflow','hidden');
		$('#'+_id).animate({
			height:"350px"
		},1000);	
	},
	
	closed : function(_id){
		$('#'+_id).css('overflow','hidden');
		$('#'+_id).animate({
			height:"29px"
		},1000);	
	},
	
	del : function(_id){
		$('#'+_id).css('overflow','hidden');
		$('#'+_id).hide();
	},
	
	fixed : function(_obj){
	},
	
	layerOpen : function(_id, top, left){
		var _top = 13, _left = 1;
		
		if(top == undefined){
			_top = 15;
			_left = 25;
		}else{
			_top*=top;
			_left+=left;
		}
				
		var parentId = $('#'+_id).parent()[0].id;
		$('#'+parentId).css({
			'box-shadow' : 'none',
			'border' : 'none',
			'background' : 'none'	
		});
		
		$('.container').css('position', 'relative');
		$('#'+_id).css({
			'position' : 'absolute',
			'top' : _top+'%',
			'left' : _left+'%',
			'z-index' : '999',
			'width' : '56%',
			'background' : '#FFF'
		});
	},
	
	layerClosed : function(_id){
		$('#'+_id).css({
			'position' : 'static',
			'top' : '0',
			'left' : '0',
			'z-index' : '0',
			'width' : '100%',
			'background' : '#FFF'
		});
	},
	
	favorites: function(obj){
		
		var imgSrc = $(obj).children()[0].src;
		var splitImg = imgSrc.split('_');
		var jsObj = $(obj).parent().parent().parent().parent().parent();
		
		if(splitImg.length == 2){
			$(obj).children()[0].src = splitImg[0]+'_icon03_on.png'; 
			jsObj.addClass('favorite');
		}else{
			$(obj).children()[0].src = splitImg[0]+'_icon03.png';
			jsObj.removeClass('favorite');
		}
		
		//console.log(jsObj);
	}
	
};

// showcase 전체 열기
function openAllShowcase(){
	var showcaseLen = $('.showcase-area01').length;
	for(var i = 0; i < showcaseLen; i++){
		var allId = $('.showcase-area01')[i].id;
		showCase.layerOpen(allId, i, i);
	}
}

function closeAllShowcase(){
	var showcaseLen = $('.showcase-area01').length;
	for(var i = 0; i < showcaseLen; i++){
		var allId = $('.showcase-area01')[i].id;
		showCase.layerClosed(allId);
	}
}

// 트리
function treeAni(){
	$("#treeDiv").treeview({
		collapsed : true,
		animated : "fast",
		control : "#sidetreecontrol",
		prerendered : true,
		persist : "location"
	});
}


// 폴더 트리 
function floderTree(){
	$("#folderTree").fancytree({
		autoActivate : false,
		autoCollapse : true,
		autoScroll : true,
		clickFolderMode : 3, 
		minExpandLevel : 2,
		tabindex : -1, 
		focus : function(event, data) {
			var node = data.node;
			if (node.data.href) {
				node.scheduleAction("activate", 1000);
			}
		},
		blur : function(event, data) {
			data.node.scheduleAction("cancel");
		},
		activate : function(event, data) {
			var node = data.node, orgEvent = data.originalEvent;
			if (node.data.href) {
				window.open(node.data.href, (orgEvent.ctrlKey || orgEvent.metaKey) ? "_blank" : node.data.target);
			}
		},
		click : function(event, data) {
			var node = data.node, orgEvent = data.originalEvent;
			if (node.isActive() && node.data.href) {
				window.open(node.data.href, (orgEvent.ctrlKey || orgEvent.metaKey) ? "_blank" : node.data.target);
			}
		}
	});
}


function mSelect(className){
	$('.'+className).change(function() {
	}).multipleSelect({
		width : '100%',
		placeholder: "전체"
	});
}


function scrollCust(){
	//$(".sc-cust, .ui-jqgrid-bdiv").mCustomScrollbar({
	$(".sc-cust").mCustomScrollbar({
		theme : "dark-3"
	});
}

function selectCust(){
	$(".selectCust").selecter();
} 

function flotChart(){
	var sin = [], cos = [];
	for (var i = 0; i < 14; i += 1.5) {
		sin.push([i, 10 * i]);
		cos.push([i, 20 * i]);
	}

	var plot = $.plot("#cdr_chart", [{
		data : sin,
		label : "2014-07-18",
		color:"rgba(245, 161, 37, 1)"
	}, {
		data : cos,
		label : "2014-07-25",
		color:"rgba(6, 162, 203, 1)"
	}], {
		series : {
			lines : {
				show : true
                // color:"rgba(6, 162, 203, 1)"
			},
			bars : {
				lineWidth : 0
            },
			points : {
				show : true,
				fill: true,
				fillColor:"rgba(255, 255, 255, 1)"
			}
        },
		grid : {
			hoverable : true,
			clickable : true
        },
		xaxis : {
			font : {
				size:10,
				color:"#333333",
				family:"Moebius"
			}
		},
		yaxis : {
			font : {
				size:10,
				color:"#333333",
				family:"Moebius"
			}
		}
	});

	$("<div id='tooltip'></div>").css({
		position : "absolute",
		display : "none",
		border : "1px solid #fdd",
		padding : "2px",
		"background-color" : "#fee",
		opacity : 0.80
	}).appendTo("body");

	$("#cdr_chart").bind("plothover", function(event, pos, item) {

		if ($("#enablePosition:checked").length > 0) {
			var str = "(" + pos.x.toFixed(2) + ", " + pos.y.toFixed(2) + ")";
			$("#hoverdata").text(str);
		}

		if ($("#enableTooltip:checked").length > 0) {
			if (item) {
				var x = item.datapoint[0].toFixed(2), y = item.datapoint[1].toFixed(2);

				$("#tooltip").html(item.series.label + " of " + x + " = " + y).css({
					top : item.pageY + 5,
					left : item.pageX + 5
				}).fadeIn(200);
			} else {
				$("#tooltip").hide();
			}
		}
	});

	$("#cdr_chart").bind("plotclick", function(event, pos, item) {
		if (item) {
			$("#clickdata").text(" - click point " + item.dataIndex + " in " + item.series.label);
			plot.highlight(item.series, item.datapoint);
		}
	});
}

function serverStateViewChart(){
	var data = [
					{data:[["IMPDAP1", 3235]], color:"#28be6f"}, 
					{data:[["IMPDAP2", 3235]], color:"#348fe2"}, 
					{data:[["IMPDAP3", 4105]], color:"#ff9000"}, 
					{data:[["IMPDAP4", 2503]], color:"#e10505"}
				];

	var p = $.plot("#server_state_chart", data, {
		series : {
			bars : {
				show : true,
				barWidth : 0.1,
				align : "center",
				lineWidth : 0,
				fill:1
			},
			lines : {
				show : false
            },
			points : {
				show : false
			}
		},
		xaxis : {
			mode : "categories",
			tickLength : 0,
			font : {
				size:10,
				color:"#333333",
				family:"Moebius"
			},
			autoscaleMargin:0.1
		},
		yaxis : {
			font : {
				size:10,
				color:"#333333",
				family:"Moebius"
			}
		}
	});
}


function jqGridCall(){
	var data = [
			['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['02', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['03', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['04', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['05', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['06', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['07', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['08', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['09', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['10', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['11', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['12', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['13', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['14', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['15', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['16', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], 
			['17', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10']
		];
	$(".grid").jqGrid({
		autowidth : true,
		shrinkToFit : true,
		datatype : "local",
		height : 250,
		colNames : ['시간', '2014-07-18', '2014-07-24', '2014-07-25', '전주대비 증감분(%)', '시간', '2014-07-18', '2014-07-24', '2014-07-25', '전주대비 증감분(%)'],
		colModel : [{
			name : 'id',
			index : 'id',
			width : 61,
			sorttype : "int"
		}, {
			name : 'thingy',
			index : 'thingy',
			width : 93,
			sorttype : "date"
		}, {
			name : 'blank',
			index : 'blank',
			width : 93
		}, {
			name : 'number',
			index : 'number',
			width : 94,
			sorttype : "float"
		}, {
			name : 'status',
			index : 'status',
			width : 138,
			sorttype : "float"
		}, {
			name : 'status',
			index : 'status',
			width : 61,
			sorttype : "float"
		}, {
			name : 'status',
			index : 'status',
			width : 93,
			sorttype : "float"
		}, {
			name : 'status',
			index : 'status',
			width : 93,
			sorttype : "float"
		}, {
			name : 'status',
			index : 'status',
			width : 94,
			sorttype : "float"
		}, {
			name : 'status',
			index : 'status',
			width : 138,
			sorttype : "float"
		}]
    });

	var names = ["id", "thingy", "blank", "number", "status"];
	var mydata = [];

	for (var i = 0; i < data.length; i++) {
		mydata[i] = {};
		for (var j = 0; j < data[i].length; j++) {
			mydata[i][names[j]] = data[i][j];
		}
	}

	for (var i = 0; i <= mydata.length; i++) {
		$(".grid").jqGrid('addRowData', i + 1, mydata[i]);
	}

	$(".grid").jqGrid('setGridParam', {
		ondblClickRow : function(rowid, iRow, iCol, e) {
			alert('double clicked');
		}
	});
}


function dateP(className){
		$('.'+className).datepicker({
		dateFormat : 'yy-mm-dd',
		monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNamesMin : ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
		weekHeader : 'Wk',
		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		yearRange : '1988:+0', // 연도 셀렉트 박스 범위(현재와 같으면 1988~현재년)
		showMonthAfterYear : true, //년 뒤에 월 표시
		buttonImageOnly : true, //이미지표시
		buttonText : '날짜를 선택하세요',
		autoSize : false, //오토리사이즈(body등 상위태그의 설정에 따른다)
		buttonImage : '../resources/img/icon/calendar_icon.png', //이미지주소
		showOn : "both" //엘리먼트와 이미지 동시 사용
	});
}

//Simple Modal
var SimpleModal = {
	
	alert : function(msg, Function){
		$('.Alertmsg').text(msg);
		$('#modal_content').modal({minHeight:140});
	},
	
	alert2 : function(message, Function){
		alert2(message, Function);
	},
	
	confirm : function(message, Function){
		confirm(message, Function);
	},
	
	close : function(){
		$.modal.close();
	}
};















