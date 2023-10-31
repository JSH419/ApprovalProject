package com.approval.jsh.service;

import java.util.List;
import java.util.Map;

public interface MemberService {
	List<Map<String, Object>> apprList(Map<String, Object> paramMap);
	List<Map<String, Object>> histList(int seq);
	Map<String, Object> isProxyMember(String memId);
}
