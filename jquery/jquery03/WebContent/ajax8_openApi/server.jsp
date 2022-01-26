<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.MalformedURLException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.io.UnsupportedEncodingException"%>
<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- server.jsp -->
<%
	    String clientId = "LtwjS0Wa2oR5DWAvqwwx"; //애플리케이션 클라이언트 아이디값"
	    String clientSecret = "zZSf7UAv4B"; //애플리케이션 클라이언트 시크릿값"
		
	    String search=request.getParameter("search");
	    String start = request.getParameter("start");
	    if(search==null) search="jquery";
	    if(start==null) start="1";
	
	    String text = null;
	    try {
	        text = URLEncoder.encode(search, "UTF-8");
	    } catch (UnsupportedEncodingException e) {
	        throw new RuntimeException("검색어 인코딩 실패",e);
	    }
	
	
	    //String apiURL = "https://openapi.naver.com/v1/search/book?query=" + text+"&display=5&start="+start;    // json 결과
	    String apiURL = "https://openapi.naver.com/v1/search/book.xml?query=" + text+"&display=5&start="+start;    // xml 결과
	
	
	    Map<String, String> requestHeaders = new HashMap<>();
	    requestHeaders.put("X-Naver-Client-Id", clientId);
	    requestHeaders.put("X-Naver-Client-Secret", clientSecret);
	    String responseBody = get(apiURL,requestHeaders);
	
	
	    //System.out.println(responseBody);
	    response.setContentType("text/xml;charset=utf-8");
	    PrintWriter pw = response.getWriter();
	    pw.println(responseBody);
%>
<%!
private String get(String apiUrl, Map<String, String> requestHeaders){
    HttpURLConnection con = connect(apiUrl);
    try {
        con.setRequestMethod("GET");
        for(Map.Entry<String, String> header :requestHeaders.entrySet()) {
            con.setRequestProperty(header.getKey(), header.getValue());
        }


        int responseCode = con.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) { // 정상 호출
            return readBody(con.getInputStream());
        } else { // 에러 발생
            return readBody(con.getErrorStream());
        }
    } catch (IOException e) {
        throw new RuntimeException("API 요청과 응답 실패", e);
    } finally {
        con.disconnect();
    }
}


private HttpURLConnection connect(String apiUrl){
    try {
        URL url = new URL(apiUrl);
        return (HttpURLConnection)url.openConnection();
    } catch (MalformedURLException e) {
        throw new RuntimeException("API URL이 잘못되었습니다. : " + apiUrl, e);
    } catch (IOException e) {
        throw new RuntimeException("연결이 실패했습니다. : " + apiUrl, e);
    }
}

private String readBody(InputStream body) throws UnsupportedEncodingException{
    InputStreamReader streamReader = new InputStreamReader(body,"utf-8");


    try (BufferedReader lineReader = new BufferedReader(streamReader)) {
        StringBuilder responseBody = new StringBuilder();


        String line;
        while ((line = lineReader.readLine()) != null) {
            responseBody.append(line);
        }


        return responseBody.toString();
    } catch (IOException e) {
        throw new RuntimeException("API 응답을 읽는데 실패했습니다.", e);
    }
}
%>