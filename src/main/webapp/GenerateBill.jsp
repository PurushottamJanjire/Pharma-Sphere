<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String saleIdParam = request.getParameter("saleId");
    if (saleIdParam == null || saleIdParam.trim().isEmpty()) {
%>
    <script>alert("Sale ID not provided!"); window.location.href = "Home.jsp";</script>
<%
        return;
    }

    int saleId = Integer.parseInt(saleIdParam);
    String customerName = "", contact = "", date = "", status = "", method = "", remarks = "";
    float total = 0;
    List<Map<String, Object>> items = new ArrayList<>();

    try (Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/project", "postgres", "1234")) {
        // Fetch sale details
        PreparedStatement ps = con.prepareStatement("SELECT customer_name, contact_details, date, total_amount, payment_status, payment_method, remarks FROM sales WHERE id = ?");
        ps.setInt(1, saleId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            customerName = rs.getString("customer_name");
            contact = rs.getString("contact_details");
            date = rs.getString("date");
            total = rs.getFloat("total_amount");
            status = rs.getString("payment_status");
            method = rs.getString("payment_method");
            remarks = rs.getString("remarks");
        }

        // Fetch medicine items
        ps = con.prepareStatement("SELECT m.name, s.quantity, s.unit_price FROM sales_items s JOIN medicine m ON s.medicine_id = m.m_id WHERE s.sale_id = ?");
        ps.setInt(1, saleId);
        rs = ps.executeQuery();
        while (rs.next()) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", rs.getString("name"));
            item.put("quantity", rs.getInt("quantity"));
            item.put("price", rs.getFloat("unit_price"));
            item.put("total", rs.getFloat("unit_price") * rs.getInt("quantity"));
            items.add(item);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bill - Pharma Sphere</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .header {
            background: linear-gradient(90deg, #007A8E, #006699);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .header h2 {
            margin: 0;
        }
        .bill-container {
            background-color: white;
            margin: 30px auto;
            padding: 30px;
            border-radius: 12px;
            max-width: 900px;
            box-shadow: 0 0 10px rgba(0,0,0,0.15);
        }
        .bill-title {
            font-weight: bold;
            color: #007A8E;
        }
        .table th {
            background-color: #007A8E;
            color: white;
        }
        .back-btn {
            margin-top: 20px;
        }
    </style>
</head>

<body>
    <div class="header">
        <h2>Pharma Sphere - Invoice</h2>
    </div>

    <div class="bill-container">
        <h4 class="bill-title mb-4">Customer Bill Details</h4>

        <div class="row mb-4">
            <div class="col-md-6">
                <p><strong>Customer Name:</strong> <%= customerName %></p>
                <p><strong>Contact:</strong> <%= contact %></p>
            </div>
            <div class="col-md-6 text-md-end">
                <p><strong>Date:</strong> <%= date %></p>
                <p><strong>Sale ID:</strong> <%= saleId %></p>
            </div>
        </div>

        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Medicine Name</th>
                    <th>Quantity</th>
                    <th>Unit Price (₹)</th>
                    <th>Total (₹)</th>
                </tr>
            </thead>
            <tbody>
            <% for (Map<String, Object> item : items) { %>
                <tr>
                    <td><%= item.get("name") %></td>
                    <td><%= item.get("quantity") %></td>
                    <td><%= item.get("price") %></td>
                    <td><%= item.get("total") %></td>
                </tr>
            <% } %>
            </tbody>
        </table>

        <div class="row mt-4">
            <div class="col-md-6">
                <p><strong>Payment Method:</strong> <%= method %></p>
                <p><strong>Status:</strong> <%= status %></p>
                <% if (remarks != null && !remarks.trim().isEmpty()) { %>
                    <p><strong>Remarks:</strong> <%= remarks %></p>
                <% } %>
            </div>
            <div class="col-md-6 text-end">
                <h4 class="text-success">Total Amount: ₹ <%= total %></h4>
            </div>
        </div>

        <div class="text-center back-btn">
        <button id="printBtn"  class="btn btn-primary"><i class="fas fa-print"></i> Print</button>
        
       
        </div>
    </div>
    <script>
    let shouldRedirectAfterPrint = false;

    document.getElementById("printBtn").addEventListener("click", function() {
        shouldRedirectAfterPrint = true; 
        window.print();
    });

    window.onafterprint = function() {
        if (shouldRedirectAfterPrint) {
         
            setTimeout(function() {
                window.location.href = 'AddSales.jsp';
            }, 500);
        }
    };
</script>
    
</body>
</html>
