<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
   
    <style>
        body {
            background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        header {
         background: linear-gradient(90deg, #007A8E, #006699);
            background-color: #0d6efd;
            color: white;
            padding: 20px;
            animation: slideDown 0.5s ease;
        }
        @keyframes slideDown {
            from { transform: translateY(-100%); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .btn-primary:hover {
            background-color: #0b5ed7;
        }
        #logout {
    border-radius: 5px;
    border: 1px solid #fff;
    color: #fff;
    background-color: transparent;
    transition: 0.3s;
}

#backButton:hover,#logout:hover {
    background-color: #fff;
    color: #007bff;
}
        
        footer {
            text-align: center;
            margin-top: 30px;
            padding: 10px;
            background-color: #e9ecef;
            color: #6c757d;
        }
    </style>
</head>
<body>

<header class="d-flex justify-content-between align-items-center">
<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp'">
    <i class="fas fa-arrow-left"></i> Back
</button>
	 <h2><b>Pharma Sphere |</b> Sales Report </h2>
  
	
   
    <div>
        <span> <%= user %>!</span>
     
         <button class="btn btn-outline-light" id="logout" onclick="window.location.href='Logout.jsp'"><i class="fas fa-sign-out-alt"></i> Logout</button>
    </div>
</header>

<div class="container mt-5">
    <h2> Sales Overview</h2>
    <p class="text-muted">View total sales, quantities sold, and sales analysis.</p>

    <form method="get" action="">
        <div class="row g-3">
            <div class="col-md-6">
                <label for="startDate" class="form-label" > Start Date</label>
                <input type="date" id="startDate" name="startDate" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label for="endDate" class="form-label" > End Date</label>
                <input type="date" id="endDate" name="endDate" class="form-control" required>
            </div>
        </div>
        <button type="submit" class="btn btn-primary mt-3"> Filter</button>
    </form>

    <%
        try {
            con = DriverManager.getConnection(url, dbUsername, dbPassword);

       
            String salesSummaryQuery = "SELECT SUM(s.total_amount) AS total_sales, SUM(si.quantity) AS total_quantity " +
                                       "FROM sales s JOIN sales_items si ON s.id = si.sale_id WHERE s.admin_id = ?";
            pstmt = con.prepareStatement(salesSummaryQuery);
            pstmt.setInt(1, user_id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
    %>
    <div class="alert alert-primary mt-4">
        <h5> Total Sales: <i class="fa-sharp fa-solid fa-indian-rupee-sign"></i> <%= rs.getFloat("total_sales") %></h5>
        <h5> Total Quantity Sold: <%= rs.getInt("total_quantity") %></h5>
    </div>
    <%
            } else {
    %>
    <div class="alert alert-warning mt-4"> No sales data found.</div>
    <%
            }

      
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            if (startDate != null && endDate != null) {
                String dateFilterQuery = "SELECT s.customer_name, m.name AS medicine_name, si.quantity, s.total_amount, s.date " +
                                         "FROM sales s JOIN sales_items si ON s.id = si.sale_id " +
                                         "JOIN medicine m ON si.medicine_id = m.m_id " +
                                         "WHERE s.admin_id = ? AND s.date BETWEEN ? AND ? ORDER BY s.date DESC";
                pstmt = con.prepareStatement(dateFilterQuery);
                pstmt.setInt(1, user_id);
                pstmt.setDate(2, Date.valueOf(startDate));
                pstmt.setDate(3, Date.valueOf(endDate));
                rs = pstmt.executeQuery();

                if (rs.next()) {
    %>
    <h4 class="mt-5"> Filtered Sales Results</h4>
    <table class="table table-bordered table-hover mt-3">
        <thead class="table-primary">
            <tr>
                <th> Customer</th>
                <th> Medicine</th>
                <th> Quantity</th>
                <th> Total Price</th>
                <th> Sale Date</th>
            </tr>
        </thead>
        <tbody>
        <%
            do {
        %>
            <tr>
                <td><%= rs.getString("customer_name") %></td>
                <td><%= rs.getString("medicine_name") %></td>
                <td><%= rs.getInt("quantity") %></td>
                <td><%= rs.getInt("total_amount") %></td>
                <td><%= rs.getTimestamp("date") %></td>
            </tr>
        <%
            } while (rs.next());
        %>
        </tbody>
    </table>
    <%
                } else {
    %>
    <div class="alert alert-warning mt-3"> No sales for the selected date range.</div>
    <%
                }
            }

           
            String avgSaleQuery = "SELECT AVG(s.total_amount) AS avg_sale FROM sales s WHERE s.admin_id = ?";
            pstmt = con.prepareStatement(avgSaleQuery);
            pstmt.setInt(1, user_id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
    %>
    <div class="alert alert-success mt-4">
        <h5> Average Sale Per Customer: <i class="fa-sharp fa-solid fa-indian-rupee-sign"></i> <%= rs.getFloat("avg_sale") %></h5>
    </div>
    <%
            }

            // Top Selling Medicines
            String topSellingQuery = "SELECT m.name AS medicine_name, SUM(si.quantity) AS total_sold " +
                                     "FROM sales_items si JOIN medicine m ON si.medicine_id = m.m_id " +
                                     "JOIN sales s ON si.sale_id = s.id " +
                                     "WHERE s.admin_id = ? GROUP BY m.name ORDER BY total_sold DESC LIMIT 5";
            pstmt = con.prepareStatement(topSellingQuery);
            pstmt.setInt(1, user_id);
            rs = pstmt.executeQuery();
    %>
    <h4 class="mt-5"> Top Selling Medicines</h4>
    <ul class="list-group mt-3">
        <%
            while (rs.next()) {
        %>
        <li class="list-group-item d-flex justify-content-between align-items-center">
            <%= rs.getString("medicine_name") %>
            <span class="badge bg-primary rounded-pill"><%= rs.getInt("total_sold") %> sold</span>
        </li>
        <%
            }
        %>
    </ul>

    <%
        } catch (SQLException e) {
            out.println("<div class='alert alert-danger mt-3'>❌ Error: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>

    <a href="Home.jsp" class="btn btn-secondary mt-4"> Back to Home</a>
</div>



<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js">


</script>
</body>
</html>
