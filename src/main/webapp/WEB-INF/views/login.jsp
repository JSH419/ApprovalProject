<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>
<style>
/* styles.css */
.login-container {
    width: 400px;
    margin: 0 auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #f5f5f5;
    text-align: center;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}

.form-group {
  margin-bottom: 10px;
}

label {
  display: block;
}

input[type="text"],
input[type="password"] {
  width: 80%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.button-container {
  text-align: center;
  margin-top: 20px;
}
</style>
<script  src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script>
	var loginChk = '${loginMsg}';
	
	if(loginChk == 'idFail'){
		alert("아이디를 확인하세요");
		$("#logId").focus();
	}else if(loginChk == 'passFail'){
		alert("비밀번호를 확인하세요");
		$("#logPass").focus();
	}
	
	$(function(){
		$("#loginbtn").click(function(){
			if($("#logId").val() == ''){
				alert('아이디를 입력하세요');
				$("#logId").focus();
			}else if($("#logPass").val() == ''){
				alert('비밀번호를 입력하세요');
				$("#logPass").focus();
			}else{
				$("#frm").attr("action","login").attr("method","post").submit();
			}
		})
	})
</script>

</head>
<body>
 
 <div class="login-container">
    <form name="frm" id="frm">
        <h1>Login</h1>
        <div class="form-group">
            <input type="text" name="logId" id="logId" placeholder="아이디를 입력하세요">
        </div>
        <div class="form-group">
            <input type="password" name="logPass" id="logPass" placeholder="비밀번호를 입력하세요">
        </div>
        <div class="button-container">
            <input type="button" name="loginbtn" id="loginbtn" value="로그인">
        </div>
    </form>
</div>
	
</body>
</html>