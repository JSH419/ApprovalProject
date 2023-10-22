<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>write page</title>
<script  src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script>
		var sessionChk = '${memInfo}';
		
		if(sessionChk == null || sessionChk == ''){
			alert("로그인 후 이용하세요");
			location.href = 'login';
		}

		$(function(){
			
			var mode = '${mode}';
			
			var addSeq = '${listSeq}';
			var addWriter = '${memInfo.memName}';
			var addWriterId = '${memInfo.memId}';
			var memRank = '${memInfo.memRank}';
			
			var mofySeq = '${detailMap.seq}';
			var mofyWriter = '${detailMap.writeName}';
			var mofyWriterId = '${detailMap.writeId}'
			var mofyStatus = '${detailMap.apprStatus}';
			
			//결제대기
			if(mofyStatus == 'wat'){
				
				$("#signWait").prop("checked",true);
				
				//결재 올린 사람과 결재자가 다른 경우
				if(addWriterId != mofyWriterId){
					$("#tmpBtn").hide();
				}else{
					$("#tmpBtn, #retBtn, #appBtn").hide();
				}
			
			//결재중
			}else if(mofyStatus == 'ing'){
				$("#signWait").prop("checked",true);
				$("#signIng").prop("checked",true);
				
				if (memRank == 'KING') {
			        $("#tmpBtn").hide();
			    } else {
			        $("#tmpBtn, #retBtn, #appBtn").hide();
			    }
				
			//결재완료
			}else if( mofyStatus == 'end'){
				$("input[name=sign]").prop("checked",true);
				$("#tmpBtn, #retBtn, #appBtn").hide();
			//임시저장	
			}else if( mofyStatus == 'tmp'){
				if(addWriterId == mofyWriterId){
					$("#retBtn").hide();
				}
			//반려
			}else if( mofyStatus == 'ret'){
				if(addWriterId == mofyWriterId){
					$("#retBtn").hide();
				}else{
					$("#tmpBtn, #retBtn, #appBtn").hide();	
				}
			}
			
			if(mode == 'add'){
				$("#seq").val(addSeq); 
				$("#writer").val(addWriter);
				$("#writerId").val(addWriterId);
				$("#retBtn").hide();
				$("#subj").removeAttr("readonly");
				$("#content").removeAttr("readonly");
			}else {
				$("#seq").val(mofySeq);
				$("#writer").val(mofyWriter);
				$("#writerId").val(mofyWriterId);

			}
			
			if((addWriterId == mofyWriterId) &&  ( mofyStatus == 'tmp' || mofyStatus == 'ret')){
				$("#subj").removeAttr("readonly");
				$("#content").removeAttr("readonly");
			}
			
		})
		
		function fncSave(stat){
			
			var ivChk = initVal();
			if(ivChk){
				$("#status").val(stat);
				var grade = '${memInfo.memRank}';
				if(stat == 'app'){	//결재인 경우
					if(grade == 'CLERK'){
						$("#status").val('wat');
					}else if(grade == 'MANAGER'){
						$("#status").val('wat');
					}else if(grade == 'BOSS'){
						$("#status").val('ing');
					}else if(grade == 'KING'){
						$("#status").val('end');
					}
				}
				
				$("#writeFrm").attr("action","writeProc").attr("method","post").submit();	
			}
		}
		
		function initVal(){
			var temp = true;
			if($("#subj").val() == ''){
				alert("제목을 입력하세요");
				temp = false;
			}else if($("#content").val() == ''){
				alert("내용을 입력하세요");
				temp = false;
			}
			return temp;
		}
		
</script>
</head>
<body>
	<div>
		<table border = "1">
			<tr>
				<th>결재요청</th>
				<th>과장</th>
				<th>부장</th>
			</tr>
			<tr>
				<td><input type = "checkbox" name = "sign" id = "signWait" disabled="disabled"></td>
				<td><input type = "checkbox" name = "sign" id = "signIng" disabled="disabled"></td>
				<td><input type = "checkbox" name = "sign" id = "signEnd" disabled="disabled"></td>
			</tr>
		</table>
	</div>
	<form name = "writeFrm" id = "writeFrm">
		<input type = "hidden" name = "status" id = "status">
		<input type = "hidden" name = "logId" id = "logId" value = "${memInfo.memId }"> 
		<div>
			<table>
				<tr>
					<th>글번호</th>
					<td><input type = "text" name = "seq" id = "seq" readonly="readonly"></td>
				</tr>
				<tr>
					<th>작성자</th>
					<td>
						<input type = "text" name = "writer" id = "writer" readonly="readonly">
						<input type = "hidden" name = "writerId" id = "writerId">
					</td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type = "text" name = "subj" id = "subj" value = "${detailMap.apprSubject }" placeholder="제목을 입력하세요" readonly="readonly"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea rows="5" cols="25" name = "content" id = "content" placeholder="내용을 입력하세요" readonly="readonly">${detailMap.apprContent }</textarea></td>
				</tr>
			</table>
		</div>
	</form>
	<div>
	
		<input type = "button" name = "tmpBtn" id = "tmpBtn" value = "임시저장" onclick = "fncSave('tmp')">
		<input type = "button" name = "retBtn" id = "retBtn" value = "반려" onclick="fncSave('ret')">
		<input type = "button" name = "appBtn" id = "appBtn" value = "결재" onclick="fncSave('app')">
	</div>
	<div>
		<table border = "1">
			<tr>
				<th>번호</th>
				<th>결재일</th>
				<th>결재자</th>
				<th>결재상태</th>
			</tr>
			<c:forEach items="${appHistory }" var = "his">
				<tr> 
					<td>${his.hisSeq }</td>
					<td>${his.hisAppDate}</td>
					<td>${his.hisApperName }</td>
					<td>${his.hisStatusKor }</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
</html>