<%-- 
    Document   : myEventDetail
    Created on : Dec 22, 2024, 11:48:23 PM
    Author     : Rina
--%>

<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="com.cm.model.eventsVolunteer"%>
<%@page import="com.cm.model.task"%>
<%@page import="com.cm.model.beneficiary"%>
<%@page import="com.cm.model.events"%>
<%@page import="com.cm.model.address"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.ZoneId" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Event Detail</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }

            .container {
                margin: 15px;
            }

            .event-image {
                width: 300px; /* Fixed width */
                height: 150px; /* Fixed height */
                object-fit: cover; /* Ensures the image is resized to fit the dimensions without distortion */
                margin: 10px;
            }

            .divider {
                height: 1px; 
                width: 100%; /* Set width to 80% of the screen size */
                background-color: black; 
                margin: 0 auto; /* Center the divider horizontally */
            }

            .progress-bar {
                background-color: pink;
            }

            .donate-btn {
                background-color: #000; /* Black button */
                color: #fff; /* White text */
                border-radius: 30px; /* Rounded edges */
            }

            .card {
                border-radius: 10px; 
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .modal-fullscreen .modal-content {
                background-color: #fff; /* Overlay background color */
                padding: 5px; /* Adjust padding */
            }

            .modal-fullscreen .modal-header, 
            .modal-fullscreen .modal-footer {
                border: none; /* Remove borders */
            }

            .print-button {
                background-color: #000; /* Black button */
                color: #fff; /* White text */
                border-radius: 30px; /* Rounded edges */
            }
            .start-date-gap {
                margin-right: 20px; /* Adjust the value as needed */
            }
            .progress-bar {
                background-color: pink;
            }

            .donate-btn {
                background-color: #000; /* Black button */
                color: #fff; /* White text */
                border-radius: 30px; /* Rounded edges */
            }
            @media print {
                body * {
                    visibility: hidden;
                }

                /* Show only the certificate content */
                .certificate-content, .certificate-content * {
                    visibility: visible;
                }

                /* Optionally, adjust the positioning to ensure it's centered */
                .certificate-content {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                }

                /* Hide the print button */
                .print-button {
                    display: none;
                }

                /* Hide other unnecessary elements like the header */
                .modal-header, .modal-header, .modal-footer, .btn-close {
                    display: none;
                }

                .modal-body {
                    padding: 0;
                    overflow: hidden; /* Prevent scrolling */
                }

                /* Ensure iframe takes up the full modal height */
                #certificatePreview {
                    width: 100%;
                    height: 100vh; /* Full viewport height */
                    border: none;
                    overflow: hidden;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="../header.jspf" %>
        <%
            String user = (String) session.getAttribute("userRole");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            // Access the attributes set by the servlet
            events event = (events) request.getAttribute("event");
            address addressObj = (address) request.getAttribute("address");
            beneficiary beneficiaryObj = (beneficiary) request.getAttribute("beneficiary");
            task tasks = (task) request.getAttribute("task");
            eventsVolunteer ev = (eventsVolunteer) request.getAttribute("eventsVolunteer");

            // Retrieve formatted date and time from request attributes
            String formattedDate = request.getAttribute("formattedDate").toString();
            String formattedStartTime = request.getAttribute("formattedStartTime").toString();
            String formattedEndTime = request.getAttribute("formattedEndTime").toString();
            int totalContributors = Integer.parseInt(request.getAttribute("totalContributors").toString());
            double totalDonation = Double.parseDouble(request.getAttribute("totalDonation").toString());
            double remainingAmount = Double.parseDouble(request.getAttribute("remainingAmount").toString());
            double progress = Double.parseDouble(request.getAttribute("progress").toString());

            int eventID = event.getEventID();

            // Get current date and time
            LocalDate currentDate = LocalDate.now();
            LocalTime currentTime = LocalTime.now();

            // Define date and time formatters
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            DateTimeFormatter timeFormatter;

            // Parse event date and times
            LocalDate eventDate = LocalDate.parse(formattedDate, dateFormatter);

            // Check if the time string contains a space (e.g., "09:00 PM")
            if (formattedStartTime.contains(" ")) {
                timeFormatter = DateTimeFormatter.ofPattern("hh:mm a"); // Pattern for "09:00 PM"
            } else {
                timeFormatter = DateTimeFormatter.ofPattern("hh:mma"); // Pattern for "09:00PM"
            }

            // Parse the time strings
            LocalTime eventStartTime = LocalTime.parse(formattedStartTime, timeFormatter);
            LocalTime eventEndTime = LocalTime.parse(formattedEndTime, timeFormatter);

            // Debugging: Print parsed values
            System.out.println("Event Date: " + eventDate);
            System.out.println("Event Start Time: " + eventStartTime);
            System.out.println("Event End Time: " + eventEndTime);
            System.out.println("Current Date: " + currentDate);
            System.out.println("Current Time: " + currentTime);

            // Check if the event is ongoing
            boolean isEventOngoing = false;
            if (currentDate.isEqual(eventDate)) {
                if (eventEndTime.isAfter(eventStartTime)) {
                    // Event does not span midnight
                    isEventOngoing = currentTime.isAfter(eventStartTime) && currentTime.isBefore(eventEndTime);
                } else {
                    // Event spans midnight (e.g., 21:00 to 01:00)
                    isEventOngoing = currentTime.isAfter(eventStartTime) || currentTime.isBefore(eventEndTime);
                }
            } else if (currentDate.isEqual(eventDate.plusDays(1))) {
                // Check if the current time is before the end time on the next day
                isEventOngoing = currentTime.isBefore(eventEndTime);
            }

            // Check if the event has ended
            boolean isEventEnded = currentDate.isAfter(eventDate) // Event date is in the past
                || (currentDate.isEqual(eventDate) && currentTime.isAfter(eventEndTime)) // Event date is today, and current time is after end time
                || (eventEndTime.isBefore(eventStartTime) // Event spans midnight
                    && currentDate.isEqual(eventDate.plusDays(1)) // Current date is the next day
                    && currentTime.isAfter(eventEndTime)); // Current time is after end time

            // Debugging: Print results
            System.out.println("Is Event Ongoing: " + isEventOngoing);
            System.out.println("Is Event Ended: " + isEventEnded);
            String daysLeft = request.getAttribute("daysLeft").toString();
        %>
        <div class="container mt-4">
            <img src="getImage.do?type=events&id=<%= eventID%>" class="rounded mx-auto d-block event-image font-weight-bold" alt="Event Image">
            <figure class="text-center">
                <blockquote class="blockquote">
                    <p class="h6"><%= event.getName()%></p>
                </blockquote>
                <figcaption class="blockquote-footer">
                    BY <cite title="Beneficiary Name">@<%= beneficiaryObj.getName()%></cite>
                </figcaption>
            </figure>
            <div class="divider"></div>
            <div class="container">
                <div class="row">
                    <!-- Left Column: About, Location, and Event Date -->
                    <div class="col-md-8">
                        <p><strong>About</strong></p>
                        <p><%= event.getDescription()%></p>
                        <p><strong>Location.</strong></p>
                        <div class="d-flex align-items-start justify-content-start">
                            <i class="bi bi-geo-alt me-2"></i>
                            <p class="text-muted"><%= addressObj.getState()%></p>
                        </div>
                        <p><strong>Event Date.</strong></p>
                        <div class="d-flex justify-content-start mb-3">
                            <!-- Start Date -->
                            <small class="start-date-gap"> <!-- Custom class for margin -->
                                Start Date
                                <br>
                                <div class="d-flex align-items-start justify-content-start">
                                    <i class="bi bi-calendar-event me-2"></i>
                                    <p class="text-muted"><%=formattedDate%> <%= formattedStartTime%></p>
                                </div>
                            </small>

                            <small>End Date
                                <br><div class="d-flex align-items-start justify-content-start">
                                    <i class="bi bi-calendar-event me-2"></i>
                                    <p class="text-muted"><%=formattedDate%> <%= formattedEndTime%></p>
                                </div>
                            </small>
                        </div>
                        <p><strong>Selected Task:</strong> <%= tasks.getDescription()%></p>
                        <input type="hidden" id="attendanceStatus" value="<%= ev.getAttendance() %>">

                        <% if (isEventOngoing) { %>
                            <% if (ev.getAttendance() == 0) { %>
                                <!-- Action Buttons at the Bottom -->
                                <div class="action-buttons mt-auto">
                                    <button onclick="confirmAttendance(<%= eventID%>, 1)" class="btn btn-primary">
                                        <i class="bi bi-calendar-check me-2"></i>Attend
                                    </button>
                                    <button onclick="confirmAttendance(<%= eventID%>, 2)" class="btn btn-danger">
                                        <i class="bi bi-x-circle me-2"></i>Absent
                                    </button>
                                </div>
                            <% } else { %>
                                <!-- Display Attendance Status Text -->
                                <div id="attendanceStatusText">
                                    <p><strong>Attendance:</strong> 
                                        <% if (ev.getAttendance() == 1) { %>
                                            Attend
                                        <% } else if (ev.getAttendance() == 2) { %>
                                            Absent
                                        <% } %>
                                    </p>
                                </div>
                            <% } %>
                        <% } %>
                    </div>


                    <div class="col-md-4">
                        <% if (!isEventEnded) { %>
                            <!-- Donation Card (Before and During Event) -->
                            <div class="card mb-4" style="border-radius: 10px;">
                                <div class="card-body text-start">
                                    <h2 class="fw-bold">RM<%= String.format("%.2f", totalDonation) %></h2>
                                    <div class="progress mb-3" style="height: 8px; border-radius: 5px;">
                                        <div class="progress-bar" role="progressbar" style="width: <%= progress %>%;" aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="d-flex justify-content-between mb-3">
                                        <small class="text-muted text-start">Goal<br>RM<%= String.format("%.2f", event.getDonationLimit()) %></small>
                                        <small class="text-muted text-end">Remaining<br>RM<%= String.format("%.2f", remainingAmount) %></small>
                                    </div>
                                    <div class="d-flex align-items-start justify-content-start">
                                        <i class="bi bi-clock me-2"></i>
                                        <small class="text-muted">
                                            <%= daysLeft %> days left
                                        </small>
                                    </div>
                                    <div class="d-flex align-items-start justify-content-start">
                                        <i class="bi bi-heart-fill text-danger me-2"></i>
                                        <small class="text-muted"><%= totalContributors %> Contributors</small>
                                    </div>
                                    <hr>
                                    <button class="btn w-100 py-2" onclick="location.href='addDonor.do?eventID=<%= event.getEventID() %>'" style="background-color: #000; color: #fff; border-radius: 30px;">
                                        DONATE <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </div>
                        <% } %>

                        <% if (isEventEnded) { %>
                            <!-- Certificate and Service Report (After Event) -->
                            <div class="card mb-4" style="border-radius: 10px;">
                                <div class="card-body text-center">
                                    <div class="d-flex align-items-center justify-content-center">
                                        <img src="assets/Medallions.svg" alt="Icon" style="width: 50px; height: 50px;">
                                        <p><strong>DOWNLOAD CERTIFICATE</strong></p>
                                    </div>
                                    <% if (ev.getAttendance() == 1) { %>
                                        <a href="javascript:void(0)" onclick="showCertificateModal(<%= eventID%>)"  
                                           class="btn w-100 py-2" 
                                           style="background-color: #000; color: #fff; border-radius: 30px;">
                                            DOWNLOAD <i class="bi bi-download"></i>
                                        </a>
                                    <% } else { %>
                                        <button class="btn w-100 py-2" style="background-color: #ccc; color: #666; border-radius: 30px;" disabled>
                                            Certificate Unavailable
                                        </button>
                                    <% } %>
                                </div>
                            </div>
                                
                                                        <!-- Fullscreen Overlay -->
                        <div class="modal fade" id="certificateOverlay" tabindex="-1" aria-labelledby="certificateOverlayLabel" aria-hidden="true">
                            <div class="modal-dialog modal-fullscreen">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="certificateOverlayLabel">Certificate</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <!--                                    Wrap the certificate content with a specific class -->
                                        <div class="certificate-content">
                                            <iframe id="certificatePreview" style="width: 100%; height: 100%; border: none;"></iframe>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-primary print-button" onclick="window.print();">Download</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                            <div class="card mb-4" style="border-radius: 10px;">
                                <div class="card-body text-center">
                                    <div class="d-flex align-items-center justify-content-center">
                                        <img src="assets/medal.svg" alt="Icon" style="width: 50px; height: 50px;">
                                        <p><strong>SERVICE REPORT</strong></p>
                                    </div>
                                    <p class="card-text text-muted">
                                        Tell us about your experience and suggestions to improve our service and enhance our system.
                                    </p>
                                    <% if (ev.getAttendance() == 1) { %>
                                        <a href="serviceForm?eventID=<%= eventID%>" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                                            FILL IN FORM? <i class="bi bi-pencil-square"></i>
                                        </a>
                                    <% } else { %>
                                        <button class="btn w-100 py-2" style="background-color: #ccc; color: #666; border-radius: 30px;" disabled>
                                            Report Unavailable
                                        </button>
                                    <% } %>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!--Hidden Form-->
        <form id="confirmAttendance" method="post" action="myDetail.do" style="display:none;">
            <input type="hidden" id="eventIdInput" name="eventId">
            <input type="hidden" id="attendaceInput" name="attendance">
        </form>        
        <script>
                function confirmAttendance(eventId, attendance) {
                document.getElementById('eventIdInput').value = eventId;
                document.getElementById('attendaceInput').value = attendance;
                document.getElementById('confirmAttendance').submit();

                // Hide the buttons and show the attendance status text
                document.querySelector('.action-buttons').style.display = 'none';
                document.getElementById('attendanceStatusText').style.display = 'block';
            }
        </script>
        <script>
            function printCertificate() {
                var iframe = document.getElementById('certificatePreview');

                if (iframe.contentWindow) {
                    iframe.contentWindow.focus(); // Focus on the iframe content
                    iframe.contentWindow.print(); // Trigger the print dialog for the iframe content
                } else {
                    alert("Failed to load certificate content for printing.");
                }
            }

            function showCertificateModal(eventID) {
                var contextPath = '<%= request.getContextPath()%>';
                var iframe = document.getElementById('certificatePreview');

                // Set the iframe source
                iframe.src = contextPath + '/certificate?eventID=' + eventID;

                // Adjust iframe height once content is fully loaded
                iframe.onload = function () {
                    var contentHeight = iframe.contentWindow.document.body.scrollHeight;
                    iframe.style.height = contentHeight + 'px';
                };

                // Show the modal
                var certificateModal = new bootstrap.Modal(document.getElementById('certificateOverlay'));
                certificateModal.show();
            }
        </script>

    </body>
</html>