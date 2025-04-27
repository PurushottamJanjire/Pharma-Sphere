<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> Edit Purchase Order | Pharma Sphere</title>
  
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <style>
        body {
            background: linear-gradient(to right, #e0eafc, #cfdef3);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
             background: linear-gradient(90deg, #006699,#007A8E);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            font-weight: bold;
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

        .container {
            background-color: white;
            border-radius: 15px;
            padding: 40px;
            margin-top: 40px;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease-in;
            width: 100%;
            max-width: 800px;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-label {
            font-weight: 600;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #4e54c8;
            box-shadow: 0 0 0 0.2rem rgba(78, 84, 200, 0.25);
        }

        button[type="submit"] {
            background-color: #4e54c8;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.2s;
        }

        button[type="submit"]:hover {
            background-color: #5a60d6;
            transform: translateY(-2px);
        }

        footer {
            text-align: center;
            padding: 20px;
            margin-top: auto;
        }

        footer button {
            border-radius: 20px;
            transition: all 0.3s ease;
        }

        footer button:hover {
            transform: translateY(-2px);
        }

        @media (max-width: 576px) {
            .container {
                padding: 20px;
            }

            header {
                flex-direction: column;
                text-align: center;
            }

            #logout {
                margin-top: 10px;
            }
        }
    </style>
</head>

<body>
    <%
        session = request.getSession(false);
        String user = (session != null) ? (String) session.getAttribute("username") : null;

        if (user == null) {
    %>
    <script>
        window.location.href = "Login.jsp";
    </script>
    <%
        return;
        }

        int user_id = (Integer) session.getAttribute("user_id");
        int po_id = Integer.parseInt(request.getParameter("po_id"));
        Map<String, String> purchaseOrder = new HashMap<>();
        String url = "jdbc:postgresql://localhost/project";
        String dbUsername = "postgres";
        String dbPassword = "1234";

        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
             PreparedStatement pstmt = con.prepareStatement("SELECT po.id, s.name, po.total_amount, po.status, po.order_date FROM purchases po JOIN suppliers s ON po.supplier_id = s.id WHERE po.id=? AND po.admin_id=?")) {

            pstmt.setInt(1, po_id);
            pstmt.setInt(2, user_id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    purchaseOrder.put("id", String.valueOf(rs.getInt("id")));
                    purchaseOrder.put("supplier", rs.getString("name"));
                    purchaseOrder.put("total_amount", String.valueOf(rs.getFloat("total_amount")));
                    purchaseOrder.put("status", rs.getString("status"));
                    purchaseOrder.put("order_date", rs.getTimestamp("order_date").toString());
                } else {
                    out.println("<script>alert('Purchase order not found or you do not have permission to edit it.');</script>");
                    response.sendRedirect("ViewPurchaseOrders.jsp");
                    return;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>

   
    <header>
	<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
    <i class="fas fa-arrow-left"></i> Back
</button>
    <h2><i class="fas fa-capsules"></i> Pharma Sphere - Edit Order</h2>
  <button class="btn btn-outline-light" id="logout"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

    <div class="container">
        <h3 class="text-center mb-4"> Edit Purchase Order</h3>
        <form action="SavePurchaseOrder.jsp" method="POST">
            <input type="hidden" name="po_id" value="<%= purchaseOrder.get("id") %>">

            <div class="mb-3">
                <label for="supplier" class="form-label">Supplier</label>
                <input type="text" class="form-control" id="supplier" name="supplier" value="<%= purchaseOrder.get("supplier") %>" disabled>
            </div>

            <div class="mb-3">
                <label for="total_amount" class="form-label">Total Amount (Rs)</label>
                <input type="text" class="form-control" id="total_amount" name="total_amount" value="<%= purchaseOrder.get("total_amount") %>" disabled>
            </div>

            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="Pending" <%= "Pending".equals(purchaseOrder.get("status")) ? "selected" : "" %>>Pending</option>
                    <option value="Completed" <%= "Completed".equals(purchaseOrder.get("status")) ? "selected" : "" %>>Completed</option>
                    <option value="Cancelled" <%= "Cancelled".equals(purchaseOrder.get("status")) ? "selected" : "" %>>Cancelled</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="order_date" class="form-label">Order Date</label>
                <input type="text" class="form-control" id="order_date" name="order_date" value="<%= purchaseOrder.get("order_date") %>" disabled>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>

  

    <script>
        document.getElementById("logout").onclick = function () {
            window.location.href = "Logout.jsp";
        };
    </script>

</body>

</html>
