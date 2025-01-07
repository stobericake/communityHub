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
                        
            .dropdown-menu {
                list-style: none; /* Removes bullet points */
                padding: 0; /* Optional: Adjust spacing */
                margin: 0; /* Optional: Adjust spacing */
            }

            .dropdown-toggle::before {
                content: none; /* Removes any unintended dots or symbols */
            }
            .dropdown-item {
                color: #495057; /* Dark gray text */
                font-size: 16px; /* Font size */
                padding: 12px 20px; /* Increase padding for better spacing */
            }

            /* Change the color of the item on hover */
            .dropdown-item:hover {
                background-color: #F56476; /* Blue background on hover */
                color: white; /* White text on hover */
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>
        <%
            String user = (String) session.getAttribute("userRole");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            int eventID = Integer.parseInt(request.getParameter("eventID"));
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
            <div class="clearfix">
                <div class="card col-md-3 float-md-end mb-4 ms-md-3" style="border-radius: 10px;">
                    <div class="card-body text-start">
                        <h2 class="fw-bold">RM<%= totalDonation %></h2>
                        <div class="progress mb-3" style="height: 8px; border-radius: 5px;">
                            <div class="progress-bar" role="progressbar" style="width: <%= progress %>%;" aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <small class="text-muted text-start">Goal<br>RM<%= event.getDonationLimit() %></small>
                            <small class="text-muted text-end">Remaining<br>RM<%= remainingAmount %></small>
                        </div>
                        <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-clock me-2"></i>
                        <small class="text-muted"> 123 days </small>
                    </div>
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-heart-fill text-danger me-2"></i>
                        <small class="text-muted"><%= totalContributors %> Contributors</small>
                    </div>
                    <hr>
                    <button class="btn w-100 py-2" href="../guest/donationForm.jsp?eventID=<%= eventID %>" style="background-color: #000; color: #fff; border-radius: 30px;">
                        DONATE <i class="bi bi-heart"></i>
                    </button>
                </div>
                    </div>
       
            <p><strong>About.</strong></p>
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
                <p class="text-muted"><%=formattedStartTime%></p>
            </div>
            </small>
            <small>End Date
                <br><div class="d-flex align-items-start justify-content-start">
                <i class="bi bi-calendar-event me-2"></i>
                <p class="text-muted"<%=formattedEndTime%></p>
            </div>
            </small>
            </div>
                <p><strong>Tasks Required:</strong></p>
                <form action="volunteer_servlet.do" method="POST">
                <input type="hidden" name="eventID" value="<%= event.getEventID() %>">
                <% int i = 0; %>
                <% for (task task : tasks) { %>
                    <div class="form-check form-check-inline mb-3">
                        <input type="hidden" name="taskID" value="<%= task.getTaskID() %>">
                        <input type="radio" class="form-check-input" name="task" id="task<%= i %>" 
                               value="<%= task.getDescription() %>" <%= i == 0 ? "checked" : "" %>>
                        <label class="form-check-label" for="task<%= i %>"><%= task.getDescription() %></label>
                    </div>
                    <% i++; %>
                <% } %>
                <%
                   if (user == null) {
                %>
                <p class="text-danger">Please log in to volunteer for this event.</p>
                <a href="../login.jsp" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                    LOGIN TO VOLUNTEER <i class="bi bi-box2-heart-fill"></i>
                </a>
                <%
                    } else {
                %>
                <button type="submit" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                    VOLUNTEER <i class="bi bi-box2-heart-fill"></i>
                </button>
                <%
                    }
                %>
            </form>
            </div>
        </div>
    </body>
</html>
