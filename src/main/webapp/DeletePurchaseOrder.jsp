<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Purchase Order</title>
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

            String url = "jdbc:postgresql:project";
            String dbUsername = "postgres";
            String dbPassword = "1234";

            try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
                 PreparedStatement deletePstmt = con.prepareStatement("DELETE FROM purchases WHERE id=? AND admin_id=?")) {

                deletePstmt.setInt(1, po_id);
                deletePstmt.setInt(2, user_id);

                int rowsAffected = deletePstmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.println("<script>alert('Purchase Order deleted successfully');</script>");
                    response.sendRedirect("PurchaseOrders.jsp");
                } else {
                    out.println("<script>alert('Failed to delete purchase order');</script>");
                    response.sendRedirect("PurchaseOrders.jsp");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html> 
