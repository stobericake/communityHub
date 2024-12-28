<%-- 
    Document   : reportEvent
    Created on : Dec 15, 2024, 7:40:46 PM
    Author     : HAZIQ
--%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.*" %>
<%@page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Event's Report</title>


        <style>
            html, body {
                margin: 0; /* Removes default margin */
                padding: 0; /* Removes default padding */
            }

            .event {
                font-family: 'Kanit', sans-serif;
            }

        </style>
    </head>
    <body>
        <%@ include file="../header.jspf" %>
        <%
            String eventID = request.getParameter("eventID");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = dbconnection.getConnection(); // Get DB connection

            String sql = "SELECT e.*, a.*, "
                    + "(SELECT COUNT(*) "
                    + "FROM eventsvolunteer ev "
                    + "WHERE ev.eventID = e.eventID) AS volunteerCount "
                    + "FROM events e "
                    + "JOIN address a ON e.addressID = a.addressID "
                    + "WHERE e.eventID = ?;";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(eventID)); // Set the eventID
            rs = stmt.executeQuery();

            if (rs.next()) {
                // Access the data in the first row
//                event = rs.getString("name");
                String ename = rs.getString("e.name");
                Date eventDate = rs.getDate("e.date");
                Time eventTime = rs.getTime("e.time");
                Time dura = rs.getTime("e.duration");
                String city = rs.getString("a.city");
                String state = rs.getString("a.state");
                int count = rs.getInt("volunteerCount");
                String formattedDate = new SimpleDateFormat("E FF, YYYY").format(eventDate);
                String formattedTime = new SimpleDateFormat("HH:mm").format(eventTime);
                String formattedDura = new SimpleDateFormat("HH:mm").format(dura);

                /// Convert java.sql.Time to LocalTime for the start time
                LocalTime startTime = eventTime.toLocalTime(); // Assuming eventTime is of type java.sql.Time

                // Extract hours and minutes from the duration (dura) - which is also a java.sql.Time
                LocalTime durationTime = dura.toLocalTime(); // Assuming dura is of type java.sql.Time

                // Convert durationTime to Duration object by manually extracting hours and minutes
                Duration duration = Duration.ofHours(durationTime.getHour())
                        .plusMinutes(durationTime.getMinute());

                // Add the duration to the start time
                LocalTime endTime = startTime.plus(duration);

                // Format the end time as "HH:mm"
                String formattedEndTime = endTime.format(DateTimeFormatter.ofPattern("HH:mm"));

        %>

        <div class='container mt-3'>
            <div class='row p-2'>
                <div class='col-md-4'></div>
                <div class='col text-center fw-bold text-uppercase'><p class='fw-bold fs-3'><%=ename%></p></div>
                <div class='col-md-4'></div>
            </div>
        </div>
        <div class='container mt-2 border-top border-black border-2'>
            <div class="row">
                <div class="col col-md-6 pt-3 border-end border-black border-1">
                    <div class="container">
                        <div class="col ms-4 mb-3 py-2">
                            <h4 class="fw-bold">Participant Details</h4>
                            <ul class="text-body-secondary">
                                <li>Total Participant: <%=count%></li>

                            </ul>
                        </div>

                        <div class="col ms-4 mb-3 py-2">
                            <h4 class="fw-bold">Locations</h4>
                            <p class="text-body-secondary"><i class="bi bi-geo-alt"></i>&ensp; <%=city%>, <%=state%></p>
                        </div>

                        <div class="col ms-4 mb-3 py-2">
                            <h4 class="fw-bold">Event Date</h4>
                            <div class='row'>
                                <div class='col-12 col-md-6'>
                                    <p class='lh-base text-body-secondary'>
                                        Start Date<br>
                                        <i class="bi bi-calendar3"></i>&ensp; <%=formattedDate%> (<%=formattedTime%>)
                                    </p>
                                </div>
                                <div class='col-12 col-md-6 text-body-secondary'>
                                    End Date<br>
                                    <i class="bi bi-calendar3"></i>&ensp; <%=formattedDate%> (<%=formattedEndTime%>)
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% rs.close();
                    }
                    String sql1 = "SELECT * "
                            + "FROM servicereport  "
                            + "WHERE eventID = 1; ";
                    stmt = conn.prepareStatement(sql1);
                    rs = stmt.executeQuery();

                %>
                <!--Left Side-->
                <div class="col-6 pt-3 border-start border-black border-1">
                    <div class="container">
                        <div class="col ms-4 mb-3 ">
                            <h4 class="fw-bold">Environement & Community Impact</h4>
                            <ul class="text-body-secondary">
                                <%                                    while (rs.next()) {
                                        String recommend = rs.getString("recommendation");
                                        String problem = rs.getString("challange");
                                        String solution = rs.getString("solution");
                                        String feedback = rs.getString("feedback");
                                %>
                                <li><%=feedback%></li>
                                    <%
                                        }
                                    %>
                            </ul>
                        </div>

                        <div class="col ms-4 mb-3 mt-4">
                            <h4 class="fw-bold">Challanges and Solutions</h4>
                            <ul class="text-body-secondary">
                                <li>Challenge:
                                    <%
                                        rs.beforeFirst(); // Move the result set pointer back to the beginning to reuse it
                                        while (rs.next()) {
                                            String problem = rs.getString("challange");
                                    %>
                                    <%=problem + ", "%>
                                    <%
                                        }
                                    %>
                                </li>
                                <li>Solutions:
                                    <%
                                        rs.beforeFirst(); // Move the result set pointer back to the beginning to reuse it
                                        while (rs.next()) {
                                            String solution = rs.getString("solution");
                                    %>
                                    <%=solution + ", "%>
                                    <%
                                        }
                                    %>
                                </li>
                            </ul>
                        </div>

                        <div class="col ms-4 mb-3 mt-4">
                            <h4 class="fw-bold">Recommendations for Future Events</h4>
                            <ol class="text-body-secondary">
                                <%
                                    rs.beforeFirst(); // Move the result set pointer back to the beginning to reuse it
                                    while (rs.next()) {
                                        String recomm = rs.getString("recommendation");
                                %>
                                <li><%=recomm%></li>
                                    <%
                                        }
                                    %>
                            </ol>
                        </div>
                        <!--                        End Of Left Side-->
                    </div>
                </div>
                <%
                %>
            </div>
        </div>
        <div class="text-center mt-4">
            <button class="btn btn-primary print-button" onclick="window.print();">
                <i class="bi bi-printer"></i> Print Report
            </button>
        </div>
    </body>
</html>


