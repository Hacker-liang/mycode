package com.lps;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

@WebServlet("/ActivityListServlet")
public class ActivityListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private HttpServletRequest request = null;
    private HttpServletResponse response = null;
    public ActivityListServlet() {
        super();
      
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.request =request;
		this.response = response;
		ReadJSON();
	}
	
	private void ReadJSON() {
		StringBuffer receiveStr = new StringBuffer();
		String line = null;
		try {
			BufferedReader reader = new BufferedReader(request.getReader());
			
			while ((line = reader.readLine()) != null) {
				receiveStr.append(line);
			}
			DecodeJSON(receiveStr.toString());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	private void DecodeJSON(String json) {
		try {
			JSONObject requestObj = new JSONObject(json);
			if(requestObj.get("request").equals("refreshactivity")) {
				System.out.println("获取个人活动信息");
				sendActivityList(requestObj.getString("userno"));
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
	}
	
	private void sendActivityList(String userno) {
		MyDatabase database = new MyDatabase();
		DataOutputStream dos;
		try {
			dos = new DataOutputStream(response.getOutputStream());
			dos.writeChars(database.getActivityList(userno).toString());
			System.out.println(database.getActivityList(userno).toString());
		} catch (IOException e) {
			e.printStackTrace();
		}	

	}

}
