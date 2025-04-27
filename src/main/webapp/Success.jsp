<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>🎉 Registration Successful | Pharma Sphere</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

    <style>
        body {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
            animation: fadeIn 1s ease;
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

        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
            animation: pop 0.8s ease-in-out;
        }

        @keyframes pop {
            0% {
                transform: scale(0.5);
                opacity: 0;
            }

            100% {
                transform: scale(1);
                opacity: 1;
            }
        }

        .success-message h1 {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .success-message p {
            font-size: 18px;
            color: #6c757d;
        }

        .btn-login {
            margin-top: 20px;
            padding: 12px 30px;
            font-size: 18px;
            border-radius: 50px;
            background-color: #4e54c8;
            color: white;
            border: none;
            transition: background-color 0.3s ease, transform 0.2s;
        }

        .btn-login:hover {
            background-color: #5f65e2;
            transform: translateY(-2px);
        }

        @media (max-width: 576px) {
            .container {
                padding: 30px;
            }

            .success-icon {
                font-size: 60px;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <div class="success-message">
            <h1>Registration Successful! 🎉</h1>
            <p>Thank you for registering with <strong>Pharma Sphere</strong>. You can now log in to your account and
                explore our platform.</p>
        </div>
        <a href="Login.jsp">
            <button class="btn-login">🚀 Go to Login Page</button>
        </a>
    </div>
</body>

</html>
