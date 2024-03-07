<%@ page import="java.util.List" %>
<%@ page import="com.vo.CalendarVO" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Objects" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
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
    <link rel="stylesheet" href="/css/reservation.css" />
    <!-- fullcalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar-scheduler@5.10.1/main.min.css" rel="stylesheet">
</head>

<body class="hold-transition sidebar-mini sidebar-collapse">
<div class="wrapper">
    <%@include file="/include/KGW_bar.jsp"%>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            let calendarEl = document.getElementById('calendar1');
            let calendar;
            if (calendarEl) {
                calendar = new FullCalendar.Calendar(calendarEl, {
                    initialView: 'resourceTimelineDay',
                    resourceAreaWidth: '100px',
                    expandRows: false,
                    aspectRatio: 1,
                    headerToolbar: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'resourceTimelineDay,resourceTimelineWeek,resourceTimelineMonth,listWeek',
                    },
                    navLinks: true,
                    editable: true,
                    selectable: true,
                    nowIndicator: true,
                    resourceAreaHeaderContent: '',
                    height: 'auto',
                    locale: 'ko',

                    // 타임라인 드래그 이벤트
                    select: function(arg) {
                        if (detailStart && detailEnd == !null) {
                            let modal = document.getElementById('detailModal');
                            modal.style.display = 'block';

                            let startInput = document.getElementById('detailStart');
                            let endInput = document.getElementById('detailEnd');
                            let resourceIdInput = document.getElementById('detailResourceId');
                            let detailAssetNoInput = document.getElementById('detailAssetNo');

                            let startTime = moment(arg.start, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');
                            let endTime = moment(arg.end, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');

                            startInput.value = startTime;
                            endInput.value = endTime;
                            resourceIdInput.value = arg.resource.id;
                            detailAssetNoInput.value = arg.id;
                            console.log(arg.id);
                        } else {
                            let modal = document.getElementById('insertModal');
                            modal.style.display = 'block';

                            let startInput = document.getElementById('insertStart');
                            let endInput = document.getElementById('insertEnd');
                            let resourceIdInput = document.getElementById('insertResourceId');

                            let startTime = moment(arg.start, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');
                            let endTime = moment(arg.end, 'Asia/Seoul').format('YYYY-MM-DDTHH:mm');

                            startInput.value = startTime;
                            endInput.value = endTime;
                            resourceIdInput.value = arg.resource.id;
                        }
                    },


                    eventClick: function(info) {
                        if(detailStart && detailEnd != null) {
                            let modal = document.getElementById('detailModal');
                            modal.style.display = 'block';

                            let detailTitleInput = document.getElementById('detailTitle');
                            let detailStartInput = document.getElementById('detailStart');
                            let detailEndInput = document.getElementById('detailEnd');
                            let detailResourceIdInput = document.getElementById('detailResourceId');
                            let detailAssetNoInput = document.getElementById('detailAssetNo');
                            let detailReservationNoInput = document.getElementById('detailReservationNo');

                            // FullCalendar의 함수를 사용하여 정보 가져오기
                            let event = info.event;
                            detailTitleInput.value = event.title;
                            detailAssetNoInput.value = event.id;

                            detailReservationNoInput.value = event.extendedProps.reservationNo;

                            // 이벤트의 리소스 가져오기
                            let resource = event.getResources()[0]; // 이벤트가 하나의 리소스에만 할당되었다고 가정합니다.

                            if (resource) {
                                detailResourceIdInput.value = resource.id;
                            } else {
                                console.error('Resource not found.');
                                detailResourceIdInput.value = '';
                            }
                            // moment.js를 사용하여 시간 형식 맞추기
                            detailStartInput.value = moment(event.start).format('YYYY-MM-DDTHH:mm');
                            detailEndInput.value = moment(event.end).format('YYYY-MM-DDTHH:mm');
                        }else{
                            let modal = document.getElementById('insertModal');
                            modal.style.display = 'block';

                            let insertTitleInput = document.getElementById('insertTitle');
                            let insertStartInput = document.getElementById('insertStart');
                            let insertEndInput = document.getElementById('insertEnd');
                            let insertResourceIdInput = document.getElementById('insertResourceId');
                            let insertAssetNoInput = document.getElementById('insertAssetNo');
                            let insertReservationNoInput = document.getElementById('insertReservationNo');

                            // FullCalendar의 함수를 사용하여 정보 가져오기
                            let event = info.event;
                            insertTitleInput.value = event.title;
                            insertAssetNoInput.value = event.id;

                            insertReservationNoInput.value = event.extendedProps.reservationNo;


                            // 이벤트의 리소스 가져오기
                            let resource = event.getResources()[0]; // 이벤트가 하나의 리소스에만 할당되었다고 가정합니다.

                            if (resource) {
                                insertResourceIdInput.value = resource.id;
                            } else {
                                console.error('Resource not found.');
                                insertResourceIdInput.value = '';
                            }
                            // moment.js를 사용하여 시간 형식 맞추기
                            insertStartInput.value = moment(event.start).format('YYYY-MM-DDTHH:mm');
                            insertEndInput.value = moment(event.end).format('YYYY-MM-DDTHH:mm');
                        }
                    },
                    resources: [
                        <%
                            int team_no_value = sessionVO.getTeam_no(); // 기존에 선언된 변수를 사용하도록 수정
                            System.out.println("assetReservation="+team_no_value);
                            List<CalendarVO> assetList1 = (List<CalendarVO>) request.getAttribute("assetList1");
                            List<CalendarVO> assetList2 = (List<CalendarVO>) request.getAttribute("assetList2");
                            if (team_no_value == 2 && assetList1 != null) {
                                for (CalendarVO vo : assetList1) {
                        %>
                        {
                            id: '<%= vo.getAsset_id()%>',
                            title : '<%= vo.getAsset_name() %>',
                        },
                        <%
                                }
                            } else if (team_no_value != 2 && assetList2 != null) {
                                for (CalendarVO vo : assetList2) {
                        %>
                        {
                            id: '<%= vo.getAsset_id()%>',
                            title : '<%= vo.getAsset_name() %>',
                        },
                        <%
                                }
                            }
                        %>
                    ],
                    events: [
                        <%
                            List<CalendarVO> assetReservationList = (List<CalendarVO>) request.getAttribute("assetReservationList");
                             if (assetReservationList != null) {
                               for (CalendarVO vo1 : assetReservationList) {
                        %>
                        {
                            id: '<%= vo1.getAsset_no() %>', // 이벤트의 고유 ID
                            extendedProps: { reservationNo: '<%= vo1.getReservation_no() %>' }, // 예약 정보를 사용자 정의 속성 extendedProps에 포함 (events 배열에서 각 이벤트 객체의 extendedProps를 설정하여 확장 속성을 추가)
                            resourceId: '<%= vo1.getAsset_id() %>',
                            title: '<%= vo1.getReservation_title() %>',
                            start: '<%= vo1.getReservation_start() %>',
                            end: '<%= vo1.getReservation_end() %>',
                            color: '<%= vo1.getAsset_color() %>'
                        },
                        <%
                        }}
                        %>
                    ]
                });
                console.log(<%= sessionVO.getEmp_no() %>);
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
            searchBtn.addEventListener('click', reservationSearch);
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
                let titleInput = document.getElementById('insertTitle');
                let startInput = document.getElementById('insertStart');
                let endInput = document.getElementById('insertEnd');
                let resourceIdInput = document.getElementById('insertResourceId');
                let assetNoInput = document.getElementById('insertAssetNo');

                let reservation_title = titleInput.value;
                let reservation_start = startInput.value;
                let reservation_end = endInput.value;
                let emp_no = <%= sessionVO.getEmp_no() %>;
                let asset_id = resourceIdInput.value;
                let asset_no = assetNoInput.value;
                let url = '/assetReservation/insertReservation';

                // 필수 값이 모두 입력되었는지 확인
                if (reservation_title && reservation_start && reservation_end && emp_no && asset_id && asset_no) {
                    // SweetAlert로 등록 여부 확인
                    Swal.fire({
                        title: "예약을 등록하시겠습니까?",
                        icon: "question",
                        showCancelButton: true,
                        confirmButtonColor: '#7c1512',
                        cancelButtonColor: '#7c1512',
                        confirmButtonText: '등록',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                type: "POST",
                                url: url,
                                data: {
                                    reservation_title: reservation_title,
                                    reservation_start: reservation_start,
                                    reservation_end: reservation_end,
                                    emp_no: emp_no,
                                    asset_id: asset_id,
                                    asset_no: asset_no
                                },
                                success: function(response) {
                                    console.log(response);
                                    if (response > 0) {
                                        if (window.opener) window.opener.location.reload(true);
                                        window.location.href = '${pageContext.request.contextPath}' + '/assetReservation/assetReservationList';

                                        Swal.fire({
                                            title: "예약이 등록되었습니다.",
                                            icon: "success",
                                        });
                                    }
                                },
                                error: function(request, status, error) {
                                    console.error("오류 발생 >> " + error);
                                }
                            });
                        }
                    });
                } else {
                    // 필수 값이 입력되지 않은 경우 알림 표시
                    Swal.fire({
                        title: "필수 항목을 모두 입력해주세요.",
                        icon: "warning",
                    });
                }

                // 모달 숨기기
                let modal = document.getElementById('insertModal');
                modal.style.display = 'none';
                closeModalAndClearInputs();
            }

            function handleEventDelete() {
                let reservationNoInput = document.getElementById('detailReservationNo');
                let reservation_no = reservationNoInput.value;
                let url = '<%=request.getContextPath()%>/assetReservation/deleteReservation';

                if (reservation_no) {
                    // SweetAlert로 삭제 여부 확인
                    Swal.fire({
                        title: "예약을 삭제하시겠습니까?",
                        icon: "question",
                        showCancelButton: true,
                        confirmButtonColor: '#7c1512',
                        cancelButtonColor: '#7c1512',
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                type: "POST",
                                url: url,
                                data: {
                                    reservation_no: reservation_no,
                                    // asset_no: asset_no
                                },
                                success: function(response) {
                                    console.log(response);
                                    if (response > 0) {
                                        if (window.opener) window.opener.location.reload(true);
                                        window.location.href = '${pageContext.request.contextPath}' + '/assetReservation/assetReservationList';

                                        Swal.fire({
                                            title: "예약이 삭제되었습니다.",
                                            icon: "success",
                                        });
                                    }
                                },
                                error: function(request, status, error) {
                                    console.error("오류 발생 >> " + error);
                                }
                            });
                        }
                    });
                }
                closeModalAndClearInputs();
                // 모달 숨기기
                let modal = document.getElementById('detailModal');
                modal.style.display = 'none';
            }

            function handleEventUpdate() {
                let titleInput = document.getElementById('detailTitle');
                let startInput = document.getElementById('detailStart');
                let endInput = document.getElementById('detailEnd');
                let assetNoInput = document.getElementById('detailAssetNo');
                let reservationNoInput = document.getElementById('detailReservationNo');

                let reservation_title = titleInput.value;
                let reservation_start = startInput.value;
                let reservation_end = endInput.value;
                let emp_no = <%= sessionVO.getEmp_no() %>;
                let asset_no = assetNoInput.value;
                let reservation_no = reservationNoInput.value;
                let url = "/assetReservation/updateReservation";

                if (reservation_title && reservation_start && reservation_end && emp_no && asset_no && reservation_no) {
                    // SweetAlert로 수정 여부 확인
                    Swal.fire({
                        title: "예약을 수정하시겠습니까?",
                        icon: "question",
                        showCancelButton: true,
                        confirmButtonColor: '#7c1512',
                        cancelButtonColor: '#7c1512',
                        confirmButtonText: '수정',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                type: "POST",
                                url: url,
                                data: {
                                    reservation_title: reservation_title,
                                    reservation_start: reservation_start,
                                    reservation_end: reservation_end,
                                    emp_no: emp_no,
                                    asset_no : asset_no,
                                    reservation_no: reservation_no
                                },
                                success: function(response) {
                                    console.log(response);
                                    if (response > 0) {
                                        if (window.opener) window.opener.location.reload(true);
                                        window.location.href = '${pageContext.request.contextPath}' + '/assetReservation/assetReservationList';

                                        Swal.fire({
                                            title: "예약이 수정되었습니다.",
                                            icon: "success",
                                        });
                                    }
                                },
                                error: function(request, status, error) {
                                    console.error("오류 발생 >> " + error);
                                }
                            });
                        }
                    });
                }
                closeModalAndClearInputs();
                // 모달 숨기기
                let modal = document.getElementById('detailModal');
                modal.style.display = 'none';
            }


            let cancelTodayButton = document.querySelectorAll('.cancel-button');

            cancelTodayButton.forEach(function(cancelButton) {
                cancelButton.addEventListener('click', function() {
                    let reservationNoInput = document.getElementById('reservNo');
                    if (reservationNoInput !== null) {
                        let reservation_no = reservationNoInput.textContent;

                        if (reservation_no) {
                            // SweetAlert로 삭제 여부 확인
                            Swal.fire({
                                title: "일정을 삭제하시겠습니까?",
                                icon: "warning",
                                showCancelButton: true,
                                confirmButtonColor: '#7c1512',
                                cancelButtonColor: '#7c1512',
                                confirmButtonText: '삭제',
                                cancelButtonText: '취소'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    // 사용자가 삭제를 선택한 경우, AJAX를 통해 삭제 요청
                                    let url = "<%=request.getContextPath()%>/assetReservation/deleteTodayReservation";

                                    $.ajax({
                                        type: "POST",
                                        url: url,
                                        data: { calendar_no: calendar_no },
                                        success: function(response) {
                                            console.log(response);
                                            if (response > 0) {
                                                if (window.opener) window.opener.location.reload(true);
                                                window.location.href = '${pageContext.request.contextPath}' +'/assetReservation/assetReservationList';                                     Swal.fire({
                                                    title: "일정이 삭제되었습니다.",
                                                    icon: "success",
                                                });
                                            }
                                        },
                                        error: function(request, status, error) {
                                            console.error("오류 발생 >> " + error);
                                        }
                                    });
                                }
                            });
                        }
                    }
                });
            });

            // 차량 예약 체크박스 클릭 시 링크로 이동
            document.getElementById('assetReserv').addEventListener('change', function() {
                if (this.checked) {
                    window.location.href = '../vehicleReservation/vehicleReservationList';
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
                document.getElementById('detailReservationNo').value = '';
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

        function searchEnter(event){
            if(window.event.keyCode == 13){
                reservationSearch()
            }
        }

        function reservationSearch() {
            console.log('reservationSearch');
            const gubun = document.querySelector("#gubun").value;
            const keyword = document.querySelector("#keyword").value;

            console.log(`${gubun} , ${keyword}`);

            let searchURL = "/assetReservation/assetReservationList?gubun=" + gubun;

            if (keyword.trim() === '') {
                Swal.fire({
                    icon: 'warning',
                    title: '검색어를 입력하세요',
                    text: '검색어를 입력하지 않으면 검색할 수 없습니다.',
                    confirmButtonText: '확인'
                });
            } else {
                searchURL += "&keyword=" + keyword;
                location.href = searchURL;
            }
        }
    </script>
    <div class="content-wrapper">

        <div class="box-header p-4">
            <div class="d-flex align-items-center">
                <div class="d-flex align-items-center me-2">
                    <a class="text-muted fs-6" href="/">예약현황</a>
                    <div class="ms-2">></div>
                </div>
                <div class="d-flex align-items-center">
                    <div class="text-dark fs-6">예약</div>
                </div>
            </div>
            <div class="d-flex align-items-center mt-3">
                <div class="position-relative">
                    <div class="position-absolute top-0 start-0"></div>
                </div>
                <div class="d-flex align-items-center ms-2">
                    <div class="fw-bold fs-5">자산예약 현황</div>
                    <div class="text-muted ms-3">자산예약 현황을 조회할 수 있는 페이지입니다.</div>
                </div>
            </div>
        </div>


        <section class="content">
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="container-fluid1">
                            <h4 class="cal_title">자산 예약 현황</h4>
                            <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary col-md-1" id="addEvent" name="addEvent" value="예약 등록"/>
                        </div>
                        <hr />

                        <%-- 캘린더 태그 --%>
                        <div id="calendar1"></div>
                        <div class="checkbox-container">
                            <div>
                                <input type="checkbox" class="form-check-input" id="assetReserv" name="assetReserv" value="assetReserv">
                                <label for="assetReserv">차량 예약</label>
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
                        <%-- 내 예약 현황 태그 --%>
                        <div class="container-fluid1">
                            <h4 class="cal_title">나의 예약 현황</h4>
                            <!-- 검색기 시작 -->
                            <div class="row search">
                                <div class="col-3">
                                    <select id="gubun" class="form-select" aria-label="분류선택">
                                        <option value="name">예약자</option>
                                        <option value="reservation_title">예약명</option>
                                        <option value="reservation_start">시작일</option>
                                        <option value="reservation_end">종료일</option>
                                    </select>
                                </div>
                                <div class="col-7">
                                    <input type="text" id="keyword" class="form-control" placeholder="검색어를 입력하세요"
                                           aria-label="검색어를 입력하세요" aria-describedby="btn_search" onkeyup="searchEnter()"/>
                                </div>
                                <div class="col-2">
                                    <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" id="searchEvent" name="searchEvent" value="검색" style="border-radius: 3px;" onclick="reservationSearch()"/>
                                </div>
                            </div>
                        </div>

                        <div class="container-fluid">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">예약자산</th>
                                    <th scope="col">예약자</th>
                                    <th scope="col">예약명</th>
                                    <th scope="col">시작시간</th>
                                    <th scope="col">종료시간</th>
                                    <th scope="col">취소</th>
                                </tr>
                                </thead>
                                <tbody id="reservationTableBody">
                                <% List<CalendarVO> assetReservationList1 = (List<CalendarVO>) request.getAttribute("assetReservationList");
                                    if (assetReservationList1 != null) {
                                        int count = 0; // 예약 카운터 변수 추가
                                        for (CalendarVO vo : assetReservationList1) {
                                            if (Objects.equals(sessionVO.getName(), vo.getName())) {
                                                String startDateCheck = vo.getReservation_start().split("T")[0]; // 예약 시작일자만 추출
                                                String endDateCheck = vo.getReservation_end().split("T")[0]; // 예약 종료일자만 추출
                                                String startDate = vo.getReservation_start().replace("T", "&nbsp;"); // T를 공백으로 대체
                                                String endDate = vo.getReservation_end().replace("T", "&nbsp;"); // T를 공백으로 대체
                                                if (startDateCheck.equals(todayDate) || endDateCheck.equals(todayDate) || (startDateCheck.compareTo(todayDate) < 0 && endDateCheck.compareTo(todayDate) > 0)) { // 오늘 날짜와 시작일 또는 종료일이 일치하거나 오늘 날짜가 시작일과 종료일 사이에 있는 경우에만 출력
                                %>
                                <tr>
                                    <th scope="row"><%= ++count %></th>
                                    <%-- 화면엔 필요없지만 서버에 전송할 데이터 --%>
                                    <td class="reservNo" id="reservNo" style="display: none;"><%= vo.getReservation_no() %></td>
                                    <td><%= vo.getAsset_no() %></td>
                                    <td><%= vo.getName() %></td>
                                    <td><%= vo.getReservation_title() %></td>
                                    <td><%= startDate%></td>
                                    <td><%= endDate %></td>
                                    <td><input type="button" class="btn btn-danger cancel-button" id="cancel-button" value="취소"/></td>
                                </tr>
                                <%
                                                }}}}
                                %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- 예약등록 모달 -->
        <div class="modal " id="insertModal">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content rounded-4 shadow">
                    <div class="modal-header p-5 pb-2 border-bottom-0">
                        <h1 class="fw-bold mb-0 fs-2">예약 등록</h1>
                    </div>
                    <div class="modal-body p-5 pt-0">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="insertTitle" name="insertTitle" placeholder="예약명">
                            <label for="insertTitle">예약명</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="insertName" name="insertName" placeholder="예약자" value="<%=sessionVO.getName()%>">
                            <label for="insertName">예약자</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="insertStart" name="insertStart">
                            <label for="insertStart">예약 시작</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="insertEnd" name="insertEnd">
                            <label for="insertEnd">예약 종료</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="insertResourceId" name="insertResourceId" placeholder="시설 ID">
                            <label for="insertResourceId">시설 ID</label>
                        </div>
                        <select class="form-control" id="insertAssetNo" name="insertAssetNo">
                            <% if(sessionVO.getTeam_no() == 2){ %>
                            <option value="0" selected>자산을 선택하세요.</option>
                            <option value="101">대회의실 A</option>
                            <option value="102">대회의실 B</option>
                            <option value="103">소회의실 A</option>
                            <option value="104">소회의실 B</option>
                            <option value="105">소회의실 C</option>
                            <option value="106">미팅룸 A</option>
                            <option value="107">미팅룸 B</option>
                            <option value="108">선수훈련실 A</option>
                            <option value="109">선수훈련실 B</option>
                            <option value="110">선수훈련실 C</option>
                            <option value="111">물리치료실A</option>
                            <option value="112">물리치료실B</option>
                            <option value="113">물리치료실C</option>
                            <% } else { %>
                            <option value="0" selected>자산을 선택하세요.</option>
                            <option value="101">대회의실 A</option>
                            <option value="102">대회의실 B</option>
                            <option value="103">소회의실 A</option>
                            <option value="104">소회의실 B</option>
                            <option value="105">소회의실 C</option>
                            <option value="106">미팅룸 A</option>
                            <option value="107">미팅룸 B</option>
                            <% } %>
                        </select>

                        <br>
                        <%--                        <div class="form-floating mb-3">--%>
                        <%--                            <input type="text" class="form-control rounded-3" id="insertAssetNo" name="insertAssetNo" placeholder="시설 고유ID">--%>
                        <%--                            <label for="insertAssetNo">시설 고유ID</label>--%>
                        <%--                        </div>--%>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-primary" id="submitEvent" name="submitEvent" value="등록"/>
                        <input type="button" class="w-100 mb-2 btn btn-lg rounded-3 btn-secondary close" id="exitEvent" name="exitEvent" value="취소"/>
                    </div>
                </div>
            </div>
        </div>

        <!-- 예약 수정/삭제 모달 -->
        <div class="modal " id="detailModal">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content rounded-4 shadow">
                    <div class="modal-header p-5 pb-4 border-bottom-0">
                        <h1 class="fw-bold mb-0 fs-2">예약 상세</h1>
                    </div>
                    <div class="modal-body p-5 pt-0">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailTitle" name="detailTitle" placeholder="예약명">
                            <label for="detailTitle">예약명</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailName" name="detailName" placeholder="예약자" value="<%=sessionVO.getName()%>">
                            <label for="detailName">예약자</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailReservationNo" name="detailReservationNo" placeholder="예약 번호">
                            <label for="detailReservationNo">예약 번호</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="detailStart" name="detailStart">
                            <label for="detailStart">예약 시작</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="datetime-local" class="form-control rounded-3" id="detailEnd" name="detailEnd">
                            <label for="detailEnd">예약 종료</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailResourceId" name="detailResourceId" placeholder="시설 ID">
                            <label for="detailResourceId">시설 ID</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control rounded-3" id="detailAssetNo" name="detailAssetNo" placeholder="시설 고유ID">
                            <label for="detailAssetNo">시설 고유ID</label>
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
