<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Medicine - Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        #logout {
            border-radius: 5px;
            border: 1px solid #fff;
            color: #fff;
            background-color: transparent;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        #logout:hover {
            background-color: #fff;
            color: #007bff;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            margin: 60px auto;
            transition: transform 0.3s ease-in-out;
        }

        .form-container:hover {
            transform: translateY(-5px);
        }

        .form-control:focus {
            border-color: #00c6ff;
            box-shadow: 0 0 5px rgba(0, 198, 255, 0.5);
            transition: all 0.3s ease-in-out;
        }

        button[type="submit"] {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            background-color:#007A8E;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #A5C1C1;
        }

        @media (max-width: 768px) {
            .form-container {
                margin: 30px 20px;
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
    Integer user_id = (session != null) ? (Integer) session.getAttribute("user_id") : null;

    if (user == null || user_id == null) {
%>
    <script>window.location.href = "Login.jsp";</script>
<%
    } else {
%>

<header>
	<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
    <i class="fas fa-arrow-left"></i> Back
</button>
    <h2><i class="fas fa-capsules"></i> Pharma Sphere - Add Medicine</h2>
  <button class="btn btn-outline-light" id="logout"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

<%
    Connection con = null;
    PreparedStatement psmt = null;
    ResultSet rs = null;

    String url = "jdbc:postgresql:project";
    String dbUsername = "postgres";
    String dbPassword = "1234";

    try {
        Class.forName("org.postgresql.Driver");
        con = DriverManager.getConnection(url, dbUsername, dbPassword);
        String supplierQuery = "SELECT id, name FROM suppliers where a_id="+user_id;
        psmt = con.prepareStatement(supplierQuery);
        rs = psmt.executeQuery();
%>

<div class="form-container">
    <h3 class="text-center mb-4"><i class="fas fa-plus-circle"></i> Add Medicine Details</h3>
    <form method="post" action="AddMedicine.jsp">
        <div class="mb-3">
            <label class="form-label">Medicine Name</label>
            <input type="text" class="form-control" name="name" required>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Quantity</label>
                <input type="number" class="form-control" name="qty" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Cost</label>
                <input type="text" class="form-control" name="price" required>
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label">Manufacturer</label>
            <input type="text" class="form-control" name="company" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Medicine Type</label>
            <input type="text" class="form-control" name="type" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Description</label>
            <textarea class="form-control" name="desc" rows="2" required></textarea>
        </div>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Threshold</label>
                <input type="number" class="form-control" name="threshold" required>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Expiry Date</label>
                <input type="date" class="form-control" name="expiry_date" required>
            </div>
        </div>
		<div class=" mb-3">
                <label class="form-label">Batch No.</label>
                <input type="text" class="form-control" name="batch_no" required>
            </div>
      
        <div class="mb-3">
            <label class="form-label">Supplier</label>
            <select class="form-select" name="supplier" required>
                <option value="">Select Supplier</option>
                <% while (rs.next()) { %>
                    <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
                <% } %>
            </select>
        </div>

        <button type="submit" class="btn btn-secondary"><i class="fas fa-plus"></i> Add Medicine</button>
    </form>
  
</div>
  
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (psmt != null) psmt.close();
        if (con != null) con.close();
    }
%>

<script>
    document.getElementById("logout").onclick = () => window.location.href = "Logout.jsp";
</script>

<%
    if (request.getParameter("company") != null && request.getParameter("supplier") != null) {
    	 if (request.getParameter("company") != null && request.getParameter("supplier") != null) {
    	        String name = request.getParameter("name");
    	        String company = request.getParameter("company");
    	        float price = 0;
    	        int qty = 0;
    	        int thrs = 0;
    	        int supplier_id = 0;

    	        try {
    	            price = Float.parseFloat(request.getParameter("price"));
    	            qty = Integer.parseInt(request.getParameter("qty"));
    	            thrs = Integer.parseInt(request.getParameter("threshold"));
    	            supplier_id = Integer.parseInt(request.getParameter("supplier"));
    	        } catch (NumberFormatException e) {
    	            out.println("<script>alert('Invalid input format.');</script>");
    	        }

    	        String type = request.getParameter("type");
    	        String desc = request.getParameter("desc");
    	        String e_date = request.getParameter("expiry_date");
    	        String batch_no=(request.getParameter("batch_no")!=null)?request.getParameter("batch_no"):null;

    	        Connection conn = null;
    	        PreparedStatement pstmt = null;

    	        try {
    	            Class.forName("org.postgresql.Driver");
    	            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

    	            // Corrected SQL Query (Ensure correct column names)
    	            String sql = "INSERT INTO medicine (admin_id, category, manufacturer, description, price, stock, threshold, expiry_date, supplier_id, name,batch_no) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
    	            
    	            pstmt = conn.prepareStatement(sql);
    	            pstmt.setInt(1, user_id);
    	            pstmt.setString(2, type);
    	            pstmt.setString(3, company);
    	            pstmt.setString(4, desc);
    	            pstmt.setFloat(5, price);
    	            pstmt.setInt(6, qty);
    	            pstmt.setInt(7, thrs);
    	            pstmt.setDate(8, java.sql.Date.valueOf(e_date));
    	            pstmt.setInt(9, supplier_id);
    	            pstmt.setString(10, name);
    	            pstmt.setString(11, batch_no);

    	            int result = pstmt.executeUpdate();
    	            if (result > 0) {
    	                out.println("<script>alert('Record added successfully.');</script>");
    	            } else {
    	                out.println("<script>alert('Failed to add record.');</script>");
    	            }
    	        } catch (Exception e) {
    	            e.printStackTrace();
    	            out.println("<script>alert('Error occurred: " + e.getMessage() + "');</script>");
    	        } finally {
    	            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    	            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    	        }
    	    }
    	
    }
}
%>
</body>
</html>
