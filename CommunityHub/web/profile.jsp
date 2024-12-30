
<%@page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>
            html, body {
                margin: 0; /* Removes default margin */
                padding: 0; /* Removes default padding */
                font-family: 'Montserrat', sans-serif;
            }

            .form-label {
                font-weight: 500;
            }

            .btn {
                font-family: 'Montserrat', sans-serif;
            }

            .toggle-password i {
                font-size: 18px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>
        <%
            int userID = 1;
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = dbconnection.getConnection(); // Get DB connection

            String sql = "SELECT * FROM admin WHERE adminID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID); // Set the eventID
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Access the data in the first row
                String name = rs.getString("name");
                String email = rs.getString("email");
                int contact = rs.getInt("contactInfo");
                String username = rs.getString("username");
                String password = rs.getString("password");
        %>
        <div class="container mt-4 mb-4">
            <h3 class="fw-bold">ACCOUNT INFORMATION</h3>
            <p>Profile User</p>
            <div class="row">
                <div class="profile-header row align-items-center">
                    <div class="col-2">
                        <div class="profile-picture rounded-circle overflow-hidden" style="width: 100px; height: 100px;">
                            <img src="assets/profile.jpg" alt="Profile Picture" class="w-100 h-100" style="object-fit: cover;">
                        </div>
                    </div>
                    <div class="col">
                        <h5 class="mt-3"><%=name%></h5>
                        <p><%=email%></p>
                    </div>
                </div>

                <!-- Update User Info Form -->
                <form class="border mt-3 p-3">
                    <div class="row mb-3">
                        <div class="col">
                            <label for="Username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="Username" value="<%=username%>">
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" value="<%=email%>">
                    </div>
                    <div class="mb-3">
                        <label for="contactNumber" class="form-label">Contact Number</label>
                        <input type="text" class="form-control" id="contactNumber" value="<%=contact%>">
                    </div>
                    <div class="d-flex justify-content-start">
                        <button type="submit" class="btn btn-primary me-2">Update Info</button>
                        <button type="button" class="btn btn-danger">Cancel</button>
                    </div>
                </form>

                <!-- Change Password Form -->
                <form class="border mt-3 p-3">
                    <div class="mb-3">
                        <label for="currentPassword" class="form-label">Current Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control" id="currentPassword" value="<%=password%>">
                            <button type="button" class="btn btn-link position-absolute top-50 end-0 translate-middle-y toggle-password" data-target="#currentPassword">

                            </button>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control" id="newPassword">
                            <button type="button" class="btn btn-link position-absolute top-50 end-0 translate-middle-y toggle-password" data-target="#newPassword">

                            </button>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <div class="position-relative">
                            <input type="password" class="form-control" id="confirmPassword">
                            <button type="button" class="btn btn-link position-absolute top-50 end-0 translate-middle-y toggle-password" data-target="#confirmPassword">

                            </button>
                        </div>
                    </div>
                    <div class="d-flex justify-content-start">
                        <button type="submit" class="btn btn-primary me-2">Update Password</button>
                        <button type="button" class="btn btn-danger">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
        <%
            }
        %>

    </body>
</html>
