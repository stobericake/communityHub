<%-- 
    Document   : myEventDetail
    Created on : Dec 22, 2024, 11:48:23 PM
    Author     : Rina
--%>

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
            
            String formattedDate = request.getAttribute("formattedDate").toString();
            String formattedStartTime = request.getAttribute("formattedStartTime").toString();
            String formattedEndTime = request.getAttribute("formattedEndTime").toString();
            
            int eventID = event.getEventID();
                        
        %>
        <img src="getImage.do?type=events&id=<%= eventID %>" class="rounded mx-auto d-block event-image font-weight-bold" alt="Event Image">
        <figure class="text-center">
            <blockquote class="blockquote">
                <p class="h6"><%= event.getName() %></p>
            </blockquote>
            <figcaption class="blockquote-footer">
                BY <cite title="Beneficiary Name">@<%= beneficiaryObj.getName() %></cite>
            </figcaption>
        </figure>
        <div class="divider"></div>
        <div class="container">
            <div class="row">
                <!-- Left Column: About, Location, and Event Date -->
                <div class="col-md-8">
                    <p><strong>About</strong></p>
                    <p><%= event.getDescription() %></p>
                    <p><strong>Location.</strong></p>
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-geo-alt me-2"></i>
                        <p class="text-muted"><%= addressObj.getState() %></p>
                    </div>
                    <p><strong>Event Date.</strong></p>
                    <div class="d-flex justify-content-between mb-3">
                        <small>Start Date

                            <br><div class="d-flex align-items-start justify-content-start">
                                <i class="bi bi-calendar-event me-2"></i>
                                <p class="text-muted"><%=formattedDate%> <%=formattedStartTime%></p>
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
                </div>

                <!-- Right Column: Cards -->
                <div class="col-md-4">
                    <div class="card mb-4" style="border-radius: 10px;">
                        <div class="card-body text-center">
                            <div class="d-flex align-items-center justify-content-center">
                                <img src="assets/Medallions.svg" alt="Icon" style="width: 50px; height: 50px;">
                                <p><strong>DOWNLOAD CERTIFICATE</strong></p>
                            </div>
                            <a href="javascript:void(0)" onclick="showCertificateModal(<%= eventID%>)" 
                               class="btn w-100 py-2" 
                               style="background-color: #000; color: #fff; border-radius: 30px;">
                                DOWNLOAD <i class="bi bi-download"></i>
                            </a>
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


                    <!-- Second Card -->
                    <div class="card mb-4" style="border-radius: 10px;">
                        <div class="card-body text-center">
                            <div class="d-flex align-items-center justify-content-center">
                                <img src="assets/medal.svg" alt="Icon" style="width: 50px; height: 50px;">
                                <p><strong>SERVICE REPORT</strong></p>
                            </div>
                            <p class="card-text text-muted">
                                Tell us about your experience and suggestions to improve our service and enhance our system.
                            </p>
                            <a href="volunteer/serviceForm.jsp" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                                FILL IN FORM? <i class="bi bi-pencil-square"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
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