<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<%@ page import="java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>身份验证</title>
</head>
<body>
  <%
    request.setCharacterEncoding("GB18030");
    String name = request.getParameter("userNo");
    String password = request.getParameter("password");
    System.out.println(name);
    if(name.equals("abc")&& password.equals("123")) {
      System.out.println("right");
  %>
  <jsp:forward page="AfterLogin.jsp">
     <jsp:param name="userName" value="<%=name%>"/>
  </jsp:forward>
  <%
   }
   else {
  %>
  <% 
  	out.print("<html><head></head><body> 密码错误 </body>"); 
  	%>
  <%
   }
  %>
</body>
</html> 
