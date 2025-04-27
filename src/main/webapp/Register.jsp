<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/10df695d13.js" crossorigin="anonymous"></script>
   
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <style>
        body {
            background: url('pharma4.jpg') no-repeat center center fixed;
            background-size: cover;

            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        header {
        font-size: 3rem;
            text-align: center;
            color:#F1F2F7;
            margin-bottom: 30px;
            animation: fadeInDown 1s ease-in-out;
        }
        
        
        	header p {
			    font-size: 1.5rem; 
			    color:#5C5D63;
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

        .form-container {
            background: rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(5px);
            margin-left:10%;
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
            background-color: #252ecb;
            border: none;
            transition: background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #131dd9;
        }

        .strength-meter {
            height: 5px;
            background-color: #e0e0e0;
            border-radius: 5px;
            overflow: hidden;
            margin-top: -15px;
            margin-bottom: 10px;
        }

        .strength-meter-fill {
            height: 100%;
            width: 0%;
            transition: width 0.3s ease-in-out;
        }

        .text-center a {
            text-decoration: none;
            color: #0a13c3;
        }

        .text-center a:hover {
            text-decoration: underline;
        }

        @media (max-width: 576px) {
            .form-container {
                padding: 25px;
            }
        }
    </style>

    <script type="text/javascript">
        function checkPasswords() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("password1").value;
            const submitButton = document.getElementById("submit");
            const msg = document.getElementById("msg");

            if (password === confirmPassword && password.length >= 6) {
                submitButton.disabled = false;
                msg.innerHTML = "";
            } else {
                submitButton.disabled = true;
                msg.innerHTML = password !== confirmPassword ? "❌ Passwords do not match." : "⚠️ Password must be at least 6 characters.";
            }
        }

        function checkStrength(password) {
            const strengthMeter = document.getElementById("strength-meter-fill");
            let strength = 0;
            if (password.match(/[a-z]+/)) strength += 1;
            if (password.match(/[A-Z]+/)) strength += 1;
            if (password.match(/[0-9]+/)) strength += 1;
            if (password.match(/[$@#&!]+/)) strength += 1;
            if (password.length >= 8) strength += 1;

            const colors = ["#ff4d4d", "#ff884d", "#ffb84d", "#4dff88", "#4de04d"];
            strengthMeter.style.width = (strength * 20) + "%";
            strengthMeter.style.backgroundColor = colors[strength - 1] || "#e0e0e0";
        }

        window.onload = function () {
            document.getElementById("submit").disabled = true;
            document.getElementById("password").addEventListener("input", function () {
                checkPasswords();
                checkStrength(this.value);
            });
            document.getElementById("password1").addEventListener("input", checkPasswords);
        };
    </script>
</head>

<body>
    <header>
        <h2 class="text-white"><b> Pharma Sphere</b></h2>
        <p class="text-light">Your trusted pharma management solution</p>
    </header>

    <%
        String errorMessage = null;

        if (request.getParameter("name") != null) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String password1 = request.getParameter("password1");

            if (password.equals(password1)) {
                try (Connection con = DriverManager.getConnection("jdbc:postgresql:project", "postgres", "1234");
                     PreparedStatement pstmt = con.prepareStatement("INSERT INTO admin(name, email, password) VALUES (?, ?, ?)")) {

                    Class.forName("org.postgresql.Driver"); 
                    pstmt.setString(1, name);
                    pstmt.setString(2, email);
                    pstmt.setString(3, password);

                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        response.sendRedirect("Success.jsp");
                        return;
                    } else {
                        errorMessage = "Registration failed. Please try again.";
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    errorMessage = "Error: " + e.getMessage();
                }
            } else {
                errorMessage = "Passwords do not match.";
            }

            if (errorMessage != null) {
            	%>
            	    <script>
            	        window.onload = function () {
            	            alert("<%= errorMessage.replace("\"", "\\\"").replace("'", "\\'") %>");
            	        };
            	    </script>
            	<%
            	}
        }
        
    %>

    <div class="form-container">
        <h3 class="text-center mb-4"><i class="fa-solid fa-circle-user"></i> Create Your Account</h3>
        <form action="Register.jsp" method="post">
            <div class="mb-3">
                <label for="username" class="form-label"><i class="fas fa-user"></i>Username:</label>
                <input type="text" class="form-control" name="name" id="username" placeholder="Enter your username" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label"><i class="fas fa-envelope"></i>Email:</label>
                <input type="email" class="form-control" name="email" id="email" placeholder="Enter your email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label"><i class="fas fa-lock"></i>Password:</label>
                <input type="password" class="form-control" name="password" id="password" placeholder="Minimum 6 characters" required>
                <div class="strength-meter"><div id="strength-meter-fill" class="strength-meter-fill"></div></div>
            </div>
            <div class="mb-3">
                <label for="password1" class="form-label"><i class="fas fa-lock"></i>Confirm Password:</label>
                <input type="password" class="form-control" name="password1" id="password1" placeholder="Confirm your password" required>
            </div>
            <p id="msg" style="color:red;"></p>
            <div class="text-center">
                <button type="reset" class="btn btn-secondary">Reset</button>
                <button type="submit" id="submit" class="btn btn-primary" disabled>Register</button>
            </div>
            <div class="text-center mt-3">
                <p>Already have an account? <a href="Login.jsp">Sign in here <i class="fa fa-key" aria-hidden="true"></i></a></p>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
