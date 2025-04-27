<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>

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
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title> Sales History | Pharma Sphere</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
		background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        header {
            background: linear-gradient(90deg, #007A8E, #006699);
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
            background-color: transparent;
            color: #fff;
            transition: background-color 0.3s ease, color 0.3s ease;
        }
       #backButton:hover, #logout:hover {
            background-color: #fff;
            color: #007bff;
        }
        .container {
            background-color: white;
            border-radius: 15px;
            padding: 30px;
            margin-top: 30px;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
            animation: fadeIn 0.8s ease-in;
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

        .table {
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
        }

        thead th {
            background-color: #4e54c8;
            color: white;
            text-align: center;
        }

        tbody tr:hover {
            background-color: #f1f1f1;
            transition: background-color 0.3s ease;
        }

        .table th,
        .table td {
            text-align: center;
            vertical-align: middle;
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
    <header>
	<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
    <i class="fas fa-arrow-left"></i> Back
</button>
    <h2><i class="fas fa-capsules"></i> Pharma Sphere - Sales History</h2>
  <button class="btn btn-outline-light" id="logout"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

    <div class="container">
        <h3 class="text-center mb-4"> <i class="fa fa-file-medical"></i> Sales History </h3>
        
        <table class="table table-striped table-hover table-bordered">
            <thead>
                <tr>
                    <th>Sale ID</th>
                    <th>Customer Name</th>
                    <th>Contact Details</th>
                    <th>Medicine Name</th>
                    <th>Batch No</th>
                    <th>Quantity</th>
                    <th>Total Price (RS)</th>
                    <th>Date of Sale</th>
                    
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        String url = "jdbc:postgresql:project";
                        String dbUsername = "postgres";
                        String dbPassword = "1234";
                        con = DriverManager.getConnection(url, dbUsername, dbPassword);

                        String sql = "SELECT s.id AS sale_id, s.customer_name, s.contact_details, " +
                                     "COALESCE(m.name, 'Unknown') AS medicine_name, m.batch_no, si.quantity, s.total_amount, s.date " +
                                     "FROM sales s " +
                                     "JOIN sales_items si ON s.id = si.sale_id " +
                                     "LEFT JOIN medicine m ON si.medicine_id = m.m_id " +
                                     "WHERE s.admin_id = ? " +
                                     "ORDER BY s.date DESC";

                        pstmt = con.prepareStatement(sql);
                        pstmt.setInt(1, user_id);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int saleId = rs.getInt("sale_id");
                            String customerName = rs.getString("customer_name");
                            String contactDetails = rs.getString("contact_details");
                            String medicineName = rs.getString("medicine_name");
                            int quantity = rs.getInt("quantity");
                            float totalPrice = rs.getFloat("total_amount");
                            Timestamp dateOfSale = rs.getTimestamp("date");
                            String batch=rs.getString("batch_no");
                %>
                <tr>
                    <td><%= saleId %></td>
                    <td><%= customerName %></td>
                    <td><%= contactDetails %></td>
                    <td><%= medicineName %></td>
                    <td><%= batch%></td>
                    <td><%= quantity %></td>
                    <td>Rs<%= totalPrice %></td>
                    <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(dateOfSale) %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
            
        </table>
        <div class="text-end mb-3">
    <button class="btn btn-primary" onclick="window.print();">
        <i class="fas fa-print"></i> Print Report
    </button>
</div>
       
    </div>

    <script>
        document.getElementById("logout").onclick = function () {
            window.location.href = "Logout.jsp";
        };
    </script>

</body>

</html>
<% } %>
