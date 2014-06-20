package com.lps;

import java.io.BufferedReader;

import sun.misc.*;

import java.io.DataOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@WebServlet("/UpdateUserInfoServlet")
public class UpdateUserInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HttpServletRequest request = null;
	private HttpServletResponse response = null;
	private UserInformation userInfo;
       
    public UpdateUserInfoServlet() {
        super();
      
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.request = request;
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
			if(requestObj.get("change").equals("refresh")) {
				System.out.print("接收到更新数据");
				String userno = requestObj.getString("userno");
				SendUserInfoToClient(userno);
			}else if(requestObj.get("change").equals("changecontact")) {
				
				System.out.print("收到更改个人信息请求");
				OperateRequestData OD = new OperateRequestData();
				String userno = requestObj.getString("userno");
				String emailaddress = requestObj.getString("newemail");
				String phonenumber = requestObj.getString("newphone");
				String password = requestObj.getString("newpassword");
				String photodata = requestObj.getString("newphoto");
				boolean updateresult = (OD.UpdateUserInfo(userno, password, emailaddress, phonenumber) && OD.UpdateUserphoto(userno, photodata));
				SendUpdataResult(userno,updateresult);
				MyDatabase database = new MyDatabase();
				database.InsertActivity(userno, System.currentTimeMillis()/1000+8*3600, "更改个人信息");
			}else if(requestObj.get("change").equals("refreshall")) {
				System.out.print("接收到更新用户列表数据");
				String userno = requestObj.getString("userno");
				SendAllUserInfoToClient(userno);
			} else if(requestObj.get("change").equals("adduser")) {
				MyDatabase database = new MyDatabase();
				JSONObject retObj = new JSONObject();
				retObj.put("addResult", database.AddUser(requestObj.getString("userno"), requestObj.getString("password"), requestObj.getString("username"), requestObj.getString("department")));
				DataOutputStream dos = new DataOutputStream(response.getOutputStream());
				dos.writeChars(retObj.toString());
				
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void SendUserInfoToClient(String userno) {
		JSONObject retJSON = new JSONObject();
		JSONObject userInfoJSON = new JSONObject();
		OperateRequestData OD = new OperateRequestData();
		userInfo = OD.getUserInfo(userno);
		try {
			userInfoJSON.put("userno", userInfo.userno);
			userInfoJSON.put("username", userInfo.username);
			userInfoJSON.put("accounttype", userInfo.accounttype);
			userInfoJSON.put("department", userInfo.department);
			userInfoJSON.put("emailaddress", userInfo.emailaddress);
			userInfoJSON.put("phonenumber", userInfo.phonenumber);
			userInfoJSON.put("userphoto", userInfo.photodata);
			retJSON.put("refreshresult", userInfoJSON);
			DataOutputStream dos = new DataOutputStream(response.getOutputStream());
			dos.writeChars(retJSON.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private void SendAllUserInfoToClient(String userno) {
		ArrayList<UserInformation> allUserInfo = new ArrayList<UserInformation>();
		JSONObject retJSON = new JSONObject();
		JSONArray userInfoArray = new JSONArray();
		OperateRequestData OD = new OperateRequestData();
		allUserInfo = OD.getAllUserInfo(userno);
		try {
			for(int i=0; i<allUserInfo.size(); i++) {
				UserInformation theUserInfo = new UserInformation();
				theUserInfo = allUserInfo.get(i);
				System.out.print(theUserInfo.userno);
				JSONObject userInfoJSON = new JSONObject();
				userInfoJSON.put("userno", theUserInfo.userno);
				userInfoJSON.put("accounttype", theUserInfo.accounttype);
				userInfoJSON.put("username", theUserInfo.username);
				userInfoJSON.put("department", theUserInfo.department);
				userInfoJSON.put("userphoto", theUserInfo.photodata);
				userInfoArray.put(userInfoJSON);
			}
			retJSON.put("refreshallresult", userInfoArray);
			DataOutputStream dos = new DataOutputStream(response.getOutputStream());
			dos.writeChars(retJSON.toString());
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void SendUpdataResult(String userno, boolean result) {
		JSONObject retJSON = new JSONObject();
		try {
			retJSON.put("updateresult", result);
			DataOutputStream dos;
			dos = new DataOutputStream(response.getOutputStream());
			dos.writeChars(retJSON.toString());	
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();	
			} catch (JSONException e) {
				e.printStackTrace();
			}
	}
	

}
















