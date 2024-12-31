<%-- 
    Document   : myEventDetail
    Created on : Dec 22, 2024, 11:48:23 PM
    Author     : Rina
--%>

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
                width: 350px; /* Set the width */
                height: auto; /* Keep the aspect ratio */
                margin: 10px
            }

            .divider {
                height: 1px; 
                width: 95%; /* Set width to 80% of the screen size */
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
                .header, .modal-header, .modal-footer, .btn-close {
                    display: none;
                }
            }
        </style>
        </head>
        <body>
            <%@ include file="../header.jspf" %>
            <%
            String eventID = request.getParameter("eventID");
            String loggedInUser = (String) session.getAttribute("volunteer");
            String selectedTask = (String) session.getAttribute("selectedTask");

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            PreparedStatement taskStmt = null;
            ResultSet taskRs = null;
            PreparedStatement donationStmt = null;
            ResultSet donationRs = null;
            boolean isLoggedIn = loggedInUser != null;

            if (eventID != null && !eventID.isEmpty()) {
                try {
                    conn = dbconnection.getConnection();
                    String sql = "SELECT e.eventID, e.name AS eventName, e.date AS eventDate, e.time AS eventTime, e.duration, e.description, a.state AS location, b.name AS beneficiary, e.donationLimit FROM events e " +
                                 "INNER JOIN address a ON e.addressID = a.addressID " +
                                 "INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID WHERE e.eventID = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(eventID));
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        int id = rs.getInt("e.eventID");
                        String eventName = rs.getString("eventName");
                        Date eventDate = rs.getDate("eventDate");
                        Time eventTime = rs.getTime("eventTime");
                        Time eventDuration = rs.getTime("duration");
                        String description = rs.getString("description");
                        String location = rs.getString("location");
                        String beneficiary = rs.getString("beneficiary");
                        // Formatting setup
                        SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");
                        SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");

                        // Convert `eventDate` to LocalDate (compatible approach)
                        LocalDate eventLocalDate = new java.util.Date(eventDate.getTime())
                                .toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDate();

                        // Convert SQL Time to LocalTime
                        LocalTime startTime = eventTime.toLocalTime();
                        LocalTime duration = eventDuration.toLocalTime();

                        // Calculate the event's end time
                        LocalTime endTime = startTime.plusHours(duration.getHour()).plusMinutes(duration.getMinute());

                        // Format the date and time for display
                        String formattedDate = inputDateFormat.format(eventDate);
                        String formattedStartTime = outputFormat.format(eventTime);
                        String formattedEndTime = outputFormat.format(Time.valueOf(endTime));

                        // Fetch tasks
                        List<String> tasks = new ArrayList<String>();
                        String taskSql = "SELECT description FROM task WHERE eventID = ?";
                        taskStmt = conn.prepareStatement(taskSql);
                        taskStmt.setInt(1, Integer.parseInt(eventID));
                        taskRs = taskStmt.executeQuery();
                        while (taskRs.next()) {
                            tasks.add(taskRs.getString("description"));
                        }

        %>
            <img src="getImage.do?type=events&id=<%= id %>" class="rounded mx-auto d-block event-image font-weight-bold" alt="Event Image">
            <figure class="text-center">
                <blockquote class="blockquote">
                    <p class="h6"><%= eventName %></p>
                </blockquote>
                <figcaption class="blockquote-footer">
                    BY <cite title="Beneficiary Name">@<%= beneficiary %></cite>
                </figcaption>
            </figure>
            <div class="divider"></div>
            <div class="container">
                    <div class="row">
                        <!-- Left Column: About, Location, and Event Date -->
                        <div class="col-md-8">
                            <p><strong>About</strong></p>
                <p><%= description %></p>
                            <p><strong>Location.</strong></p>
                            <div class="d-flex align-items-start justify-content-start">
                                <i class="bi bi-geo-alt me-2"></i>
                                <p class="text-muted"><%= location %></p>
                            </div>
                            <p><strong>Event Date.</strong></p>
                            <div class="d-flex justify-content-between mb-3">
                            <small>Start Date

                                <br><div class="d-flex align-items-start justify-content-start">
                                <i class="bi bi-calendar-event me-2"></i>
                                <p class="text-muted"><%= formattedStartTime %></p>
                            </div>
                            </small>
                            <small>End Date
                                <br><div class="d-flex align-items-start justify-content-start">
                                <i class="bi bi-calendar-event me-2"></i>
                                <p class="text-muted"><%= formattedEndTime %></p>
                            </div>
                            </small>
                            </div>
                            <p><strong>Selected Task:</strong> <%= selectedTask %></p>
        </div>

        <!-- Right Column: Cards -->
        <div class="col-md-4">
            <div class="card mb-4" style="border-radius: 10px;">
                <div class="card-body text-center">
                    <div class="d-flex align-items-center justify-content-center">
                        <img src="../assets/Medallions.svg" alt="Icon" style="width: 50px; height: 50px;">
                        <p><strong>DOWNLOAD CERTIFICATE</strong></p>
                    </div>
                    <button class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;" type="button" data-bs-toggle="modal" data-bs-target="#certificateOverlay">
                        DOWNLOAD <i class="bi bi-download"></i>
                    </button>
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
                            <!-- Wrap the certificate content with a specific class -->
                            <div class="certificate-content">
                                <%@ include file="certificate.jsp" %>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary print-button" onclick="window.print();">Download</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Second Card -->
            <div class="card mb-4" style="border-radius: 10px;">
                <div class="card-body text-center">
                    <div class="d-flex align-items-center justify-content-center">
                    <img src="../assets/medal.svg" alt="Icon" style="width: 50px; height: 50px;">
                    <p><strong>SERVICE REPORT</strong></p>
                    </div>
                    <p class="card-text text-muted">
                        Tell us about your experience and suggestions to improve our service and enhance our system.
                    </p>
                    <a href="serviceForm.jsp" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                        FILL IN FORM? <i class="bi bi-pencil-square"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
    <% 
                    } else { 
        %>
        <div class="container">
            <p>Event not found.</p>
        </div>
    <%  }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Close resources manually
                try {
                    if (taskRs != null) taskRs.close();
                    if (taskStmt != null) taskStmt.close();
                    if (donationRs != null) donationRs.close();
                    if (donationStmt != null) donationStmt.close();
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else { 
         %>
    <div class="container">
        <p>Invalid Event ID.</p>
    </div>
    <% } %>
    </body>
</html>

