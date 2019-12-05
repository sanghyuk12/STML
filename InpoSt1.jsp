<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.w3c.dom.*"%>
<%@ page import="javax.xml.parsers.*"%>
<%@ page import="java.util.*"%>
<%
	//XML 데이터를 호출할 URL
	String url = "http://swopenapi.seoul.go.kr/api/subway/46434d6675726b643737456f574c74/xml/firstLastTimetable/0/10/%EC%84%9C%EC%9A%B8";
	
	//URL에 파라미터로 'size' 항목이 존재하는지 체크
	String size = request.getParameter("size");
	
	//size 파라미터가 null이 아니고, 0이 아닐경우에만 URL에 추가, size항목은 가져올 게시물의 갯수를 의미함.
	if(size != null && !"0".equals(size)){
		url += "?size=" + size;
	}
	
	//서버에서리턴될 XML데이터의 엘리먼트 이름 배열 
	String[] fieldNames ={"statnNm", "subwayNm", "subwayename",  "updnLine", "lastcarDiv", "weekendTranHour", "saturdayTranHour", "holidayTranHour"};
	
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
		NodeList items = doc.getElementsByTagName("firstLastTimetable");
		System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
		  NodeList SearchFirstAndLastTrainInfobyLineService = doc.getElementsByTagName("row");
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
				//"id", "title", "userName", "recommendId", "recommendName", "recommendDate", "url"에 해당하는 값을 XML 노드에서 가져옴
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
<title>1호선 지하철</title>
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
		location.href='http://localhost:8080/xmlreport/InpoSt1.jsp?size=' + sel.value;
	}
</script>

</head>
<body>
	<div class="header">
		<h3>1호선 지하철</h3>
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
		<input type="button" value="검색" onclick="refresh()"/>
		
	</div>
	<div>

	
		<table class="main-table">
			<tr class="table-title">
				<td>출발역</td>
				<td>호선명</td>
				<td>종점지하철역명</td>
				<td>상하행선 구분(1.상행, 2.하행)</td>
				<td>첫차 막차 구분(1.첫차, 2.막차)</td>
				<td>평일 운행시간</td>
				<td>토요일 운행시간</td>
				<td>휴일 운행시간</td>
			</tr>

	<%
		//XML의 모든 노드가 맵으로 변환되어 pubList에 들어가고,for 루프를 돌면서 pubList의 값을 뿌려줌.
		for(Map pub : pubList){
	%>
			<tr>
				<td><%=pub.get("statnNm") %></td>
				<td><%=pub.get("subwayNm") %></td>
				<td><%=pub.get("subwayename") %></td>
				<td><%=pub.get("updnLine") %></td>
				<td><%=pub.get("lastcarDiv") %></td>
				<td><%=pub.get("weekendTranHour") %></td>				
				<td><%=pub.get("saturdayTranHour") %></td>
				<td><%=pub.get("holidayTranHour") %></td>
   <%

   }

    %>

 </TR>

		</table>
	</div>

</body>
</html>