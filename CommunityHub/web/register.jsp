<!DOCTYPE html>
<html lang="en">
    <%@ page import="javax.servlet.http.HttpSession"%>
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
            // Display the error message
            out.println("<div class='alert alert-danger'>" + error + "</div>");
        }
    %>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Signup Screen</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(to bottom, #2F6690, #ffffff);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .signup-container {
                background: #ffffff;
                border-radius: 10px;
                padding: 30px;
                width: 100%;
                max-width: 600px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .signup-header {
                text-align: center;
                margin-bottom: 20px;
            }
            .signup-header h1 {
                font-size: 32px;
                font-weight: bold;
                color: #ff5722;
            }
            .signup-header h2 {
                font-size: 24px;
                color: #6c757d;
            }
            #register {
                transition: background-color 0.3s ease; /* Smooth transition */
            }
            #register:hover {
                background-color: #1E4A68 !important;
            }
            /* Style for username availability message */
            .username-feedback {
                font-size: 14px;
                margin-top: 5px;
            }
            .username-available {
                color: green;
            }
            .username-taken {
                color: red;
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>
        <div class="signup-container">
            <div class="signup-header">
                <h2>Welcome to</h2>
                <h1 style="color: #2F6690;">CommUNITYHub</h1>
            </div>
            <form action="register" method="post" onsubmit="return validateForm()">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <input type="text" name="full_name" class="form-control" placeholder="Full Name" required>
                    </div>
                    <div class="col-md-6">
                        <input type="text" name="username" id="username" class="form-control" placeholder="Username" required 
                               oninput="checkUsernameAvailability()" data-bs-toggle="tooltip" data-bs-placement="right" 
                               title="" data-bs-trigger="manual">
                        <div id="username-feedback" class="username-feedback"></div>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <input type="number" name="phone_number" class="form-control" placeholder="Phone Number" 
                               oninput="enforceMaxLength(this, 13)" required>
                    </div>
                    <div class="col-md-6">
                        <input type="text" name="street" class="form-control" placeholder="Street" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <div class="col-md-4">
                        <input type="number" name="postcode" class="form-control" placeholder="Postcode" 
                               oninput="enforceMaxLength(this, 5)" required>
                    </div>
                    <div class="col-md-4">
                        <input type="text" name="city" class="form-control" placeholder="City" required>
                    </div>
                    <div class="col-md-4">
                        <input type="text" name="state" class="form-control" placeholder="State" required>
                    </div>
                </div>
                <div class="mb-3">
                    <input type="text" name="country" class="form-control" placeholder="Country" value="Malaysia" required>
                </div>
                <div class="row mb-3">
                    <div class="col-md-6">
                        <input type="password" name="password" class="form-control" placeholder="Password" required>
                    </div>
                    <div class="col-md-6">
                        <input type="password" name="confirm_password" class="form-control" placeholder="Confirm Password" required>
                    </div>
                </div>
                <div class="row mb-4">
                    <div class="col-md-12">
                        <label for="role" class="form-label">I want to register as:</label>
                        <select id="role" name="role" class="form-select" required>
                            <option value="" selected disabled>Select Role</option>
                            <option value="volunteer">Volunteer</option>
                            <option value="beneficiary">Beneficiary</option>
                        </select>
                    </div>
                </div>
                <div class="text-center">
                    <button type="submit" class="btn btn-lg w-100" id="register" style="background-color: #2F6690; color: #ffffff;">REGISTER</button>
                </div>
            </form>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Initialize Bootstrap tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });

            // Function to enforce maximum length for number inputs
            function enforceMaxLength(input, maxLength) {
                if (input.value.length > maxLength) {
                    input.value = input.value.slice(0, maxLength); // Truncate the input
                }
            }

            // Function to validate the form
            function validateForm() {
                const phoneNumber = document.querySelector('input[name="phone_number"]').value;
                const postcode = document.querySelector('input[name="postcode"]').value;
                const usernameFeedback = document.getElementById("username-feedback");

                // Validate phone number length (10 to 13 digits)
                if (phoneNumber.length < 10 || phoneNumber.length > 13) {
                    alert("Phone number must be between 10 to 13 digits.");
                    return false;
                }

                // Validate postcode length (exactly 5 digits)
                if (postcode.length !== 5) {
                    alert("Postcode must be exactly 5 digits.");
                    return false;
                }

                // Check if username is already taken
                if (usernameFeedback.classList.contains("username-taken")) {
                    alert("Username is already taken. Please choose a different username.");
                    return false;
                }

                return true;
            }

            // Function to check username availability
            function checkUsernameAvailability() {
                const username = document.getElementById("username").value;
                const role = document.getElementById("role").value;
                const usernameInput = document.getElementById("username");
                const usernameFeedback = document.getElementById("username-feedback");

                if (username.length === 0) {
                    usernameFeedback.textContent = "";
                    usernameInput.setAttribute("title", "");
                    bootstrap.Tooltip.getInstance(usernameInput).hide();
                    return;
                }

                // Send AJAX request to check username availability
                fetch(`/register?username=${username}&role=${role}`)
                    .then(response => response.json())
                    .then(data => {
                        if (data.available) {
                            usernameFeedback.textContent = "Username is available.";
                            usernameFeedback.classList.remove("username-taken");
                            usernameFeedback.classList.add("username-available");
                            usernameInput.setAttribute("title", "");
                            bootstrap.Tooltip.getInstance(usernameInput).hide();
                        } else {
                            usernameFeedback.textContent = "";
                            usernameInput.setAttribute("title", "Username is already taken.");
                            bootstrap.Tooltip.getInstance(usernameInput).show();
                            usernameFeedback.classList.remove("username-available");
                            usernameFeedback.classList.add("username-taken");
                        }
                    })
                    .catch(error => {
                        console.error("Error checking username availability:", error);
                    });
            }
        </script>
    </body>
</html>