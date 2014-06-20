		package com.lps;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet("/Upload")
public class Upload extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_PATH = "C://Users//Administrator.ZGC-20120221BVQ//ServerFile//AttachFiles//";
       
    public Upload() {
        super();
        
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("GB18030");
		DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();
		ServletFileUpload servletFileUpload = new ServletFileUpload(diskFileItemFactory);
		try {
			List<FileItem> fileItemList = servletFileUpload.parseRequest(request);
			Iterator iterator = fileItemList.iterator();
			String showFileName = "";
			String department = "";
			String type = "";
			String fileType = "";
			String fileName = "";
			while(iterator.hasNext()) {
				FileItem fileItem = (FileItem)iterator.next();
				if(fileItem.isFormField()) {
					String name = fileItem.getFieldName();
					String value = fileItem.getString();
					System.out.println(name);
					if("uploadName".equals(name)) {
						showFileName = new String(value.getBytes("ISO8859-1"),"GB18030");
						System.out.println(showFileName);
					}else if("department".equals(name)) {
						department =  new String(value.getBytes("ISO8859-1"),"GB18030");
					}
				}else {
					String fieldName = fileItem.getFieldName();
					fileName = fileItem.getName();
					String contentType = fileItem.getContentType();
					System.out.println(fieldName);
					System.out.println(fileName);
					long size = fileItem.getSize();
					String filePath = UPLOAD_PATH+showFileName+fileName.substring(fileName.lastIndexOf("."));
					fileType = fileName.substring(fileName.lastIndexOf("."));
					File saveFile = new File(filePath);
					
					try {
						fileItem.write(saveFile);
						PrintWriter out = response.getWriter();
						out.print("<html><head></head><body>OK~~~~~</body></html>");
						out.close();
						
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			String office = ".doc.docx.xls.xlsx.pptx.ppt";
			String image = ".png.jpg.jpeg.gif.psd";
			String video = ".avi.mp4.rmvb.mp3";
			String pdf = ".pdf";
			if(office.indexOf(fileType)!=-1) {
				type = "office";
			}else if(image.indexOf(fileType)!=-1) {
				type = "image";
			}else if(video.indexOf(fileType)!=-1) {
				type = "video";
			}else if(pdf.indexOf(fileType)!=-1) {
				type = "pdf";
			}
			MyDatabase database = new MyDatabase();
			database.InsertAttachFile(showFileName+fileType, type,department);
			System.out.println(type);
		} catch (FileUploadException e) {
			PrintWriter out = response.getWriter();
			out.print("wrong");
			e.printStackTrace();
		}
	}

}
