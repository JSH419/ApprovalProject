<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>replace page</title>
<script  src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script>

	// 세션만료시 체크
	var sessionChk = '${memInfo}';
	
	if(sessionChk == null || sessionChk == ''){
		alert("로그인 후 이용하세요");
		location.href = 'login';
	}
	
	$(function(){
		//대리결재 버튼 조건 
		var proxSh = '${memInfo.memRank}';
		if(proxSh == 'BOSS' || proxSh == 'KING'){
			$("#replaceBtn").show();
		}
	   
	   $("#replaceBtn").click(function () {
		  window.open('replace', '팝업창', 'width=400, height=400');
	    });
	   
	   $("#xx").click(function () {
		  window.close();
	    });
	   
	   $("#oo").click(function () {
		   
		   $("#replaceFrm").attr("action","replace").attr("method","post").submit();
	    });
	   
	   $("#logoutBtn").click(function () {
            // 로그아웃 버튼 클릭 시 확인 대화상자 표시
            if (confirm("로그아웃 하시겠습니까?")) {
                location.href = 'logout';
            }
            return false; 
        })
		
		$("#searchType").val('${map1.searchType}');
		$("#searchTxt").val('${map1.searchTxt}');	
		$("#searchStatus").val('${map1.searchStatus}');
		$("#stDate").val('${map1.stDate}');	
		$("#enDate").val('${map1.enDate}');
		
		//동기 
		$("#schBtn").click(function(){
			$("#searchFrm").attr("action","list").attr("method","post").submit();
		})
		
		//비동기 
		$("#searchStatus").change(function(){
			$.ajax({
				url : "searchList",
				data : $("#searchFrm").serialize(),
				type : "post",
				success : function(data){
					alert("검색완료");
					$("#tContent").html(data);
				},
				error :function(data){
					
				}
			})
		})
	})
	
	function fncGoDetail(seq){
		location.href = 'detail?seq='+seq;
	}
</script>
<body>
<c:set var="name" value="${memInfo.memName}" />
<c:set var="rank" value="${memInfo.memRankKor}" />

<div id="popup">
    <form name="replaceFrm" id="replaceFrm">
        	<div>
			    대리결제자 :
			    <select name="replacePerson" id="replacePerson">
			    	<option value="" disabled selected>선택</option>
			        <c:forEach items="${memberchk}" var="member">
			            <option value="${member.memRankKor}">${member.memName}</option>
			        </c:forEach>
			    </select>
			    <input type="hidden" name="selectedRankKor" id="selectedRankKor" value="">
			    <p>직급 : <span id="selectedMemRank"></span></p>
			    <p>대리자 : ${name} (${rank})</p>
			</div>
	        <input type="button" name="xx" id="xx" value="취소">
	        <input type="button" name="oo" id="oo" value="승인">
    </form>
</div>
<script>
    $(document).ready(function() {
        $('#replacePerson').on('change', function() {
            var selectedRankKor = $(this).val(); // 선택된 memRankKor 값 가져오기
            $('#selectedRankKor').val(selectedRankKor);
            $('#selectedMemRank').text(selectedRankKor); // 직급을 표시하는 부분 업데이트
        });
    });
</script>
</body>
</html>