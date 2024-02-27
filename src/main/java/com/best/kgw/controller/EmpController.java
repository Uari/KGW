package com.best.kgw.controller;

import com.best.kgw.service.AdminSevice;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Controller
public class EmpController {


    @Autowired
    private AdminSevice adminSevice;

    Logger logger = LoggerFactory.getLogger(ExelController.class);

    /**********************************************************************************
     작성자 : 이동건
     작성일자 : 24.02.21
     기능 : 전사원 목록 조회
     **********************************************************************************/
    @GetMapping("empInfo")
    public String empInfo(@RequestParam Map<String, Object> pmap, Model model) {
        logger.info("Controller : empInfo 호출");
        List<Map<String ,Object>> empList = null;
        empList = adminSevice.empList(pmap);
        model.addAttribute("empList", empList);
        return "forward:/empinfo/empInfo.jsp";
    }
}
