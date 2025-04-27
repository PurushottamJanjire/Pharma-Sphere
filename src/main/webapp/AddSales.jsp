<%@ page import="java.sql.*, java.util.*" %>
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("Login.jsp");
        return;
    }

    int adminId = (Integer) session.getAttribute("user_id");

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String customerName = request.getParameter("customerName");
        String contactDetails = request.getParameter("contactDetails");
        String paymentStatus = request.getParameter("paymentStatus");
        String paymentMethod = request.getParameter("paymentMethod");
        String remarks = request.getParameter("remarks");
        String[] medicineIds = request.getParameterValues("medicineId[]");
        String[] quantities = request.getParameterValues("quantity[]");

        Connection con = null;
        try {
            con = DriverManager.getConnection("jdbc:postgresql:project", "postgres", "1234");
            con.setAutoCommit(false);

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO sales(admin_id, customer_name, contact_details, date, total_amount, payment_status, payment_method, remarks) " +
                "VALUES (?, ?, ?, CURRENT_DATE, 0, ?, ?, ?) RETURNING id"
            );
            ps.setInt(1, adminId);
            ps.setString(2, customerName);
            ps.setString(3, contactDetails);
            ps.setString(4, paymentStatus);
            ps.setString(5, paymentMethod);
            ps.setString(6, remarks);
            ResultSet rs = ps.executeQuery();
            rs.next();
            int saleId = rs.getInt(1);

            float totalAmount = 0;

            for (int i = 0; i < medicineIds.length; i++) {
                int mId = Integer.parseInt(medicineIds[i]);
                int qty = Integer.parseInt(quantities[i]);

                PreparedStatement priceStmt = con.prepareStatement("SELECT price, stock FROM medicine WHERE m_id = ? and admin_id=? and stock>0");
                priceStmt.setInt(1, mId);
                priceStmt.setInt(2, adminId);
                ResultSet priceRs = priceStmt.executeQuery();

                if (priceRs.next()) {
                    float unitPrice = priceRs.getFloat("price");
                    int currentStock = priceRs.getInt("stock");

                    if (qty > currentStock) {
                        out.println("<script>alert('Error: Requested quantity (" + qty + ") exceeds available stock (" + currentStock + ") for Medicine ID: " + mId + "'); history.back();</script>");
                        return;
                    }

                    totalAmount += unitPrice * qty;

                    PreparedStatement itemStmt = con.prepareStatement("INSERT INTO sales_items(sale_id, medicine_id, quantity, unit_price) VALUES (?, ?, ?, ?)");
                    itemStmt.setInt(1, saleId);
                    itemStmt.setInt(2, mId);
                    itemStmt.setInt(3, qty);
                    itemStmt.setFloat(4, unitPrice);
                    itemStmt.executeUpdate();

                    PreparedStatement updateStock = con.prepareStatement("UPDATE medicine SET stock = stock - ? WHERE m_id = ?");
                    updateStock.setInt(1, qty);
                    updateStock.setInt(2, mId);
                    updateStock.executeUpdate();

                  /*  PreparedStatement deleteIfZero = con.prepareStatement("DELETE FROM medicine WHERE m_id = ? AND stock <= 0");
                    deleteIfZero.setInt(1, mId);
                    deleteIfZero.executeUpdate(); */
                } else {
                    out.println("<script>alert('Medicine ID " + mId + " not found in database'); history.back();</script>");
                    return;
                }
            }

            PreparedStatement updateTotal = con.prepareStatement("UPDATE sales SET total_amount = ? WHERE id = ?");
            updateTotal.setFloat(1, totalAmount);
            updateTotal.setInt(2, saleId);
            updateTotal.executeUpdate();

            con.commit();
            response.sendRedirect("GenerateBill.jsp?saleId=" + saleId);

        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignore) {}
            e.printStackTrace();
        } finally {
            if (con != null) try { con.close(); } catch (SQLException ignore) {}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Sale - Pharma Sphere</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

#logout, #backButton {
    border-radius: 5px;
    border: 1px solid #fff;
    color: #fff;
    background-color: transparent;
    transition: background-color 0.3s ease, color 0.3s ease;
}

#logout:hover, #backButton:hover {
    background-color: #fff;
    color: #007bff;
}

.container {
    background: white;
    padding: 30px;
    border-radius: 15px;
    width: 100%;
    max-width: 600px;
    margin: 60px auto;
    transition: transform 0.3s ease-in-out;
}

.container:hover {
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
   
    transition: all 0.3s ease-in-out;
}

.medicine-row,input[ type=number]{
margin:10px 0 10px 0;


}
.form-control:focus {
    border-color: #007A8E;
    box-shadow: 0 0 8px rgba(0, 122, 142, 0.5);
}

button[type="submit"] {
    width: 100%;
    padding: 12px;
    font-size: 18px;
    background-color: #007A8E;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}

button[type="submit"]:hover {
    background-color: #A5C1C1;
}
h2 {
    margin-bottom: 11px;
    font-weight: bold;
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
<header>
    <button id="backButton" class="btn btn-outline-light" onclick="window.location.href='Home.jsp';">
        <i class="fas fa-arrow-left"></i> Back
    </button>
    <h2><i class="fas fa-capsules"></i> Pharma Sphere</h2>
    <button class="btn btn-outline-light" id="logout" onclick="window.location.href ='Logout.jsp'"><i class="fas fa-sign-out-alt"></i> Logout</button>
</header>

<div class="container">
    <h2><i class="fas fa-file-medical"></i> Add Sale</h2>
    <form method="post" class="bg-white p-4">
        <div class="mb-3">
            <label class="form-label">Customer Name</label>
            <input type="text" name="customerName" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Contact Details</label>
            <input type="text" name="contactDetails" class="form-control" required>
        </div>

        <div id="medicineContainer">
            <div class="medicine-row">
                <select name="medicineId[]" class="form-select" required>
                    <% 
                        try (Connection con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/project", "postgres", "1234");
                            PreparedStatement ps = con.prepareStatement("SELECT m_id, name FROM medicine WHERE admin_id = ?")) {
                            ps.setInt(1, adminId);
                            ResultSet rs = ps.executeQuery();
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("m_id") %>"><%= rs.getString("name") %></option>
                    <% 
                            }
                        } catch (Exception e) { e.printStackTrace(); }
                    %>
                </select>
                <input type="number" name="quantity[]" class="form-control" placeholder="Quantity" min="1" required>
            </div>
        </div>

        <button type="button" class="btn btn-sm btn-success mt-2 btn-add" onclick="addRow()">
            <i class="fas fa-plus-circle"></i> Add Medicine
        </button>

        <div class="mt-3">
            <label class="form-label">Payment Status</label>
            <select name="paymentStatus" class="form-select">
                <option>Paid</option>
                <option>Pending</option>
            </select>
        </div>

        <div class="mt-3">
            <label class="form-label">Payment Method</label>
            <select name="paymentMethod" class="form-select">
                <option>Cash</option>
                <option>UPI</option>
                <option>Card</option>
            </select>
        </div>

        <div class="mt-3">
            <label class="form-label">Remarks</label>
            <input type="text" name="remarks" class="form-control">
        </div>

        <div class="mt-4 text-center">
            <button type="submit" class="btn ">
                <i class="fas fa-print"></i> Generate Bill
            </button>
        </div>
    </form>
</div>

<script>
    function addRow() {
        const container = document.getElementById("medicineContainer");
        const row = document.querySelector(".medicine-row").cloneNode(true);
        row.querySelectorAll("input").forEach(i => i.value = "");
        const removeBtn = document.createElement("button");
        removeBtn.type = "button";
        removeBtn.className = "btn btn-sm btn-outline-danger btn-remove ms-2";
        removeBtn.innerHTML = '<i class="fas fa-times"></i> Remove';
        removeBtn.onclick = function () {
            row.remove();
        };
        row.appendChild(removeBtn);
        container.appendChild(row);
    }
</script>

</body>
</html>
