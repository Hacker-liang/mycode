package com.lps;
import java.io.*;
import java.net.*;
import java.util.*;

import org.json.JSONException;
import org.json.JSONObject;

public class FireFightingChatServer {
	ArrayList<Client>activityClients = new ArrayList<Client>();
	boolean started = false;
	ServerSocket ss = null;      
	DataInputStream dis = null;
	DataOutputStream dos = null;
	
	public static void main(String[] args) {
		new FireFightingChatServer().start();
	}
	
	public void start() {
		try {
			ss = new ServerSocket(8088);
			started = true;
		} catch (BindException e) {
			System.exit(0);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		try {

			while(started) {
				Socket s = ss.accept();
				System.out.println("new client");
				String Msg = "heheceo";
				Client c = new Client(s);
				new Thread(c).start();
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				ss.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
	class Client implements Runnable {
		String userID;
		Socket s;
		DataInputStream dis = null;
		DataOutputStream dos = null;
		
		Client (Socket s) {
			this.s = s;
			try {
				dis = new DataInputStream(s.getInputStream());
				dos = new DataOutputStream(s.getOutputStream());
				System.out.println("Ready to read bytes");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		public void run() {
//			try{             
//	            DataInputStream dis = new   
//	              DataInputStream(s.getInputStream()); 
//	            int len;
//	            DataOutputStream dos = new   
//	              DataOutputStream(s.getOutputStream());  
//	            while((len = dis.read())!=-1){
//	                 System.out.println("len="+len);
//	                 //os.write(len);
//	           }
//	            dis.close();
//	            dos.close();  
//	            s.close();  
//	        }catch(Exception ee){  
//	            ee.printStackTrace();  
//	        }  
			try {
				System.out.println("start run");

				byte[]bytes = new byte[2048];
				byte[]data = null;
				int size;
				String str;;
				while (!s.isClosed()) {
					if((size = dis.read(bytes)) != 0) {
						ByteArrayOutputStream baout = new ByteArrayOutputStream(2048);
						try {
							baout.write(bytes,0,size);
						} catch (Exception e) {
							System.out.print("断开连接");
							break;
						}
						data = baout.toByteArray();
						str = new String(data);
						this.HandleMsg(str);	
					}
				}    
				this.DeletenewClient(userID);
				System.out.println("客户端断开连接");
			} catch (EOFException e ) {
				this.DeletenewClient(userID);
				System.out.println("exception");
			} catch (IOException e) {
				this.DeletenewClient(userID);
				System.out.print("ioexception");
			} 
			
		}
		
		private void HandleMsg(String Msg) {
			try {
				System.out.println(Msg);
				JSONObject MsgJson = new JSONObject(Msg);
				if(MsgJson.get("cmd").equals("newclient")) {
					this.userID = MsgJson.getString("userno");
					this.AddnewClient(this.userID);
					this.sendChatLog(this.userID);
				}
				if(MsgJson.get("cmd").equals("newmsg")) {
					JSONObject detailMsgJson = (JSONObject) MsgJson.get("msgcontent");
					this.SendMsg(detailMsgJson);
				}
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		private void SendMsg(JSONObject json) {
			try {
				String toID= json.getString("toid");
				Socket theSocket = new Socket();
				boolean hasClient = false;
				for(int i=0; i<activityClients.size(); i++) {
					if(activityClients.get(i).userID.equals(toID)) {
						hasClient = true;
						theSocket = activityClients.get(i).s;
						System.out.println(activityClients.get(i).userID+"在线");
						break;
					}
				}
				if(hasClient) {
					JSONObject toClientJson = new JSONObject();
					toClientJson.put("cmd", "newmsg");
					toClientJson.put("msgcontent",json);
					DataOutputStream dos = new DataOutputStream(theSocket.getOutputStream());
					dos.write(toClientJson.toString().getBytes());
				} else {
					System.out.println("储存为离线信息");
					MyDatabase database = new MyDatabase();
					database.InserChatLog(json);
				}
				dos.flush();	
			}catch (IOException e) {
				System.out.println("储存为离线信息");
				MyDatabase database = new MyDatabase();
				database.InserChatLog(json);
				e.printStackTrace();
			}  catch (JSONException e) {
				e.printStackTrace();
			}
			
		}
		
		private void sendChatLog(String userID) {
			MyDatabase database = new MyDatabase();
			DataOutputStream dos;
			try {
				dos = new DataOutputStream(this.s.getOutputStream());
				dos.write(database.selectChatlog(userID).toString().getBytes());
				System.out.print(database.selectChatlog(userID).toString());
				database.DeleteChatLog(userID);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		private void AddnewClient(String userID) {
			Client client;
			
			for(int i=0; i<activityClients.size(); i++) {
				if((client = activityClients.get(i)).userID.equals(userID)) {
					activityClients.remove(i);
					System.out.println(userID+"已经获得更新");
					break;
				}
			}
			activityClients.add(this);
			for(int i=0;i <activityClients.size(); i++) {
				System.out.print("**"+activityClients.get(i).userID+"**");
			}
		}
		
		private void DeletenewClient(String userID) {
			Client client;
			
			for(int i=0; i<activityClients.size(); i++) {
				if((client = activityClients.get(i)).userID.equals(userID)) {
					activityClients.remove(i);
					System.out.println(userID+"已经删除");
					break;
				}
			}
			for(int i=0;i <activityClients.size(); i++) {
				System.out.print("**"+activityClients.get(i).userID+"**");
			}
		}
	}
	
}
