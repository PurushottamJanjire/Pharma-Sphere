<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Order Details | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
         background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            margin-top: 30px;
        }
        .badge-status {
            font-size: 14px;
            padding: 5px 10px;
        }
    </style>
</head>

<body>
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
            int user_id = (Integer) session.getAttribute("user_id");
            String url = "jdbc:postgresql:project";
            String dbUsername = "postgres";
            String dbPassword = "1234";
            int purchaseId = Integer.parseInt(request.getParameter("id"));
        

            Map<String, String> orderDetails = new HashMap<>();
            List<Map<String, String>> medicines = new ArrayList<>();

            try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword)) {
                String query = "SELECT p.id, s.name AS supplier, p.total_amount, p.status, p.order_date " +
                               "FROM purchases p JOIN suppliers s ON p.supplier_id = s.id " +
                               "WHERE p.id = ? AND p.admin_id = ?";
                try (PreparedStatement pstmt = con.prepareStatement(query)) {
                    pstmt.setInt(1, purchaseId);
                    pstmt.setInt(2, user_id);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            orderDetails.put("id", String.valueOf(rs.getInt("id")));
                            orderDetails.put("supplier", rs.getString("supplier"));
                            orderDetails.put("total_amount", String.format("%.2f", rs.getFloat("total_amount")));
                            orderDetails.put("status", rs.getString("status") == null ? "Pending" : rs.getString("status"));
                            orderDetails.put("order_date", rs.getTimestamp("order_date").toString());
                        }
                    }
                }
                
                String medicineQuery = "SELECT m.name, pi.quantity, m.price FROM purchase_items pi JOIN medicine m ON pi.medicine_id = m.m_id WHERE pi.purchase_id =?";
                try (PreparedStatement pstmt = con.prepareStatement(medicineQuery)) {
                    pstmt.setInt(1, purchaseId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        while (rs.next()) {
                            Map<String, String> medDetails = new HashMap<>();
                            medDetails.put("name", rs.getString("name"));
                            medDetails.put("quantity", String.valueOf(rs.getInt("quantity")));
                            medDetails.put("price", String.format("%.2f", rs.getFloat("price")));
                            medicines.add(medDetails);
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
    %>

    <div class="container">
        <h2 class="mb-4">Purchase Order Details</h2>
        <div class="card shadow-sm p-4">
            <p><strong>PO ID:</strong> <%= orderDetails.get("id") %></p>
            <p><strong>Supplier:</strong> <%= orderDetails.get("supplier") %></p>
            <p><strong>Total Amount:</strong> <i class="fa-solid fa-indian-rupee-sign"></i> <%= orderDetails.get("total_amount") %></p>
            <p><strong>Status:</strong> <span class="badge bg-<%= orderDetails.get("status").equals("Completed") ? "success" : "warning" %> badge-status">
                <%= orderDetails.get("status") %></span></p>
            <p><strong>Order Date:</strong> <%= orderDetails.get("order_date") %></p>
        </div>

        <h3 class="mt-4">Medicines Ordered</h3>
        <% if (medicines.isEmpty()) { %>
            <div class="alert alert-warning">No medicines found for this purchase order.</div>
        <% } else { %>
            <table class="table table-bordered mt-3">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Quantity</th>
                        <th>Price (<i class="fa-solid fa-indian-rupee-sign"></i>)</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, String> med : medicines) { %>
                        <tr>
                            <td><%= med.get("name") %></td>
                            <td><%= med.get("quantity") %></td>
                            <td><%= med.get("price") %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <a href="PurchaseOrders.jsp" class="btn btn-secondary mt-3">Back to Purchase Orders</a>
    </div>
    <% } %>
</body>
</html>
