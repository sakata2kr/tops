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
            <h4 class="modal-title">내 정보 수정</h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">

                <div class="form-no-line">
                    <span>사용자 계정</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="modifyUserId" class="form-control02 w100" readonly="readonly" value="${userInfo.user_id}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>이름</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="modifyUserName" class="form-control02 w88" maxlength="30" style="ime-mode:desativated;" value="${userInfo.user_name}"/>
                    </div>
                </div>

                <div class="form-no-line">
                    <span>기존 비밀번호</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="password" id="confirmPw" class="form-control02 w88" maxlength="20" value="" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>변경 비밀번호</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="password" id="modifyNewPw" class="form-control02 w88" maxlength="20" value="" />
                    </div>
                </div>
                <div class="form-no-line">
                    <span>비밀번호 확인</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="password" id="modifyNewRePw" class="form-control02 w88" maxlength="20" value="" />
                    </div>
                </div>

                  <div class="form-no-line">
                    <span>휴대폰</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="modifyPhoneNo" class="form-control02 w100" maxlength="13" style="ime-mode:disabled;" value="${userInfo.phone_no}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>E-mail</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="modifyEmail" class="form-control02 w100" maxlength="256" style="ime-mode:disabled;" value="${userInfo.email}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>Alert수신여부</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="checkbox" id="alert_receive_yn"  class="form-control02" value="${userInfo.alert_receive_yn}"  <c:if test="${userInfo.alert_receive_yn eq 'Y'}">checked='checked'</c:if>/>
                    </div>
                </div>

            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search w25 btn_operation" onClick="modifyUserInfo();">저장</button>
            <button type="button" class="btn btn-search w25" data-dismiss="modal">닫기</button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->

<script>
    var regExp = null; // 정규식 사용을 위한 임시 변수

    //사용자 정보 수정 화면 팝업
    $(document).ready(function()
    {
        $("body").on("hidden.bs.modal","#formModal",function() { $(this).removeData("bs.modal")}); // modal에 넘겼던 데이터 지움

        // 전화번호 하이픈 처리
        regExp = /(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/;
        var tmpphoneNo = $("#modifyPhoneNo").val().trim();

        if ( regExp.test(tmpphoneNo))
        {
            tmpphoneNo = tmpphoneNo.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
        }

        $("#modifyPhoneNo").val(tmpphoneNo);

        // 전화번호입력 이벤트 처리 (오직 숫자만 입력 가능)
        $("#modifyPhoneNo").on("keydown", function (event)
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
        // 팝업화면 오픈시 비밀번호 입력란을 비워두지 말고 '**********' 로 보여줌
        $("#confirmPw").val("          ");
        $("#modifyNewPw").val("          ");
        $("#modifyNewRePw").val("          ");

        //비밀번호 클릭시
        $("#confirmPw").bind("focus", function()
        {
            if ( $("#confirmPw").val().trim() == "" )
            {
                $("#confirmPw").val("");

            }
        });

        $("#confirmPw").bind("blur", function()
        {
            if ( $("#confirmPw").val() == "" )
            {
                $("#confirmPw").val("          ");
            }
        });

        $("#modifyNewPw").bind("focus", function()
        {
            if ( $("#modifyNewPw").val().trim() == "" )
            {
                $("#modifyNewPw").val("");
            }
        });

        $("#modifyNewPw").bind("blur", function()
        {
            if ( $("#modifyNewPw").val() == "" )
            {
                $("#modifyNewPw").val("          ");
            }
        });

        $("#modifyNewRePw").bind("focus", function()
        {
            if ( $("#modifyNewRePw").val().trim() == "" )
            {
                $("#modifyNewRePw").val("");
            }
        });

        $("#modifyNewRePw").bind("blur", function()
        {
            if ( $("#modifyNewRePw").val() == "" )
            {
                $("#modifyNewRePw").val("          ");
            }
        });
    });


    //checkValidation : 유효성 검사
    function checkValidation()
    {
        var confirmPw = $("#confirmPw").val().trim();
        var newPw     = $("#modifyNewPw").val().trim();
        var newRePw   = $("#modifyNewRePw").val().trim();

        // 비밀번호
        if ( confirmPw != "" )
        {
            if ( newPw == "" )
            {
                alert('변경할 비밀번호를 입력해 주세요.');
                $("#modifyNewPw").focus();
                return false;
            }

            if ( !checkPassWord($('#modifyUserId').val().trim(), newPw) )
            {
                return false;
            }

            if ( newRePw == "" )
            {
                alert('변경할 비밀번호 다시 입력해 주세요.');
                $("#modifyNewRePw").focus();
                return false;
            }

        }

        // 비밀번호
        if ( newPw != "" || newRePw != "" )
        {
            if ( confirmPw == "" )
            {
                alert('비밀번호를 변경하시려면 기존 비밀번호를 입력해 주세요.');
                $("#confirmPw").focus();
                return false;
            }

            if ( newRePw == "" )
            {
                alert('변경할 비밀번호 다시 입력해 주세요.');
                $("#modifyNewRePw").focus();
                return false;
            }

            if ( newPw != newRePw )
            {
                alert('변경할 비밀번호와 재입력 비밀번호가 일치하지 않습니다.');
                $("#modifyNewRePw").val("");
                $("#modifyNewRePw").focus();
                return false;
            }

            if ( confirmPw == newRePw )
            {
                alert('변경할 비밀번호와 기존 비밀번호가 같습니다.');
                return false;
            }
        }

        // 사용자 이름
        var userName = $("#modifyUserName").val().trim();
        $("#modifyUserName").val( userName );

        if( userName == "" )
        {
            alert("사용자 이름을 입력해 주세요.");
            $("#modifyUserName").focus();
            return false;
        }

        regExp = /^[가-힣]{2,4}$|[a-zA-Z]{2,10}\s{1}[a-zA-Z]{2,10}$/;

        if ( !regExp.test(userName) )
        {
            alert("사용자 이름은 한글 2 ~ 4글자(공백 없음)\n또는 영문 Firstname(2 ~ 10글자) + 공백 1자리 + Lastname(2 ~10글자)\n로만 입력이 가능합니다.");
            $("#modifyUserName").focus();
            return false;
        }

        // 전화번호
        var phoneNo = $("#modifyPhoneNo").val().trim();
        regExp = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;

        if ( phoneNo.length > 0 && !regExp.test(phoneNo) )
        {
            alert("올바른 휴대전화번호 형식이 아닙니다.");
            $("#modifyPhoneNo").focus();
            return false;
        }

        // 이메일
        var email = $("#modifyEmail").val().trim();
        regExp = /^[0-9a-zA-Z._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;

        if ( email.length > 0 && !regExp.test(email) )
        {
            alert("올바른 이메일 형식이 아닙니다.");
            $("#modifyEmail").focus();
            return false;
        }
        else
        {
            $("#modifyEmail").val(email);
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

    //사용자 정보 수정
    function modifyUserInfo()
    {
        //유효성 검사 실패 또는 confirm 취소 시 미처리
        if ( !checkValidation() || !confirm("저장하시겠습니까?") )
        {
            return;
        }

        var obj = {};
        obj.user_id = $("#modifyUserId").val();
        obj.user_name = $("#modifyUserName").val();
        obj.phone_no = $("#modifyPhoneNo").val();
        obj.email = $("#modifyEmail").val();

        if( $("input:checkbox[id='alert_receive_yn']").is(":checked") == true )
        {
            obj.alert_receive_yn = "Y";
        }
        else
        {
            obj.alert_receive_yn = "N";
        }

        var confirmPw = $("#confirmPw").val().trim();
        var newPw = $("#modifyNewPw").val().trim();
        var newRePw = $("#modifyNewRePw").val().trim();

        // 비밀번호 변경시
        if(confirmPw != "" && newPw != "" && newPw == newRePw)
        {
            obj.password = $("#confirmPw").val();
            obj.new_password = $("#modifyNewPw").val();
        }

        var json_data = JSON.stringify(obj);

        // 저장
        $.ajax({ url : "<c:url value='/main/modifyMyInfo' />"
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: "application/json"
               , cache: false
               , success : function(data, status)
                 {
                     //console.log(data);
                     if ( data.result == "1" )
                     {
                         $("#modifyUserName").val(data.userInfo.user_name)
                         $('#modifyPhoneNo').val(data.userInfo.phone_no);
                         $('#modifyTelNo').val(data.userInfo.tel_no);
                         $('#modifyEmail').val(data.userInfo.email);

                         $("#confirmPw").val("          ");
                         $("#modifyNewPw").val("          ");
                         $("#modifyNewRePw").val("          ");

                         alert("수정되었습니다.");

                         // Event Alert 처리 여부 변경 시 처리
                         if (obj.alert_receive_yn != g_alert_receive_yn)
                         {
                             g_alert_receive_yn = obj.alert_receive_yn;
                         }

                         // 사용자명 변경 시 NAV BAR 의 표시된 사용자명도 변경
                         $("#nav_user_name").text(data.userInfo.user_name);

                         // 이 모달 창 숨기기
                         $("#formModal").modal("hide");
                     }
                     else if ( data.result == "2" )
                     {
                         alert("기존 비밀번호가 일치하지 않습니다.");

                         $("#confirmPw").val("          ");
                         $("#modifyNewPw").val("          ");
                         $("#modifyNewRePw").val("          ");
                     }
                 }
               , error : function()
                 {
                     alert("저장 중 오류가 발생했습니다.")
                 }
               });
    }

</script>
