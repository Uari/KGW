<%@ page import="java.util.List" %>
<%@ page import="com.vo.CalendarVO" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.vo.EmpVO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Objects" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calendar</title>
    <!-- fullcalendar CDN -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@5.10.1/main.min.js"></script>
    <!-- moment.js 라이브러리 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <!-- moment-timezone.js 라이브러리 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.34/moment-timezone-with-data.min.js"></script>
    <!-- 부트스트랩 라이브러리 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/calendar.css" />
    <!-- fullcalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@5.10.1/main.min.css" rel="stylesheet">
</head>

<body class="hold-transition sidebar-mini sidebar-collapse">
<div class="wrapper">
    <%@include file="/include/KGW_bar.jsp"%>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        let calendarEl = document.getElementById('calendar');
        let calendar;
        if (calendarEl) {
            calendar = new FullCalendar.Calendar(calendarEl, {
                expandRows: true,
                initialView: 'dayGridMonth',
                slotMinTime: '08:00',
                slotMaxTime: '20:00',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
                },
                navLinks: true,
                editable: true,
                selectable: true,
                nowIndicator: true,
                dayMaxEvents: true,
                height: '570px',
                locale: 'ko',

                select: function(arg) {
                    if (detailStart === !null) {
                        let modal = document.getElementById('detailModal');
                        modal.style.display = 'block';
                        let endInput = document.getElementById('detailEnd');
                        let startInput = document.getElementById('detailStart');
                        let startTime = moment(arg.start, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');
                        let endTime = moment(arg.end, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');
                        startInput.value = startTime;
                        endInput.value = endTime;
                    } else {
                        let modal = document.getElementById('insertModal');
                        modal.style.display = 'block';
                        let startInput = document.getElementById('insertStart');
                        let endInput = document.getElementById('insertEnd');
                        let startTime = moment(arg.start, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');
                        let endTime = moment(arg.end, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');
                        startInput.value = startTime;
                        endInput.value = endTime;
                    }
                },
                eventClick: function(info) {
                    if(detailTitle != null && detailCalendarNo != null) {
                        let modal = document.getElementById('detailModal');
                        modal.style.display = 'block';
                        let detailCalendarNoInput = document.getElementById('detailCalendarNo');
                        let detailCalendarIdInput = document.getElementById('detailCalendarId');
                        let detailTitleInput = document.getElementById('detailTitle');
                        let detailStartInput = document.getElementById('detailStart');
                        let detailEndInput = document.getElementById('detailEnd');
                        let event = info.event;
                        detailTitleInput.value = event.title;
                        detailCalendarIdInput.value = event.id;
                        detailCalendarNoInput.value = event.extendedProps.CalendarNo;
                        detailStartInput.value = moment(event.start).format('YYYY-MM-DDTHH:mm');
                        detailEndInput.value = moment(event.end).format('YYYY-MM-DDTHH:mm');
                    } else {
                        let modal = document.getElementById('insertModal');
                        modal.style.display = 'block';
                        let insertTitleInput = document.getElementById('insertTitle');
                        let insertStartInput = document.getElementById('insertStart');
                        let insertEndInput = document.getElementById('insertEnd');
                        let event = info.event;
                        insertTitleInput.value = event.title;
                        insertStartInput.value = moment(event.start).format('YYYY-MM-DDTHH:mm');
                        insertEndInput.value = moment(event.end).format('YYYY-MM-DDTHH:mm');
                    }
                },
                events: [
                    <%  List<CalendarVO> myCalendarList = (List<CalendarVO>) request.getAttribute("myCalendarList");
                        if (myCalendarList != null) {
                            for (CalendarVO vo : myCalendarList) {
                            if (Objects.equals(sessionVO.getName(), vo.getName())) {
                            %>
                    {
                        extendedProps: { CalendarNo: '<%= vo.getCalendar_no() %>' },
                        id: '<%= vo.getCalendar_id() %>',
                        title: '<%= vo.getCalendar_title() %>',
                        start: '<%= vo.getCalendar_start() %>',
                        end: '<%= vo.getCalendar_end() %>',
                        color: '#' + Math.round(Math.random() * 0xffffff).toString(16)
                    },
                    <% }}} %>
                ]
            });
            calendar.render();
        } else {
            console.error('calendarEl = NULL');
        }

        // 예약 취소 모달 관련 스크립트
        const modal = document.getElementById('detailModal');
        const span = document.getElementsByClassName("close")[0];

        span.onclick = function () {
            modal.style.display = "none";
        }

        window.onclick = function (event) {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        }

        //내 예약 현황 취소 버튼
        let cancelButtonList = document.querySelectorAll('.cancel-button');
        cancelButtonList.forEach(function (cancelButton) {
            cancelButton.addEventListener('click', function () {
                let modal = document.getElementById('detailModal');
                modal.style.display = 'block';
            }, { passive: true }); // passive 옵션 추가
        });

        // 이벤트 핸들러 등록
        let submitBtn = document.getElementById('submitEvent');
        let searchBtn = document.getElementById('searchEvent');
        let exitBtn = document.getElementById('exitEvent');
        let deleteBtn = document.getElementById('deleteEvent');
        let updateBtn = document.getElementById('updateEvent');
        let addEventBtn = document.getElementById('addEvent');
        let closeBtnList = document.querySelectorAll('.modal-content .close');

        submitBtn.addEventListener('click', handleEventSubmit);
        submitBtn.addEventListener('click', handleEventUpdate);
        searchBtn.addEventListener('click', calendarSearch);
        exitBtn.addEventListener('click', handleEventSubmit);
        exitBtn.addEventListener('click', handleEventUpdate);
        deleteBtn.addEventListener('click', handleEventDelete);
        updateBtn.addEventListener('click', handleEventUpdate);
        addEventBtn.addEventListener('click', function() {
            let insertModal = document.getElementById('insertModal');
            insertModal.style.display = 'block';
        });
        closeBtnList.forEach(function(closeBtn) {
            closeBtn.addEventListener('click', handleModalClose);
            closeBtn.addEventListener('click', handleEventUpdate);
        });

        function handleEventSubmit() {
                let idInput = document.getElementById('insertCalendarId');
                let empNoInput = document.getElementById('insertCalendarId');
                let titleInput = document.getElementById('insertTitle');
                let startInput = document.getElementById('insertStart');
                let endInput = document.getElementById('insertEnd');

                let calendar_id = idInput.value;
                let calendar_title = titleInput.value;
                let calendar_start = startInput.value;
                let calendar_end = endInput.value;
                let emp_no = <%= sessionVO.getEmp_no() %>;
                let url = '/calendar/insertCalendar';

            if (calendar_title && calendar_start && calendar_end && emp_no && calendar_id) {
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        calendar_title: calendar_title,
                        calendar_start: calendar_start,
                        calendar_end: calendar_end,
                        emp_no: emp_no,
                        calendar_id: calendar_id
                    },
                    success: function(response) {
                        console.log(response);
                        if (response > 0) {
                            if (window.opener) window.opener.location.reload(true);
                            window.location.href = '${pageContext.request.contextPath}' + '/calendar/myCalendarList';

                            alert("일정이 등록되었습니다.");
                        }
                    },
                    error: function(request, status, error) {
                        console.error("오류 발생 >> " + error);
                    }
                });
            }
            // 모달 숨기기
            let modal = document.getElementById('insertModal');
            modal.style.display = 'none';
            closeModalAndClearInputs();
        }

        function handleEventDelete() {
            let calendarNoInput = document.getElementById('detailCalendarNo');
            let calendar_no = calendarNoInput.value;
            let url = "<%=request.getContextPath()%>/calendar/deleteCalendar";

            if (calendar_no) {
                $.ajax({
                    type: "POST",
                    url: url,
                    data: { calendar_no: calendar_no },
                    success: function(response) {
                        console.log(response);
                        if (response > 0) {
                            if (window.opener) window.opener.location.reload(true);
                            window.location.href = '${pageContext.request.contextPath}' + '/calendar/myCalendarList';

                            alert("일정이 삭제되었습니다.");
                        }
                    },
                    error: function(request, status, error) {
                        console.error("오류 발생 >> " + error);
                    }
                });
            }
            closeModalAndClearInputs();
            // 모달 숨기기
            let modal = document.getElementById('detailModal');
            modal.style.display = 'none';
        }

        function handleEventUpdate(updatedEvent) {
            let titleInput = document.getElementById('detailTitle');
            let startInput = document.getElementById('detailStart');
            let endInput = document.getElementById('detailEnd');
            let calendarNoInput = document.getElementById('detailCalendarNo');
            let idInput = document.getElementById('detailCalendarId');

            let calendar_title = titleInput.value;
            let calendar_start = startInput.value;
            let calendar_end = endInput.value;
            let emp_no = <%= sessionVO.getEmp_no() %>;
            let calendar_no = calendarNoInput.value;
            let calendar_id = idInput.value;

            let url = "/calendar/updateCalendar";

            if (calendar_title && calendar_start && calendar_end && emp_no && calendar_no && calendar_id) {
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        calendar_title: calendar_title,
                        calendar_start: calendar_start,
                        calendar_end: calendar_end,
                        emp_no: emp_no,
                        calendar_no : calendar_no,
                        calendar_id: calendar_id
                    },
                    success: function(response) {
                        console.log(response);
                        if (response > 0) {
                            if (window.opener) window.opener.location.reload(true);
                            window.location.href = '${pageContext.request.contextPath}' + '/calendar/myCalendarList';

                            alert("일정이 수정되었습니다.");
                        }
                    },
                    error: function(request, status, error) {
                        console.error("오류 발생 >> " + error);
                    }
                });
            }
            closeModalAndClearInputs();
            // 모달 숨기기
            let modal = document.getElementById('detailModal');
            modal.style.display = 'none';
        }

        // 팀 일정 체크박스 클릭 시 링크로 이동
        document.getElementById('teamCal').addEventListener('change', function() {
            if (this.checked) {
                window.location.href = '../calendar/teamCalendarList';
            }
        });

        // 전사 일정 체크박스 클릭 시 링크로 이동
        document.getElementById('comCal').addEventListener('change', function() {
            if (this.checked) {
                window.location.href = '../calendar/companyCalendarList';
            }
        });

        // 모달 닫기 및 입력 값 초기화 함수
        function closeModalAndClearInputs() {
            let modal = document.getElementById('insertModal');
            modal.style.display = 'none';
            clearModalInputs();
        }

        // 모달 닫기 처리 함수
        function handleModalClose() {
            let modal1 = document.getElementById('insertModal');
            let modal2 = document.getElementById('detailModal');
            modal1.style.display = 'none';
            modal2.style.display = 'none';
            clearModalInputs();
        }

        // 모달 입력값 초기화 함수
        function clearModalInputs() {
            document.getElementById('insertTitle').value = '';
            document.getElementById('detailTitle').value = '';
            document.getElementById('insertStart').value = '';
            document.getElementById('detailStart').value = '';
            document.getElementById('insertEnd').value = '';
            document.getElementById('detailEnd').value = '';
            document.getElementById('detailCalendarNo').value = '';
        }
    });

    // 모달 외부 클릭 시 모달 닫기
    window.onclick = function(event) {
        let modal1 = document.getElementById('insertModal');
        let modal2 = document.getElementById('detailModal');
        if (event.target === modal1) {
            modal1.style.display = 'none';
        } else if (event.target === modal2) {
            modal2.style.display = 'none';
        }
    }

    $(document).ready(function() {
        $('#calendarTable').show();
        $('#my').hide();
        $('#team').hide();
        $('#company').hide();
        $('#calendarGubun').show();
    });

    function calendarSearch() {
        var gubunValue = document.getElementById('gubun').value;
        var calendarGubunValue = document.getElementById('calendarGubun').value;

        if (gubunValue === 'my') {
            if (calendarGubunValue === 'calendarTable') {
                window.location.href = '/calendar/myList';
            } else if (gubunValue === 'team ') {
                if (calendarGubunValue === 'calendarTable') {
                    window.location.href = '/calendar/teamList';
                } else {
                    window.location.href = '/calendar/companyList';
                }
            }
        }
    }
</script>
    <div class="content-wrapper">

        <div style="width: 100%; height: 100px; padding-left: 24px; padding-right: 24px; padding-top: 16px; padding-bottom: 16px; flex-direction: column; justify-content: flex-start; align-items: flex-start; display: inline-flex">
            <div style="justify-content: flex-end; align-items: center; display: inline-flex; flex-direction: row-reverse;">
                <div style="justify-content: flex-start; align-items: center; display: flex">
                    <div style="color: rgba(0, 0, 0, 0.45); font-size: 14px; font-family: Roboto; font-weight: 400; line-height: 22px; word-wrap: break-word">일정</div>
                </div>
                <div style="padding-left: 8px; padding-right: 8px; flex-direction: column; justify-content: flex-start; align-items: center; gap: 10px; display: inline-flex">
                    <div style="color: rgba(0, 0, 0, 0.45); font-size: 14px; font-family: Roboto; font-weight: 400; line-height: 22px; word-wrap: break-word">></div>
                </div>
                <div style="justify-content: flex-start; align-items: center; display: flex">
                    <div style="color: rgba(0, 0, 0, 0.85); font-size: 14px; font-family: Roboto; font-weight: 400; line-height: 22px; word-wrap: break-word">내 일정</div>
                </div>
            </div>
            <div style="padding-top: 14px; padding-bottom: 6px; justify-content: flex-start; align-items: center; gap: 16px; display: inline-flex">
                <div style="width: 16.25px; height: 16px; position: relative">
                    <div style="width: 13.35px; height: 12.71px; left: 1.45px; top: 1.64px; position: absolute; background: rgba(0, 0, 0, 0.85)"></div>
                </div>
                <div style="justify-content: flex-start; align-items: center; gap: 12px; display: flex">
                    <div style="color: rgba(0, 0, 0, 0.85); font-size: 20px; font-family: Roboto; font-weight: 700; line-height: 28px; word-wrap: break-word">내 일정 현황</div>
                    <div style="color: rgba(0, 0, 0, 0.45); font-size: 14px; font-family: Roboto; font-weight: 400; line-height: 22px; word-wrap: break-word">내 일정 현황을 조회할 수 있는 페이지입니다.</div>
                </div>
            </div>
        </div>

        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="container-fluid1">
                            <h2 class="cal_title">내 일정 현황</h2>
                            <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary col-md-1" id="addEvent" name="addEvent" value="일정 등록"/>
                        </div>
                        <hr />

                        <%-- 캘린더 태그 --%>
                        <div id="calendar"></div>
                        <div class="checkbox-container">

                            <div>
                                <input type="checkbox" class="form-check-input" id="teamCal" name="teamCal" value="teamCal">
                                <label for="teamCal">팀 일정</label>
                            </div>

                            <div>
                                <input type="checkbox" class="form-check-input" id="comCal" name="comCal" value="comCal">
                                <label for="comCal">전사 일정</label>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </section>

        <%
            // 현재 날짜 가져오기
            Date today = new Date();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String todayDate = dateFormat.format(today);
        %>

        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <%-- 내 일정 현황 태그 --%>
                        <div class="container-fluid1">
                            <h2 class="cal_title">오늘 내 일정</h2>
                            <!-- 검색기 시작 -->
                            <div class="row search">
                                <div class="col-2">
                                    <select id="gubun" class="form-select" aria-label="분류선택">
                                        <option value="my">내 일정</option>
                                        <option value="team">팀 일정</option>
                                        <option value="company">전사 일정</option>
                                    </select>
                                </div>
                                <div class="col-2">
                                    <select id="calendarGubun" class="form-select" aria-label="분류선택">
                                        <option value="calendarTable">참석자</option>
                                        <option value="calendarTable">날짜</option>
                                    </select>
                                </div>
                                <div class="col-7">
                                    <input type="text" id="keyword" class="form-control" placeholder="검색어를 입력하세요"
                                           aria-label="검색어를 입력하세요" aria-describedby="btn_search" onkeyup="searchEnter()"/>
                                </div>
                                <div class="col-1">
                                    <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" id="searchEvent" name="searchEvent" value="검색" onclick="calendarSearch()"/>
                                </div>
                            </div>
                        </div>

                        <div class="container-fluid">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">참석자</th>
                                    <th scope="col">일정 구분</th>
                                    <th scope="col">일정명</th>
                                    <th scope="col">일정시간</th>
                                    <th scope="col">취소</th>
                                </tr>
                                </thead>
                                <tbody id="calendarTableBody">
                                <% List<CalendarVO> myCalendarList1 = (List<CalendarVO>) request.getAttribute("myCalendarList");
                                    if (myCalendarList1 != null) {
                                        int count = 0; // 일정 카운터 변수 추가
                                        for (CalendarVO vo : myCalendarList1) {
                                         if (Objects.equals(sessionVO.getName(), vo.getName())) {
                                            String startDateCheck = vo.getCalendar_start().split("T")[0]; // 일정 시작일자만 추출
                                            String endDateCheck = vo.getCalendar_end().split("T")[0]; // 일정 종료일자만 추출
                                            String startDate = vo.getCalendar_end();
                                            String endDate = vo.getCalendar_end();
                                            // 오늘 날짜와 시작일 또는 종료일이 일치하거나 오늘 날짜가 시작일과 종료일 사이에 있는 경우에만 출력
                                            if (startDateCheck.equals(todayDate) || endDateCheck.equals(todayDate) || (startDateCheck.compareTo(todayDate) < 0 && endDateCheck.compareTo(todayDate) > 0)) {
                                %>
                                <tr>
                                    <th scope="row"><%= ++count %></th> <!-- 일정 번호 출력 -->
                                    <td><%= vo.getName() %></td>
                                    <td>내 일정</td>
                                    <td><%= vo.getCalendar_title() %></td>
                                    <td><%= startDate + "~" + endDate %></td>
                                    <td><button class="btn btn-danger cancel-button" style="background-color: #652C2C;">취소</button></td>
                                </tr>
                                <%}
                                }
                                }
                                }
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 일정등록 모달 -->
        <div class="modal " id="insertModal">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content rounded-4 shadow">
                    <div class="modal-header p-5 pb-2 border-bottom-0">
                        <h1 class="fw-bold mb-0 fs-2">일정 등록</h1>
                    </div>
                    <div class="modal-body p-5 pt-0">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="insertTitle" name="insertTitle" placeholder="일정명">
                            <label for="insertTitle">일정명</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="insertName" name="insertName" placeholder="참석자" value="<%=sessionVO.getName()%>">
                            <label for="insertName">참석자</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="insertStart" name="insertStart">
                            <label for="insertStart">일정 시작</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="insertEnd" name="insertEnd">
                            <label for="insertEnd">일정 종료</label>
                        </div>
                        <select class="form-control" id="insertCalendarId" name="insertCalendarId">
                            <option value="0" selected>일정을 선택하세요.</option>
                            <option value="1">내일정</option>
                            <option value="2">팀일정</option>
                            <option value="3">전사일정</option>
                        </select>
                        <br>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" id="submitEvent" name="submitEvent" value="등록"/>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-secondary close" id="exitEvent" name="exitEvent" value="취소"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- 일정 수정/삭제 모달 -->
        <div class="modal " id="detailModal">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content rounded-4 shadow">
                    <div class="modal-header p-5 pb-4 border-bottom-0">
                        <h1 class="fw-bold mb-0 fs-2">일정 상세</h1>
                    </div>
                    <div class="modal-body p-5 pt-0">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailTitle" name="detailTitle" placeholder="일정명">
                            <label for="detailTitle">일정명</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailName" name="detailName" placeholder="참석자" value="<%=sessionVO.getName()%>">
                            <label for="detailName">참석자</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailCalendarNo" name="detailCalendarNo" placeholder="일정 번호">
                            <label for="detailCalendarNo">일정 번호</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="detailStart" name="detailStart">
                            <label for="detailStart">일정 시작</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="detailEnd" name="detailEnd">
                            <label for="detailEnd">일정 종료</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailCalendarId" name="detailCalendarId" placeholder="일정 ID">
                            <label for="detailCalendarId">일정 ID</label>
                        </div>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" id="updateEvent" name="updateEvent" value="수정"/>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" id="deleteEvent" name="deleteEvent" value="삭제"/>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-secondary close" id="exitEvent2" name="exitEvent" value="취소"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
