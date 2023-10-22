package com.approval.jsh.dao;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDAOImpl implements MemberDAO{
	
	@Inject
	private SqlSession sql;

	@Override
	public List<Map<String, Object>> apprList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return sql.selectList("mapper.apprList", paramMap);
	}

	@Override
	public List<Map<String, Object>> histList(int seq) {
		// TODO Auto-generated method stub
		return sql.selectList("mapper.histList", seq);
	}
}
