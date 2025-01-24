<%@page import="java.util.ArrayList"%>
<%@page import="com.cm.model.events"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard</title>
        <style>
            body {
                background-color: #f8f9fa;
            }

            .dashboard-card {
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s, box-shadow 0.3s;
                background-color: #fff;
            }

            .dashboard-card:hover {
                transform: translateY(-10px) scale(1.05);
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            }

            .recent-events ul {
                padding-left: 0;
                list-style: none;
            }

            .recent-events ul li {
                padding: 10px 0;
                border-bottom: 1px solid #ddd;
            }

            .recent-events ul li:last-child {
                border-bottom: none;
            }
        </style>
    </head>
    <body>
        <%@ include file="../header.jspf" %>
        <div class="container my-5">
            <h3 class="text-center mb-4 fw-bolder fs-1">Quick Overview</h3>
            <div class="row justify-content-center g-3 gy-4">
                <!-- Total Volunteers Card -->
                <div class="col-md-3">
                    <div class="dashboard-card shadow p-3 text-center d-flex flex-column align-items-center justify-content-center">
                        <i class="bi bi-person-fill fs-1 text-success mb-2"></i>
                        <h5 class="fw-bold mb-1">Total Volunteers</h5>
                        <p class="fs-4 mb-0"><%= request.getAttribute("totalVolunteers")%></p>
                    </div>
                </div>

                <!-- Total Events Card -->
                <div class="col-md-3">
                    <div class="dashboard-card shadow p-3 text-center d-flex flex-column align-items-center justify-content-center">
                        <i class="bi bi-calendar-event fs-1 text-danger mb-2"></i>
                        <h5 class="fw-bold mb-1">Total Events</h5>
                        <p class="fs-4 mb-0"><%= request.getAttribute("totalEvents")%></p>
                    </div>
                </div>
            </div>
                    
            <!-- Additional Information Section -->
            <div class="mt-5">
                <h4 class="section-title text-center fw-bold mb-4">Additional Insights</h4>
                <div class="row g-4">
                    <!-- Recent Events -->
                    <div class="col-md-6">
                        <div class="info-section recent-events p-4 bg-light border rounded shadow-sm h-100 d-flex flex-column">
                            <h5 class="text-primary mb-3">Recent Events</h5>
                            <ul class="list-unstyled flex-grow-1">
                                <%
                                    ArrayList<events> recentEvents = (ArrayList<events>) request.getAttribute("recentEvents");
                                    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
                                    java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm");
                                    for (events event : recentEvents) {
                                        String formattedDate = dateFormat.format(event.getDate());
                                        String formattedTime = timeFormat.format(event.getTime());
                                %>
                                <li class="d-flex justify-content-between align-items-center py-2 border-bottom">
                                    <div>
                                        <strong class="text-dark"><%= event.getName()%></strong>
                                        <p class="mb-0 text-muted">Date: <%= event.getDate()%></p>
                                        <p class="mb-0 text-muted">Time: <%= event.getTime()%></p>
                                    </div>
                                  
                                </li>
                                <%
                                    }
                                %>
                            </ul>
                        </div>
                    </div>

                    <!-- System Statistics -->
                    <div class="col-md-6">
                        <div class="info-section p-4 bg-light border rounded shadow-sm h-100 d-flex flex-column">
                            <h5 class="text-primary mb-3">System Statistics</h5>
                            <div class="stat-item py-2 border-bottom">
                                <p class="mb-1">Events Held This Month:</p>
                                <span class="fw-bold text-success fs-4"><%= request.getAttribute("completedEvents")%></span>
                            </div>
                            <div class="stat-item py-2 border-bottom">
                                <p class="mb-1">Total Donations:</p>
                                <span class="fw-bold text-info fs-4">$<%= request.getAttribute("totalDonations")%></span>
                            </div>
                            <div class="flex-grow-1"></div> <!-- Spacer to align content -->
                        </div>
                    </div>
                </div>
            </div>


        </div>
    </body>
</html>
