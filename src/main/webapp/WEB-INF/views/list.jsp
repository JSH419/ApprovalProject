<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri = "http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>list</title>
<style type="text/css">
    /* Main container styling */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }

    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        background-color: #fff;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    /* Header styling */
    h1 {
        text-align: center;
    }

    /* Button styling */
    .button-container {
        text-align: right;
        margin-top: 10px;
    }

    .button-container button {
        background-color: #007BFF;
        color: #fff;
        border: none;
        padding: 10px 20px;
        cursor: pointer;
    }

    .button-container button:hover {
        background-color: #0056b3;
    }

    /* Search form styling */
    .search-form {
        margin-top: 20px;
        background-color: #f9f9f9;
        padding: 10px;
        border-radius: 5px;
    }

    .search-form select,
    .search-form input[type="text"],
    .search-form input[type="date"],
    .search-form button {
        margin: 11px;
        padding: 11px;
    }

    /* Table styling */
    table {
        width: 80%;
        border-collapse: collapse;
        background-color: #dcdcdc;
    }

    table th, table td {
        text-align: left;
        padding: 10px;
        border: 1px solid #dcdcdc;
    }

    table th {
        background-color: #007BFF;
        color: #fff;
    }
    
	#report1:hover tbody tr:hover td {
	    background: red;
	    color: white;
	}    

</style>
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
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
		  window.open('replace', '대리결차 팝업창', 'width=400, height=400');
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

</head>

<c:set var="name" value="${memInfo.memName}" />
<c:set var="rank" value="${memInfo.memRankKor}" />
${name} (${rank})님 환영합니다.
 
<body>
	<div>	
		<input type = "button" name = "writeBtn" id = "writeBtn" value = "글쓰기" onclick = "location.href = 'write'">
		<input type = "button" name = "logoutBtn" id = "logoutBtn" value = "로그아웃">
		<input type = "button" name = "replaceBtn" id = "replaceBtn" value = "대리결재" style = "display: none;">
	</div>
	<form name = "searchFrm" id = "searchFrm">
		<div>
			<select name = "searchType" id = "searchType" >
				<option value = "all">전체</option>
				<option value = "writeName">작성자</option>
				<option value = "appSubject">제목</option>
				<option value = "apperName">결재자</option>
			</select> 
			<input type = "text" name = "searchTxt" id = "searchTxt" placeholder="검색어를 입력하세요">
			<select name = "searchStatus" id = "searchStatus">
				<option value = "stEmp">결재상태</option>
				<option value = "tmp">임시저장</option>
				<option value = "wat">결재대기</option>
				<option value = "ing">결재중</option>
				<option value = "end">결재완료</option>
				<option value = "ret">반려</option>
			</select>
			<br>
			<input type = "date" name = "stDate" id = "stDate"> ~
			<input type = "date" name = "enDate" id = "enDate">
			<input type = "button" name = "schBtn" id = "schBtn" value = "검색">
		</div>
	</form>
	<div>
		<table border = "1" class="table" id = "report1"> 
			<thead>
				<tr>
					<th>글번호</th>
					<th>작성자</th>
					<th>제목</th>
					<th>작성일</th>
					<th>결재일</th>
					<th>결재자</th>
					<th>결재상태</th>
				</tr>
			</thead>
			
			<tbody id = "tContent">
				<c:choose>
						<c:when test="${empty apprList}">
						    <tr>
						        <td colspan="7" style="text-align: center;">데이터가 존재하지 않습니다</td>
						    </tr>
						</c:when>
					<c:otherwise>
						<c:forEach items="${apprList }" var = "list">
							<tr onclick="fncGoDetail(${list.seq})">
							    <td>${list.seq }</td>
							    <td>${list.writeName }</td>
							    <td>${list.apprSubject }</td>
							    <td>${list.apprRegDate }</td>
							    <td>${list.apprDate }</td>
							    <td>${list.apperName }</td>
							    <td>${list.apprStatusKor }</td>
							</tr>
						</c:forEach> 	
					</c:otherwise> 
				</c:choose> 
			</tbody> 
		</table> 
	</div>
<div>
</div>
</body>
</html>