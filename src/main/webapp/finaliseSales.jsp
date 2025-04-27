<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    session = request.getSession(false); 

    String user = (session != null) ? (String) session.getAttribute("username") : null;
    if (user == null) {
%>
    <script>
        window.location.href = "Login.jsp"; 
    </script>
<%
    } else {
    	
%>

<%
    String url = "jdbc:mysql://localhost:3306/project";
    String dbUsername = "root";
    String dbPassword = "1234";

    Connection conn = null;
    PreparedStatement pstmt = null;
    String message = "";
    int user_id = (Integer) session.getAttribute("user_id");
    if (request.getParameter("finalize_sale") != null) {
        String customerName = request.getParameter("customer_name");
        session = request.getSession();
        List<Map<String, Object>> cart = (List<Map<String, Object>>) session.getAttribute("cart");

        try {
        	 
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            conn.setAutoCommit(false); // Start transaction

            double totalPrice = 0;
            for (Map<String, Object> item : cart) {
                String medicineId = (String) item.get("medicineId");
                int quantity = (int) item.get("quantity");
                double price = (double) item.get("price");
                totalPrice += price * quantity;

                System.out.println(user_id);
                String insertQuery = "INSERT INTO sales (customer_name, medicine_id, quantity, sale_date, total_price,user_id) VALUES (?, ?, ?, NOW(), ?,?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, customerName);
                pstmt.setString(2, medicineId);
                pstmt.setInt(3, quantity);
                pstmt.setDouble(4, price * quantity);
                pstmt.setInt(5, user_id);
                pstmt.executeUpdate();

                // Update the medicine quantity
                String updateQuery = "UPDATE medicine SET qty = qty - ? WHERE m_id = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setInt(1, quantity);
                pstmt.setString(2, medicineId);
                pstmt.executeUpdate();
            }

            // Remove medicine with quantity 0
            String deleteQuery = "DELETE FROM medicine WHERE qty <= 0 and u_id="+user_id;
            pstmt = conn.prepareStatement(deleteQuery);
            pstmt.executeUpdate();

            conn.commit(); // Commit transaction
            session.removeAttribute("cart");
            message = "Sale finalized successfully!";
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on error
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            message = "Error: " + e.getMessage();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Finalize Sale</title>
</head>
<body>
    <h1>Finalize Sale</h1>
    <p><%= message %></p>
    <a href="AddSales.jsp">Add Another Sale</a>
</body>
</html>
<% }%>