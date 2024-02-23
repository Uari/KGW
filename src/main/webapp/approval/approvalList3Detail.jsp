<%@ page language="java" contentType="text/html;charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>{임시보관함 상세} -휴가</title>


    <%--  <script type="text/javascript">--%>

    <%--	const searchEnter = (event)=> {--%>
    <%--		console.log('searchEnter')--%>
    <%--		console.log(window.event.keyCode); // 13--%>
    <%--		if(window.event.keyCode==13){--%>
    <%--			boardSearch(); // 재사용성 ---%>
    <%--		}--%>
    <%--	}--%>
    <%--	const boardSearch = () => {--%>
    <%--		console.log('boardSearch');--%>
    <%--		const gubun = document.querySelector("#gubun").value;--%>
    <%--		const keyword = document.querySelector("#keyword").value;--%>
    <%--		console.log(`${gubun} , ${keyword}`);--%>
    <%--		location.href="/board/boardList?gubun="+gubun+"&keyword="+keyword;--%>
    <%--	}--%>
    <%--  	const boardList = () => {--%>
    <%--  		location.href="/board/boardList";--%>
    <%--  	}--%>
    <%--  	const boardInsert = () => {--%>
    <%--  		document.querySelector("#f_board").submit(); // form태그에 묶인 컴포넌트 값들이 전송됨--%>
    <%--  	}--%>
    <%--	const boardDetail = (b_no) => {--%>
    <%--		location.href = "/board/boardDetail?b_no="+b_no;--%>
    <%--	}--%>
    <%--  </script>--%>
</head>

<body>
<div class="wrapper">
    <!-- header start -->
    <%@include file="/include/KGW_bar.jsp"%>
    <!-- header end    -->

    <!-- body start    -->
    <div class="content-wrapper">
        <!-- 페이지 path start    -->
        <%--		<div class="card" >--%>
        <div class="box-header p-4" >
            <div class="d-flex align-items-center">
                <div class="d-flex align-items-center me-2">
                    <a class="text-muted fs-6" href="#">전자결재</a>
                    <div class="ms-2">></div>
                </div>
                <div class="d-flex align-items-center">
                    <div class="text-dark fs-6">임시보관함</div>
                </div>
            </div>
            <div class="d-flex align-items-center mt-2">
                <div class="position-relative">
                    <div class="position-absolute top-0 start-0" ></div>
                </div>
                <div class="d-flex align-items-center ms-2">
                    <div class="fw-bold fs-5">임시보관함</div>
                    <div class="text-muted ms-3">임시보관문서   상세정보 조회할수 있는 페이지입니다.</div>
                </div>
            </div>
        </div>
        <!-- 페이지 path end -->

        <!-- Main content -->
        <section class="content">
            <!-- Info boxes -->
            <div class="row">
                <div class="col-md-12">
                    <div class="box">
                        <div class="container">
                            <div class="box-header">
                                <h4 style="font-weight: bold; margin-left: 1.5rem" >임시보관문서 상세 </h4>
                                <hr />
                            </div>

                            <!-- 검색기 시작 !! div 안에 있는 태그 건들지마시오!! -->
                            <div class="row">

                                <div class="col-md-6 d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#boardForm">임시보관함</button>
                                    <button id="btn_search2" class="btn btn-danger" onclick="boardSearch()">기안문서 </button>
                                </div>
                                <div class="frame " id="do_vocation">   <%--휴가문서--%>
                                    <div class="document-section">
                                        <div class="item">
                                            <span class="title">부서:</span>
                                            <input type="text" class="value-input" id="va_department" value="자동불러옴" readonly>
                                        </div>
                                        <div class="item">
                                            <span class="title">담당자:</span>
                                            <input type="text" class="value-input" id="va_manager" value="자동불러옴" readonly>
                                        </div>
                                        <div class="item">
                                            <span class="title">신청자:</span>
                                            <input type="text" class="value-input" id="va_applicant" value="자동불러옴" readonly>
                                        </div>
                                        <div class="item">
                                            <span class="title">휴가 사유:{insert}</span>
                                            <select id="leaveReason">
                                                <option value="sickLeave">병가</option>
                                                <option value="annualLeave">연차</option>
                                                <option value="familyEvent">경조사</option>
                                            </select>
                                        </div>
                                        <div class="item">
                                            <span class="title">휴가시작일:{insert}</span>
                                            <input type="date" id="startDate" value="2024-01-12">
                                        </div>
                                        <div class="item">
                                            <span class="title">휴가만료일:{insert}</span>
                                            <input type="date" id="endDate" value="2024-01-15">
                                        </div>
                                        <div    class="text-wrapper-2">상기와 같이 휴가  희망함</div>
                                    </div>
                                </div>


                                <div  id ="documentButton" class="col-md-6 d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#boardForm">재출</button>
                                    <button id="btn_search3" class="btn btn-danger" onclick="Search()">삭제 </button>
                                </div>
                        </div>
                    </div>
                </div>
            </div>


    </div>
    <!-- content-wrapper end-->
<!-- body end   -->



<!-- ========================== [[ 게시판 Modal ]] ========================== -->
<%--	<div class="modal" id="boardForm">--%>
<%--  		<div class="modal-dialog modal-dialog-centered">--%>
<%--	<div class="modal-content">--%>

<%--	  <!-- Modal Header -->--%>
<%--	  <div class="modal-header">--%>
<%--		<h4 class="modal-title">게시판</h4>--%>
<%--		<button type="button" class="btn-close" data-bs-dismiss="modal"></button>--%>
<%--	  </div>--%>
<%--	  <!-- Modal body -->--%>
<%--	  <div class="modal-body">--%>
<%--		<!-- <form id="f_board" method="get" action="./boardInsert"> -->--%>
<%--		<form id="f_board" method="post" enctype="multipart/form-data" action="./boardInsert">--%>
<%--		  <input type="hidden" name="method" value="boardInsert">--%>
<%--		  <div class="form-floating mb-3 mt-3">--%>
<%--			<input type="text"  class="form-control" id="b_title" name="b_title" placeholder="Enter 제목" />--%>
<%--			<label for="b_title">제목</label>--%>
<%--		  </div>--%>
<%--		  <div class="form-floating mb-3 mt-3">--%>
<%--			<input type="text"  class="form-control" id="b_writer" name="b_writer" placeholder="Enter 작성자" />--%>
<%--			<label for="b_writer">작성자</label>--%>
<%--		  </div>--%>
<%--		  <div class="form-floating mb-3 mt-3">--%>
<%--			<textarea rows="5" class="form-control h-25" aria-label="With textarea" id="b_content" name="b_content"></textarea>--%>
<%--		  </div>--%>
<%--		  <div class="input-group mb-3">--%>
<%--			  <input type="file" class="form-control" id="b_file" name="b_file">--%>
<%--			  <label class="input-group-text" for="b_file">Upload</label>--%>
<%--		  </div>--%>
<%--		</form>--%>
<%--	  </div>--%>
<%--	  <div class="modal-footer">--%>
<%--		<input type="button" class="btn btn-warning" data-bs-dismiss="modal" onclick="boardInsert()"  value="저장">--%>
<%--		<input type="button" class="btn btn-danger" data-bs-dismiss="modal" value="닫기">--%>
<%--	  </div>--%>
<!-- ========================== [[ 게시판 Modal ]] ========================== -->
</body>
</html>