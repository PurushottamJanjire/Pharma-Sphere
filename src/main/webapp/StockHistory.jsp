<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="in.java.project.StockHistoryRecord" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<header>
    <div class="header-content">
        <h2>E-Pharma Manager</h2>
        <button type="button" id="logout" class="btn btn-light">Logout</button>
    </div>
</header>

<div class="container">
    <h2>Enter Medicine ID to View Stock History</h2>
    <form method="get" action="">
        <div class="mb-3">
            <label for="medicineId" class="form-label">Medicine ID:</label>
            <input type="number" class="form-control" id="medicineId" name="medicineId" required>
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </form>

    <%
        // Only execute the database query if medicineId is provided
        String medicineIdParam = request.getParameter("medicineId");
        if (medicineIdParam != null) {
            int medicineId = Integer.parseInt(medicineIdParam);
            List<StockHistoryRecord> stockHistory = new ArrayList<>();

            String url = "jdbc:mysql://localhost:3306/project";
            String dbUsername = "root";
            String dbPassword = "1234";
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT * FROM StockHistory WHERE medicine_id = ?";
                pstmt = con.prepareStatement(sql);
                pstmt.setInt(1, medicineId);
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    StockHistoryRecord record = new StockHistoryRecord();
                    record.setDate(rs.getTimestamp("date"));
                    record.setQuantityChange(rs.getInt("quantity_change"));
                    stockHistory.add(record);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
    %>

    <h2>Stock History for Medicine ID: <%= medicineId %></h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Date</th>
                <th>Quantity Change</th>
            </tr>
        </thead>
        <tbody>
        <%
            for (StockHistoryRecord record : stockHistory) {
        %>
            <tr>
                <td><%= record.getDate() %></td>
                <td><%= record.getQuantityChange() %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>
    <%
        } 
    %>
</div>

<script>
document.getElementById("logout").onclick = function() {
    window.location.href = "Logout.jsp"; 
};
</script>
</body>
</html>