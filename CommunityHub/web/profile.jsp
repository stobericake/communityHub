<%@page import="java.sql.Blob"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.beneficiary"%>
<%@page import="com.cm.model.volunteer"%>
<%@page import="com.cm.model.admin"%>
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
            String userRole1 = (String) session.getAttribute("userRole");
            volunteer volunteerObj = null;
            beneficiary beneficiaryObj = null;
            admin adminObj = null;

            String name = "";
            String email = "";
            int contact = 0;
            String street = "";
            int postcode = 0;
            String city = "";
            String state = "";
            String country = "";
            String username = "";
            String password = "";
            Blob profileImage = (Blob) request.getAttribute("profileImage");
            address addressObj = (address) request.getAttribute("addressObj");

            if (userRole1.equals("admin")) {
                adminObj = (admin) request.getAttribute("adminObj");
                name = adminObj.getName();
                email = adminObj.getEmail();
                contact = adminObj.getContactInfo();
                username = adminObj.getUsername();
                password = adminObj.getPassword();
            } else if (userRole1.equals("volunteer")) {
                volunteerObj = (volunteer) request.getAttribute("volunteerObj");
                name = volunteerObj.getName();
                contact = volunteerObj.getContactInfo();
                country = addressObj.getCountry();
                postcode = addressObj.getPostalCode();
                street = addressObj.getStreet();
                city = addressObj.getCity();
                state = addressObj.getState();
                username = volunteerObj.getUsername();
                password = volunteerObj.getPassword();
            } else {
                beneficiaryObj = (beneficiary) request.getAttribute("beneficiaryObj");
                name = beneficiaryObj.getName();
                contact = beneficiaryObj.getContactInfo();
                country = addressObj.getCountry();
                postcode = addressObj.getPostalCode();
                street = addressObj.getStreet();
                city = addressObj.getCity();
                state = addressObj.getState();
                username = beneficiaryObj.getUsername();
                password = beneficiaryObj.getPassword();
            }
        %>
        <div class="container mt-4 mb-4">
            <h3 class="fw-bold">ACCOUNT INFORMATION</h3>
            <p>Profile User</p>
            <div class="row">
                <div class="profile-header row align-items-center">
                    <div class="col-2">
                        <div class="profile-picture rounded-circle overflow-hidden" style="width: 100px; height: 100px;">
                            <%
                                if (profileImage != null) {
                                    InputStream inputStream = profileImage.getBinaryStream();
                                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                                    byte[] buffer = new byte[4096];
                                    int bytesRead = -1;
                                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                                        outputStream.write(buffer, 0, bytesRead);
                                    }
                                    byte[] imageBytes = outputStream.toByteArray();
                                    String base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
                            %>
                            <img src="data:image/jpeg;base64,<%= base64Image%>" alt="Profile Picture" class="w-100 h-100" style="object-fit: cover;">
                            <%
                            } else {
                            %>
                            <img src="assets/profile.jpg" alt="Profile Picture" class="w-100 h-100" style="object-fit: cover;">
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <div class="col">
                        <h5 class="mt-3"><%=name%></h5>
                        <% if (userRole1.equals("admin")) { %>
                            <p><%=email%></p>
                        <% } %>
                    </div>
                </div>

                <!-- Tab Navigation -->
                <ul class="nav nav-tabs mt-4" id="profileTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="user-info-tab" data-bs-toggle="tab" data-bs-target="#user-info" type="button" role="tab" aria-controls="user-info" aria-selected="true">
                            Update User Info
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="password-tab" data-bs-toggle="tab" data-bs-target="#password" type="button" role="tab" aria-controls="password" aria-selected="false">
                            Change Password
                        </button>
                    </li>
                    <% if (!userRole1.equals("admin")) { %>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="address-tab" data-bs-toggle="tab" data-bs-target="#address" type="button" role="tab" aria-controls="address" aria-selected="false">
                            Address
                        </button>
                    </li>
                    <% }%>
                </ul>

                <!-- Tab Content -->
                <div class="tab-content border border-top-0 p-3" id="profileTabsContent">
                    <!-- Update User Info Tab -->
                    <div class="tab-pane fade show active" id="user-info" role="tabpanel" aria-labelledby="user-info-tab">
                        <form action="<%=request.getContextPath()%>/updateprofile?type=basic" method="POST" enctype="multipart/form-data">
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="Name" class="form-label">Name</label>
                                    <input type="text" name="name" class="form-control" id="Name" value="<%=name%>">
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="Username" class="form-label">Username</label>
                                    <input type="text" name="username" class="form-control" id="Username" value="<%=username%>">
                                </div>
                            </div>
                            <% if (userRole1.equals("admin")) { %>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" name="email" class="form-control" id="email" value="<%=email%>">
                            </div>
                            <% } %>
                            <div class="mb-3">
                                <label for="contactNumber" class="form-label">Contact Number</label>
                                <input type="text" name="phone_number" class="form-control" id="contactNumber" value="<%=contact%>">
                            </div>
                            <div class="mb-3">
                                <label for="profilePicture" class="form-label">Profile Picture</label>
                                <input type="file" name="profilePicture" class="form-control" id="profilePicture">
                            </div>
                            <div class="d-flex justify-content-start">
                                <button type="submit" class="btn btn-primary me-2">Update Info</button>
                                <button type="button" class="btn btn-danger">Cancel</button>
                            </div>
                        </form>
                    </div>

                    <!-- Change Password Tab -->
                    <div class="tab-pane fade" id="password" role="tabpanel" aria-labelledby="password-tab">
                        <form action="<%=request.getContextPath()%>/updateprofile?type=password" method="POST">
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">Current Password</label>
                                <div class="position-relative">
                                    <input type="password" class="form-control" id="currentPassword" value="<%=password%>" required>
                                    <button type="button" class="btn btn-link position-absolute top-50 end-0 translate-middle-y toggle-password" data-target="#currentPassword">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="newPassword" class="form-label">New Password</label>
                                <div class="position-relative">
                                    <input type="password" name="password" class="form-control" id="newPassword" required>
                                    <button type="button" class="btn btn-link position-absolute top-50 end-0 translate-middle-y toggle-password" data-target="#newPassword">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <div class="position-relative">
                                    <input type="password" name="password" class="form-control" id="confirmPassword" required>
                                    <button type="button" class="btn btn-link position-absolute top-50 end-0 translate-middle-y toggle-password" data-target="#confirmPassword">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="d-flex justify-content-start">
                                <button type="submit" class="btn btn-primary me-2">Update Password</button>
                                <button type="button" class="btn btn-danger">Cancel</button>
                            </div>
                        </form>
                    </div>

                    <!-- Address Tab -->
                    <% if (!userRole1.equals("admin")) {%>
                    <div class="tab-pane fade" id="address" role="tabpanel" aria-labelledby="address-tab">
                        <form action="<%=request.getContextPath()%>/updateprofile?type=address" method="POST" class="mt-3">
                            <div class="mb-3">
                                <label for="street" class="form-label">Street</label>
                                <input type="text" class="form-control" id="street" name="street" value="<%=street%>">
                            </div>
                            <div class="mb-3">
                                <label for="postcode" class="form-label">Postcode</label>
                                <input type="text" class="form-control" id="postcode" name="postcode" value="<%=postcode%>">
                            </div>
                            <div class="mb-3">
                                <label for="city" class="form-label">City</label>
                                <input type="text" class="form-control" id="city" name="city" value="<%=city%>">
                            </div>
                            <div class="mb-3">
                                <label for="state" class="form-label">State</label>
                                <input type="text" class="form-control" id="state" name="state" value="<%=state%>">
                            </div>
                            <div class="mb-3">
                                <label for="country" class="form-label">Country</label>
                                <input type="text" class="form-control" id="country" name="country" value="<%=country%>">
                            </div>
                            <button type="submit" class="btn btn-primary">Update Address</button>
                            <button type="button" class="btn btn-danger">Cancel</button>
                        </form>
                    </div>
                    <% }%>
                </div>
            </div>
        </div>
        <script>
            // Add event listeners to toggle password visibility
            document.querySelectorAll('.toggle-password').forEach(button => {
                button.addEventListener('click', function () {
                    const target = document.querySelector(this.getAttribute('data-target'));
                    if (target) {
                        if (target.type === 'password') {
                            target.type = 'text';
                            this.innerHTML = '<i class="bi bi-eye-slash"></i>'; // Change icon to "eye-slash"
                        } else {
                            target.type = 'password';
                            this.innerHTML = '<i class="bi bi-eye"></i>'; // Change icon back to "eye"
                        }
                    }
                });
            });
        </script>
    </body>
</html>