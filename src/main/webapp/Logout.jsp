<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
     session = request.getSession(false); // Get the session, do not create a new one
    if (session != null) {
        session.invalidate(); // Invalidate the session
    }
    response.sendRedirect("Login.jsp"); // Redirect to login page
%>