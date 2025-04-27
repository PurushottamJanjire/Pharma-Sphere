<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Today's Report | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        header {
            background: linear-gradient(90deg, #007A8E, #006699);
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .main-content {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 30px;
        }
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        #logout, #printBtn {
            border-radius: 5px;
            border: 1px solid #fff;
            background-color: transparent;
            color: #fff;
        }
        #backButton:hover, #logout:hover, #printBtn:hover {
            background-color: #fff;
            color: #007bff;
        }
    </style>
</head>
<body>
<%
    session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;

    if (user == null) {
%>
    <script>window.location.href = "Login.jsp";</script>
<%
    } else {
        int user_id = (Integer) session.getAttribute("user_id");
        String url = "jdbc:postgresql:project";
        String dbUsername = "postgres";
        String dbPassword = "1234";

        List<Map<String, String>> todaySales = new ArrayList<>();
        List<Map<String, String>> todayPurchases = new ArrayList<>();
        String today = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword)) {

            // Get Today's Sales
            String salesQuery = "SELECT s.id, s.customer_name, s.total_amount, s.date " +
                                "FROM sales s WHERE s.admin_id=? AND CAST(s.date AS DATE)=?";
            try (PreparedStatement pst = con.prepareStatement(salesQuery)) {
                pst.setInt(1, user_id);
                pst.setDate(2, java.sql.Date.valueOf(today));
                try (ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("id", String.valueOf(rs.getInt("id")));
                        row.put("customer_name", rs.getString("customer_name"));
                        row.put("amount", String.format("%.2f", rs.getFloat("total_amount")));
                        row.put("date", rs.getTimestamp("date").toString());
                        todaySales.add(row);
                    }
                }
            }

            // Get Today's Purchases
            String purchaseQuery = "SELECT p.id, s.name AS supplier, p.total_amount, p.order_date " +
                                   "FROM purchases p JOIN suppliers s ON p.supplier_id = s.id " +
                                   "WHERE p.admin_id=? AND CAST(p.order_date AS DATE)=?";
            try (PreparedStatement pst = con.prepareStatement(purchaseQuery)) {
                pst.setInt(1, user_id);
                pst.setDate(2, java.sql.Date.valueOf(today));
                try (ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> row = new HashMap<>();
                        row.put("id", String.valueOf(rs.getInt("id")));
                        row.put("supplier", rs.getString("supplier"));
                        row.put("amount", String.format("%.2f", rs.getFloat("total_amount")));
                        row.put("date", rs.getTimestamp("order_date").toString());
                        todayPurchases.add(row);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
%>

<header>
    <button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
        <i class="fas fa-arrow-left"></i> Back
    </button>
    <h2><i class="fas fa-calendar-day"></i> Today's Report</h2>
    <div>
        <button id="printBtn" class="btn btn-outline-light me-2"><i class="fas fa-print"></i> Print</button>
        <button id="logout" class="btn btn-outline-light"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </div>
</header>

<div class="container">
    <div class="main-content">
        <h4 class="mb-4 text-primary"><i class="fas fa-file-invoice-dollar"></i> Today's Sales</h4>
        <% if (todaySales.isEmpty()) { %>
            <div class="alert alert-info">No sales made today.</div>
        <% } else { %>
        <table class="table table-bordered table-hover">
            <thead class="table-success">
                <tr>
                    <th>Sale ID</th>
                    <th>Customer</th>
                    <th>Amount (₹)</th>
                    <th>Time</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> row : todaySales) { %>
                <tr>
                    <td><%= row.get("id") %></td>
                    <td><%= row.get("customer_name") %></td>
                    <td><%= row.get("amount") %></td>
                    <td><%= row.get("date") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>

        <h4 class="mb-4 mt-5 text-primary"><i class="fas fa-truck-loading"></i> Today's Purchases</h4>
        <% if (todayPurchases.isEmpty()) { %>
            <div class="alert alert-info">No purchases made today.</div>
        <% } else { %>
        <table class="table table-bordered table-hover">
            <thead class="table-warning">
                <tr>
                    <th>Purchase ID</th>
                    <th>Supplier</th>
                    <th>Amount (₹)</th>
                    <th>Time</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> row : todayPurchases) { %>
                <tr>
                    <td><%= row.get("id") %></td>
                    <td><%= row.get("supplier") %></td>
                    <td><%= row.get("amount") %></td>
                    <td><%= row.get("date") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

<script>
    document.getElementById('logout').addEventListener('click', () => {
        window.location.href = 'Logout.jsp';
    });

    document.getElementById('printBtn').addEventListener('click', () => {
        window.print();
    });
</script>

<% } %>
</body>
</html>
