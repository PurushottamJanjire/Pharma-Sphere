<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medicine Management - Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
           background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
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
        .table-container {
            padding: 40px;
            overflow-x: auto;
        }
        table {
            background-color: white;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-radius: 15px;
            overflow: hidden;
            transition: transform 0.3s ease-in-out;
        }
        table:hover {
            transform: translateY(-5px);
        }
        th, td {
            text-align: center;
            vertical-align: middle;
        }
        .btn-warning, .btn-danger {
            transition: transform 0.2s ease-in-out;
        }
        .btn-warning:hover, .btn-danger:hover {
            transform: scale(1.1);
        }
        
        .btn-sm {
    min-width: 70px;
    margin:5px; 
    text-align: center;
   }
        
        @media (max-width: 768px) {
            .table-container {
                padding: 20px;
            }
            header {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>
<body>
<%
    session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;
    int user_id = 0;

    String url = "jdbc:postgresql:project";
    String dbUsername = "postgres";
    String dbPassword = "1234";
    Connection con = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;

    if (user == null) {
%>
    <script>window.location.href = "Login.jsp";</script>
<%
    } else {
        user_id = (Integer) session.getAttribute("user_id");
        if (request.getParameter("id") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
                Class.forName("org.postgresql.Driver");
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "DELETE FROM medicine WHERE m_id=?";
                psmt = con.prepareStatement(sql);
                psmt.setInt(1, id);
                int res = psmt.executeUpdate();

                if (res != 0) {
                    out.println("<script>Swal.fire('Deleted!','Record deleted successfully.','success');</script>");
                } else {
                    out.println("<script>Swal.fire('Failed!','Failed to delete record.','error');</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>Swal.fire('Error!','An error occurred: " + e.getMessage() + "','error');</script>");
            } finally {
                if (psmt != null) psmt.close();
                if (con != null) con.close();
            }
        }
    }
%>

<header>
<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
    <i class="fas fa-arrow-left"></i> Back
</button>
    <h2><i class="fas fa-capsules"></i> Pharma Sphere - Medicine Management</h2>
    
    <button id="logout" class="btn btn-outline-light"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

<div class="table-container">
    <table class="table table-bordered table-hover align-middle">
        <thead class="table-primary">
            <tr>
                <th>ID</th><th>Batch No</th><th>Name</th><th>Quantity</th><th>Company</th>
                <th>Price</th><th>Type</th><th>Description</th>
                <th>Threshold</th><th>Expiry Date</th><th>Supplier</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT m.*, s.name AS supplier_name FROM medicine m " +
                             "LEFT JOIN suppliers s ON m.supplier_id = s.id WHERE m.admin_id=? and m.stock>0";
                psmt = con.prepareStatement(sql);
                psmt.setInt(1, user_id);
                rs = psmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("m_id");
                    String batch = rs.getString("batch_no");
                    String name = rs.getString("name");
                    int quantity = rs.getInt("stock");
                    String company = rs.getString("manufacturer");
                    float price = rs.getFloat("price");
                    String type = rs.getString("category");
                    String description = rs.getString("description");
                    int threshold = rs.getInt("threshold");
                    java.sql.Date expiryDate = rs.getDate("expiry_date");
                    String supplierName = rs.getString("supplier_name");
        %>
                    <tr>
                        <td><%= id %></td> <td><%= batch %></td><td><%= name %></td><td><%= quantity %></td>
                        <td><%= company %></td><td><%= price %></td><td><%= type %></td>
                        <td><%= description %></td><td><%= threshold %></td><td><%= expiryDate %></td>
                        <td><%= (supplierName != null) ? supplierName : "N/A" %></td>
                        <td>
                            <a href="EditMedicine.jsp?m_id=<%= id %>" class="btn btn-warning btn-sm">
                                <i class="fas fa-edit"></i> Edit
                            </a>
                            <button class="btn btn-danger btn-sm delete-btn" data-id="<%= id %>">
                                <i class="fas fa-trash-alt"></i>Delete</button>
                        </td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (psmt != null) psmt.close();
                if (con != null) con.close();
            }
        %>
        </tbody>
    </table>
    
</div>

<script>
    document.getElementById("logout").onclick = () => window.location.href = "Logout.jsp";

    document.querySelectorAll('.delete-btn').forEach(button => {
        button.addEventListener('click', function() {
            const id = this.getAttribute('data-id');
            Swal.fire({
                title: 'Are you sure?',
                text: "This action cannot be undone!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = 'MedicineManagement.jsp';
                    const hiddenField = document.createElement('input');
                    hiddenField.type = 'hidden';
                    hiddenField.name = 'id';
                    hiddenField.value = id;
                    form.appendChild(hiddenField);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });
    });
</script>

</body>
</html>
