package com.lps;

import org.json.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class LogInServlet
 */
@WebServlet("/LogInServlet")
public class LogInServlet extends HttpServlet {
	private HttpServletRequest request = null;
	private HttpServletResponse response = null;
	JSONObject retJSON = new JSONObject();
	JSONObject checkResult = new JSONObject();
	
	private static final long serialVersionUID = 1L;
       
    public LogInServlet() {
        super();
       //nihao
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.request = request;
		this.response = response;
		ReadJSON();
	}
	
	private void ReadJSON() {
		System.out.print("收到客户端连接请求");
		StringBuffer receiveString = new StringBuffer();
		String line = null;
		
		try {
			BufferedReader br = new BufferedReader(request.getReader());
			while((line = br.readLine()) != null) 
				receiveString.append(line);
			DecodeJson(receiveString.toString());
		} catch (IOException e) {
			
			e.printStackTrace();
			System.out.print("exception");
		}
	}
	
	private void WriteOK() {
		
		try {
			System.out.println("验证成功");
			checkResult.put("checkresult", "ok");		
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
	private void WriteNO() {
		
		try {
			System.out.println("验证失败");
			checkResult.put("checkresult", "no");
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void WriteType(int acountType) {
		try {
			checkResult.put("accountType", acountType );
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void WriteToClient() {
		try {
			retJSON.put("login", checkResult);
			DataOutputStream dos = new DataOutputStream(response.getOutputStream());
			dos.writeChars(retJSON.toString());
			System.out.println(retJSON.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	private void DecodeJson(String jsonStr) {
		String username = null;
		String userpassword = null;
		try {
			JSONObject jsonObject = new JSONObject(jsonStr);
			JSONObject LoginInfo = (JSONObject) jsonObject.get("login");
			username = LoginInfo.getString("username");
			userpassword = LoginInfo.getString("userpassword");
			OperateRequestData OD = new OperateRequestData();
			if (OD.CheckUser(username, userpassword)) 
				WriteOK();
			else WriteNO();
			int userType = OD.getUserType(username);
			WriteType(userType);
			WriteToClient();
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
}






