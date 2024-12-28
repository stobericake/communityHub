<%-- 
    Document   : volunteerDetail.jsp
    Created on : Dec 18, 2024, 4:54:05 AM
    Author     : Rina
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalTime"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>

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
            // Get the event ID from the request
            String eventID = request.getParameter("eventID");
            String loggedInUser = (String) session.getAttribute("volunteerID");

            boolean isLoggedIn = loggedInUser != null;
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            if (eventID != null && !eventID.isEmpty()) {
                try {
                    // Database connection
                    conn = dbconnection.getConnection();
                    String sql = "SELECT e.eventId, e.name, e.date, e.time, e.duration, e.description, a.state, t.description, b.name FROM events e INNER JOIN address a ON e.addressID = a.addressID INNER JOIN task t ON e.eventID = t.eventID INNER JOIN beneficiary b ON e.beneficiaryID = b.beneficiaryID WHERE e.eventID = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(eventID));
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        String eventName = rs.getString("e.name");
                        Date eventDate = rs.getDate("e.date");
                        Time eventTime = rs.getTime("e.time");
                        Time eventDuration = rs.getTime("e.duration");
                        String description = rs.getString("e.description");
                        String location = rs.getString("a.state");
                        String beneficiary = rs.getString("b.name");
                        
                         // Task handling
                        List<String> tasks = new ArrayList<String>();
                        do {
                            tasks.add(rs.getString("t.description"));
                        } while (rs.next());

                        // Parse and format
                        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");

                        String formattedDateTime = outputFormat.format(inputFormat.parse(eventDate + " " + eventTime));
                        
                        // Convert SQL Time to LocalTime
                        LocalTime startTime = eventTime.toLocalTime();
                        LocalTime duration = eventDuration.toLocalTime();
                        
                        // Calculate end time
                        LocalTime endTime = startTime.plusHours(duration.getHour()).plusMinutes(duration.getMinute());

                        // Format the end time if needed
                        String formattedEndTime =  outputFormat.format(inputFormat.parse(eventDate + " " +endTime.toString()));

                        // Display details
            %>
        <img src=src="getImage.do?id=<%= eventID %>" class="rounded mx-auto d-block event-image font-weight-bold" alt="Event Image">
        <figure class="text-center">
            <blockquote class="blockquote">
              <p class="h6"><%= eventName %></p>
            </blockquote>
            <figcaption class="blockquote-footer">
              BY <cite title="Beneficiary Name">@<%= beneficiary%></cite>
            </figcaption>
        </figure>
        <div class="divider"></div>
        <div class="container">
        <div class="clearfix">
            <div class="card col-md-3 float-md-end mb-4 ms-md-3" style="border-radius: 10px;">
                <div class="card-body text-start">
                    <h2 class="fw-bold">RM124,000</h2>
                    <div class="progress mb-3" style="height: 8px; border-radius: 5px;">
                        <div class="progress-bar" role="progressbar" style="width: 62%;" aria-valuenow="62" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <small class="text-muted  text-start">Goal<br>RM2,00,000</small>
                        <small class="text-muted  text-end">Remaining<br>RM1234</small>
                    </div>
                    
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-clock me-2"></i>
                        <small class="text-muted">12 days left</small>
                    </div>
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-heart-fill text-danger me-2"></i>
                        <small class="text-muted">12354 Contributors</small>
                    </div>
                    <hr>
                    <button class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
                        DONATE <i class="bi bi-heart"></i>
                    </button>
                </div>
            </div>
            <p><strong>About.</strong></p>
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
                <p class="text-muted"><%= formattedDateTime %></p>
            </div>
            </small>
            <small>End Date
                <br><div class="d-flex align-items-start justify-content-start">
                <i class="bi bi-calendar-event me-2"></i>
                <p class="text-muted"><%= formattedEndTime %></p>
            </div>
            </small>
            </div>
            <p><strong>Task required.</strong></p>
            <form action="volunteer_servlet.do" method="POST">
                <input type="hidden" name="eventID" value="<%= eventID %>">
                <% for (int i = 0; i < tasks.size(); i++) { %>
                    <div class="form-check form-check-inline mb-3">
                        <input type="radio" class="form-check-input" name="task" id="task<%= i %>" value="<%= tasks.get(i) %>" <%= i == 0 ? "checked" : "" %>>
                        <label class="form-check-label" for="task<%= i %>"><%= tasks.get(i) %></label>
                    </div>
                <% } %>
                <%
                    if (!isLoggedIn) {
                %>
                <p class="text-danger">Please log in to volunteer for this event.</p>
                <a href="login.jsp" class="btn w-100 py-2" style="background-color: #000; color: #fff; border-radius: 30px;">
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
        <%
            } else {
        %>
        <div class="container">
            <p>Event not found.</p>
        </div>
        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            } else {
        %>
        <div class="container">
            <p>Invalid Event ID.</p>
        </div>
        <%
            }
        %>
    </body>
</html>
