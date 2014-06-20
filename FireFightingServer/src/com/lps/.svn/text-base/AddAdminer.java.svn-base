package com.lps;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddAdminer")
public class AddAdminer extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public AddAdminer() {
        super();
        
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userno = request.getParameter("userno");
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String department = request.getParameter("department");
		MyDatabase database = new MyDatabase();
		PrintWriter out = response.getWriter();
		if (database.AddAdminer(new String(userno.getBytes("ISO8859-1"),"GB18030"), new String(password.getBytes("ISO8859-1"),"GB18030"), new String(username.getBytes("ISO8859-1"),"GB18030"), new String(department.getBytes("ISO8859-1"),"GB18030"))) {
			out.print("OK");
		} else out.print("wrong");
		
	}

}
