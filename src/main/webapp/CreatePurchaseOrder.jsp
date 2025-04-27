<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Purchase Order | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
             background: linear-gradient(to right, #f5f7fa, #c3cfe2);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

       header {
           background: linear-gradient(90deg, #007A8E, #006699);
            padding: 20px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
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

        header h2 {
            font-weight: 700;
            letter-spacing: 1px;
            margin: 0;
        }

        .container {
            background-color: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-top: 30px;
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .form-select, .form-control {
            border-radius: 8px;
        }

        #addRow {
            transition: all 0.3s ease-in-out;
        }

        #addRow:hover {
            transform: translateY(-2px);
            background-color: #198754;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
            transition: background-color 0.2s ease-in;
        }

        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }

        .remove-row {
            transition: all 0.2s ease-in-out;
        }

        .remove-row:hover {
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            header h2 {
                font-size: 1.5rem;
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
<script> window.location.href = "Login.jsp"; </script>
<%
    } else {
        int user_id = (Integer) session.getAttribute("user_id");
        String url = "jdbc:postgresql:project";
        String dbUsername = "postgres";
        String dbPassword = "1234";

%>
   <header>
	<button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
    <i class="fas fa-arrow-left"></i> Back
</button>
    <h2><i class="fas fa-truck"></i> Pharma Sphere - Add Purchase</h2>
  <button class="btn btn-outline-light" id="logout"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

    <div class="container">
        <form method="POST" action="AddPurchaseOrder.jsp">
		            <div class="row g-3">
		    <div class="col-md-6">
		        <label for="supplierId" class="form-label">Supplier</label>
					       <select class="form-select" name="supplierId" required>
			    <option value="">Select Supplier</option>
			    <% 
			        try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
			             PreparedStatement pstmt = con.prepareStatement("SELECT * FROM suppliers WHERE a_id = ?")) {
			            pstmt.setInt(1, user_id);
			            try (ResultSet rs = pstmt.executeQuery()) {
			                while (rs.next()) {
			    %>
			        <option value="<%= rs.getInt("id") %>"><%= rs.getString("name") %></option>
			    <%
			                }
			            }
			        } catch (SQLException e) {
			            e.printStackTrace();
			        }
			    %>
			</select>

		    </div>
		</div>


            <hr>
            <!-- Medicines Table -->
            <table id="medicinesTable" class="table table-bordered align-middle mt-4">
                <thead class="table-dark">
                    <tr>
                        <th>Medicine Name</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Total Price</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <select name="medicineId[]" class="form-select" required>
                                <option value="">Select Medicine</option>
                                <%
                                    try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
                                         PreparedStatement pstmt = con.prepareStatement("SELECT m_id, name FROM medicine where admin_id="+user_id);
                                         ResultSet rs = pstmt.executeQuery()) {
                                        while (rs.next()) {
                                %>
                                <option value="<%= rs.getInt("m_id") %>"><%= rs.getString("name") %></option>
                                <%
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                %>
                            </select>
                        </td>
                        <td><input type="number" name="quantity[]" class="form-control quantity" required></td>
                        <td><input type="number" step="any" name="price[]" class="form-control price" required></td>
                        <td><input type="number" name="total[]" class="form-control total" readonly></td>
                        <td><button type="button" class="btn btn-danger remove-row">Remove</button></td>
                    </tr>
                </tbody>
            </table>
            <button type="button" id="addRow" class="btn btn-success">+ Add Medicine</button>

            <div class="row mt-4">
                <div class="col-md-6">
                    <label for="totalAmount" class="form-label">Total Amount</label>
                    <input type="number" class="form-control" id="totalAmount" name="totalAmount" readonly>
                </div>
                <div class="col-md-6">
                    <label for="paymentStatus" class="form-label">Order Status</label>
                    <select class="form-select" id="status" name="status" required>
                    <option value="Completed">Completed</option>
                        <option value="Pending">Pending</option>
                        
                    </select>
                </div>
            </div>

            <div class="row g-3 mt-3">
                <div class="col-md-6">
                    <label for="paymentMethod" class="form-label">Payment Method</label>
                    <input type="text" class="form-control" id="paymentMethod" name="paymentMethod" required>
                </div>
                <div class="col-md-6">
                    <label for="remarks" class="form-label">Remarks</label>
                    <input type="text" class="form-control" id="remarks" name="remarks">
                </div>
            </div>

            <button type="submit" class="btn btn-primary mt-4 w-100 py-2">Create Purchase Order</button>
        </form>
    </div>

    <script>
        document.getElementById('addRow').addEventListener('click', function () {
            let table = document.getElementById('medicinesTable').getElementsByTagName('tbody')[0];
            let row = table.insertRow();
            row.innerHTML = `
                <td>
                    <select name="medicineId[]" class="form-select" required>
                        <option value="">Select Medicine</option>
                        <% 
                            try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
                            PreparedStatement pstmt = con.prepareStatement("SELECT m_id, name FROM medicine where admin_id="+user_id);
                                 ResultSet rs = pstmt.executeQuery()) {
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("m_id") %>"><%= rs.getString("name") %></option>
                        <% } } catch (SQLException e) { e.printStackTrace(); } %>
                    </select>
                </td>
                <td><input type="number" name="quantity[]" class="form-control quantity" required></td>
                <td><input type="number" name="price[]" class="form-control price" required></td>
                <td><input type="number" name="total[]" class="form-control total" readonly></td>
                <td><button type="button" class="btn btn-danger remove-row">Remove</button></td>
            `;
            updateEventListeners();
        });

        function updateEventListeners() {
            document.querySelectorAll('.quantity, .price').forEach(input => {
                input.removeEventListener('input', calculateTotal);
                input.addEventListener('input', calculateTotal);
            });

            document.querySelectorAll('.remove-row').forEach(button => {
                button.removeEventListener('click', removeRow);
                button.addEventListener('click', removeRow);
            });
        }

        function removeRow() {
            this.closest('tr').remove();
            calculateGrandTotal();
        }

        function calculateTotal() {
            document.querySelectorAll('#medicinesTable tbody tr').forEach(row => {
                let quantity = row.querySelector('.quantity').value;
                let price = row.querySelector('.price').value;
                let totalField = row.querySelector('.total');
                totalField.value = (quantity && price) ? (quantity * price).toFixed(2) : 0;
            });
            calculateGrandTotal();
        }

        function calculateGrandTotal() {
            let grandTotal = 0;
            document.querySelectorAll('.total').forEach(input => {
                grandTotal += parseFloat(input.value) || 0;
            });
            document.getElementById('totalAmount').value = grandTotal.toFixed(2);
        }

        updateEventListeners();
    </script>
</body>
</html>
<%} %>
