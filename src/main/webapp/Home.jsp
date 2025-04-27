<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, java.text.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pharma Sphere - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
     <style>
      
body {
      background: linear-gradient(to right, #f5f7fa, #c3cfe2);
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
    min-height: 100vh;
}


header {
    background: linear-gradient(90deg, #006699,#007A8E);
    padding: 20px;
    color: white;
    display: flex;
    justify-content:space-between;
    align-items:center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    animation: slideDown 0.5s ease;
}
@keyframes slideDown {
            from { transform: translateY(-100%); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }


header .logo img {
    
margin-right:100px;
    
}

header .header-content h2 {
    margin: 0;
    font-weight: 600;
}

#logout {
    border-radius: 5px;
    border: 1px solid #fff;
    color: #fff;
    background-color: transparent;
    transition: 0.3s;
}

#logout:hover {
    background-color: #fff;
    color: #007bff;
}


.sidebar {
    width: 260px;
   background: #B2BDD0;
    
    padding-top: 110px;
    position: fixed;
    top: 0;
    bottom: 0;
    overflow-y: auto;
    z-index: 900;
    transition: transform 0.3s ease;
}

.sidebar button {
    width: 90%;
    margin: 10px;
    border-radius: 10px;

    border: none;
    color: white;
     box-shadow: 0 0 4px 1px rgba(6, 19, 46, 0.39);
    transition: background-color 0.3s ease;
}

.sidebar button:hover {
    background-color: #A5A6AE;
     box-shadow: 0 0 4px 1px rgba(164, 195, 217, 0.8);
}

.sidebar button i {
    margin-right: 10px;
}

.sidebar.collapsed {
    transform: translateX(-100%);
}

.main-content {
	margin-top:20px;
    margin-left: 240px;
    padding: 100px 40px 40px;
    width: calc(100% - 240px);
    transition: margin-left 0.3s ease, width 0.3s ease;
}

@media (max-width: 768px) {
    .sidebar {
        transform: translateX(-100%);
        width: 230px;
    }
    .sidebar.active {
        transform: translateX(0);
    }

    .main-content {
        margin-left: 0;
        width: 100%;
    }
    }

.main-content h3 {
    font-size: 28px;
    color: #343a40;
    font-weight: 600;
}

.main-content.expanded {
    margin-left: 0;
    width: 100%;
}

.container {
    background-color: white;
    padding: 25px;
    border-radius: 15px;
    box-shadow: 0 4px 10px rgba(20, 20, 200, 0.5);
}

.alert {
    border-radius: 10px;
    padding: 15px;
}


footer {
    text-align: center;
    padding: 15px;
    background-color: #f1f1f1;
    margin-top: 30px;
    border-radius: 0 0 15px 15px;
}

footer button {
    border-radius: 20px;
    padding: 10px 20px;
}


table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
}

table th, table td {
    text-align: center;
    padding: 12px;
}

table th {
    background-color: #007bff;
    color: black;
}

table tr:nth-child(even) {
    background-color: #f2f2f2;
}

@media (max-width: 768px) {
    .sidebar {
        width: 100%;
        height: auto;
        position: relative;
    }

    .main-content {
        margin-left: 0;
        width: 100%;
        padding: 80px 20px;
    }

    header {
        flex-direction: column;
        text-align: center;
    }
}

.card-title i {
    margin-right: 10px;
}
.card:hover {
    transform: scale(1.05);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    cursor: pointer;
}

.card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}


    </style>
</head>
<body>
<%
    session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;
    Integer user_id = (session != null) ? (Integer) session.getAttribute("user_id") : null;

    if (user == null || user_id == null) {
%>
<script>window.location.href = "Login.jsp";</script>
<%
    } else {
        String url = "jdbc:postgresql:project";
        String dbUsername = "postgres";
        String dbPassword = "1234";

        List<String> lowStockAlerts = new ArrayList<>();
        List<String> expiryAlerts = new ArrayList<>();
        List<Map<String, String>> purchaseOrders = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
             PreparedStatement pstmt = con.prepareStatement("SELECT name, stock FROM medicine WHERE stock < threshold AND admin_id=? AND stock>0");
             PreparedStatement expiryPstmt = con.prepareStatement("SELECT name, expiry_date FROM medicine WHERE expiry_date < (CURRENT_DATE + INTERVAL '30 days') AND admin_id=? AND stock>0");
             PreparedStatement poPstmt = con.prepareStatement("SELECT po.id, s.name AS supplier_name, po.total_amount, po.status, po.order_date FROM purchases po JOIN suppliers s ON po.supplier_id = s.id WHERE po.admin_id = ? AND po.status = 'Pending';")) {

            pstmt.setInt(1, user_id);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    lowStockAlerts.add("Low stock alert for " + rs.getString("name") + ": Quantity is " + rs.getInt("stock"));
                }
            }

            expiryPstmt.setInt(1, user_id);
            try (ResultSet rs1 = expiryPstmt.executeQuery()) {
                while (rs1.next()) {
                    expiryAlerts.add("Expiry alert for " + rs1.getString("name") + ": Expiry date is " + rs1.getDate("expiry_date"));
                }
            }

            poPstmt.setInt(1, user_id);
            try (ResultSet rs2 = poPstmt.executeQuery()) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
                while (rs2.next()) {
                    Map<String, String> poDetails = new HashMap<>();
                    poDetails.put("id", String.valueOf(rs2.getInt("id")));
                    poDetails.put("supplier", rs2.getString("supplier_name"));
                    poDetails.put("total_amount", String.valueOf(rs2.getFloat("total_amount")));
                    poDetails.put("status", rs2.getString("status"));
                    poDetails.put("order_date", sdf.format(rs2.getTimestamp("order_date")));
                    purchaseOrders.add(poDetails);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        int totalSalesToday = 0;
        int totalPurchasesToday = 0;
        int totalStock = 0;
        float monthlyRevenue = 0;

        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword)) {
            try (PreparedStatement stmt = con.prepareStatement("SELECT COUNT(*) FROM sales WHERE DATE(date) = CURRENT_DATE AND admin_id = ?")) {
                stmt.setInt(1, user_id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) totalSalesToday = rs.getInt(1);
                }
            }

            try (PreparedStatement stmt = con.prepareStatement("SELECT COUNT(*) FROM purchases WHERE DATE(order_date) = CURRENT_DATE AND admin_id = ?")) {
                stmt.setInt(1, user_id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) totalPurchasesToday = rs.getInt(1);
                }
            }

            try (PreparedStatement stmt = con.prepareStatement("SELECT SUM(stock) FROM medicine WHERE admin_id = ?")) {
                stmt.setInt(1, user_id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) totalStock = rs.getInt(1);
                }
            }

            try (PreparedStatement stmt = con.prepareStatement("SELECT SUM(total_amount) FROM sales WHERE EXTRACT(MONTH FROM date) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM CURRENT_DATE) AND admin_id = ?")) {
                stmt.setInt(1, user_id);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) monthlyRevenue = rs.getFloat(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
%>

<header>
    <div class="d-flex align-items-center">
        <button class="btn btn-outline-light me-3" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <img src="R.png" alt="Logo" style=" height:50px;margin:0 30px 0 30px; ">
        <h2>Pharma Sphere</h2>
    </div>
    <h2>Welcome, <%= user %>!</h2>
    <button class="btn btn-outline-light" id="logout"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

<div class="sidebar">
    <button class="btn btn-dark" id="addMedi"><i class="fas fa-plus-circle"></i> Add Medicine</button>
     <button class="btn btn-dark" id="addSales"><i class="fas fa-cart-plus"></i> Add Sales</button>
      <button class="btn btn-dark" id="purchaseorder"><i class="fas fa-truck-loading"></i> Manage Purchase Order</button>
    <button class="btn btn-dark" id="mediReport"><i class="fas fa-pills"></i> Medicine Report</button>
   
    <button class="btn btn-dark" id="salesReport"><i class="fas fa-chart-line"></i> Sales Analysis</button>
   
    <button class="btn btn-dark" id="viewPurchaseOrders"><i class="fas fa-eye"></i> View Purchase Orders</button>
    <button class="btn btn-dark" id="salesanalysis"><i class="fas fa-chart-bar"></i> Sales Report</button>
    <button onclick="window.location.href='about.jsp'" class="btn btn-primary"><i class="fas fa-info-circle"></i> About</button>
</div>

<div class="main-content">
    <h3> Dashboard </h3>
    <div class="container">
       
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-white bg-primary shadow-sm rounded-4">
                    <div class="card-body" onclick="window.location.href ='TodayReport.jsp'">
                        <h5 class="card-title"><i class="fas fa-cash-register"></i> Sales Today</h5>
                        <p class="card-text fs-4"><%= totalSalesToday %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-success shadow-sm rounded-4">
                    <div class="card-body" onclick="window.location.href ='TodayReport.jsp'">
                        <h5 class="card-title"><i class="fas fa-truck"></i> Purchases Today</h5>
                        <p class="card-text fs-4"><%= totalPurchasesToday %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-info shadow-sm rounded-4">
                    <div class="card-body" onclick="window.location.href ='MedicineManagement.jsp'">
                        <h5 class="card-title"><i class="fas fa-pills"></i> Total Stock</h5>
                        <p class="card-text fs-4"><%= totalStock %></p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-white bg-warning shadow-sm rounded-4">
                    <div class="card-body" onclick="window.location.href ='salesReport.jsp'">
                        <h5 class="card-title"><i class="fa-solid fa-sack-dollar"></i> Revenue (This Month)</h5>
                        <p class="card-text fs-4"><i class="fa-solid fa-indian-rupee-sign"></i><%= monthlyRevenue %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts -->
        <% if (!lowStockAlerts.isEmpty()) { %>
        <div class="alert alert-warning"><strong><i class="fa fa-hourglass-3"></i> Low Stock Alerts:</strong>
            <ul><% for (String alert : lowStockAlerts) { %><li><%= alert %></li><% } %></ul>
        </div>
        <% } %>

        <% if (!expiryAlerts.isEmpty()) { %>
        <div class="alert alert-danger"><strong><i class="fa fa-exclamation-triangle"></i> Expiry Alerts:</strong>
            <ul><% for (String alert : expiryAlerts) { %><li><%= alert %></li><% } %></ul>
        </div>
        <% } %>

        
        <h3>Your Pending Purchase Orders:</h3>
        <% if (!purchaseOrders.isEmpty()) { %>
        <table class="table table-hover">
            <thead class="table-primary">
                <tr><th>PO ID</th><th>Supplier</th><th>Total Amount</th><th>Status</th><th>Order Date</th><th>Action</th></tr>
            </thead>
            <tbody>
                <% for (Map<String, String> po : purchaseOrders) { %>
                <tr>
                    <td><%= po.get("id") %></td>
                    <td><%= po.get("supplier") %></td>
                    <td><%= po.get("total_amount") %> Rs.</td>
                    <td><%= po.get("status") %></td>
                    <td><%= po.get("order_date") %></td>
                    <td>
                        <a href="EditPurchaseOrder.jsp?po_id=<%= po.get("id") %>" class="btn btn-warning btn-sm" title="Edit Purchase Order"><i class="fas fa-edit"></i></a>
                        <a href="DeletePurchaseOrder.jsp?po_id=<%= po.get("id") %>" class="btn btn-danger btn-sm" title="Delete Purchase Order"
                           onclick="return confirm('Delete this purchase order?')"><i class="fas fa-trash-alt"></i></a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>No pending purchase orders.</p>
        <% } %>
    </div>
</div>

<script>
    document.getElementById("sidebarToggle").onclick = function () {
        const sidebar = document.querySelector('.sidebar');
        const content = document.querySelector('.main-content');
        sidebar.classList.toggle('collapsed');
        content.classList.toggle('expanded');
    };

   
    document.getElementById("logout").onclick = () => window.location.href = "Logout.jsp";
    document.getElementById("addMedi").onclick = () => window.location.href = "AddMedicine.jsp";
    document.getElementById("mediReport").onclick = () => window.location.href = "MedicineManagement.jsp";
    document.getElementById("addSales").onclick = () => window.location.href = "AddSales.jsp";
    document.getElementById("salesReport").onclick = () => window.location.href = "salesReport.jsp";
    document.getElementById("purchaseorder").onclick = () => window.location.href = "ManageSuppliers.jsp";
    document.getElementById("viewPurchaseOrders").onclick = () => window.location.href = "PurchaseOrders.jsp";
    document.getElementById("salesanalysis").onclick = () => window.location.href = "SalesAnalysis.jsp";
    document.getElementById("card").onclick = () => window.location.href = "TodayReport.jsp";
</script>

<% } %>
</body>
</html>
