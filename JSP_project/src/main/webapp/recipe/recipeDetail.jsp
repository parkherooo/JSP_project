<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.BufferedReader, java.io.InputStreamReader, java.net.HttpURLConnection, java.net.URL, org.json.JSONObject" %>

<%	
    String title = request.getParameter("title");
    String recipeId = request.getParameter("id");
    if(title==null||recipeId==null){
    	response.setContentType("text/html; charset=UTF-8");
		PrintWriter outPrintWriter = response.getWriter();
		outPrintWriter.println("<script>");
		outPrintWriter.println("alert('선택하신 레시피가 없습니다.')");
		outPrintWriter.println("history.back()");
		outPrintWriter.println("</script>");
    }
    String apiUrl = "https://openapi.foodsafetykorea.go.kr/api/12cb932ee6ff42828803/COOKRCP01/json/1/100/RCP_SEQ=" + recipeId + "&RCP_NM=" +java.net.URLEncoder.encode(title, "UTF-8");
    StringBuilder result = new StringBuilder();

    try {
        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        String line;
        while ((line = rd.readLine()) != null) {
            result.append(line);
        }
        rd.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // JSON 데이터 파싱
    JSONObject recipeDetail = null;
    try {
        JSONObject jsonResponse = new JSONObject(result.toString());
        recipeDetail = jsonResponse.getJSONObject("COOKRCP01").getJSONArray("row").getJSONObject(0);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/main/header.jsp" %>
	<link rel="stylesheet" href="../css/recipe.css">
    <title><%= recipeDetail != null ? recipeDetail.getString("RCP_NM") : "레시피 상세" %></title>
</head>
<body class="recipe-body">

    <h1 class="recipe-h1">Recipe</h1><br>
    
    <div class="recipe-detail">
        <h2><%= recipeDetail != null ? recipeDetail.getString("RCP_NM") : "레시피를 찾을 수 없습니다." %></h2>	<br>
        <hr>
        <div class="ingredients">
            <img class="recipe-image" src="<%= recipeDetail != null ? recipeDetail.getString("ATT_FILE_NO_MK") : "" %>" alt="조리 이미지" />
            <div class="ingredient">
                <h3 class="recipe-h3">영양성분</h3>
                <b>탄수화물: <%= recipeDetail != null ? recipeDetail.getString("INFO_CAR") : "" %>g<br>
                단백질: <%= recipeDetail != null ? recipeDetail.getString("INFO_PRO") : "" %>g<br>
                지방: <%= recipeDetail != null ? recipeDetail.getString("INFO_FAT") : "" %>g<br>
                나트륨: <%= recipeDetail != null ? recipeDetail.getString("INFO_NA") : "" %>g<br><br>
                열량: <%= recipeDetail != null ? recipeDetail.getString("INFO_ENG") : "" %>cal</b><br>
            </div>
        </div>
    <h3>조리방법</h3>
    <div class="recipe-method">
        <% for (int i = 1; i <= 20; i++) {
            String manualKey = "MANUAL0" + i;
            if (recipeDetail != null && recipeDetail.has(manualKey) && !recipeDetail.getString(manualKey).isEmpty()) {
        %>
            <div class="method-step">
                <%= recipeDetail.getString(manualKey) %>
            </div>
        <% 
            }
        } %>
    </div>

    <h3>재료</h3>
	    <div class="recipe-ingredient">
	            <%= recipeDetail != null ? recipeDetail.getString("RCP_PARTS_DTLS") : "재료 정보를 찾을 수 없습니다." %>
	    </div>

        <br>
        <h3>저감 조리법 Tip</h3>
        <div><%= recipeDetail != null ? recipeDetail.getString("RCP_NA_TIP") : "" %></div>
        
    </div>
    <br><a class="recipe-a" href="recipeList.jsp">[목록]</a>
    <div>
    <br>
    </div>
    <%@ include file="/chatbot/chatbot.jsp" %>
</body>
<footer><%@ include file="/main/footer.jsp" %></footer>
</html>
