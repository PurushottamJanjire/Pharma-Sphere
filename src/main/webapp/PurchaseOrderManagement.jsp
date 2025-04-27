<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%
    String url = "jdbc:mysql://localhost:3306/project";
    String dbUsername = "root";
    String dbPassword = "1234";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Add Purchase Order Logic
    if (request.getParameter("createOrder") != null) {
        int supplierId = Integer.parseInt(request.getParameter("supplier_id"));
        int medicineId = Integer.parseInt(request.getParameter("medicine_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try {
            con = DriverManager.getConnection(url, dbUsername, dbPassword);
            String sql = "INSERT INTO PurchaseOrder (supplier_id, medicine_id, quantity) VALUES (?, ?, ?)";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, supplierId);
            pstmt.setInt(2, medicineId);
            pstmt.setInt(3, quantity);
            pstmt.executeUpdate();
            out.println("<script>alert('Purchase order created successfully.');</script>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('Error occurred: " + e.getMessage() + "');</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<header>
    <div class="header-content">
        <h2>E-Pharma Manager</h2>
        <button type="button" id="logout" class="btn btn-light">Logout</button>
    </div>
</header>

<div class="container">
    <h2>Purchase Order Management</h2>

    <!-- Form to Create Order -->
    <form method="post" action="PurchaseOrderManagement.jsp">
        <div class="mb-3">
            <label for="supplier_id" class="form-label">Supplier:</label>
            <select class="form-select" name="supplier_id" required>
                <%
                try {
                    con = DriverManager.getConnection(url, dbUsername, dbPassword);
                    String sql = "SELECT * FROM Supplier";
                    pstmt = con.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                %>
                        <option value="<%= id %>"><%= name %></option>
                <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                %>
            </select>
        </div>

        <!-- Medicine selection -->
        <div class="mb-3">
            <label for="medicine_id" class="form-label">Medicine:</label>
            <select class="form-select" name="medicine_id" required>
                <%
                try {
                    con = DriverManager.getConnection(url, dbUsername, dbPassword);
                    String sql = "SELECT * FROM medicine";
                    pstmt = con.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        int id = rs.getInt("m_id");
                        String name = rs.getString("m_name");
                %>
                        <option value="<%= id %>"><%= name %></option>
                <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                %>
            </select>
        </div>

        <!-- Quantity input -->
        <div class="mb-3">
            <label for="quantity" class="form-label">Quantity:</label>
            <input type="number" class="form-control" name="quantity" required>
        </div>

        <!-- Submit button -->
        <button type="submit" name="createOrder" class="btn btn-primary">Create Order</button>
    </form>

    <!-- Display Purchase Orders -->
    <h3 class="mt-5">Purchase Orders</h3>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>Supplier</th>
                <th>Medicine</th>
                <th>Quantity</th>
                <th>Order Date</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT po.id, s.name AS supplier_name, m.m_name AS medicine_name, po.quantity, po.order_date, po.status " +
                             "FROM PurchaseOrder po " +
                             "JOIN Supplier s ON po.supplier_id = s.id " +
                             "JOIN medicine m ON po.medicine_id = m.m_id";
                pstmt = con.prepareStatement(sql);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String supplierName = rs.getString("supplier_name");
                    String medicineName = rs.getString("medicine_name");
                    int quantity = rs.getInt("quantity");
                    Timestamp orderDate = rs.getTimestamp("order_date");
                    String status = rs.getString("status");
        %>
                    <tr>
                        <td><%= id %></td>
                        <td><%= supplierName %></td>
                        <td><%= medicineName %></td>
                        <td><%= quantity %></td>
                        <td><%= orderDate %></td>
                        <td><%= status %></td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
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
