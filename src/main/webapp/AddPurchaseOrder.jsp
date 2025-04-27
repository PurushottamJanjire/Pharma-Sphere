<%@ page import="java.sql.*, java.util.*" %>

<%

session = request.getSession(false); 
String user = (session != null) ? (String) session.getAttribute("username") : null;
if (user == null) {
%>
<script> window.location.href = "Login.jsp"; </script>
<%
} 
    int user_id = (Integer) session.getAttribute("user_id");
    String supplierId = request.getParameter("supplierId");
    System.out.print(user_id );
    System.out.print(supplierId );
    String totalAmount = request.getParameter("totalAmount");
    String paymentStatus = request.getParameter("status");
    String paymentMethod = request.getParameter("paymentMethod");
    String remarks = request.getParameter("remarks");

    // Get medicine details (arrays)
    String[] medicineIds = request.getParameterValues("medicineId[]");
    String[] quantities = request.getParameterValues("quantity[]");
    String[] prices = request.getParameterValues("price[]");

    // NULL CHECK
    if (medicineIds == null || quantities == null || prices == null) {
        out.println("<script>alert('Error: No medicines selected!'); window.history.back();</script>");
        return;
    }

    // Database connection
    String url = "jdbc:postgresql:project";
    String dbUsername = "postgres";
    String dbPassword = "1234";

    try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword)) {
        con.setAutoCommit(false); // Start transaction

        // Insert into purchases table
        String purchaseSQL = "INSERT INTO purchases (admin_id, supplier_id, order_date, total_amount, status, payment_method, remarks) VALUES (?, ?, NOW(), ?, ?, ?, ?) RETURNING id";
        PreparedStatement pstmt = con.prepareStatement(purchaseSQL);
        pstmt.setInt(1,user_id); 
        pstmt.setInt(2, Integer.parseInt(supplierId));
        pstmt.setDouble(3, Double.parseDouble(totalAmount));
        pstmt.setString(4, paymentStatus);
        pstmt.setString(5, paymentMethod);
        pstmt.setString(6, remarks);

        ResultSet rs = pstmt.executeQuery();
        int purchaseId = 0;
        if (rs.next()) {
            purchaseId = rs.getInt(1);
        }

        // Insert into purchase_items table
        String itemSQL = "INSERT INTO purchase_items (purchase_id, medicine_id, quantity, unit_price) VALUES ( ?, ?, ?, ?)";
        PreparedStatement itemStmt = con.prepareStatement(itemSQL);

      
        	for (int i = 0; i < medicineIds.length; i++) {
        	    // Safety checks
        	    if (medicineIds[i] == null || medicineIds[i].trim().isEmpty() ||
        	        quantities[i] == null || quantities[i].trim().isEmpty() ||
        	        prices[i] == null || prices[i].trim().isEmpty()) {
        	        continue; // Skip this entry
        	    }
        	    System.out.println("Medicine: " + medicineIds[i] + ", Qty: " + quantities[i] + ", Price: " + prices[i]);

        	    int medicineId = Integer.parseInt(medicineIds[i].trim());
        	    int quantity = Integer.parseInt(quantities[i].trim());
        	    double price = Double.parseDouble(prices[i].trim());

        	    itemStmt.setInt(1, purchaseId);
        	    itemStmt.setInt(2, medicineId);
        	    itemStmt.setInt(3, quantity);
        	    itemStmt.setDouble(4, price);

        	    itemStmt.addBatch(); // Batch insert
        	

        }

        itemStmt.executeBatch();
        con.commit(); // Commit transaction
        out.println("<script>alert('Purchase Order Created Successfully!'); window.location='CreatePurchaseOrder.jsp';</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
    }
%>
