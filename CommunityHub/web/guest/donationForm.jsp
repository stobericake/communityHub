<%@page import="com.cm.model.events"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Donation Form</title>
    <style>
        .is-invalid { border-color: #dc3545; }
        .is-valid { border-color: #28a745; }
    </style>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <%
        events event = (events) request.getAttribute("event");
        String volunteerName = (String) request.getAttribute("volunteerName");
        Integer contactInfo = (Integer) request.getAttribute("contactInfo");
        // Get current date
        Date currentDate = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String formattedDate = dateFormat.format(currentDate);
    %>
    <div class="container mt-4 pb-3 border w-50 w-md-75 rounded-4 shadow" style="background-color:#3A7CA5;">
        <div class="container">
            <div class="row text-center">
                <h1 class="fw-bolder text-white my-3" style="text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.3);">Donation Form</h1>
            </div>
            <form class="needs-validation" method="post" action="addDonor.do" enctype="multipart/form-data" novalidate>
                <div class="row border mb-3 mx-3 rounded-4 bg-white gy-2 p-3">
                    <div class="col-12 text-end">
                        <p class="mb-0"><strong>Date:</strong> <%= formattedDate %></p>
                    </div>
                    <div class="col-12">
                        <label for="eventName" class="form-label">Event</label>
                        <input type="text" class="form-control" id="eventName" value="<%= event.getName() %>" name="eventName" readonly required>
                        <input type="hidden" name="eventID" value="<%= event.getEventID() %>">
                        <div class="invalid-feedback">Event name is required.</div>
                    </div>
                    <div class="col-12">
                        <label for="name" class="form-label">Donor/Volunteer Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="<%= volunteerName != null ? volunteerName : "" %>" <%= volunteerName == null ? "required" : "readonly" %>>
                        <div class="invalid-feedback">Please insert your name.</div>
                    </div>
                    <div class="col-12">
                        <label for="contactInfo" class="form-label">Contact Number (without '-')</label>
                        <input type="tel" class="form-control" id="contactInfo" value="<%= contactInfo != null ? "0" + contactInfo : "" %>" name="contactInfo" pattern="^[0-9]{9,11}$" <%= contactInfo == null ? "required" : "readonly" %>>
                        <div class="invalid-feedback">Please insert a valid contact number.</div>
                    </div>

                    <div class="col-12">
                        <label for="amount" class="form-label">Amount (RM)</label>
                        <input type="number" class="form-control" id="amount" name="amount" min="1" step="1" required>
                        <div class="invalid-feedback">Insert amount for your donation.</div>
                    </div>
                    <div class="col-12">
                        <label for="receipt" class="form-label">Payment Receipt</label>
                        <input type="file" class="form-control" id="receipt" name="receipt" accept="image/*,application/pdf" required>
                        <div class="invalid-feedback">Please upload your donation receipt.</div>
                    </div>
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn btn-primary w-100 text-center" style="background-color:#2F6690; border-color: #2F6690;">Submit</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        (() => {
            'use strict';

            const forms = document.querySelectorAll('.needs-validation');

            // Loop over all forms and add the custom validation
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });

            // Real-time validation for individual inputs
            const validateField = (input) => {
                if (input.checkValidity()) {
                    input.classList.remove('is-invalid');
                    input.classList.add('is-valid');
                } else {
                    input.classList.remove('is-valid');
                    input.classList.add('is-invalid');
                }
            };

            // Add real-time validation event listeners
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('input', () => validateField(input));
            });
        })();
    </script>
</body>
</html>