<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Save Purchase Order Edit</title>
</head>

<body>
    <%
        // Check if the user session exists
        session = request.getSession(false); 
        String user = (session != null) ? (String) session.getAttribute("username") : null;
        if (user == null) {
    %>
    <script>
        window.location.href = "Login.jsp"; 
    </script>
    <%
        } else {
            int user_id = (Integer) session.getAttribute("user_id");
            int po_id = Integer.parseInt(request.getParameter("po_id"));
            String status = request.getParameter("status");

            String url = "jdbc:postgresql:project";
            String dbUsername = "postgres";
            String dbPassword = "1234";

            try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
                 PreparedStatement pstmt = con.prepareStatement("UPDATE purchases SET status=? WHERE id=? AND admin_id=?")) {

                pstmt.setString(1, status);
                pstmt.setInt(2, po_id);
                pstmt.setInt(3, user_id);

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.println("<script>alert('Purchase order updated successfully');</script>");
                    response.sendRedirect("ViewPurchaseOrders.jsp");
                } else {
                    out.println("<script>alert('Failed to update purchase order');</script>");
                    response.sendRedirect("ViewPurchaseOrders.jsp");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
