<%@page import="com.cm.model.beneficiary"%>
<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.events"%>
<%@page import="com.cm.model.task"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Beneficiary Event Detail</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif !important;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }

            .container {
                margin: 15px;
            }

            .event-image {
                width: 350px;
                height: auto;
                margin: 10px;
            }

            .divider {
                height: 1px;
                width: 95%;
                background-color: black;
                margin: 0 auto;
            }

            .progress-bar {
                background-color: pink;
            }

            .task-list {
                list-style-type: none;
                padding: 0;
            }

            .task-item {
                padding: 10px;
                margin: 5px 0;
                background-color: #f8f9fa;
                border-radius: 5px;
                border: 1px solid #dee2e6;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 0.9em;
                font-weight: 500;
            }

            .status-pending {
                background-color: #ffd700;
                color: #000;
            }

            .status-approved {
                background-color: #28a745;
                color: #fff;
            }

            .status-rejected {
                background-color: #dc3545;
                color: #fff;
            }

            .task-container {
                max-height: 150px; /* Adjust this value to fit exactly 2 tasks */
                overflow-y: auto; /* Make the container scrollable */
                border: 1px solid #dee2e6; /* Optional: Add a border for better visibility */
                border-radius: 5px; /* Optional: Rounded corners */
                padding: 10px; /* Optional: Add some padding */
            }

            .task-item {
                padding: 10px;
                margin: 5px 0;
                background-color: #f8f9fa;
                border-radius: 5px;
                border: 1px solid #dee2e6;
            }
        </style>
    </head>
    <body>
        <%@ include file="../header.jspf" %>
        <%
            events event = (events) request.getAttribute("event");
            address addressObj = (address) request.getAttribute("address");
            beneficiary beneficiaryObj = (beneficiary) request.getAttribute("beneficiary");
            List<task> tasks = (List<task>) request.getAttribute("tasks");
            String formattedDate = (String) request.getAttribute("formattedDate");
            String formattedStartTime = (String) request.getAttribute("formattedStartTime");
            String formattedEndTime = (String) request.getAttribute("formattedEndTime");
            int totalContributors = (Integer) request.getAttribute("totalContributors");
            double totalDonation = (Double) request.getAttribute("totalDonation");
            double remainingAmount = (Double) request.getAttribute("remainingAmount");
            double progress = (Double) request.getAttribute("progress");
        %>

        <div class="container mt-4">

            <img src="getImage.do?type=events&id=<%= event.getEventID()%>" class="rounded mx-auto d-block event-image" alt="Event Image">

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
                <div class="row mt-4">
                    <div class="col-md-8">
                        <div class="mb-4">
                            <h5>Status</h5>
                            <span class="status-badge status-<%= event.getStatus().toLowerCase()%>">
                                <%= event.getStatus().equals("1") ? "Pending"
                                        : event.getStatus().equals("2") ? "Approved" : "Rejected"%>
                            </span>
                        </div>



                        <div class="mb-4">
                            <h5>About</h5>
                            <p><%= event.getDescription()%></p>
                        </div>

                        <div class="mb-4">
                            <h5>Location</h5>
                            <div class="d-flex align-items-start">
                                <i class="bi bi-geo-alt me-2"></i>
                                <p class="mb-0"><%= addressObj.getStreet()%>, <%= addressObj.getCity()%>, 
                                    <%= addressObj.getState()%>, <%= addressObj.getPostalCode()%></p>
                            </div>
                        </div>

                        <div class="mb-4">
                            <h5>Event Schedule</h5>
                            <div class="row">
                                <div class="col-md-6">
                                    <small class="text-muted">Start Time</small>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-calendar-event me-2"></i>
                                        <p class="mb-0"><%= formattedDate%> <%= formattedStartTime%></p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <small class="text-muted">End Time</small>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-calendar-event me-2"></i>
                                        <p class="mb-0"><%= formattedDate%> <%= formattedEndTime%></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-4">
                            <h5>Total Volunteer: </h5>
                            <span class="status-badge">
                                <c:choose>
                                    <c:when test="${not empty requestScope.totalVol and requestScope.totalVol != 0}">
                                        ${requestScope.totalVol}
                                    </c:when>
                                    <c:otherwise>
                                          No one has volunteered yet
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                    </div>

                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title mb-4">Donation Progress</h5>
                                <h2 class="fw-bold">RM<%= String.format("%.2f", totalDonation)%></h2>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar" role="progressbar" 
                                         style="width: <%= progress%>%;" 
                                         aria-valuenow="<%= progress%>" 
                                         aria-valuemin="0" 
                                         aria-valuemax="100">
                                    </div>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <small class="text-muted">Goal<br>RM<%= String.format("%.2f", event.getDonationLimit())%></small>
                                    <small class="text-muted">Remaining<br>RM<%= String.format("%.2f", remainingAmount)%></small>
                                </div>
                                <div class="d-flex justify-content-between mb-3">
                                    <div>
                                        <i class="bi bi-clock me-2"></i>
                                        <small class="text-muted"><%= request.getAttribute("daysLeft")%> days left</small>
                                    </div>
                                    <div>
                                        <i class="bi bi-heart-fill text-danger me-2"></i>
                                        <small class="text-muted"><%= totalContributors%> Contributors</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <h5 class="mt-2">Tasks</h5>
                            <div class="task-container">
                                <ul class="task-list">
                                    <% for (task task : tasks) {%>
                                    <li class="task-item">
                                        <i class="bi bi-check-circle me-2"></i>
                                        <%= task.getDescription()%>
                                    </li>
                                    <% }%>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>