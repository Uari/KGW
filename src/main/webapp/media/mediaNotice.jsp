<%@ page language="java" contentType="text/html;charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.*,com.util.BSPageBar" %>
<%@ page import="com.vo.MediaNoticeVO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
  int size=0;
  List<MediaNoticeVO> mediaNoticeList = (List)request.getAttribute("mediaNoticeList");
//  out.print(mediaNoticeList);
  if(mediaNoticeList!=null){
    size = mediaNoticeList.size();
  }

  //페이징처리
  int numPerPage = 5;
  int nowPage = 0;
  if(request.getParameter("nowPage")!=null){
    nowPage = Integer.parseInt(request.getParameter("nowPage"));

  }

  SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");

%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>우리구단 소식</title>

  <!-- Google Font: Source Sans Pro -->
</head>
<script type="text/javascript">
    function searchEnter(event) {
        if (window.event.keyCode === 13) {
            mediaNoticeSearch();
        }
    }

  function mediaNoticeSearch(){
    console.log('mediaNoticeSearch');
    const gubun = document.querySelector("#gubun").value;
    const keyword = document.querySelector("#keyword").value;
    console.log(`${gubun} , ${keyword}`);
    location.href="/media/mediaNotice?gubun="+gubun+"&keyword="+keyword;
  }

  function mediaNoticeForm () {
    location.href = '/media/mediaForm.jsp';
  }
  const mediaDetail=(board_no) => {
    location.href = '/media/mediaDetail?board_no='+board_no;
  }


</script>

<body class="hold-transition sidebar-mini sidebar-collapse">
<div class="wrapper">
  <!-- header start -->
  <%@include file="/include/KGW_bar.jsp"%>
  <link rel="stylesheet" href="/css/mediaNoticeCard.css">

  <!-- header end    -->

  <!-- body start    -->
  <div class="content-wrapper">
    <!-- 페이지 path start    -->
    <!-- <div class="card"> -->
    <div class="box-header p-4">
      <div class="d-flex align-items-center">
        <div class="d-flex align-items-center me-2">
          <a class="text-muted fs-6" href="#">우리구단</a>
          <div class="ms-2">></div>
        </div>
        <div class="d-flex align-items-center">
          <div class="text-dark fs-6">우리구단 소식</div>
        </div>
      </div>
      <div class="d-flex align-items-center mt-3">
        <div class="position-relative">
          <div class="position-absolute top-0 start-0"></div>
        </div>
        <div class="d-flex align-items-center ms-2">
          <div class="fw-bold fs-5">우리구단 소식</div>
          <div class="text-muted ms-3">우리구단 소식을 조회할 수 있는 페이지입니다.</div>
        </div>
      </div>
    </div> <!-- Main content -->
    <section class="content">
      <!-- Info boxes -->
      <div class="row">
        <div class="col-md-12">
          <div class="box">
            <div class="container">
              <div class="box-header">
                <h4 style="font-weight: bold; margin-left: 2rem">우리구단 소식</h4>
                <hr/>
              </div>

              <!-- 검색기 시작 !! div 안에 있는 태그 건들지마시오!! -->
              <div class="row">
                <div class="col-2">
                  <select id="gubun" class="form-select" aria-label="분류선택">
                    <option value="none">분류선택</option>
                    <option value="board_title">제목</option>
                    <option value="name">작성자</option>
                  </select>
                </div>
                <div class="col-3">
                  <input type="text" id="keyword" class="form-control" placeholder="검색어를 입력하세요"
                         aria-label="검색어를 입력하세요." aria-describedby="btn_search" onkeyup="searchEnter()"/>
                </div>
                <div class="col-1">
                  <button id="btn_search" class="btn btn-danger" onclick="mediaNoticeSearch()">검색</button>
                </div>
                <div class="col-md-6 d-flex justify-content-end">
                  <button type="button" class="btn btn-danger" onclick="mediaNoticeForm()">글쓰기</button>
                </div>
              </div>
              <!------------------------- [[ 미디어게시판목록 시작 ]] ------------------------->
              <div class='board-list'>

                <%  for(int i = nowPage*numPerPage; i < (nowPage*numPerPage)+numPerPage; i++) {
                  if (i == size) break;
                  MediaNoticeVO mediaNoticeVO = mediaNoticeList.get(i);
                  String originalString  = mediaNoticeVO.getReg_date();
                  String newFormatString = originalString.substring(0, 10);
                %>
                <div class="card mb-3 custom-card">
                  <div class="row g-0">

                    <div class="col-md-4">
                      <%------------------------- [[ 이미지의 경로를 가져오는 코드 ]]-------------------------%>
                      <img src="/fileUpload/media/<%=mediaNoticeVO.getFilename()%>/" class="img-fluid rounded-start" alt="...이미지 없음 ">
                    </div>
                    <div class="col-md-8">
                      <div class="card-body">
                        <p class="card-link">
                          <a href="javascript:mediaDetail('<%=mediaNoticeVO.getBoard_no()%>')" class="link-styled">
                            <%=mediaNoticeVO.getBoard_title()%> [<%=mediaNoticeVO.getCommend_cnt()%>]
                          </a>
                        </p>
                        <p class="card-text">작성자 : <%=mediaNoticeVO.getName()%></p>
                        <p class="card-text">작성일 : <%=newFormatString%></p>
                        <p class="card-text">
                          <small class="text-body-secondary">조회수 : <%=mediaNoticeVO.getBoard_hit()%></small>
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
                <%
                  }
                %>
                <hr/>
              </div>

              <!-- [[ Bootstrap 페이징 처리  구간  ]] -->
              <div style="display:flex; justify-content:center;">
                <ul class="pagination">
                  <%
                    String pagePath = "mediaNotice";
                    BSPageBar bspb = new BSPageBar(numPerPage,size,nowPage,pagePath);
                    out.print(bspb.getPageBar());
                  %>
                </ul>
              </div>
              <!-- [[ Bootstrap 페이징 처리  구간  ]] -->

            </div>
            <!-- 미디어게시판목록   끝  -->
          </div>
        </div>
      </div>
    </section>
  </div>
</div>
</body>
</html>
