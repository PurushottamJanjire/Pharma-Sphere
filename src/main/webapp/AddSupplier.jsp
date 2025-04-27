<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Management</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
	 <link href="AddSupplier.css" rel="stylesheet">
</head>
<body>

<%
session = request.getSession(false);
String user = (session != null) ? (String) session.getAttribute("username") : null;
int user_id = 0;
if (user == null) {
%>
<script>
    window.location.href = "Login.jsp";
</script>
<%
} else {
    user_id = (Integer) session.getAttribute("user_id");
    String url = "jdbc:postgresql:project";
    String dbUsername = "postgres";
    String dbPassword = "1234";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Add Supplier
    if (request.getParameter("addSupplier") != null) {
        String name = request.getParameter("name");
        String contactDetails = request.getParameter("contact_details");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, dbUsername, dbPassword);
            String sql = "INSERT INTO suppliers (name, contact_details, email, phone, a_id) VALUES (?, ?, ?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, contactDetails);
            pstmt.setString(3, email);
            pstmt.setString(4, phone);
            pstmt.setInt(5, user_id);
            pstmt.executeUpdate();
            out.println("<script>alert('Supplier added successfully.'); window.location='AddSupplier.jsp';</script>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Error occurred: " + e.getMessage() + "');</script>");
        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        }
    }

    // Delete Supplier
    if (request.getParameter("deleteSupplier") != null) {
        int supplierId = Integer.parseInt(request.getParameter("supplierId"));
        try {
            con = DriverManager.getConnection(url, dbUsername, dbPassword);
            String sql = "DELETE FROM suppliers WHERE id = ? AND a_id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, supplierId);
            pstmt.setInt(2, user_id);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<script>alert('Supplier deleted successfully.'); window.location='AddSupplier.jsp';</script>");
            } else {
                out.println("<script>alert('Error: Supplier not found or does not belong to you.');</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Error occurred: " + e.getMessage() + "');</script>");
        } finally {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        }
    }
%>

<div class="container">
    <h2>Supplier Management</h2>
    <form method="post" action="AddSupplier.jsp">
        <div class="mb-3">
            <label for="name" class="form-label">Supplier Name:</label>
            <input type="text" class="form-control" name="name" required>
        </div>
        <div class="mb-3">
            <label for="contact_details" class="form-label">Contact Details:</label>
            <input type="text" class="form-control" name="contact_details" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email:</label>
            <input type="email" class="form-control" name="email" required>
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Phone:</label>
            <input type="text" class="form-control" name="phone" required>
        </div>
        <button type="submit" name="addSupplier" class="btn btn-primary">Add Supplier</button>
    </form>
    
    <h3 class="mt-5">Supplier List</h3>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Contact Details</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT * FROM suppliers WHERE a_id = ?";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, user_id);
                rs = pstmt.executeQuery();
                while (rs.next()) {
        %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("contact_details") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("phone") %></td>
                        <td>
                            <form method="post" action="AddSupplier.jsp" onsubmit="return confirm('Are you sure you want to delete this supplier?');">
                                <input type="hidden" name="supplierId" value="<%= rs.getInt("id") %>">
                                <button type="submit" name="deleteSupplier" class="btn btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            }
        }
        %>
        </tbody>
    </table>
</div>

<script>
document.getElementById("logout").onclick = function() {
    window.location.href = "Logout.jsp";
};
</script>
</body>
</html>
