<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medicine Report</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
   <link href="MediReport.css" rel="stylesheet">
</head>
<body>

<%
    int user_id = 0;
 session = request.getSession(false);
    String user = (session != null) ? (String) session.getAttribute("username") : null;

    if (user == null) {
%>
    <script>
        window.location.href = "Login.jsp"; 
    </script>
<%
    } else {
%>
<header>
    <div class="header-content">
       <h2><b>Pharma Sphere</b></h2>
        <button type="button" id="logout" class="btn btn-light">Logout</button>
    </div>
</header>

<%
    user_id = (Integer) session.getAttribute("user_id");
    }
%>
<div class="table-container">
    <h1 class="text-center">Medicine Report</h1>

<%
    Connection con = null;
    PreparedStatement psmt = null;

    try {
    	 Class.forName("org.postgresql.Driver");
        out.println("<script>alert('Rloaded successfully.');</script>");
        String url = "jdbc:postgresql:project";
        String dbUsername = "postgres";
        String dbPassword = "1234";
        con = DriverManager.getConnection(url, dbUsername, dbPassword);
        psmt = con.prepareStatement("SELECT * FROM medicine WHERE u_id=? ");
        psmt.setInt(1, user_id);

        ResultSet rs = psmt.executeQuery();
%>

<table class="table table-bordered">
        <thead>
            <tr>
                <th>Medicine Id</th>
                <th>Medicine Name</th>
                <th>Quantity</th>
                <th>Company</th>
                <th>Price</th>
                <th>Type</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
<%
        while (rs.next()) {
            int id = rs.getInt(1);
            String name = rs.getString(3);
            int qnt = rs.getInt(4);
            String company = rs.getString(5);
            Float price = rs.getFloat(6);
            String type = rs.getString(7);
            String description = rs.getString(8); 
%>

            <tr>
                <td><%= id %></td>
                <td><%= name %></td>
                <td><%= qnt %></td>
                <td><%= company %></td>
                <td><%= price + " Rs" %></td>
                <td><%= type %></td>
                <td><%= description %></td>
                <td>
                  
                    <a href="EditMedicine.jsp?m_id=<%= id %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="DeleteMedicine.jsp?m_id=<%= id %>" class="btn btn-danger btn-sm">Delete</a>
                </td>
            </tr>
<%
        }
%>
        </tbody>
    </table>

</div>

 <div class="text-center">
        <button type="button" id="btn" class="btn btn-primary">Go Back</button>
    </div>

<%
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error occurred: " + e.getMessage() + "');</script>");
    } finally {
        if (psmt != null) try { psmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

</body>
<script>
document.getElementById("btn").onclick = function() {
    window.location.href = "Home.jsp";
};

document.getElementById("logout").onclick = function() {
    window.location.href = "Logout.jsp"; 
};
</script>

</html>
