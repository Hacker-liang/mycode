package com.lps;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import sun.misc.*;

public class OperateRequestData {
	public UserInformation userInfo;
	MyDatabase database = new MyDatabase();
	MyFiles myfile = new MyFiles();
	public boolean CheckUser(String username, String userpassword) {
		String retPassword = database.selectUserpassword(username);
		if (userpassword.equals(retPassword))
			return true;
		else return false;
	}
	//dddd
	
	public int getUserType(String username) {
		int retType = database.selectUserType(username);
		return retType;
	}

	public UserInformation getUserInfo(String userno) {
		userInfo = database.selectUserInfo(userno);
		if(myfile.getUserPhoto(userno) != null) 	
			userInfo.photodata = new sun.misc.BASE64Encoder().encode(myfile.getUserPhoto(userno));
		else userInfo.photodata = "";
		return userInfo;
	}
	
	public ArrayList<UserInformation> getAllUserInfo(String userno) {
		ArrayList<UserInformation> allUserInfo = new ArrayList<UserInformation>();
		ArrayList<String> allUserNo = new ArrayList<String>();
		allUserNo = database.selectAllUserNo(userno);
		for(int i=0; i<allUserNo.size(); i++) {
			System.out.print(allUserNo.get(i)+"  ");
			userInfo = database.selectSampleUserInfo(allUserNo.get(i));
			if(myfile.getUserPhoto(allUserNo.get(i)) != null) 	
				userInfo.photodata = new sun.misc.BASE64Encoder().encode(myfile.getUserPhoto(allUserNo.get(i)));
			else userInfo.photodata = "";
			allUserInfo.add(userInfo);
		}
		return allUserInfo;
	}
	
	public boolean UpdateUserInfo (String userno, String password, String emailaddress, String phone) {
		return (database.updataUserMessage(userno, password, emailaddress, phone) );
		//return (database.updataUserMessage(userno, password, emailaddress, phone));
	}
	
	public boolean UpdateUserphoto(String userno, String photodata) {
		try {
			byte[] photo = (new sun.misc.BASE64Decoder()).decodeBuffer(photodata);
			myfile.updateUserPhoto(userno, photo);
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean InsertnewFileToDB(FileContent file) {
		return database.InsertnewFile(file);
	}
	
	public List<FileContent> getPostFiles(String userno) {
		List<FileContent> files = new ArrayList<FileContent>();
		files = database.selectPostFiles(userno);
		return files;
	}
	
	//根据部门来选择用户所能看到的文件
	public List<FileContent> getReceiveFiles(String userno, String department) {
		List<FileContent> files = new ArrayList<FileContent>();
		files = database.selectReceiveFiles(userno, department);
		return files;
	}
	
	public List<FileContent> getUnPassFiles(String department) {
		List<FileContent> files = new ArrayList<FileContent>();
		files = database.selectUnPassFiles(department);
		return files;
	}
	
	public List<AttachFile> getAttachFileLabel(String department) {
	 List<AttachFile> attachfiles = new ArrayList<AttachFile>();
	 attachfiles = database.selectAttachFileLabel(department);
	 return attachfiles;
	}
	
	public String getAttachFile(String attachFileName) {
		if(myfile.getAttachFile(attachFileName) != null) {
			return (new sun.misc.BASE64Encoder().encode(myfile.getAttachFile(attachFileName)));
		}
		return null;
	}
	
	public JSONObject getActivityList(String userno) {
		JSONObject retObj = new JSONObject();
		return retObj;
	}
	
	
}







