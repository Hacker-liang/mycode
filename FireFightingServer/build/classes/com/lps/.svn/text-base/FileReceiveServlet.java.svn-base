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

@WebServlet("/FileReceiveServlet")
public class FileReceiveServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	 private HttpServletRequest request = null;
	 private HttpServletResponse response = null;
	 private FileContent file = new FileContent();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FileReceiveServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		this.request = request;
		this.response = response;
		ReadJSON();
	}
	
	private void ReadJSON() {
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
	
	private void DecodeJson(String jsonStr) {
		try {
			OperateRequestData OD = new OperateRequestData();
			JSONObject requestObj = new JSONObject(jsonStr);
			String requestStr = requestObj.getString("receivefilerequest");
			if(requestStr.equals("refreshreceivefile")) {
				List<FileContent> files = new ArrayList<FileContent>();
				files = OD.getReceiveFiles(requestObj.getString("userno"),requestObj.getString("department"));
				JSONObject retFiles = new JSONObject();
				JSONArray fileArray = new JSONArray();
				for(int i=0; i<files.size(); i++) {
					JSONObject fileObj = new JSONObject();
					fileObj.put("username", files.get(i).username);
					fileObj.put("posttime", files.get(i).posttime);
					fileObj.put("fromdepartment", files.get(i).fromdepartment);
					fileObj.put("filelabel", files.get(i).filelabel);
					fileObj.put("filedetail", files.get(i).filedetail);
					fileArray.put(fileObj);
				}
				retFiles.put("filetype", "receivefile");
				retFiles.put("receivefile", fileArray);
				DataOutputStream dos;
				dos = new DataOutputStream(response.getOutputStream());
				dos.writeChars(retFiles.toString());
			} else if(requestStr.equals("getunpassfile")) {
				List<FileContent> files = new ArrayList<FileContent>();
				files = OD.getUnPassFiles(requestObj.getString("department"));
				JSONObject retFiles = new JSONObject();
				JSONArray fileArray = new JSONArray();
				for(int i=0; i<files.size(); i++) {
					JSONObject fileObj = new JSONObject(); 
					fileObj.put("userno", files.get(i).userno);
					fileObj.put("username", files.get(i).username);
					fileObj.put("posttime", files.get(i).posttime);
					fileObj.put("todepartment", files.get(i).todepartment);
					fileObj.put("filelabel", files.get(i).filelabel);
					fileObj.put("filedetail", files.get(i).filedetail);
					fileArray.put(fileObj);
				}
				retFiles.put("filetype", "unpassfile");
				retFiles.put("unpassfile", fileArray);
				DataOutputStream dos;
				dos = new DataOutputStream(response.getOutputStream());
				dos.writeChars(retFiles.toString());
				System.out.println(retFiles.toString());
			} else {
				MyDatabase database = new MyDatabase();
				JSONObject retObj = new JSONObject();
				retObj.put("filetype", "updateresult");
				retObj.put("result",database.ChangeUnpassFiletoPass( requestObj.getString("userno"),  requestObj.getLong("posttime"),  requestObj.getString("checkstr")));
				DataOutputStream dos;
				dos = new DataOutputStream(response.getOutputStream());
				dos.writeChars(retObj.toString());
				System.out.println(retObj.toString());
			}
				 
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
	}

}
