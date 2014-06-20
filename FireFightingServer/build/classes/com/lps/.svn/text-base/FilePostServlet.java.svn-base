package com.lps;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
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

/**
 * Servlet implementation class FilePostServlet
 */
@WebServlet("/FilePostServlet")
public class FilePostServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private HttpServletRequest request = null;
    private HttpServletResponse response = null;
    private FileContent file = new FileContent();
    public FilePostServlet() {
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
		StringBuffer receiveString = new StringBuffer();
		
		
		try {
			request.setCharacterEncoding("utf-8");
			InputStreamReader br = new InputStreamReader(request.getInputStream(),"utf-8");
			String str;
			char[]data = new char[256];
			while((br.read(data))!=-1) {
				str = new String(data);
				receiveString.append(str);
				System.out.println(receiveString);
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
			String requestStr = requestObj.getString("postfilerequest");
			if(requestStr.equals("postnewfile")) {
				System.out.println("收到新建文章请求");
				file.userno = requestObj.getString("userno");
				file.username = requestObj.getString("username");
				file.todepartment = requestObj.getString("todepartment");
				file.fromdepartment = requestObj.getString("fromdepartment");
				file.posttime = requestObj.getLong("posttime");
				file.filestatus = requestObj.getInt("filestatus");
				file.filelabel = requestObj.getString("filelabel");
				file.filedetail = requestObj.getString("filedetail");
				WriteresultToClient(OD.InsertnewFileToDB(file));
				MyDatabase database = new MyDatabase();
				database.InsertActivity(file.userno, System.currentTimeMillis()/1000+8*3600, "发表题名为：《"+file.filelabel+"》的文章");
			}else if(requestStr.equals("refreshfilestatus")) {
				List<FileContent> files = new ArrayList<FileContent>();
				files = OD.getPostFiles(requestObj.getString("userno"));
				JSONObject retFiles = new JSONObject();
				JSONArray fileArray = new JSONArray();
				for(int i=0; i<files.size(); i++) {
					JSONObject fileObj = new JSONObject();
					fileObj.put("department", files.get(i).todepartment);
					fileObj.put("posttime", files.get(i).posttime);
					fileObj.put("filestatus", files.get(i).filestatus);
					fileObj.put("filelabel", files.get(i).filelabel);
					fileObj.put("filedetail", files.get(i).filedetail);
					fileArray.put(fileObj);
				}
				retFiles.put("postfile", fileArray);
				DataOutputStream dos;
				dos = new DataOutputStream(response.getOutputStream());
				dos.writeChars(retFiles.toString());
			}
				
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
	}
	
	private void WriteresultToClient(boolean isSuccess) {
		JSONObject retJSON = new JSONObject();
		try {
			retJSON.put("postfileresult", isSuccess);
			DataOutputStream  dos = new DataOutputStream(response.getOutputStream());
			dos.writeChars(retJSON.toString());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
				// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
