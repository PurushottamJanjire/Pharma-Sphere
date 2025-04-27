<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    int m_id = Integer.parseInt(request.getParameter("m_id"));
    String m_name = request.getParameter("m_name");
    int qty = Integer.parseInt(request.getParameter("qty"));
    String m_company = request.getParameter("m_company");
    float price = Float.parseFloat(request.getParameter("price"));
    String type = request.getParameter("type");
    String description = request.getParameter("description");
    int threshold = Integer.parseInt(request.getParameter("threshold"));
    String expiry_date = request.getParameter("expiry_date");

    String url = "jdbc:mysql://localhost:3306/project";
    String dbUsername = "root";
    String dbPassword = "1234";

    try (Connection con = DriverManager.getConnection(url, dbUsername, dbPassword)) {
        String sql = "UPDATE medicine SET m_name=?, qty=?, m_company=?, price=?, type=?, description=?, threshold=?, expiry_date=? WHERE m_id=?";
        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, m_name);
            pstmt.setInt(2, qty);
            pstmt.setString(3, m_company);
            pstmt.setFloat(4, price);
            pstmt.setString(5, type);
            pstmt.setString(6, description);
            pstmt.setInt(7, threshold);
            pstmt.setString(8, expiry_date);
            pstmt.setInt(9, m_id);

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                out.println("<script>alert('Medicine details updated successfully!');</script>");
                response.sendRedirect("MedicineManagement.jsp");
            } else {
                out.println("<script>alert('Error: Unable to update medicine details.');</script>");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('Error: Unable to update medicine details.');</script>");
    }
%>
