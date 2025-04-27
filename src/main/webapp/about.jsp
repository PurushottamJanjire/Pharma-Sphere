<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | Pharma Sphere</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

        * { font-family: 'Poppins', sans-serif; scroll-behavior: smooth; }
        body {  background: linear-gradient(to right, #f5f7fa, #c3cfe2); }

       
        header {
            background: linear-gradient(90deg, #007A8E, #006699);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0; z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
       
        header h2 { font-weight: 600; }
        #logout { border-radius: 20px; transition: 0.3s; }
        #logout:hover {  color: white; }

       
        .about-section { padding: 80px 0; }
        .about-heading { font-size: 3rem; font-weight: bold; color: #0d6efd; margin-bottom: 30px; }
        .about-content p, .about-content li { font-size: 1.1rem; color: #555; }
        .about-image { border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); transition: transform 0.5s; }
        .about-image:hover { transform: scale(1.03); }

      
        .footer {
           background: linear-gradient(90deg, #007A8E, #006699);
            color: white;
            padding: 20px;
            text-align: center;
            
        }
        .footer a { color: #ffc107; text-decoration: none; font-weight: 600; }
        .footer a:hover { text-decoration: underline; }
		.btn:hover { text-decoration: underline;
						transform: scale(1.05);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    cursor: pointer;
		  }
      
        @media (max-width: 768px) {
            .about-heading { font-size: 2.2rem; }
            .about-content p { font-size: 1rem; }
        }
    </style>
</head>
<body>

<header>
    <h2>Pharma Sphere</h2>
    <button type="button" id="logout" class="btn btn-light">Logout <i class="fas fa-sign-out-alt"></i></button>
</header>

<div class="container about-section">
    <h1 class="about-heading text-center text-secondary">About Pharma Sphere</h1>
    <div class="row align-items-center">
        <div class="col-md-6 mb-4">
            <img src="pharma03.jpg" alt="Pharma Sphere" class="about-image w-100">
        </div>
        <div class="col-md-6 about-content">
            <p><strong>Pharma Sphere</strong> is a modern solution designed for pharmacy owners to efficiently manage inventory, sales, and customer records with ease.</p>
            <h3> Key Features:</h3>
            <ul>
                <li> Real-time Inventory Management</li>
                <li> Invoice Generation with One Click</li>
                <li> Secure Login & Role-Based Access</li>
                <li> Sales & Customer Management</li>
               
            </ul>

            <h3> Why Choose Pharma Sphere?</h3>
            <ul>
                <li> User-friendly interface for pharmacy staff.</li>
                <li> Accurate and instant inventory tracking.</li>
                <li> Enhance customer satisfaction with seamless services.</li>
            </ul>
            <a href="Home.jsp" class="btn btn-lg mt-3"style="background: linear-gradient(90deg, #007A8E, #006699);">Get Started <i class="fas fa-arrow-right"></i></a>
        </div>
    </div>
</div>

<div class="footer">
    <p>&copy; 2025 Pharma Sphere | <a href="contact.jsp"><i class="fas fa-envelope"></i> Contact Us</a></p>
</div>

<script>
    document.getElementById("logout").onclick = function() {
        window.location.href = "Logout.jsp";
    };
</script>

</body>
</html>
