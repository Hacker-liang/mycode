<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>Insert title here</title>
</head>
<body>
	 <form method="post" action="AddAdminer" class="login">
    <p>
      <label for="usreNo">�û���:</label>
      <input type="text" name="userno" id="userno" value="">
    </p>

    <p>
      <label for="password">����:</label>
      <input type="text" name="password" id="password" value="">
    </p>
	 <p>
      <label for="username">����:</label>
      <input type="text" name="username" id="username" value="">
    </p>
     ѡ���ţ�<select name="department">
     	<option value="����ѧԺ">����ѧԺ</option> 
     	<option value="����ѧԺ">����ѧԺ</option> 
     	<option value="�����ѧԺ">�����ѧԺ</option>
     	<option value="����ѧԺ">����ѧԺ</option> 
     </select><br/>   
    <p class="login-submit">
      <button type="submit" class="login-button">���</button>
    </p>
  </form> 
</body>
</html>