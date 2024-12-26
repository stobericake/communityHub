<%-- 
    Document   : reportEvent
    Created on : Dec 15, 2024, 7:40:46 PM
    Author     : HAZIQ
--%>
<%@ page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>

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
        <%@ include file="header.jspf" %>
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = dbconnection.getConnection(); // Get DB connection
            String currvolunteerID = request.getParameter("volunteerID");
            String sql = "SELECT name FROM volunteer WHERE volunteerID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(currvolunteerID));
            rs = stmt.executeQuery();
            String volu = "";
            if (rs.next()) {
                // Access the data in the first row
                volu = rs.getString("name");
            }
        %>
        <div class='container mt-3'>
            <div class='row p-1'>
                <div class='col-md-4'></div>
                <div class='col text-center fw-bold text-uppercase'>
                    <p class='fw-bold fs-6'><%=volu%><br> Volunteer ID: 12</p>
                </div>
                <div class='col-md-4'></div>
            </div>
        </div>
        <div class='container mt-2 border-top border-black border-2'>
            <div class='row mt-3'>
                <div class='col pt-2 ps-4 '>
                    <table class="table table-striped">
                        <thead class="table-dark">
                            <tr class='text-uppercase'>
                                <th class="text-center">NO</th>
                                <th class="col-4">Event List</th>
                                <th class="text-center">Date</th>
                                <th class="text-center">Time</th>
                                <th class="text-center">Role</th>
                                <th class="text-center">Hours</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                rs.close();
                                // Database Connection
                                
                                DecimalFormat df = new DecimalFormat("0.00");
                                int num = 0;
                                int hours = 0;
                                double totDonation = 0;
                                double recent = 0;
                                try {

                                    String sql1 = "SELECT v.name AS volunteerName, e.name AS eventName, e.date AS eventDate, e.time AS eventTime, e.duration AS eventDuration, "
                                            + "t.description AS taskDescription, d.amount AS donationAmount, d.date AS donationDate  "
                                            + "FROM events e "
                                            + "JOIN eventsvolunteer ev ON e.eventID = ev.eventID "
                                            + "JOIN volunteer v ON ev.volunteerID = v.volunteerID "
                                            + "LEFT JOIN task t ON t.volunteerID = v.volunteerID AND t.eventID = e.eventID "
                                            + "LEFT JOIN donation d ON d.volunteerID = v.volunteerID AND d.eventID = e.eventID "
                                            + "WHERE v.volunteerID = ?;";
                                    stmt = conn.prepareStatement(sql1);
                                    stmt.setInt(1, Integer.parseInt(currvolunteerID));
                                    rs = stmt.executeQuery();

                                    // Iterate through each event
                                    while (rs.next()) {
                                        num++;
                                        String vname = rs.getString("volunteerName");
                                        String ename = rs.getString("eventName");
                                        String taskDesc = rs.getString("taskDescription");
                                        Date eventDate = rs.getDate("eventDate");
                                        Time eventTime = rs.getTime("eventTime");
                                        Time dura = rs.getTime("eventDuration");
                                        double donation = rs.getDouble("donationAmount");
                                        if (donation > 0) {
                                            recent = donation;
                                        }

                                        String formattedDate = new SimpleDateFormat("dd/MM/yyyy").format(eventDate);
                                        String formattedTime = new SimpleDateFormat("HH:mm").format(eventTime);
                                        String formattedDura = new SimpleDateFormat("H").format(dura);

                                        if (taskDesc == null) {
                                            taskDesc = "Crew";
                                        }
                                        int durationHour = dura.toLocalTime().getHour(); // Using java.time (modern)
                                        hours += durationHour;
                                        totDonation += donation;
                            %>

                            <tr>
                                <td class="text-center fw-bold"><%=num%></td>
                                <td><%=ename%></td>
                                <td class="text-center"><%=formattedDate%></td>
                                <td class="text-center"><%=formattedTime%></td>
                                <td class="text-center text-nowrap"><%=taskDesc%></td>
                                <td class="text-center"><%=formattedDura%></td>
                            </tr>

                            <%

                                    } // End while
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    try {
                                        if (rs != null) {
                                            rs.close();
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                    try {
                                        if (stmt != null) {
                                            stmt.close();
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                    try {
                                        if (conn != null) {
                                            conn.close();
                                        }
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class='row'>
                <div class="col pt-3 ps-4">
                    <h5 class="fw-bold">Participant Details</h4>
                        <ul class='lh-1 text-body-secondary'>
                            <li>Total Events Participated: <%=num%></li>
                            <li>Total Hours Committed: <%=hours%> </li>
                        </ul>
                </div>
            </div>
            <div class='row'>
                <div class="col pt-3 ps-4">
                    <h5 class="fw-bold">Donations:</h5>
                    <ul class='lh-1 text-body-secondary'>
                        <li>Total Donation: RM <%=df.format(totDonation)%></li>
                        <li>Recent Donation: RM <%=df.format(recent)%></li>
                    </ul>
                </div>
                <div class="col-md-6"></div>
                <div class="col pt-3 ps-4">
                    <h5 class="fw-bold">Generated By:</h5>
                    <p class="fw-medium ms-1 lh-1">
                        Admin - CommunityHub<br>
                        Date of Report: <%= new SimpleDateFormat("MMMM dd, yyyy").format(new Date())%>
                    </p>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <button class="btn btn-primary  print-button" onclick="window.print();">
                <i class="bi bi-printer"></i> Print Report
            </button>
        </div>
    </body>
</html>
