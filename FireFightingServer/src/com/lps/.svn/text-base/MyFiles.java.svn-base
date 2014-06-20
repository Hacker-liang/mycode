package com.lps;
import java.io.*;

import sun.misc.*;

public class MyFiles {
	static String photoDic = "C://Users//Administrator.ZGC-20120221BVQ//ServerFile//Userphotos//";
	static String attachFileDic = "C://Users//Administrator.ZGC-20120221BVQ//ServerFile//AttachFiles//";
	public void updateUserPhoto(String userno, byte[] photodata) {
		String filePath = photoDic+userno+".png";
		System.out.println(filePath);
		File saveFile = new File(filePath);
		try {
			DataOutputStream dos = new DataOutputStream(new FileOutputStream(saveFile));
			dos.write(photodata);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public byte[] getUserPhoto(String userno) {
		String filePath = photoDic+userno+".png";
		System.out.println(filePath);
		byte[] photoData = null;
		try {
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(filePath));
			photoData = new byte[bis.available()];
			bis.read(photoData);
			
			return photoData;
		} catch (IOException e) {
			System.out.print("服务器中找不到用户的头像");
			return photoData;
		}
	}
	
	public byte[] getAttachFile(String attachfilename) {
		String filePath = attachFileDic+attachfilename; 
		System.out.println(filePath);
		byte[] attachfileData = null;
		try {
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(filePath));
			attachfileData = new byte[bis.available()];
			bis.read(attachfileData);
			return attachfileData;
		} catch (IOException e) {
			System.out.print("服务器中找不到用户的文件");
			return attachfileData;
		}
	}
}









