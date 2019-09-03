<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.tops.model.*" %>

<script>

    //모달창으로부터 데이터를 받기위한 부분
    window.onmessage = function (e) {
        if (e.data == "selectBinaryInfoList") {
            selectBinaryInfoList();
        }
    };

    //그룹정보 등록창
    function popupBinaryInfoRegisterForm() {

        $('body').on('hidden.bs.modal', '#binaryInfoRegisterFormModal', function () {
            $(this).removeData('bs.modal')
        }); // modal에 넘겼던 데이터 지움

        $("#binaryInfoRegisterFormModal").modal({
            backdrop: 'static',
            remote: '/flow/binaryInfoRegisterForm'
        });
    }

    //그룹정보 수정창
    function popupBinaryInfoModifyForm(binaryId) {

        $('body').on('hidden.bs.modal', '#binaryInfoRegisterFormModal', function () {
            $(this).removeData('bs.modal')
        }); // modal에 넘겼던 데이터 지움

        $("#binaryInfoRegisterFormModal").modal({
            backdrop: 'static',
            remote: '/flow/binaryInfoModifyForm?binaryId=' + binaryId
        });
    }

    function makeBinaryInfoGrid(gridList) {

        var binaryInfoGrid = $("#binaryInfoGrid");

        binaryInfoGrid.jqGrid({
            datatype: "local",
            autowidth: true,
            shrinkToFit: true,
            height: 120,
            rowNum: 100000000,
            colNames: ['ID',
                'Name',
                'Description'
            ],
            colModel: [
                {
                    name: 'binary_id',
                    width: 61,
                    sorttype: "int",
                    align: 'center',
                    classes: 'ui_jqgrid_specialfontcolor',
                    formatter: linkText
                },
                {name: 'binary_name', width: 61, sorttype: "int", align: 'left'},
                {name: 'description', width: 61, sorttype: "int", align: 'left'}
            ]
            //loadComplete : summaryFnc,
        });


        binaryInfoGrid.clearGridData();

        if (gridList.length > 0) {
            for (var i = 0; i < gridList.length; i++) {
                //console.log(gridList[i]);
                binaryInfoGrid.jqGrid('addRowData', 'BI_' + (i + 1), gridList[i]);
            }
        } else {
            binaryInfoGrid.jqGrid('addRowData', 'BI_0', {binary_id: "No Data"});

            var tdTag   = $('#BI_0 td');
            var tdTagEq = $('#BI_0 td:eq(' + i + ')');

            for (var i = 0; i < tdTag.length; i++) {
                if (i == 0) {
                    tdTagEq.attr('colspan', tdTag.length);
                } else {
                    tdTagEq.hide();
                }
            }
        }

    }

    function linkText(cellValue, options, rowdata, action) {

        return "<a onclick=\"popupBinaryInfoModifyForm('" + rowdata.binary_id + "');\" style='color:#0094C8;' >" + cellValue + "</a>";
    }


    function selectBinaryInfoList() {

        var obj = {};
        var spinObj = startSpin('bi_');

        $.ajax({
            type: "GET",
            url: "<c:url value='/flow/selectBinaryInfoList' />",
		data:obj,
		dataType:'json',
		contentType: 'application/json',
		cache: false,	
		success: function(data){
			//console.log(data);
			makeBinaryInfoGrid(data.grid);
			stopSpin(spinObj);
		},
		error: function(){
			stopSpin(spinObj);
			showModal("통신중 오류가 발생했습니다.");
		}
	});
}

$(document).ready(function(){
	
	//makeBinaryInfoGrid(new Array());
	selectBinaryInfoList();
	
	setOperationBtn();
});

</script>

<div class="modal-dialog dialog-style02" >
	<div class="modal-content">
		<div class="modal-header">
			 <a data-dismiss="modal" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
			<h4 class="modal-title">Binary 관리</h4>
		</div>
		<div class="modal-body">
			<div class="modal-cust-con02" style="height:160px;">

				<div class="form-no-line">
					<table id="binaryInfoGrid" class='gridH7'></table>
				</div>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-search w12 btn_operation" onclick="popupBinaryInfoRegisterForm();">
				등록
			</button>
			<!-- <button type="button" class="btn btn-search w12" onclick="selectBinaryInfoList();">
				조회
			</button> -->
			<button type="button" class="btn btn-search w12" data-dismiss="modal">
				닫기
			</button>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->