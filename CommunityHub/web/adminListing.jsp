<%-- 
    Document   : index
    Created on : Dec 12, 2024, 4:07:00 PM
    Author     : anaqi
--%>

<%@page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>

        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">


        <style>
            html, body {
                margin: 0; /* Removes default margin */
                padding: 0; /* Removes default padding */
            }
        </style>
    </head>
    <body>
        <%@ include file="header.jspf" %>

        <!-- Event List -->
        <div class="container mt-4">
            <div class="row">
                <div class="col col-md-4">
                    <h2>Event Approval</h2>
                    <caption>Events Approval List</caption>
                </div>
                <div class="col-md-4"></div>
                <div class="search-container col-md-4 my-auto">
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="search">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col ms-3 mt-3 p-3 border border-grey rounded-4 mb-4 shadow">
                    <h2>Event Categories</h2>
                    <!--table-->
                    <div class="col ms-3 mt-3 p-3">
                        <table class="table table-sm table-bordered rounded-3">
                            <thead class="rounded">
                                <tr>
                                    <th class="col-1 text-center">SN</th>
                                    <th class="col">Event</th>
                                    <th class="col-2 text-center">Action</th>
                                </tr>
                            </thead>

                            <%
                                // Database Connection
                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;

                                try {
                                    conn = dbconnection.getConnection(); // Get DB connection
                                    String sql = "SELECT e.*, a.* FROM events e "
                                            + "JOIN address a ON e.addressID = a.addressID "
                                            + "WHERE e.status = 1;";
                                    stmt = conn.prepareStatement(sql);
                                    rs = stmt.executeQuery();
                                    int num = 1;
                                    // Iterate through each event
                                    while (rs.next()) {

                                        String name = rs.getString("name");
                                        String desc = rs.getString("description");
                                        String city = rs.getString("city");
                                        Date eventDate = rs.getDate("date");
                                        Time eventTime = rs.getTime("time");

                                        String formattedDate = new SimpleDateFormat("dd/MM E").format(eventDate);
                                        String formattedTime = new SimpleDateFormat("HH:mm").format(eventTime);

                            %>
                            <tbody>
                                <tr>    
                                    <td class="text-center"><%=num%></td>
                                    <td>
                                        <div class="card my-2 mx-2">
                                            <div class="row g-0">
                                                <div class="col-md-4">
                                                    <img src="..." class="img-fluid rounded-start" alt="...">
                                                </div>
                                                <div class="col-md-8">
                                                    <div class="card-body">
                                                        <h5 class="card-title fw-bold"><%=name%></h5>
                                                        <p class="card-text"><%=desc%></p>
                                                        <p class="card-text"><i class="bi bi-geo-alt-fill"></i><small class="text-body-secondary"> <%=city%></small></p>
                                                        <p class="card-text"><i class="bi bi-clock-fill"></i><small class="text-body-secondary"> <%=formattedDate%> <%=formattedTime%></small></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="container mt-4">
                                            <div class="d-grid gap-3 col mx-auto">
                                                <a href="#" onclick="updateStatus(<%=rs.getInt("eventID")%>, 2)" class="btn btn-primary"><i class="bi bi-calendar-check me-2"></i> Approve</a>
                                                <a href="#" onclick="updateStatus(<%=rs.getInt("eventID")%>, 3)" class="btn btn-danger"><i class="bi bi-x-circle me-2"></i> Reject</a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>

                            <%  num++;
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

                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!--Hidden Fields-->
        <form id="updateStatusForm" method="post" action="updatestatus.do" style="display:none;">
            <input type="hidden" id="eventIdInput" name="eventId">
            <input type="hidden" id="statusInput" name="status">
        </form>
    </body>
</html>

<script>
    function updateStatus(eventId, status) {
        document.getElementById('eventIdInput').value = eventId;
        document.getElementById('statusInput').value = status;
        document.getElementById('updateStatusForm').submit();
    }
</script>
