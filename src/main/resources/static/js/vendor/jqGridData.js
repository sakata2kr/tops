$(function() {

	var data = [['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10'], ['01', "1,215,403", "1,215,403", "1,215,403", "0.10", '01', '1,215,403', '1,215,403', '1,215,403', '0.10']];

	$("#grid").jqGrid({
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
        // caption : "Stack Overflow Example",
		// ondblClickRow: function(rowid,iRow,iCol,e){alert('double clicked');}
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
		$("#grid").jqGrid('addRowData', i + 1, mydata[i]);
	}

	/*
	 $("#grid").jqGrid('setGridParam', {onSelectRow: function(rowid,iRow,iCol,e){alert('row clicked');}});
	 */
	$("#grid").jqGrid('setGridParam', {
		ondblClickRow : function(rowid, iRow, iCol, e) {
			alert('double clicked');
		}
	});
});
