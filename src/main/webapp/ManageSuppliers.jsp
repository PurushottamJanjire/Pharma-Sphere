<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="java.util.*" %>

<%
    session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;
    int user_id = 0;

    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    } else {
        user_id = (Integer) session.getAttribute("user_id");
    }

    String url = "jdbc:postgresql:project";
    String dbUsername = "postgres";
    String dbPassword = "1234";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    if (request.getParameter("deleteSupplier") != null) {
        String supplierId = request.getParameter("supplierIdToDelete");
        try {
            con = DriverManager.getConnection(url, dbUsername, dbPassword);
            String sql = "DELETE FROM suppliers WHERE id = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(supplierId));
            pstmt.executeUpdate();
            out.println("<div class='alert alert-success text-center'>Supplier Deleted Successfully!</div>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div class='alert alert-danger text-center'>Error deleting supplier: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Suppliers</title>
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">    <style>
        body {
             background: linear-gradient(to right, #f5f7fa, #c3cfe2);
    		font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.4s ease;
        }
        .sidebar {
         background: #B2BDD0;
            height: 100vh;
            width: 300px;
            position: fixed;
            top: 0;
            left: 0;
          
            padding-top: 0px;
            transition: all 0.5s ease;
        }
        .sidebar h3 {
        
           background: linear-gradient(90deg, #006699,#007A8E);
           font-color:white;
            font-weight: bold;
            margin-bottom: 30px;
             padding: 30px;
             margin-top:0px;
        }
        .sidebar a {
             width: 90%;
    margin: 10px;
    border-radius: 10px;

    border: none;
    color: white;
     box-shadow: 0 0 4px 1px rgba(6, 19, 46, 0.39);
    transition: background-color 0.3s ease;
        }
        .sidebar a:hover {
            background-color: #A5A6AE;
     box-shadow: 0 0 4px 1px rgba(164, 195, 217, 0.8);
        }
        .main-content {
            margin-left: 300px;
            padding: 30px;
            transition: margin-left 0.3s;
        }
        
     .table-container {
            padding: 40px;
            overflow-x: auto;
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
    color: white; 
}

table tr:nth-child(even) {
    background-color: #f2f2f2;
}
        .btn-custom {
            border-radius: 5px;
            padding: 8px 25px;
            transition: background-color 0.3s, transform 0.2s;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
        }
        .btn-view {
            background-color: #17a2b8;
            color: white;
        }
        .btn-view:hover {
            background-color: #138496;
        }
        .btn-delete {
            background-color: #dc3545;
            color: white;
        }
        .btn-delete:hover {
            background-color: #bd2130;
        }
        .btn-add {
            background-color: #28a745;
            color: white;
        }
        .btn-add:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <div class="sidebar text-center">
        <h3 >Pharma Sphere</h3>
        <a href="Home.jsp" class="btn btn-dark"><i class="fa-solid fa-house"></i> Home</a>
        <a href="CreatePurchaseOrder.jsp" class="btn btn-dark"><i class="fas fa-cart-plus"></i> Create Purchase Order</a>
        <a href="ManageSuppliers.jsp"  class="btn btn-dark"><i class="fa-solid fa-users-gear"></i> Manage Suppliers</a>
        <a href="PurchaseOrders.jsp" class="btn btn-dark"><i class="fa-solid fa-cart-shopping"></i> View Purchase Orders</a>
        <a href="Logout.jsp" class="btn btn-dark"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2 class="mb-4 fw-bold">Manage Suppliers</h2>

        <h4 class="mb-3">Existing Suppliers</h4>
        <div class="table-container">
        <table class="table table-hover">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        con = DriverManager.getConnection(url, dbUsername, dbPassword);
                        String sql = "SELECT id, name, email, phone FROM suppliers WHERE a_id = " + user_id;
                        pstmt = con.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int supplierId = rs.getInt("id");
                            String name = rs.getString("name");
                            String email = rs.getString("email");
                            String phone = rs.getString("phone");
                %>
                <tr>
                    <td><%= supplierId %></td>
                    <td><%= name %></td>
                    <td><%= email %></td>
                    <td><%= phone %></td>
                    <td>
                        <a href="ViewSupplier.jsp?supplierId=<%= supplierId %>" class="btn btn-warning btn-sm">view</a>
                        <form method="post" action="ManageSuppliers.jsp" style="display:inline;">
                            <input type="hidden" name="supplierIdToDelete" value="<%= supplierId %>">
                            <button type="submit" name="deleteSupplier" class="btn btn-delete btn-sm"> delete</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        out.println("<div class='alert alert-danger text-center'>Error fetching suppliers: " + e.getMessage() + "</div>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>
	</div>
        <div class="text mt-4">
            <a href="AddSupplier.jsp" class="btn btn-add ">Add New Supplier</a>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
