<!DOCTYPE html>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
    HttpSession checkSession = request.getSession(false); // Check if session already exists
    if (checkSession != null) {
        String userRole = (String) checkSession.getAttribute("userRole");
        if (userRole != null) {
            // Redirect based on the user role
            if (userRole.equals("volunteer")) {
                response.sendRedirect(request.getContextPath()+ "/volunteer/eventListingVolunteer.jsp"); // Redirect to volunteer page
                return;
            } else if (userRole.equals("admin")) {
                response.sendRedirect(request.getContextPath()+ "/admin/adminListing.jsp"); // Redirect to admin page
                return;
            } else if (userRole.equals("beneficiary")) {
                response.sendRedirect(request.getContextPath()+ "/beneficiary/eventmanagement.jsp"); // Redirect to beneficiary page
                return;
            }
        }
    }
%>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login Screen</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(to bottom, #2F6690, #C3DFE6);
                min-height: 100vh;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>
        <div class="container d-flex justify-content-center align-items-center flex-column mt-5">
            <!-- Logo -->
            <div class="mb-3 text-center d-flex justify-content-center align-items-center" style="width: 100px; height: 100px; overflow: hidden;">
                <img src="assets/logo.png" alt="Profile" class="img-fluid w-100 h-100" style="object-fit: contain;">
            </div>


            <div class="text-center w-100 bg-white rounded-4" style="max-width: 450px;">
                <div class="container p-4">
                    <h1 class="fw-bold mb-4" style="color:#2F6690;">CommUNITYHub</h1>
                    <form action="login.do" method="POST">
                        <div class="mb-3">
                            <input type="text" class="form-control" placeholder="Username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" class="form-control" placeholder="Password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-login btn-lg w-100 mb-3" style="background-color: #3A7CA5;color:white;">LOGIN</button>
                        <div class="mb-3">
                            <div class="row">
                                <div class="col-6"><a href="#" class="text-decoration-none text-primary">Forgot password?</a></div>
                                <div class="col-6"><a href="register.jsp" class="text-decoration-none text-primary">Register</a></div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
