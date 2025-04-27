<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="java.io.PrintWriter" %>

<%
    session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;
    int user_id = 0;
    if (user == null) {
%>
    <script>
        window.location.href = "Login.jsp";
    </script>
<%
    } else {
        user_id = (Integer) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Invoices</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="viewInvoices.css" rel="stylesheet">
</head>
<body>
<header>
    <div class="header-content">
        <h2><b>Pharma Sphere</b></h2>
        <button type="button" id="logout" class="btn btn-light">Logout</button>
    </div>
</header>
<div class="container">
    <h2>Invoice List</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Invoice ID</th>
                <th>Customer Name</th>
                <th>Total Amount</th>
                <th>Payment Status</th>
                <th>Action</th>
                <th>Edit</th> <!-- New Edit column -->
            </tr>
        </thead>
        <tbody>
            <%
                // Fetch invoices from the database
                String query = "SELECT invoice_id, customer_name, total_amount, payment_status FROM invoice WHERE user_id = ?";
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "1234");
                     PreparedStatement pstmt = con.prepareStatement(query)) {
                    pstmt.setInt(1, user_id);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int invoiceId = rs.getInt("invoice_id");
                        String customerName = rs.getString("customer_name");
                        float totalAmount = rs.getFloat("total_amount");
                        String paymentStatus = rs.getString("payment_status");
            %>
            <tr>
                <td><%= invoiceId %></td>
                <td><%= customerName %></td>
                <td><%= totalAmount %></td>
                <td><%= paymentStatus %></td>
                <td>
                    <a href="ViewInvoiceDetails.jsp?invoiceId=<%= invoiceId %>" class="btn btn-primary">View Details</a>
                </td>
                <td>
                    <a href="EditInvoice.jsp?invoiceId=<%= invoiceId %>" class="btn btn-warning">Edit</a> <!-- Edit button -->
                </td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>
</div>

<script>
    document.getElementById("logout").onclick = function() {
        window.location.href = "Logout.jsp";
    };
</script>

</body>
</html>
<% } %>
