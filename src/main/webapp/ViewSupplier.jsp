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

    String supplierId = request.getParameter("supplierId");
    if (supplierId == null) {
        response.sendRedirect("ManageSuppliers.jsp");
        return;
    }

    String url = "jdbc:postgresql:project";
    String dbUsername = "postgres";
    String dbPassword = "1234";
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String name = "", email = "", phone = "", contact_details = "";
    try {
        con = DriverManager.getConnection(url, dbUsername, dbPassword);
        String sql = "SELECT name, email, phone, contact_details FROM suppliers WHERE id = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, Integer.parseInt(supplierId));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
            contact_details = rs.getString("contact_details");
        } else {
            out.println("<div class='alert alert-danger'>Supplier not found!</div>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f9f9f9;
            transition: background-color 0.3s ease-in-out;
        }
        .card {
            border-radius: 15px;
            transition: transform 0.3s;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
            border-radius: 20px;
            padding: 10px 30px;
            transition: background-color 0.3s ease-in-out;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow-lg p-4">
                    <h2 class="text-center mb-4">Supplier Details</h2>
                    <table class="table table-bordered table-striped">
                        <tr>
                            <th>Name</th>
                            <td><%= name %></td>
                        </tr>
                        <tr>
                            <th>Email</th>
                            <td><%= email %></td>
                        </tr>
                        <tr>
                            <th>Phone</th>
                            <td><%= phone %></td>
                        </tr>
                        <tr>
                            <th>Contact Details</th>
                            <td><%= contact_details %></td>
                        </tr>
                    </table>
                    <div class="text-center">
                        <a href="ManageSuppliers.jsp" class="btn btn-custom mt-3">Back to Manage Suppliers</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
