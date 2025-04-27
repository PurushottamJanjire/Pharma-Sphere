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
    }

    int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Invoice</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<header>
    <div class="header-content">
        <h2><b>Pharma Sphere</b></h2>
        <button type="button" id="logout" class="btn btn-light">Logout</button>
    </div>
</header>
<div class="container">
    <h2>Edit Invoice</h2>
    
    <%-- Fetch invoice details to pre-populate the form --%>
    <%
        String query = "SELECT customer_name, total_amount, payment_status FROM invoice WHERE invoice_id = ?";
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "1234");
             PreparedStatement pstmt = con.prepareStatement(query)) {
            pstmt.setInt(1, invoiceId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String customerName = rs.getString("customer_name");
                float totalAmount = rs.getFloat("total_amount");
                String paymentStatus = rs.getString("payment_status");
    %>
    
    <form action="UpdateInvoice.jsp" method="post">
        <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
        <div class="mb-3">
            <label for="customerName" class="form-label">Customer Name</label>
            <input type="text" class="form-control" id="customerName" name="customerName" value="<%= customerName %>" required>
        </div>
        <div class="mb-3">
            <label for="totalAmount" class="form-label">Total Amount</label>
            <input type="text" class="form-control" id="totalAmount" name="totalAmount" value="<%= totalAmount %>" required>
        </div>
        <div class="mb-3">
            <label for="paymentStatus" class="form-label">Payment Status</label>
            <input type="text" class="form-control" id="paymentStatus" name="paymentStatus" value="<%= paymentStatus %>" required>
        </div>
        <button type="submit" class="btn btn-primary">Update Invoice</button>
    </form>
    
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
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
