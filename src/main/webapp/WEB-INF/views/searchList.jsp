<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri = "http://java.sun.com/jsp/jstl/core" %>    
    
<c:choose>
	<c:when test="${empty apprList}">
		<tr>
			<td colspan="7">검색된 데이터가 없습니다!</td>
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