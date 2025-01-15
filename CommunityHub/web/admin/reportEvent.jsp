<%-- 
    Document   : reportEvent
    Created on : Dec 15, 2024, 7:40:46 PM
    Author     : HAZIQ
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.*" %>
<%@page import="java.text.SimpleDateFormat"%>
<%
    String user = (String) session.getAttribute("userRole");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
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

            @media print {
                @page {
                    margin: 0; /* Removes browser default margins */
                }

                body {
                    margin: 0;
                    padding: 0;
                }

                /* Hide unnecessary elements */
                header, footer {
                    display: none; /* Hide header/footer elements if any */
                }

                /* Hide browser headers and footers */
                body {
                    overflow: hidden;
                }

                /* Optional: Ensure the printed content takes the full width */
                .container {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="../header.jspf" %>
        <%
            String eName = (String) request.getAttribute("eventName");
            Date eDate = (Date) request.getAttribute("eventDate");
            Time eTime = (Time) request.getAttribute("eventTime");
            Time eDuration = (Time) request.getAttribute("eventDuration");
            String city = (String) request.getAttribute("city");
            String state = (String) request.getAttribute("state");
            int vCount = (Integer) request.getAttribute("volunteerCount");

            String formattedDate = new SimpleDateFormat("E FF, YYYY").format(eDate);
            String formattedTime = new SimpleDateFormat("HH:mm").format(eTime);
            String formattedDura = new SimpleDateFormat("HH:mm").format(eDuration);

            /// Convert java.sql.Time to LocalTime for the start time
            LocalTime startTime = eTime.toLocalTime(); // Assuming eventTime is of type java.sql.Time

            // Extract hours and minutes from the duration (dura) - which is also a java.sql.Time
            LocalTime durationTime = eDuration.toLocalTime(); // Assuming dura is of type java.sql.Time

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
                <div class='col text-center fw-bold text-uppercase'><p class='fw-bold fs-3'><%=eName%></p></div>
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
                                <li>Total Participant: <%=vCount%></li>

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

                <!--Left Side-->
                <div class="col-6 pt-3 border-start border-black border-1">
                    <div class="container">
                        <div class="col ms-4 mb-3 ">
                            <h4 class="fw-bold">Environement & Community Impact</h4>
                            <ul class="text-body-secondary">
                                <% for (String feedback : (ArrayList<String>) request.getAttribute("feedbackList")) {%>
                                <li><%= feedback%></li>
                                    <% } %>
                            </ul>
                        </div>

                        <div class="col ms-4 mb-3 mt-4">
                            <h4 class="fw-bold">Challanges and Solutions</h4>
                            <ul class="text-body-secondary">
                                <li>Challenge:
                                    <% for (String challenge : (ArrayList<String>) request.getAttribute("challengeList")) {
                                            %>
                                            
                                            <%= challenge + ',' %> 
                                       <% } %>
                                </li>
                                <li>Solutions:
                                    <% for (String solution : (ArrayList<String>) request.getAttribute("solutionList")) { %>
                                            <%= solution + ',' %> 
                                      <%  } %>
                                </li>
                            </ul>
                        </div>

                        <div class="col ms-4 mb-3 mt-4">
                            <h4 class="fw-bold">Recommendations for Future Events</h4>
                            <ol class="text-body-secondary">
                                <% for (String recommendation : (ArrayList<String>) request.getAttribute("recommendationList")) {%>
                                <li><%= recommendation%></li>
                                    <% } %>
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


