package com.best.kgw.controller;

import com.best.kgw.auth.PrincipalDetails;
import com.best.kgw.service.AttendanceService;
import com.best.kgw.service.ChartService;
import com.best.kgw.service.DashboardService;
import com.best.kgw.service.FileService;
import com.google.gson.Gson;
import com.vo.AttendanceVO;
import com.vo.EmpVO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**********************************************************************************
 작성자 : 박병현
 작성일자 : 24.02.19
 기능 : 메인페이지 Controller
 **********************************************************************************/
@Controller
//@RequestMapping("/")
public class DashboardController{
    Logger logger = LoggerFactory.getLogger(DashboardController.class);
    @Autowired
    private DashboardService dashboardService;
    @Autowired
    private FileService fileService;

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;
    @Autowired
    private ChartService chartService;

    /**********************************************************************************
     작성자 : 박병현
     작성일자 : 24.02.19
     기능 : 메인페이지
     **********************************************************************************/
    @GetMapping("/")
    public String DashboardForm(Model model,Map<String, Object> fmap, Map<String, Object> wmap, Map<String, Object> pmap) throws Exception {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        PrincipalDetails principalDetails = (PrincipalDetails) authentication.getPrincipal();
        EmpVO empVO = principalDetails.getEmpVO();

        logger.info("Controller : DashboardForm" + empVO.toString());
        AttendanceVO attendance = attendanceService.attendance(empVO.getEmp_no());
        logger.info(empVO.getEmp_no()+"");
        List<AttendanceVO> attendanceCalendar = attendanceService.attendanceData(empVO.getEmp_no());
        model.addAttribute("attendanceCalendar",attendanceCalendar);
        model.addAttribute("attendance", attendance);

        // 1. FA 선수 현황 -  WAR차트
        List<Map<String, Object>> wList = chartService.wList(wmap);
        logger.info("wList (받아온 DB data) : " + wList);
        // 1차 가공
        List<Object[]> dataList = new ArrayList<>();
        String[] hs = {"NAME", "WAR"};
        dataList.add(hs);
        for (Map<String, Object> entry : wList) {
            dataList.add(new Object[]{entry.get("FA_NAME"), entry.get("FA_WAR")});
        }
        logger.info("dataList : " + dataList);  // 객체[]라서 주소값으로 나올것 -> Json으로 바꿔야 값이 나옴(2차 가공)
        // 2차 가공
        Gson g = new Gson();
        String wChart = g.toJson(dataList);
        logger.info("wChart : " + wChart);
        model.addAttribute("wChart", wChart);

        // 2. FA 선수 현황 -  포지션별 차트
        List<Map<String, Object>> pList = chartService.pList(pmap);
        logger.info("pList (받아온 DB data) : " + pList);
        // 1차 가공
        List<Object[]> pieList = new ArrayList<>();
        String[] hs2 = {"FA_POS", "COUNT"};
        pieList.add(hs2);
        for (Map<String, Object> entry : pList) {
            pieList.add(new Object[]{entry.get("FA_POS"), entry.get("COUNT")});
        }
        logger.info("pieList : " + pieList);  // 객체[]라서 주소값으로 나올것 -> Json으로 바꿔야 값이 나옴(2차 가공)
        // 2차 가공
        g = new Gson();
        String pChart = g.toJson(pieList);
        logger.info("pChart : " + pChart);
        model.addAttribute("pChart", pChart);

        // 3. FA 선수 명단
        List<Map<String, Object>> faList = chartService.faList(fmap);
        logger.info("faList : " + faList);
        model.addAttribute("faList", faList);
        return "forward:/dashboard/dashboardForm.jsp";
    }

    /**********************************************************************************
     작성자 : 박병현 (동건씨 땡큐)
     작성일자 : 24.02.24
     기능 : 사원 상세조회
     **********************************************************************************/
    @GetMapping("mypage")
    public String empDetail(EmpVO empvo, Model model) throws Exception {
        logger.info("Controller : empDetail 호출" + empvo);
        EmpVO empDetail = dashboardService.empDetail(empvo);
        logger.info(empDetail.toString());
        model.addAttribute("empDetail", empDetail);
//    logger.info(ticketList.toString());
        return "forward:/mypage/mypage.jsp";
    }

    /**********************************************************************************
     작성자 : 박병현
     작성일자 : 24.02.24
     기능 : 사원정보 수정
     **********************************************************************************/
    @PostMapping("empDetailUpdate")
    public String empDetailUpdate(EmpVO empvo, @RequestParam("profiles") MultipartFile file, HttpServletRequest req) throws Exception {
        logger.info("empDetailUpdate");
        if (file != null && !file.isEmpty()) {
            // 파일이 제대로 전달되었을 때의 처리
            logger.info("File is not null and not empty.");
            fileService.fileUpload("profile", file, req, empvo);
            String originalFilename = file.getOriginalFilename(); // 업로드된 파일의 원본 파일 이름
            String extension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1); // 확장자 추출
            empvo.setProfile_img(empvo.getEmp_no()+"."+extension);
            String rawPassword = empvo.getPassword();
            String encPassword = bCryptPasswordEncoder.encode(rawPassword);
            empvo.setPassword(encPassword);
            int result = 0;
            result = dashboardService.empDetailUpdate(empvo);
            // 파일 업로드 및 처리 로직을 여기에 추가
        } else {
            // 파일이 전달되지 않았을 때의 처리
            logger.info("File is null or empty.");
        }


        return "redirect:/";
    }
}
