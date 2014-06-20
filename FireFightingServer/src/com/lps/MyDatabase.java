package com.lps;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class MyDatabase {
	
	private UserInformation userInfo;
	private static Connection con;
	private static Statement statement;
	private static String url = "jdbc:mysql://127.0.0.1:3306/firefightingdb";
	
	public static boolean insertUserMessage(String name, String password ,int type) {
		getConnection();
		String insert_sql = "INSERT INTO UserInfo(name, password, type) VALUES('"+name+"', '"+password+"', '"+type+"')";
		try {
			statement.executeUpdate(insert_sql);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		
	}
	
	public String selectUserpassword(String n) {
		String password = null;
		getConnection();
		String select_sql = "SELECT password FROM UserInfo WHERE userno = '"+n+"'";
		try {
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				password = set.getString("password");
			}
			if (password == null) return "wrong";
			return password;			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "wrong";
		}
	}
	
	public int selectUserType(String n) {
		int type = -1;
		getConnection();
		String select_sql = "SELECT accounttype FROM userinfo WHERE userno = '"+n+"'";
		try {
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				type = set.getInt("accounttype");
			}
			return type;
		} catch (SQLException e) {
			e.printStackTrace();
			return type;
		}
	}
	
	public UserInformation selectUserInfo(String no) {
		getConnection();
		String select_sql = "SELECT * FROM userinfo WHERE userno = '"+no+"'";
		//String select_sql = "select username from userinfo where userno = 'heheceo'";
		
		try {
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				userInfo = new UserInformation();
				userInfo.userno = set.getString("userno");
				userInfo.username = set.getString("username");
				userInfo.accounttype = set.getInt("accounttype");
				userInfo.department = set.getString("department");
				userInfo.emailaddress = set.getString("emailaddress");
				userInfo.phonenumber = set.getString("phonenumber");
			}
			return userInfo;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return userInfo;
		
	}
	
	//聊天列表获取信息使用的api
	public UserInformation selectSampleUserInfo(String no) {
		getConnection();
		String select_sql = "SELECT userno, accounttype, department, username FROM userinfo WHERE userno = '"+no+"'";
		//String select_sql = "select username from userinfo where userno = 'heheceo'";
		
		try {
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				userInfo = new UserInformation();
				userInfo.userno = set.getString("userno");
				userInfo.username = set.getString("username");
				userInfo.department = set.getString("department");
				userInfo.accounttype = set.getInt("accounttype");
			}
			return userInfo;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return userInfo;
		
	}
	
	public ArrayList<String> selectAllUserNo(String no) {
		getConnection();
		ArrayList<String> allUserNo = new ArrayList<String>();
		String userno = null;
		String select_sql = "SELECT userno FROM userinfo WHERE userno != '"+no+"'";
		
		try {
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				userno = set.getString("userno");
				allUserNo.add(userno);
			}
			return allUserNo;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return allUserNo;
		
	}
	
	public List<FileContent> selectPostFiles(String userno) {
		List<FileContent> files = new ArrayList<FileContent>();
		
		getConnection();
		String select_sql = "select todepartment, filestatus, posttime, filelabel, filedetail from filecontent where userno = '"+userno+"'"; 
		try {
			System.out.println(select_sql);
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				FileContent file = new FileContent();
				file.todepartment = set.getString("todepartment");
				file.posttime = set.getLong("posttime");
				file.filestatus = set.getInt("filestatus");
				file.filelabel = set.getString("filelabel");
				file.filedetail = set.getString("filedetail");
				files.add(file);
			}
			return files;
		} catch (SQLException e) {
			e.printStackTrace();
			return files;
		}
	}
	
	public List<FileContent> selectReceiveFiles(String userno, String department) {
		List<FileContent> files = new ArrayList<FileContent>();
		
		getConnection();
		String select_sql = "select username, posttime, fromdepartment, filelabel, filedetail from filecontent where (todepartment = '"+department+"'or todepartment =  'all') and filestatus = '2' and userno != '"+userno+"'";                      
		try {
			System.out.println(select_sql);
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				FileContent file = new FileContent();
				file.username = set.getString("username");
				file.posttime = set.getLong("posttime");
				file.fromdepartment = set.getString("fromdepartment");
				file.filelabel = set.getString("filelabel");
				file.filedetail = set.getString("filedetail");
				files.add(file);
			}
			return files;
		} catch (SQLException e) {
			e.printStackTrace();
			return files;
		}
	}
	
	//此api用来管理员获取本学院未审核的文件的
	public List<FileContent> selectUnPassFiles(String department) {
		List<FileContent> files = new ArrayList<FileContent>();
		
		getConnection();
		String select_sql = "select userno, username, posttime, todepartment, filelabel, filedetail from filecontent where fromdepartment = '"+department+"' and filestatus = '1'";                      
		try {
			System.out.println(select_sql);
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				FileContent file = new FileContent();
				file.userno = set.getString("userno");
				file.username = set.getString("username");
				file.posttime = set.getLong("posttime");
				file.todepartment = set.getString("todepartment");
				file.filelabel = set.getString("filelabel");
				file.filedetail = set.getString("filedetail");
				files.add(file);
			}
			return files;
		} catch (SQLException e) {
			e.printStackTrace();
			return files;
		}
	}
	
	
	public List<AttachFile> selectAttachFileLabel(String department) {
		List<AttachFile>attachfiles = new ArrayList<AttachFile>();
		
		getConnection();
		String select_sql = "select attachfilelabel, attachfiletype from attachfile where attachfiledepartment = '"+department+"'or attachfiledepartment =  'all'";
		try {
			System.out.println(select_sql);
			ResultSet set = statement.executeQuery(select_sql);
			while (set.next()) {
				AttachFile file = new AttachFile();
				file.attachFileLabel = set.getString("attachfilelabel");
				file.attachFileType = set.getString("attachfiletype");
				attachfiles.add(file);
			}
			return attachfiles;
		} catch (SQLException e) {
			e.printStackTrace();
			return attachfiles;
		}
	}
	
	public JSONObject selectChatlog(String userID) {
		JSONObject retJson = new JSONObject();
		JSONArray chatArray = new JSONArray();
		getConnection();
		String select_sql = "select * from chatlog where toid = '"+userID+"'";
		ResultSet set;
		try {
			set = statement.executeQuery(select_sql);
			while (set.next()) {
				JSONObject chatObj = new JSONObject();
				chatObj.put("fromid", set.getString("fromid"));
				chatObj.put("msgdate", set.getLong("chatdate"));
				chatObj.put("msgdetail", set.getString("chatdetail"));
				chatArray.put(chatObj);
			}
			retJson.put("cmd", "chatlog");
			retJson.put("msgcontent", chatArray);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retJson;
	}
	
	public JSONObject getActivityList(String userno) {
		JSONObject retObject = new JSONObject();
		JSONArray activityList = new JSONArray();
		getConnection();
		String select_sql = "select * from activitylist where userno = '"+userno+"'";
		ResultSet set;
		try {
			System.out.println(select_sql);
			set = statement.executeQuery(select_sql);
			while(set.next()) {
				JSONObject activity = new JSONObject();
				activity.put("date", set.getString("activitydate"));
				activity.put("detail", set.getString("activitydetail"));
				activityList.put(activity);
			}
			retObject.put("activitylist", activityList);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return retObject;
	}
	
	
	public  boolean updateUserMessage(String name, String newpassword, String newtype) {
		getConnection();
		String update_sql = "UPDATE UserInfo SET (password, type) = '"+newpassword+"''"+newtype+"' WHERE name = '"+name+"'";
		//String update_sql = "UPDATE name_password SET password = '12345' where name = 'heheceo'";
		try {
			int set = statement.executeUpdate(update_sql);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean updataUserMessage(String userno, String password, String emailaddress, String phone) {
		getConnection();
		String update_sql = "UPDATE UserInfo SET password = '"+password+"',emailaddress = '"+emailaddress+"',phonenumber = '"+phone+"' where userno = '"+userno+"'";
		System.out.println(update_sql);
		try {
			int set = statement.executeUpdate(update_sql);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean updateUserPhoto(String userno, String photodata) {
		getConnection();
		String update_sql = "UPDATE userphoto SET photodata = '"+photodata+"' WHERE userno = '"+userno+"'";
		try {
			int set = statement.executeUpdate(update_sql);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean InsertnewFile(FileContent file) {
		getConnection();
		System.out.println(file.filedetail);
		String insert_sql = "insert into filecontent (userno, username, posttime, todepartment, fromdepartment, filestatus, filelabel, filedetail) values ('"+file.userno+"','"+file.username+"','"
				+file.posttime+"','"+file.todepartment+"','"+file.fromdepartment+"','"+file.filestatus+"','"+file.filelabel+"','"+file.filedetail+"')";
		try {
			statement.executeUpdate(insert_sql);
			return true;
		} catch (SQLException e) {
		
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	public void InserChatLog(JSONObject chatJson) {
		getConnection();
		String insert_sql;
		try {
			insert_sql = "insert into chatlog(fromid, toid, chatdate, chatdetail) values ('"+chatJson.getString("fromid")+"','"+chatJson.getString("toid")+"','"+
																								(System.currentTimeMillis()/1000)+"','"+chatJson.getString("msgdetail")+"')";
			System.out.println(insert_sql);
			statement.executeUpdate(insert_sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}  catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}
	
	public void DeleteChatLog(String userID) {
		getConnection();
		String delete_sql;
		try {
			delete_sql = "delete from chatlog where toid = '"+userID+"'";
			System.out.println(delete_sql);
			statement.executeUpdate(delete_sql);
		} catch (SQLException e) {
			e.printStackTrace();
		} 
	}
	
	public void InsertActivity(String userno, long date, String detail) {
		getConnection();
		String insert_sql = "insert into activitylist(userno, activitydate, activitydetail) values ('"+userno + "','" +date+"','"+detail+"')"; 
		try {
			statement.executeUpdate(insert_sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void InsertAttachFile(String name, String type,String department) {
		getConnection();
		String insert_sql = "insert into attachfile(attachfiledate,attachfiletype,attachfiledepartment,attachfilelabel) values ('"
				+System.currentTimeMillis()/1000+8*3600+"','"+type+"','"+department+"','"+name+"')";
		System.out.println(insert_sql);
		try {
			statement.executeUpdate(insert_sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public boolean ChangeUnpassFiletoPass(String userno, long posttime, String checkStr) {
		getConnection();
		String update_sql = null;
		if(checkStr.equals("pass")) 
			update_sql = "update filecontent set filestatus = 2 where userno = '"+userno+"' and posttime = '"+posttime+"'";
		if(checkStr.equals("nopass")) 
			update_sql = "update filecontent set filestatus = 0 where userno = '"+userno+"' and posttime = '"+posttime+"'";
		try {
			statement.executeUpdate(update_sql);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean AddUser(String userno, String password, String username, String department) {
		getConnection();
		String insert_sql = "insert into userinfo (userno, password, username, department, accounttype) values ('"+userno+"','"+password+"','"+username+"','"+department+"','"+1+"')";
		System.out.println(insert_sql);
		try {
			statement.execute(insert_sql);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean AddAdminer(String userno, String password, String username, String department) {
		getConnection();
		String insert_sql = "insert into userinfo (userno, password, username, department, accounttype) values ('"+userno+"','"+password+"','"+username+"','"+department+"','"+0+"')";
		System.out.println(insert_sql);
		try {
			statement.execute(insert_sql);
			return true;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
	}
	
	public static void getConnection() {
		try {
			con = DriverManager.getConnection(url,"root","james890526");
			statement = con.createStatement();
		}catch (SQLException e) {
			e.printStackTrace();
		}
	}

}

