package com.approval.jsh.dao;

import java.util.List;
import java.util.Map;


public interface MemberDAO {

	List<Map<String, Object>> apprList(Map<String, Object> paramMap);
	List<Map<String, Object>> histList(int seq);
	Map<String, Object> isProxyMember(String memId);
}
