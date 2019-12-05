﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="java.util.*"%>
<%
	//XML 데이터를 호출할 URL
	String url = "http://ws.bus.go.kr/api/rest/stationinfo/getRouteByStation?ServiceKey=6BS0pHb4y5eedo8ZQYAKYQ48Omt3cnuNJBa6w4LEB7bgXN5o7sPd8XGcj9RSXtDzdaaVnqBHkr418dG7NxqIfQ%3D%3D&arsId=19005";
	
	//URL에 파라미터로 'size' 항목이 존재하는지 체크
	String size = request.getParameter("size");
	
	//size 파라미터가 null이 아니고, 0이 아닐경우에만 URL에 추가, size항목은 가져올 게시물의 갯수를 의미함.
	if(size != null && !"0".equals(size)){
		url += "?size=" + size;
	}
	
	//서버에서리턴될 XML데이터의 엘리먼트 이름 배열 
	String[] fieldNames ={"busRouteNm", "busRouteType", "stBegin",  "term", "nextBus", "firstBusTm", "lastBusTm"};
	
	//각 게시물하나에 해당하는 XML 노드를 담을 리스트
	ArrayList<Map> pubList = new ArrayList<Map>();
	
	try {
		//XML파싱 준비
		DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
		DocumentBuilder b = f.newDocumentBuilder();
		//위에서 구성한 URL을 통해 XMl 파싱 시작
		Document doc = b.parse(url);
		doc.getDocumentElement().normalize();
		
		//서버에서 응답한 XML데이터를 publication(발행문서 1개 해당)태그로 각각 나눔(파라미터로 요청한 size항목의 수만큼)
		NodeList items = doc.getElementsByTagName("erviceResult");
		System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
		  NodeList SearchFirstAndLastTrainInfobyLineService = doc.getElementsByTagName("itemList");
		//for 루프시작
		for (int i = 0; i < SearchFirstAndLastTrainInfobyLineService.getLength(); i++) {
			//i번째 publication 태그를 가져와서
			Node n = SearchFirstAndLastTrainInfobyLineService.item(i);
			//노드타입을 체크함, 노드 타	입이 엘리먼트가 아닐경우에만 수행
			if (n.getNodeType() != Node.ELEMENT_NODE)
				continue;
			
			Element e = (Element) n;
			HashMap pub = new HashMap();
			//for 루프 시작
			for(String name : fieldNames){
				
				NodeList titleList = e.getElementsByTagName(name);
				Element titleElem = (Element) titleList.item(0);
	
				Node titleNode = titleElem.getChildNodes().item(0);
				// 가져온 XML 값을 맵에 엘리먼트 이름 - 값 쌍으로 넣음
				pub.put(name, titleNode.getNodeValue());
			}
			//데이터가 전부 들어간 맵을 리스트에 넣고 화면에 뿌릴 준비.
			pubList.add(pub);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>영등포역 버스정보</title>
<style type="text/css">
	.main-table{ width : 100%; border : #000 solid 1px;}
	.table-title{text-align : center; font-weight : bold;}
	.selectbox-div{text-align : right; margin-bottom:10px;}
	.header{text-align : center;}
	
	select{width:100px;height :23px;margin-left: 10px;}
	td{border : #000 solid 1px;}
</style>

<script>
	function refresh(){
		var sel = document.getElementById('cntBox');
		location.href='http://localhost:8080/xmlreport/InpoSt2.jsp?size=' + sel.value;
	}
</script>

</head>
<body>
	<div class="header">
		<h3>영등포역 버스정보</h3>
	</div>
	<div class="selectbox-div" >
		<span>검색게시물 수 : </span>
		<select id="cntBox">
			<option value="0">전체</option>
			<option value="2">2</option>
			<option value="4">4</option>
			<option value="6">6</option>
			<option value="8">8</option>
		</select>
		<input type="button" value="검색" onclick="refresh()"/><p>
		<input type="button" value="서울역" onClick="location.href='http://localhost:8080/xmlreport/InpoSt3.jsp'"><p>
		<input type="button" value="잠실역" onClick="location.href='http://localhost:8080/xmlreport/InpoSt4.jsp'"><p>
		<input type="button" value="용산역" onClick="location.href='http://localhost:8080/xmlreport/InpoSt5.jsp'"><p>
	</div>
	<div>
	
	
		<table class="main-table">
			<tr class="table-title">
				<td>버스번호</td>
				<td>노선유형</td>
				<td>기점</td>
				<td>배차간격</td>
				<td>막차유형</td>
				<td>금일첫차</td>
				<td>금일막차</td>
				
			</tr>

	<%
		//XML의 모든 노드가 맵으로 변환되어 pubList에 들어가고,for 루프를 돌면서 pubList의 값을 뿌려줌.
		for(Map pub : pubList){
	%>
			<tr>
				<td><%=pub.get("busRouteNm") %></td>
				<td><%=pub.get("busRouteType") %></td>
				<td><%=pub.get("stBegin") %></td>
				<td><%=pub.get("term") %></td>
				<td><%=pub.get("nextBus") %></td>
				<td><%=pub.get("firstBusTm") %></td>				
				<td><%=pub.get("lastBusTm") %></td>
			
				
   <%

   }

    %>

 </TR>


		</table>
	</div>

</body>
</html>