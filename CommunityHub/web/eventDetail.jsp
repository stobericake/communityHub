<%@page import="com.cm.model.beneficiary"%>
<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.events"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="com.cm.model.task" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Event Detail</title>
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
                width: 300px; /* Fixed width */
                height: 150px; /* Fixed height */
                object-fit: cover; /* Ensures the image is resized to fit the dimensions without distortion */
                margin: 10px;
            }

            .divider {
                height: 1px;
                width: 100%;
                background-color: black;
                margin: 0 auto;
            }

            .progress-bar {
                background-color: pink;
            }

            .donate-btn {
                background-color: #000; /* Black button */
                color: #fff; /* White text */
                border-radius: 30px; /* Rounded edges */
            }
                        
        </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>
        <%
            Integer user = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
            // Access the attributes set by the servlet
            events event = (events) request.getAttribute("event");
            address addressObj = (address) request.getAttribute("address");
            beneficiary beneficiaryObj = (beneficiary) request.getAttribute("beneficiary");
            List<task> tasks = (List) request.getAttribute("tasks");
            
            String formattedDate = request.getAttribute("formattedDate").toString();
            String formattedStartTime = request.getAttribute("formattedStartTime").toString();
            String formattedEndTime = request.getAttribute("formattedEndTime").toString();
            int totalContributors = Integer.parseInt(request.getAttribute("totalContributors").toString());
            double totalDonation = Double.parseDouble(request.getAttribute("totalDonation").toString());
            double remainingAmount = Double.parseDouble(request.getAttribute("remainingAmount").toString());
            double progress = Double.parseDouble(request.getAttribute("progress").toString());
            String daysLeft = request.getAttribute("daysLeft").toString();
        %>    
        <div class="container mt-4">
            <img src="getImage.do?type=events&id=<%= event.getEventID() %>" class="rounded mx-auto d-block event-image" alt="Event Image">
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
            <div class="clearfix">
                <div class="card col-md-3 float-md-end mb-4 ms-md-3" style="border-radius: 10px;">
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
       
            <div class="mb-4">
                <h5>About</h5>
                <p><%= event.getDescription() %></p>
            </div>
            <div class="mb-4">
                <h5>Location</h5>
                <div class="d-flex align-items-start">
                <i class="bi bi-geo-alt me-2"></i>
                <p class="mb-0"><%= addressObj.getState() %></p>
                </div>
            </div>
                        <div class="mb-4">
                            <h5>Event Date</h5>
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
                    <!-- Task Selection Dropdown -->
                    <div class="d-flex align-items-center mb-4">
                        <h5 class="mb-0 me-4">Tasks Required:</h5>
                        <select name="taskID" id="taskID" class="form-select w-auto" required>
                            <!-- "Crew" option with value -1 -->
                            <option value="-1">Crew</option>
                            <% 
                                if (tasks != null && !tasks.isEmpty()) { 
                                    for (task task : tasks) { 
                            %>
                                <option value="<%= task.getTaskID() %>"><%= task.getDescription() %></option>
                            <% 
                                    } 
                                } 
                            %>
                        </select>
                    </div>

                    <!-- Form Submission -->
                    <form action="volunteerServlet1" method="POST">
                        <input type="hidden" name="eventID" value="<%= event.getEventID() %>">
                        <input type="hidden" name="taskID" id="selectedTaskID" value=""> <!-- Hidden field for taskID -->

                        <% 
                            if (user == null) { 
                        %>
                            <p class="text-danger mt-2">Please log in to volunteer for this event.</p>
                            <a href="../login.jsp" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                                LOGIN TO VOLUNTEER <i class="bi bi-box2-heart-fill"></i>
                            </a>
                        <% 
                            } else { 
                        %>
                            <button type="submit" class="btn w-100 py-2 mt-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                                VOLUNTEER <i class="bi bi-box2-heart-fill"></i>
                            </button>
                        <% 
                            } 
                        %>
                    </form>

                    <!-- JavaScript to set the selected taskID in the hidden field -->
                    <script>
                        document.getElementById('taskID').addEventListener('change', function() {
                            document.getElementById('selectedTaskID').value = this.value;
                        });
                    </script>
    </body>
</html>
