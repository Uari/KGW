package com.best.kgw.controller;

import com.best.kgw.service.AttendanceService;
import com.vo.AttendanceModifyVO;
import com.vo.AttendanceVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/attendance/*")
@EnableScheduling
@Component
public class AttendanceController {
    Logger logger = LoggerFactory.getLogger(AttendanceController.class);

    @Autowired
    private AttendanceService attendanceService;

    @GetMapping("attendanceCalendar")
    public String attendanceCalendar(AttendanceVO attendanceVO, Model model) throws Exception {
        logger.info("AttendanceController : attendanceCalendar");
        List<AttendanceVO> attendanceCalendar = attendanceService.attendanceData(attendanceVO.getEmp_no());
        model.addAttribute("attendanceCalendar",attendanceCalendar);
        return "forward:/attendance/attendanceCalendar.jsp";
    }

    @PostMapping("attendanceTime")
    @ResponseBody
    public void attendanceTime(AttendanceVO attendanceVO) throws Exception{
        logger.info(attendanceVO.toString());

        attendanceService.attendanceTime(attendanceVO);
    }

    @PostMapping("attendanceEndTime")
    @ResponseBody
    public void attendanceEndTime(AttendanceVO attendanceVO) throws Exception{
        logger.info(attendanceVO.toString());

        attendanceService.attendanceEndTime(attendanceVO);
    }

    @GetMapping("attendanceList")
    public String attendanceList(AttendanceVO attendanceVO, Model model) throws Exception{
        logger.info("emp_no"+attendanceVO.getEmp_no());
        List<AttendanceModifyVO> attendanceModList = attendanceService.attendaceModList(attendanceVO);
        List<AttendanceVO> attendanceList = attendanceService.attendanceData(attendanceVO.getEmp_no());
        logger.info(attendanceModList.toString());
        model.addAttribute("attendanceModList",attendanceModList);
        model.addAttribute("attendanceList",attendanceList);
        return "forward:/attendance/attendanceList.jsp";
    }

    @PostMapping("attendaceMod")
    public String attendaceMod(AttendanceVO attendanceVO, RedirectAttributes redirectAttributes) throws Exception{
        logger.info(attendanceVO.toString());
        attendanceService.attendaceMod(attendanceVO);
        redirectAttributes.addAttribute("emp_no", attendanceVO.getEmp_no());
        return "redirect:./attendanceList";
    }

    @GetMapping("adminAttendance")
    public String adminAttendance(AttendanceVO attendancevo, Model model) throws Exception{
        logger.info("AttendanceController: adminAttendance");
        List<AttendanceModifyVO> attendanceModList = attendanceService.attendaceModList(attendancevo);
        logger.info(attendanceModList.toString());
        model.addAttribute("attendanceModList", attendanceModList);
        return "forward:/admin/adminAttendance.jsp";
    }

    @GetMapping("adminModAttendance")
    public String adminModAttendeance(AttendanceModifyVO attendancemodifyvo, Model model) throws Exception{
        Map<String, Object> attendanceModMap = attendanceService.adminModAttendeanceMap(attendancemodifyvo);
        model.addAttribute("attendanceModMap", attendanceModMap);
        return "forward:/admin/adminModAttendance.jsp";
    }

    @PostMapping("attendanceModUpdate")
    public String attendanceModUpdate(AttendanceModifyVO attendancemodifyvo) throws Exception{
        logger.info(attendancemodifyvo.toString());
        attendanceService.attendanceModUpdate(attendancemodifyvo);
        return "redirect:./adminAttendance";
    }

    @PostMapping("/jsonAttendanceSelect")
    @ResponseBody
    public List<AttendanceVO> jsonAttendanceSelect(@RequestBody AttendanceVO attendanceVO) throws Exception{
        List<AttendanceVO> attendanceList = attendanceService.jsonAttendanceSelect(attendanceVO);
        logger.info(attendanceList.toString());
        return attendanceList;
    }

    //@Scheduled(cron = "57 59 23 ? * 1-5")
    public void run() throws Exception {
        try {
            attendanceService.attemdamceStateUpdate();
        }catch (Exception e) {
            // 예외 발생 시 로그 출력 또는 예외 처리 로직 추가
            e.printStackTrace();
        }
    }
}
