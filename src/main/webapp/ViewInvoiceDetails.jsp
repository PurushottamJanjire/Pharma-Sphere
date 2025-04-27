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
    <title>Invoice Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .grand-total {
            font-weight: bold;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
<header>
    <div class="header-content">
        <h2><b>Pharma Sphere</b></h2>
        <button type="button" id="logout" class="btn btn-light">Logout</button>
    </div>
</header>
<div class="container">
    <h2>Invoice Details</h2>

    <%-- Fetching customer name --%>
    <%
        String customerName = "";
        String invoiceQuery = "SELECT customer_name FROM invoice WHERE invoice_id = ?";
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "1234");
             PreparedStatement pstmt = con.prepareStatement(invoiceQuery)) {
            pstmt.setInt(1, invoiceId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                customerName = rs.getString("customer_name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>

    <h4>Customer Name: <%= customerName %></h4>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Medicine Name</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Subtotal</th>
            </tr>
        </thead>
        <tbody>
            <%
                float grandTotal = 0.0f;
                String query = "SELECT m.m_name, id.quantity, id.unit_price, (id.quantity * id.unit_price) AS subtotal " +
                               "FROM invoice_details id " +
                               "JOIN medicine m ON m.m_id = id.medicine_id " +
                               "WHERE id.invoice_id = ?";
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/project", "root", "1234");
                     PreparedStatement pstmt = con.prepareStatement(query)) {
                    pstmt.setInt(1, invoiceId);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String medicineName = rs.getString("m_name");
                        int quantity = rs.getInt("quantity");
                        float unitPrice = rs.getFloat("unit_price");
                        float subtotal = rs.getFloat("subtotal");
                        grandTotal += subtotal;  // Add to the grand total
            %>
            <tr>
                <td><%= medicineName %></td>
                <td><%= quantity %></td>
                <td><%= unitPrice %></td>
                <td><%= subtotal %></td>
            </tr>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </tbody>
    </table>

    <div class="grand-total">
        <span>Grand Total: <%= grandTotal %></span>
    </div>

    <button class="btn btn-success" onclick="window.print()">Print Invoice</button>

</div>

<script>
    document.getElementById("logout").onclick = function() {
        window.location.href = "Logout.jsp";
    };
</script>

</body>
</html>
