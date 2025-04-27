<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Orders | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
        	background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.5s ease;
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

header h2, header h4, header span {
    color: white !important;
}


        .main-content {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
            padding: 30px;
            animation: fadeInUp 0.5s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
         #logout {
            border-radius: 5px;
            border: 1px solid #fff;
            background-color: transparent;
            color: #fff;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
       #backButton:hover, #logout:hover {
            background-color: #fff;
            color: #007bff;
        }

        .table {
            border-radius: 10px;
            overflow: hidden;
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }

        .btn-secondary, .btn-light {
            transition: transform 0.3s;
        }

        .btn-secondary:hover, .btn-light:hover {
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            header h2, header h4 {
                font-size: 20px;
            }
            .table th, .table td {
                font-size: 14px;
            }
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

            List<Map<String, String>> purchaseOrders = new ArrayList<>();

            try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
                 PreparedStatement pstmt = con.prepareStatement(
                     "SELECT p.id, s.name AS supplier, p.total_amount, p.status, p.order_date " +
                     "FROM purchases p " +
                     "JOIN suppliers s ON p.supplier_id = s.id " +
                     "WHERE p.admin_id = ?")) {

                pstmt.setInt(1, user_id);

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, String> poDetails = new HashMap<>();
                        poDetails.put("id", String.valueOf(rs.getInt("id")));
                        poDetails.put("supplier", rs.getString("supplier"));
                        poDetails.put("total_amount", String.format("%.2f", rs.getFloat("total_amount")));
                        poDetails.put("status", rs.getString("status") == null ? "Pending" : rs.getString("status"));
                        poDetails.put("order_date", rs.getTimestamp("order_date").toString());
                        purchaseOrders.add(poDetails);
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
    %>

 <header>
<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
    <i class="fas fa-arrow-left"></i> Back
</button>
    <h2><i class="fas fa-capsules"></i> View Purchase Orders</h2>
    <span><button id="printBtn" onvlick="window.print();" class="btn btn-outline-light me-2"><i class="fas fa-print"></i> Print</button>
     <button id="logout" class="btn btn-outline-light"><i class="fas fa-sign-out-alt"></i> Logout</button></span>
   
</header>


    <div class="container mt-5">
        <div class="main-content">
            <h3 class="mb-3">📋 Your Purchase Orders</h3>
            <p class="text-muted">Here is a list of all your purchase orders with status and total amount details.</p>

            <% if(purchaseOrders.isEmpty()) { %>
                <div class="alert alert-info shadow-sm" role="alert">
                    <strong>No purchase orders found.</strong> Create a new purchase order to get started.
                </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover table-striped">
                    <thead class="table-primary">
                        <tr>
                            <th>PO ID</th>
                            <th>Supplier</th>
                            <th>Total Amount (<i class="fa-solid fa-indian-rupee-sign"></i>)</th>
                            <th>Status</th>
                            <th>Order Date</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Map<String, String> po : purchaseOrders) { %>
                            <tr>
                                <td><%= po.get("id") %></td>
                                <td><%= po.get("supplier") %></td>
                                <td><%= po.get("total_amount") %></td>
                                <td><span class="badge bg-<%= po.get("status").equals("Completed") ? "success" : "warning" %>">
                                    <%= po.get("status") %></span>
                                </td>
                                <td><%= po.get("order_date") %></td>
                                <td>
                                    <a href="ViewPurchaseOrders.jsp?id=<%= po.get("id") %>" class="btn btn-primary btn-sm">View Order</a>
                                     <a href="DeletePurchaseOrder.jsp?po_id=<%= po.get("id") %>" class="btn btn-danger btn-sm" title="Delete Purchase Order"
                           onclick="return confirm('Delete this purchase order?')"><i class="fas fa-trash-alt"></i></a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('logout')?.addEventListener('click', function() {
            window.location.href = 'Logout.jsp';
        });
    </script>
</body>
</html>
