package com.best.kgw.service;

import com.vo.EmpVO;

import java.util.List;
import java.util.Map;

public interface AdminSevice {

    /**********************************************************************************
     작성자 : 이동건
     작성일자 : 24.02.19
     기능 : 사원추가 인터페이스
     **********************************************************************************/
    public int regist(EmpVO empVO) throws Exception;

    /**********************************************************************************
     작성자 : 이동건
     작성일자 : 24.02.19
     기능 : 사원목록 인터페이스
     **********************************************************************************/
    public List<Map<String, Object>> empList(Map<String, Object> pmap);

    /**********************************************************************************
     작성자 : 이동건
     작성일자 : 24.02.21
     기능 : 사원수정 인터페이스
     **********************************************************************************/
    public int empInfoUpdate(Map<String, Object> pmap);
}
