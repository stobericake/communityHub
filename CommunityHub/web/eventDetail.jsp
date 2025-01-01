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
            String eventID = request.getParameter("eventID");
            String loggedInUser = (String) session.getAttribute("volunteer");

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
                        int id = rs.getInt("eventID");
                        String eventName = rs.getString("eventName");
                        Date eventDate = rs.getDate("eventDate");
                        Time eventTime = rs.getTime("eventTime");
                        Time eventDuration = rs.getTime("duration");
                        String description = rs.getString("description");
                        String location = rs.getString("location");
                        String beneficiary = rs.getString("beneficiary");
                        double donationLimit = rs.getDouble("donationLimit");
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

                        // Calculate days left from the current date to the event date
                        LocalDate currentDate = LocalDate.now();
                        long daysLeft = ChronoUnit.DAYS.between(currentDate, eventLocalDate);

                        // Fetch tasks
                        List<String> tasks = new ArrayList<String>();
                        String taskSql = "SELECT description FROM task WHERE eventID = ?";
                        taskStmt = conn.prepareStatement(taskSql);
                        taskStmt.setInt(1, Integer.parseInt(eventID));
                        taskRs = taskStmt.executeQuery();
                        while (taskRs.next()) {
                            tasks.add(taskRs.getString("description"));
                        }

                        // Fetch donation details
                        double totalDonation = 0;
                        String donationSql = "SELECT SUM(amount) AS totalDonation FROM donation WHERE eventID = ?";
                        donationStmt = conn.prepareStatement(donationSql);
                        donationStmt.setInt(1, Integer.parseInt(eventID));
                        donationRs = donationStmt.executeQuery();
                        if (donationRs.next()) {
                            totalDonation = donationRs.getDouble("totalDonation");
                        }
                        
                            // Fetch the total number of contributors (donors)
                        String contributorsQuery = "SELECT COUNT(DISTINCT donorID) AS totalContributors FROM donation WHERE eventID = ?";
                        PreparedStatement contributorsStmt = conn.prepareStatement(contributorsQuery);
                        contributorsStmt.setInt(1, Integer.parseInt(eventID));
                        ResultSet contributorsRs = contributorsStmt.executeQuery();
                        int totalContributors = 0;
                        if (contributorsRs.next()) {
                            totalContributors = contributorsRs.getInt("totalContributors");
                        }
                        double remainingAmount = donationLimit - totalDonation;
                        double progress = (totalDonation / donationLimit) * 100;

        %>
            <img src="getImage.do?type=events&id=<%= id%>" class="rounded mx-auto d-block event-image font-weight-bold" alt="Event Image">
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
            <div class="clearfix">
                <div class="card col-md-3 float-md-end mb-4 ms-md-3" style="border-radius: 10px;">
                    <div class="card-body text-start">
                        <h2 class="fw-bold">RM<%= totalDonation %></h2>
                        <div class="progress mb-3" style="height: 8px; border-radius: 5px;">
                            <div class="progress-bar" role="progressbar" style="width: <%= progress %>%;" aria-valuenow="<%= progress %>" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <small class="text-muted text-start">Goal<br>RM<%= donationLimit %></small>
                            <small class="text-muted text-end">Remaining<br>RM<%= remainingAmount %></small>
                        </div>
                        <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-clock me-2"></i>
                        <small class="text-muted"><%= daysLeft %> days </small>
                    </div>
                    <div class="d-flex align-items-start justify-content-start">
                        <i class="bi bi-heart-fill text-danger me-2"></i>
                        <small class="text-muted"><%= totalContributors %> Contributors</small>
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
                <p><strong>Tasks Required:</strong></p>
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
