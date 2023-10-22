package com.approval.jsh.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import org.springframework.stereotype.Service;
import com.approval.jsh.dao.MemberDAO;


@Service
public class MemberServiceImpl implements MemberService{

	@Inject
	private MemberDAO dao;

	@Override
	public List<Map<String, Object>> apprList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return dao.apprList(paramMap);
	}

	@Override
	public List<Map<String, Object>> histList(int seq) {
		// TODO Auto-generated method stub
		return dao.histList(seq);
	}

}
