<%@ page language="java" contentType="text/html; charset=GB18030"
    pageEncoding="GB18030"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GB18030">
<title>Insert title here</title>
</head>
<body>
	<form name="uploadForm" method="post" action="Upload" enctype="multipart/form-data">  
    附件名称：<input type="text" name="uploadName" value=""/><br/>  
    选择附件：<input type="file" name="uploadFile"/><br/> 
     选择部门：<select name="department">
     	<option value="all">所有部门</option>
     	<option value="环能学院">环能学院</option> 
     	<option value="材料学院">材料学院</option> 
     	<option value="计算机学院">计算机学院</option>
     	<option value="体育学院">体育学院</option> 
     </select><br/>   
    <input type="submit" value="上传"/>  
	</form>  
</body>
</html>