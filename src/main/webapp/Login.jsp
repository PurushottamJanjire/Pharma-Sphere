<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <script src="https://kit.fontawesome.com/10df695d13.js" crossorigin="anonymous"></script>
     <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>  

    <style>
        body {
            background: url('pharma01.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display:flex;
            margin-left:20%;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        header {
 			font-size: 3rem; 
            text-align: center;
            color:#F1F2F7;
            margin-bottom: 20px;
            animation: fadeInDown 1s ease-in-out;
        }

			header p {
			    font-size: 1.5rem; 
			    color: #B3B4B9;
			}

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .container{
            background: rgba(255, 255, 255, 0.5);
            backdrop-filter: blur(5px);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            
            animation: fadeInUp 1s ease;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-label i {
            margin-right: 8px;
        }

        .btn-primary {
            background-color: #4e54c8;
            border: none;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #202583;
        }

        .toggle-password {
            cursor: pointer;
            position: absolute;
            right: 15px;
            top: 38px;
            color: #41474c;
        }

        .form-text {
            font-size: 0.9rem;
            color: #111213;
        }

        .text-center a {
            text-decoration: none;
            color: #1a23c6;
        }

        .text-center a:hover {
            text-decoration: underline;
        }

        @media (max-width: 576px) {
            .container {
                padding: 25px;
            }
        }
    </style>

    <script type="text/javascript">
        function displayError(message) {
            const alertBox = document.getElementById("error-alert");
            alertBox.style.display = "block";
            alertBox.innerText = message;
        }

        function togglePassword() {
            const passwordInput = document.getElementById("password");
            const icon = document.getElementById("toggleIcon");
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                passwordInput.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
</head>

<body>
    <header>
        <h2 ><b>Pharma Sphere</b></h2>
        <p >Streamline Your Pharma Management </p>
    </header>

    <div class="container">
        <h3 class="text-center mb-4"> <i class="fa fa-sign-in" aria-hidden="true"></i> Sign In to Your Account</h3>
        <div id="error-alert" class="alert alert-danger text-center" style="display:none;"></div>

        <form action="Login.jsp" method="post">
            <div class="mb-3">
                <label for="email" class="form-label"><i class="fas fa-envelope"></i>Email:</label>
                <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                <div id="emailHelp" class="form-text">We'll never share your email with anyone else.</div>
            </div>

            <div class="mb-3 position-relative">
                <label for="password" class="form-label"><i class="fas fa-lock"></i>Password:</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                <i class="fas fa-eye toggle-password" id="toggleIcon" onclick="togglePassword()"></i>
            </div>

            <button type="reset" class="btn btn-secondary w-100 mb-2">Reset</button>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <div class="text-center mt-3">
            <p>Don't have an account? <a href="Register.jsp">Register here <i class="fa fa-user-plus" aria-hidden="true"></i>
            </a></p>
        </div>
    </div>

    <%
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email != null && password != null) {
            Connection con = null;
            PreparedStatement pstmt = null;
            ResultSet resultSet = null;

            try {
                Class.forName("org.postgresql.Driver");
                String url = "jdbc:postgresql:project";
                String dbUsername = "postgres";
                String dbPassword = "1234";

                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT * FROM admin WHERE email=? AND password=?";
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                resultSet = pstmt.executeQuery();

                if (resultSet.next()) {
                    session.setAttribute("username", resultSet.getString("name"));
                    session.setAttribute("user_id", resultSet.getInt("id"));
                    response.sendRedirect("Home.jsp");
                    return;
                } else {
                    String errorMessage = "❌ Invalid email or password. Please try again.";
                    out.println("<script>displayError('" + errorMessage + "');</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>displayError('⚠️ An error occurred during login. Please try again later.');</script>");
            } finally {
                try {
                    if (resultSet != null) resultSet.close();
                    if (pstmt != null) pstmt.close();
                    if (con != null) con.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-JRv6Ue7xKOJyxWBaHtBPwL/kIR+Lw2Jng5h7x2gHp4UO5uI0xFgHzS3Jwv3ZiwVU" crossorigin="anonymous">
    </script>
</body>

</html>
