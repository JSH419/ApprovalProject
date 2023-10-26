package com.approval.jsh.controller;


import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.approval.jsh.service.MemberService;

@Controller
public class ApprovalController {
	
	@Inject
	public SqlSessionTemplate sqlSession;
	
	@Inject
	public MemberService service;
	
	// 1. 로그인 
	@RequestMapping("login")
	public String loginView(@RequestParam(value="logId", required=false) String logId
						   ,@RequestParam(value="logPass", required=false) String logPass
						   ,Model model
						   ,HttpSession session
						   ,HttpServletResponse response) throws IOException {
		//로그인 상태	        
		if(session.getAttribute("memInfo") != null) {
			return "redirect:list";
		} 
		 
		if(logId == null) {
			return "login";
		}else {
			Map<String, Object> map = sqlSession.selectOne("mapper.loginChk", logId);
			if(map == null) {
				model.addAttribute("loginMsg", "idFail");
				return "login"; 
			}else if (!logPass.equals(map.get("memPass").toString())) {
				model.addAttribute("loginMsg", "passwordFail");
				return "login"; 
			}else {
		        session.setAttribute("memInfo", map);
		        
		        String proxyMember = map.get("memId").toString();	//session에서 memId만 가져와서 저장
		        Map<String, Object> replace = sqlSession.selectOne("mapper.proxy", proxyMember);
		        //memId를 통해 proxy 테이블에서 대리권한 위임을 받았는지 확인 
		        if(replace != null) {
		        	  String grantRank = (String) replace.get("grantRank");// 대리권한 위임자 계급 추출
		        	  Map<String, Object> memInfo = (Map<String, Object>) session.getAttribute("memInfo");
				      memInfo.put("memRank", grantRank);
				      session.setAttribute("memInfo", memInfo);
		        }
				return "redirect:list";
			}
		}
	}
	
 	//2. 로그아웃
	@RequestMapping("logout")
	public String logOut(HttpSession session) {
		session.invalidate();
		return "redirect:login";
	}
	
	//3. 결재목록 
	@RequestMapping("list")
	public String list(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
		
		map.put("memInfo", session.getAttribute("memInfo"));
		if(map.get("memInfo") != null) {
		
		List<Map<String, Object>> apprList = new ArrayList<Map<String, Object>>();
		apprList = service.apprList(map);
		model.addAttribute("apprList", apprList);
		
		List<Map<String, Object>> proxy = sqlSession.selectList("mapper.proxy", map);
		model.addAttribute("proxy", proxy);
		
		System.out.println("proxy 값 : " +proxy);
		System.out.println("apprList 값 : " +apprList);
		
		}
		
		model.addAttribute("map1", map);

		return "list";
	}
	
	// 검색리스트
	@RequestMapping("searchList")	
	public String searchList(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
		map.put("memInfo", session.getAttribute("memInfo"));
		
		if(map.get("memInfo") != null) { 
			List<Map<String, Object>> list = sqlSession.selectList("mapper.apprList", map);
			model.addAttribute("apprList", list);
		}
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = service.apprList(map);
		model.addAttribute("list", list);
		
		
		return "searchList";
	}
	
	//4. 결재 페이지 이동
	@RequestMapping("write")
	public String writeView(Model model) {
		
		int seq = sqlSession.selectOne("mapper.writeSeq");
		
		model.addAttribute("listSeq", seq);
		model.addAttribute("mode", "add");
		
		return "writeView";
	}
	
	//5. 결재글 올리기 
	@RequestMapping("writeProc")
	public String writeProc(@RequestParam Map<String, Object> map, HttpSession session) {
			
			int seq = sqlSession.selectOne("mapper.dataChk", map.get("seq").toString());
			System.out.println("seq 값 : " + seq);				
			Map<String, Object> memInfo = (Map<String, Object>)session.getAttribute("memInfo");
			
			map.put("memInfo", memInfo);
			
			String rank = memInfo.get("memRank").toString();
			String aChk = "Y";
			
			if((!"tmp".equals(map.get("status").toString())) && ("BOSS".equals(rank) || "KING".equals(rank))){
				map.put("appChk", aChk);	//임시저장 상태가 아니면서 계급이 과장 혹은 부장일 때만 aChk를 Y로 넣어준다. 
			}
			
			System.out.println("결과 : " + map);
			
			if(seq == 0) {
				sqlSession.insert("mapper.insert", map);
			}else {
				sqlSession.update("mapper.update", map);
			}
			sqlSession.insert("mapper.history", map);
			
			return "redirect:list";
	}
	
	//6. 상세보기 페이지
	@RequestMapping("detail")
	public String detail(@RequestParam Map<String, Object> map, Model model, @RequestParam(required=false, defaultValue = "0") int seq) {
		Map<String, Object> detailMap = sqlSession.selectOne("mapper.detail", seq);
		
		List<Map<String, Object>> hisMap = service.histList(seq);
		
		model.addAttribute("appHistory", hisMap);
		model.addAttribute("mode", "mofy");
		model.addAttribute("detailMap", detailMap);
		
		return "writeView";
	}
	
	//7. 대리결재 팝업창 
	@RequestMapping("replace")
	public String replace(@RequestParam Map<String, Object> map, Model model, HttpSession session) {
	    map.put("memInfo", session.getAttribute("memInfo"));
	    Map<String, Object> memInfo = (Map<String, Object>) map.get("memInfo");
	    
	    List<Map<String, Object>> memberchk = sqlSession.selectList("mapper.memberchk", map);
	    
	    model.addAttribute("memberchk", memberchk);
	    System.out.println("memberchk 값 :" + memberchk);
	    
	    return "replace";
	}
	
	//8. 대리결재 권한부여 
	@RequestMapping("replaceAppr")
	public String replaceAppr(@RequestParam Map<String, Object> map, HttpSession session) {
			map.put("memInfo", session.getAttribute("memInfo"));
		    Map<String, Object> memInfo = (Map<String, Object>) map.get("memInfo");
		    	
		    sqlSession.insert("mapper.replaceInsert", map);
		    
			return "redirect:replace";
	}
}
