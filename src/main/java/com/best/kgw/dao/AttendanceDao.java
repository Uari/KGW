package com.best.kgw.dao;

import com.vo.AttendanceVO;

import java.util.List;

public interface AttendanceDao {
    public void attendanceTime(AttendanceVO attendanceVO) throws Exception;

    public void attendanceEndTime(AttendanceVO attendanceVO) throws Exception;

    public AttendanceVO attendance(int emp_no) throws Exception;

    public List<AttendanceVO> attendanceData(int attendanceVO) throws Exception;

    public void attemdamceStateUpdate() throws Exception;
}
