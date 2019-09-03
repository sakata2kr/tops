<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<style type="text/css">
    input[type="checkbox"]
    { margin: 0;
      padding: initial;
      background-color: initial;
      border: initial;
    }
</style>

<div class="modal-dialog dialog-style01">
    <div class="modal-content">
        <div class="modal-header">
            <a data-dismiss="modal" href="#none" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
            <h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">사용자 정보 수정</c:when><c:otherwise>신규 사용자 등록</c:otherwise></c:choose></h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">

                <div class="form-no-line">
                    <span>사용자 계정</span>
                    <div class="showcase-select col-lg-2 w76">
                    <c:choose>
                        <c:when test="${'modify' ne mode}">
                            <input type="text" id="userId" class="form-control02" maxlength="15" style="ime-mode:disabled;" value="${userInfo.user_id}" <c:if test="${'modify' eq mode}">readonly="readonly"</c:if>/>
                            <button type="button" class="btn btn-search btn_operation" onclick="doCheckId()" style="margin-left:7px; width:70px;">ID중복확인</button>
                            <input type="hidden" id="isIdCheck" name="isIdCheck" />
                        </c:when>
                        <c:otherwise>
                            <label for="form5" style="margin-top:5px">${userInfo.user_id}</label>
                            <input type="hidden" id="userId" name="userId" value="${userInfo.user_id}"/>
                        </c:otherwise>
                    </c:choose>
                    </div>
                </div>

                <div class="form-no-line">
                    <span>사용자 이름</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="userName" class="form-control02 w88" maxlength="30" style="ime-mode:desativated;" value="${userInfo.user_name}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>비밀번호</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="password" id="newPw" class="form-control02 w88" maxlength="20" value="" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>비밀번호 확인</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="password" id="newRePw" class="form-control02 w88" maxlength="20" value="" />
                    </div>
                </div>
                <div class="form-no-line">
                    <span>휴대폰</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="phoneNo" class="form-control02 w100" maxlength="13" style="ime-mode:disabled;" value="${userInfo.phone_no}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>E-mail</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="email" class="form-control02 w100" maxlength="256" style="ime-mode:disabled;" value="${userInfo.email}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>권한 그룹</span>
                    <div class="showcase-select col-lg-2 w76 modal-select">
                        <select id="userGroupId" class="selectCust w88">
                            <c:if test="${not empty userInfoRegisterFormAuthGroupInfoList}">
                                <c:forEach var="authGroupInfo" items="${userInfoRegisterFormAuthGroupInfoList}" varStatus="i">
                                    <option value='${authGroupInfo.auth_group_id}'>${authGroupInfo.auth_group_name}</option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>
                </div>

                <div class="form-no-line">
                    <span>Alert수신여부</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="checkbox" id="alert_receive_yn" class="form-control02" value="${userInfo.alert_receive_yn}"  <c:if test="${userInfo.alert_receive_yn eq 'Y'}">checked='checked'</c:if>/>
                    </div>
                </div>

            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search w25 btn_operation" onclick="saveUserInfo();">저장</button>
            <c:if test="${'modify' eq mode}">
                <button type="button" class="btn btn-search w25 btn_operation" onclick="removeUserInfo();">삭제</button>
            </c:if>
            <button type="button" class="btn btn-search w25" data-dismiss="modal">닫기</button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->

<script>
    var regExp = null; // 정규식 사용을 위한 임시 변수

    $(document).ready(function()
    {
        //operation버튼 제어
        setOperationBtn();

        // 사용자ID 중복확인 변수
        $("#isIdCheck").val("");

        $("body").on("hidden.bs.modal","#formModal",function() { $(this).removeData("bs.modal")}); // modal에 넘겼던 데이터 지움

        // 전화번호 하이픈 처리
        regExp = /(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/;
        var tmpphoneNo = $("#phoneNo").val().trim();

        if ( regExp.test(tmpphoneNo))
        {
        	tmpphoneNo = tmpphoneNo.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
        }

        $("#phoneNo").val(tmpphoneNo);

        // 전화번호입력 이벤트 처리 (오직 숫자만 입력 가능)
        $("#phoneNo").on("keydown", function (event)
        {
            var key = event.charCode || event.keyCode || 0;

            // 8 : BackSpace, 46 : Del, 48 : 0, 57 : 9, 96 : 0 (NumPad), 105 : 9 (NumPad)
            if ( key === 8 || key === 46 )
            {
                $(this).val("");
            }
            else if ( (key >= 48 && key <= 57) || (key >= 96 && key <= 105) )
            {
                if ($(this).val().length === 3)
                {
                    $(this).val($(this).val() + "-");
                }
                else if ($(this).val().length === 7)
                {
                    $(this).val($(this).val() + "-");
                }
                else if ($(this).val().length === 12)
                {
                    var tmpPhoneNo = $(this).val().replace(/-/gi, "");
                    $(this).val(tmpPhoneNo.substring(0, 3) + "-" + tmpPhoneNo.substring(3, 7) + "-" +  tmpPhoneNo.substring(7));
                }
            }
            else
            {
                event.preventDefault();
                $(this).val($(this).val().replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, ""));
            }
        });

        if( "${mode}" === "modify" )
        {
            // 권한그룹 select
            $("#userGroupId").val("${userInfo.user_group_id}");

            // 수정모드시 팝업화면 오픈시 비밀번호 입력란을 비워두지 말고 ********** 로 보여줌
            $("#newPw").val("          ");
            $("#newRePw").val("          ");

            $("#newPw").bind("focus", function()
            {
                if( $("#newPw").val().trim() == "" )
                {
                    $("#newPw").val("");
                }
            });

            $("#newPw").bind("blur", function()
            {
                if( $("#newPw").val() == "" )
                {
                    $("#newPw").val("          ");
                }
            });

            $("#newRePw").bind("focus", function()
            {
                if( $("#newRePw").val().trim() == "" )
                {
                    $("#newRePw").val("");
                }
            });

            $("#newRePw").bind("blur", function()
            {
                if( $("#newRePw").val() == "" )
                {
                    $("#newRePw").val("          ");
                }
            });
        }

        // 로그인 사용자 의 도메인으로 고정됨(관리자는 도메인 선택 가능)
        if ( "${sessUserInfo.user_group_id}" != "ADMIN" )
        {
            $("#userGroupId").attr("disabled", true);

            if( "${mode}" != "modify" )
            {
                $("#userGroupId").val("${sessUserInfo.user_group_id}");
            }
        }
        else
        {
            $("#userGroupId").attr("disabled", false);
        }
    });

    //회원ID 검증 및 중복확인 처리
    function doCheckId()
    {
        $("#isIdCheck").val("");

        var userId = $("#userId").val().trim();

        $("#userId").val( userId );

        if( $("#userId").val() == "" )
        {
            alert("ID를 입력해 주세요.");
            $("#userId").focus();
            return;
        }

        if( $("#userId").val().length < 5 || $("#userId").val().length > 12 )
        {
            alert("ID의 자리수는 5 ~ 12자까지입니다. ");
            $("#userId").select();
            $("#userId").focus();
            return;
        }

        regExp = /^[a-z|A-Z]/g;
        if ( !regExp.test(userId) )
        {
            alert("ID 첫글자는 반드시 영문자이어야 합니다.");
            $("#userId").select();
            $("#userId").focus();
            return;
        }

        if(userId.indexOf(" ") > -1)
        {
            alert("공백은 사용할 수 없습니다.");
            $("#userId").select();
            $("#userId").focus();
            return;
        }

        var obj = {};
        obj.user_id = $("#userId").val();
        var json_data = JSON.stringify(obj);

        // 중복 정보 존재 여부 조회
        $.ajax({ url : "<c:url value='/auth/checkUserId' />"
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: "application/json"
               , cache: false
               , success : function(data)
                 {
                     //fnUnBlockUI();
                     if (data.result == false)    // 중복되는 ID가 존재
                     {
                         $("#isIdCheck").val("");
                         $("#userId").select();
                         $("#userId").focus();
                         alert("사용중인 ID입니다. 다른 ID를 입력해주세요.");
                     }
                     else
                     {
                         $("#isIdCheck").val("1");
                         $("#userName").focus();
                         alert("사용가능한 ID입니다.");
                     }
                 }
               , error : function()
                 {
                     alert("ID 조회 중 오류가 발생했습니다.");
                 }
               });
    }

    //checkValidation : 유효성 검사
    function checkValidation()
    {
        if( "${mode}" != "modify" )
        {
        	// 사용자 ID 확인
            if( $("#userId").val().trim() == "" )
            {
                alert("사용자 ID를 입력해 주세요.");
                $("#userId").focus();
                return false;
            }

            if( $("#isIdCheck").val() != "1" )
            {
                alert("ID 중복확인를 수행해야 합니다.");
                if( $("#userId").val() == "" ) $("#userId").focus();
                return false;
            }
        }

        // 비밀번호 확인
        var newPw = $("#newPw").val().trim();
        var newRePw = $("#newRePw").val().trim();

        if ( "${mode}" != "modify" || ( newPw != "" && newRePw != "" ) )
        {
            if ( newPw == "" )
            {
                alert("비밀번호를 입력해 주세요.");
                $("#newPw").focus();
                return false;
            }

            if ( !checkPassWord($("#userId").val().trim(), newPw) )
            {
                return false;
            }

            if ( newRePw == "" )
            {
                alert("비밀번호 다시 입력해 주세요.");
                $("#newRePw").focus();
                return false;
            }

            if ( newPw != newRePw )
            {
                alert("비밀번호가 일치하지 않습니다.");
                $("#newRePw").val("");
                $("#newRePw").focus();
                return false;
            }
        }

        // 사용자 이름
        var userName = $("#userName").val().trim();
        $("#userName").val( userName );

        if( userName == "" )
        {
            alert("사용자 이름을 입력해 주세요.");
            $("#userName").focus();
            return false;
        }

        regExp = /^[가-힣]{2,4}$|[a-zA-Z]{2,10}\s{1}[a-zA-Z]{2,10}$/;
        if ( !regExp.test(userName) )
        {
            alert("사용자 이름은 한글 2 ~ 4글자(공백 없음)\n또는 영문 Firstname(2 ~ 10글자) + 공백 1자리 + Lastname(2 ~10글자)\n로만 입력이 가능합니다.");
            $("#userName").focus();
            return false;
        }

        // 전화번호
        var phoneNo = $("#phoneNo").val().trim();
        regExp = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
        if ( phoneNo.length > 0 && !regExp.test(phoneNo) )
        {
            alert("올바른 휴대전화번호 형식이 아닙니다.");
            $("#phoneNo").focus();
            return false;
        }
        // 이메일
        var email = $("#email").val().trim();
        regExp = /^[0-9a-zA-Z._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

        if ( email.length > 0 && !regExp.test(email) )
        {
            alert("올바른 이메일 형식이 아닙니다.");
            $("#email").focus();
            return false;
        }
        else
        {
            $("#email").val(email);
        }

        return true;
    }

    //비밀번호 유효성 체크
    var passwdCheck = { iSameContinuedMax : 4  // 동일문자 수 체크
                      , iContinuedMax     : 4  // 연속된 문자 수 체크
                      , setSameContinuedMax: function (iMax)
                        {
                            this.iSameContinuedMax = iMax;
                        }
                      , setContinuedMax: function (iMax)
                        {
                            this.iContinuedMax = iMax;
                        }
                      , isContinuedValue: function (sValue)
                        {
                            var iStrCount, sCurrentCode, sNextCode, aContinued1, aContinued2;
                            var aData = [];
                            for ( var i = 0; i < sValue.length; i++ )
                            {
                                aData[i] = sValue.substr(i, this.iContinuedMax);
                            }

                            var bIsContinued = false;
                            var iCount = aData.length;
                            var bIsResult = false;

                            for ( var i = 0; i < iCount; i++ )
                            {
                                iStrCount = aData[i].length;
                                if ( iStrCount !== this.iContinuedMax )
                                {
                                    continue;
                                }

                                aContinued1 = [];
                                aContinued2 = [];

                                for ( var j = 0; j < iStrCount; j++ )
                                {
                                    bIsContinued = false;
                                    sCurrentCode = aData[i].charCodeAt(j);
                                    sNextCode = aData[i].charCodeAt(j + 1);

                                    if ( aData[i].charAt(j + 1) != "" )
                                    {
                                        if ( sCurrentCode - sNextCode == 1 )
                                        {
                                            aContinued1.push(true);
                                        }

                                        if ( aContinued1.length == (this.iContinuedMax - 1) )
                                        {
                                            bIsResult = true;
                                            break;
                                        }

                                        if ( sCurrentCode - sNextCode == -1 )
                                        {
                                            aContinued2.push(true);
                                        }

                                        if ( aContinued2.length == (this.iContinuedMax - 1) )
                                        {
                                            bIsResult = true;
                                            break;
                                        }
                                    }
                                }

                                if (bIsResult === true)
                                {
                                    break;
                                }
                            }

                            return bIsResult;
                        }
                      , isSameContinuedValue: function (sValue)
                        {
                            var iStrCount, sFirstCode, sCurrentCodem, aContinued;
                            var aData = [];

                           for ( var i = 0; i < sValue.length; i++ )
                           {
                               aData[i] = sValue.substr(i, this.iSameContinuedMax);
                           }

                           var bIsContinued = false;
                           var iCount = aData.length;
                           var bIsResult = false;

                           for ( var i = 0; i < iCount; i++ )
                           {
                               bIsContinued = false;
                               iStrCount = aData[i].length;

                               if ( iStrCount !== this.iSameContinuedMax )
                               {
                                   continue;
                               }

                               aContinued = [];

                               for ( var j = 0; j < iStrCount; j++ )
                               {
                                   if (j == 0)
                                   {
                                       continue;
                                   }

                                   sFirstCode = aData[i].charCodeAt(0);
                                   sCurrentCode = aData[i].charCodeAt(j);

                                   if (sFirstCode == sCurrentCode)
                                   {
                                       aContinued.push(true);
                                   }

                                   if ( aContinued.length == (this.iSameContinuedMax - 1) )
                                   {
                                       bIsResult = true;
                                       break;
                                   }
                               }

                               if ( bIsResult === true )
                               {
                                   break;
                               }
                           }

                           return bIsResult;
                        }
                      };

    //비밀번호 유효성 체크
    function checkPassWord(userId, userPw)
    {
        if ( userPw.length < 9 || userPw.length > 16 )
        {
            alert("비밀번호는 9 ~ 16 자리로 입력해주세요.");
            return false;
        }

        regExp = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{9,16}$/;
        if ( !regExp.test(userPw) )
        {
            alert("비밀번호는 문자, 숫자, 특수문자의 조합으로 입력해주세요.");
            return false;
        }

        if ( passwdCheck.isContinuedValue(userPw) )
        {
            alert("연속되는 문자(abcd) 또는 숫자(1234)는 사용할 수 없습니다.");
            return false;
        }

        if ( passwdCheck.isSameContinuedValue(userPw) )
        {
            alert("동일문자(aaaa) 또는 숫자(1111)는 사용할 수 없습니다.");
            return false;
        }

        if( userId.indexOf(userPw) > -1 )
        {
            alert("비밀번호에 아이디를 사용할 수 없습니다.");
            return false;
        }

        return true;
    }

    //사용자 정보 등록 및 수정
    function saveUserInfo()
    {
        //유효성 검사 실패 또는 confirm 취소 시 미처리
        if ( !checkValidation() || !confirm("저장하시겠습니까?") )
        {
            return;
        }

        var obj = {};
        obj.user_id = $("#userId").val();
        obj.user_name = $("#userName").val();

        obj.phone_no = $("#phoneNo").val();
        obj.email = $("#email").val();
        obj.user_group_id =  $("#userGroupId").val();

        if( $("input:checkbox[id='alert_receive_yn']").is(":checked") == true )
        {
            obj.alert_receive_yn = "Y";
        }
        else
        {
            obj.alert_receive_yn = "N";
        }

        var newPw = $("#newPw").val().trim();
        var newRePw = $("#newRePw").val().trim();

        // 비밀번호 변경시
        if( newPw != "" && newPw == newRePw )
        {
            obj.password = $("#newPw").val();
        }

        var json_data = JSON.stringify(obj);

        var url = "";

        if( "${mode}" === "modify" )
        {
            url = "<c:url value='/auth/modifyUserInfo' />";
        }
        else
        {
            url = "<c:url value='/auth/registerUserInfo' />";
        }

        // 저장
        $.ajax({ url : url
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: "application/json"
               , cache: false
               , success : function(data, status)
                 {
                     //console.log(data);
                     if(data.result == true)
                     {
                         alert("저장되었습니다.");

                         // 부모창 목록화면 reload
                         parent.postMessage("userInfoListReload", location.protocol + "//" + location.host);

                         // 이 모달 창 숨기기
                         $("#formModal").modal("hide");
                     }
                 }
               , error : function()
                 {
                     alert("저장 중 오류가 발생했습니다.")
                 }
               });
    }

    //삭제
    function removeUserInfo()
    {
        if ( !confirm("삭제하시겠습니까?") )
        {
            return;
        }

        var obj = {};
        obj.user_id = "${userInfo.user_id}";
        var json_data = JSON.stringify(obj);

        // 삭제
        $.ajax({ url : "<c:url value='/auth/removeUserInfo' />"
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: "application/json"
               , cache: false
               , success : function(data, status)
                 {
                     if(data.result == true)
                     {
                         alert("삭제되었습니다.");

                         // 부모창 목록화면 reload
                         parent.postMessage("userInfoListReload", location.protocol + "//" + location.host);

                         // 이 모달 창 숨기기
                         $("#formModal").modal("hide");

                     }
                     else
                     {
                         alert("삭제 중 오류가 발생하였습니다.");
                     }
                 }
               , error : function()
                 {
                     alert("삭제 중 오류가 발생했습니다.")
                 }
               });
    }
</script>