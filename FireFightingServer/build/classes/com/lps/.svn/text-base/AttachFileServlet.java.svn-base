package com.lps;

import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

@WebServlet("/AttachFileServlet")
public class AttachFileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HttpServletRequest request = null;
	private HttpServletResponse response = null;
    public AttachFileServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.request = request;
		this.response = response;
		ReadJSON();
	}
	
	private void ReadJSON() 
	{
		StringBuffer receiveString = new StringBuffer();
		try {
			request.setCharacterEncoding("utf-8");
			InputStreamReader br = new InputStreamReader(request.getInputStream(),"utf-8");
			String str;
			char[]data = new char[256];
			while((br.read(data))!=-1) {
				str = new String(data);
				receiveString.append(str);
			}
			DecodeJson(receiveString.toString());
		} catch (IOException e) {
			e.printStackTrace();
			System.out.print("exception");
		}
	}
	
	private void DecodeJson(String json) {
		OperateRequestData OD = new OperateRequestData();
		try {
			JSONObject requestObj = new JSONObject(json);
			String requestStr = requestObj.getString("attachfilerequest");
			if(requestStr.equals("getattachfilelabel")) {
				System.out.println("收到获得网络上文件名字的请求");
				List<AttachFile> attachfiles = new ArrayList<AttachFile>();
				attachfiles = OD.getAttachFileLabel(requestObj.getString("department"));
				JSONObject retFiles = new JSONObject();
				JSONArray fileArray = new JSONArray();
				for(int i=0; i<attachfiles.size(); i++) {
					JSONObject fileObj = new JSONObject();
					fileObj.put("attachfilelabel", attachfiles.get(i).attachFileLabel);
					fileObj.put("attachfilestatus", 0);
					fileObj.put("attachfiletype", attachfiles.get(i).attachFileType);
					fileArray.put(fileObj);
				}
				retFiles.put("attachfilelabel", fileArray);
				retFiles.put("attachfileresult", "attachfilelabel");
				DataOutputStream dos;
				dos = new DataOutputStream(response.getOutputStream());
				dos.writeChars(retFiles.toString());
				System.out.print(retFiles.toString());
				dos.close();
			}else if(requestStr.equals("downloadattachfile")) {
				System.out.println("收到下载附件的请求");
				String attachfile = OD.getAttachFile(requestObj.getString("attachfilename"));
				JSONObject retObj = new JSONObject();
				JSONObject retfile = new JSONObject();
				if(attachfile!=null) {
					retfile.put("downloadattachfile", true);
					retfile.put("content", attachfile);
				}else retfile.put("downloadattachfile", false);
				retObj.put("attachfilecontent", retfile);
				retObj.put("attachfileresult", "attachfilecontent");
				response.setContentLength(retObj.toString().length());
				DataOutputStream dos;
				dos = new DataOutputStream(response.getOutputStream());
				dos.writeBytes(retObj.toString());
				dos.close();
				MyDatabase database = new MyDatabase();
			}
			
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}
}










