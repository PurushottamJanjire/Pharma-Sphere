<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Medicine | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
        background: linear-gradient(to right, #f5f7fa, #c3cfe2);
        }
        .form-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .form-label {
            font-weight: 600;
        }
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 5px rgba(13, 110, 253, 0.5);
        }
        .btn-primary, .btn-secondary {
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 8px;
        }
        .btn-primary:hover {
            background-color: #0b5ed7;
        }
        .btn-secondary:hover {
            background-color: #6c757d;
        }
    </style>
</head>
<body>

<%
    session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;
    int user_id = (session != null) ? (Integer) session.getAttribute("user_id") : 0;

    if (user == null) {
%>
    <script> window.location.href = "Login.jsp"; </script>
<%
    } else {
        String url = "jdbc:postgresql:project";
        String dbUsername = "postgres";
        String dbPassword = "1234";
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        int m_id = Integer.parseInt(request.getParameter("m_id"));

        if (request.getMethod().equals("POST")) {
            String name = request.getParameter("name");
            String manufacturer = request.getParameter("manufacturer");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            int stock = Integer.parseInt(request.getParameter("stock"));
            int threshold = Integer.parseInt(request.getParameter("threshold"));
            float price = Float.parseFloat(request.getParameter("price"));
            String e_date = request.getParameter("expiry_date");
            int supplier_id = Integer.parseInt(request.getParameter("supplier_id"));
            Date expiry_date=Date.valueOf(e_date);
            
            
            try {
                Class.forName("org.postgresql.Driver");
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "UPDATE medicine SET name=?, manufacturer=?, category=?, description=?, stock=?, threshold=?, price=?, expiry_date=?, supplier_id=? WHERE m_id=? AND admin_id=?";
                psmt = con.prepareStatement(sql);
                psmt.setString(1, name);
                psmt.setString(2, manufacturer);
                psmt.setString(3, category);
                psmt.setString(4, description);
                psmt.setInt(5, stock);
                psmt.setInt(6, threshold);
                psmt.setFloat(7, price);
                psmt.setDate(8, expiry_date);
                psmt.setInt(9, supplier_id);
                psmt.setInt(10, m_id);
                psmt.setInt(11, user_id);

                int updated = psmt.executeUpdate();
                if (updated > 0) {
%>
                    <script>
                        alert("Medicine updated successfully!");
                        window.location.href = "MedicineManagement.jsp";
                    </script>
<%
                }
            } catch (Exception e) {
            	out.print(expiry_date);
                e.printStackTrace();
            } finally {
                if (psmt != null) try { psmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }

        String name = "", manufacturer = "", category = "", description = "", expiry_date = "";
        int stock = 0, threshold = 0, supplier_id = 0;
        float price = 0;

        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(url, dbUsername, dbPassword);
            String sql = "SELECT * FROM medicine WHERE m_id=? AND admin_id=?";
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, m_id);
            psmt.setInt(2, user_id);
            rs = psmt.executeQuery();

            if (rs.next()) {
                name = rs.getString("name");
                manufacturer = rs.getString("manufacturer");
                category = rs.getString("category");
                description = rs.getString("description");
                stock = rs.getInt("stock");
                threshold = rs.getInt("threshold");
                price = rs.getFloat("price");
                expiry_date = rs.getString("expiry_date");
                supplier_id = rs.getInt("supplier_id");
            }
        } catch (Exception e) {
        	
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (psmt != null) try { psmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
%>

<div class="container mt-5">
    <div class="form-container">
        <h2 class="text-center mb-4"> Edit Medicine Details</h2>
        <form method="post">
            <input type="hidden" name="m_id" value="<%= m_id %>">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Medicine Name</label>
                    <input type="text" name="name" class="form-control" value="<%= name %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Manufacturer</label>
                    <input type="text" name="manufacturer" class="form-control" value="<%= manufacturer %>" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Category</label>
                    <input type="text" name="category" class="form-control" value="<%= category %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Stock</label>
                    <input type="number" name="stock" class="form-control" value="<%= stock %>" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3" required><%= description %></textarea>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Threshold</label>
                    <input type="number" name="threshold" class="form-control" value="<%= threshold %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Price (Rs)</label>
                    <input type="text" name="price" class="form-control" value="<%= price %>" required>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Expiry Date</label>
                    <input type="date" name="expiry_date" class="form-control" value="<%= expiry_date %>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Supplier ID</label>
                    <input type="number" name="supplier_id" class="form-control" value="<%= supplier_id %>" required>
                </div>
            </div>

            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-primary"> Update Medicine</button>
                <a href="MedicineManagement.jsp" class="btn btn-secondary"> Cancel</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
<% } %>
