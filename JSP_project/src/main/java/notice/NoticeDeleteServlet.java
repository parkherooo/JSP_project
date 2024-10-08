package notice;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/notice/noticeDelete")
public class NoticeDeleteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 int nNum = Integer.parseInt(request.getParameter("nNum"));
	        NoticeMgr noticeMgr = new NoticeMgr();

	        // 공지사항 삭제 시도
	        boolean success = noticeMgr.noticeDelete(nNum); // 공지사항 삭제 메소드 호출
	        if (success) {
	            response.sendRedirect("noticeList.jsp");// 성공 시 목록 페이지로 리디렉션
	        } else {
	        	 response.setContentType("text/html; charset=UTF-8");
				 PrintWriter out = response.getWriter();
				 out.println("<script>");
				 out.println("alert('삭제 실패했습니다.')");
				 out.println("history.back()");
				 out.println("</script>");
	        }
	    }
}

