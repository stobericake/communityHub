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
        <%@ include file="../header.jspf" %>

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
                        <input type="text" id="searchInput" class="form-control" placeholder="Search">
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
                            <tbody>
                                <% 
                                    // Database Connection
                                    Connection conn = null;
                                    PreparedStatement stmt = null;
                                    ResultSet rs = null;

                                    try {
                                        conn = dbconnection.getConnection(); // Get DB connection

                                        // Count total events for pagination
                                        String countSql = "SELECT COUNT(*) as total FROM events e JOIN address a ON e.addressID = a.addressID WHERE e.status = 1";
                                        stmt = conn.prepareStatement(countSql);
                                        rs = stmt.executeQuery();
                                        rs.next();
                                        int totalEvents = rs.getInt("total");

                                        // Pagination parameters
                                        int eventsPerPage = 5; // Number of events per page
                                        int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                                        int offset = (currentPage - 1) * eventsPerPage;
                                        int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);

                                        // Fetch events with pagination
                                        String sql = "SELECT e.*, a.* FROM events e "
                                                + "JOIN address a ON e.addressID = a.addressID "
                                                + "WHERE e.status = 1 LIMIT ? OFFSET ?";
                                        stmt = conn.prepareStatement(sql);
                                        stmt.setInt(1, eventsPerPage);
                                        stmt.setInt(2, offset);
                                        rs = stmt.executeQuery();
                                        int num = offset + 1; // Start numbering from the current offset
                                    %>

                                <!-- Table Body -->
                                <% while (rs.next()) {
                                    int eventID = rs.getInt("eventID");
                                    String name = rs.getString("name");
                                    String desc = rs.getString("description");
                                    String city = rs.getString("city");
                                    Date eventDate = rs.getDate("date");
                                    Time eventTime = rs.getTime("time");

                                    String formattedDate = new SimpleDateFormat("dd/MM E").format(eventDate);
                                    String formattedTime = new SimpleDateFormat("HH:mm").format(eventTime);
                                %>
                                <tr>
                                    <td class="text-center"><%= num++%></td>
                                    <td>
                                        <div class="card my-2 mx-2 event-card" data-title="<%= name%>" data-description="<%= desc%>" data-location="<%= city%>">
                                            <div class="row g-0">
                                                <div class="col-md-4">
                                                    <img src="../getImage.do?type=events&id=<%= eventID%>" class="img-fluid rounded-start" alt="Event Image">
                                                </div>
                                                <div class="col-md-8">
                                                    <div class="card-body">
                                                        <h5 class="card-title fw-bold"><%= name%></h5>
                                                        <p class="card-text"><%= desc%></p>
                                                        <p class="card-text"><i class="bi bi-geo-alt-fill"></i><small class="text-body-secondary"><%= city%></small></p>
                                                        <p class="card-text"><i class="bi bi-clock-fill"></i><small class="text-body-secondary"><%= formattedDate%> <%= formattedTime%></small></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="container mt-4">
                                            <div class="d-grid gap-3 col mx-auto">
                                                <a href="#" onclick="updateStatus(<%= eventID%>, 2)" class="btn btn-primary"><i class="bi bi-calendar-check me-2"></i> Approve</a>
                                                <a href="#" onclick="updateStatus(<%= eventID%>, 3)" class="btn btn-danger"><i class="bi bi-x-circle me-2"></i> Reject</a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <% }%>
                                </tbody>
                            </table>

                            <!-- Pagination Below the Table -->
                            <div class="pagination-container text-center mt-4">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <!-- Previous -->
                                        <li class="page-item <%= currentPage == 1 ? "disabled" : ""%>">
                                            <a class="page-link" href="?page=<%= currentPage - 1%>">&laquo;</a>
                                        </li>
                                        <% for (int i = 1; i <= totalPages; i++) {%>
                                        <li class="page-item <%= currentPage == i ? "active" : ""%>">
                                            <a class="page-link" href="?page=<%= i%>"><%= i%></a>
                                        </li>
                                        <% }%>
                                        <!-- Next -->
                                        <li class="page-item <%= currentPage == totalPages ? "disabled" : ""%>">
                                            <a class="page-link" href="?page=<%= currentPage + 1%>">&raquo;</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>

                            <%
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) {
                                        try {
                                            rs.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                    if (stmt != null) {
                                        try {
                                            stmt.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                    if (conn != null) {
                                        try {
                                            conn.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!--Hidden-->
        <form id="updateStatusForm" method="post" action="../updatestatus.do" style="display:none;">
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

    function filterEvents() {
        var input = document.getElementById('searchInput').value.toLowerCase();
        var eventCards = document.querySelectorAll('.event-card');

        eventCards.forEach(function (card) {
            var title = card.getAttribute('data-title').toLowerCase();
            var description = card.getAttribute('data-description').toLowerCase();
            var location = card.getAttribute('data-location').toLowerCase();

            if (title.includes(input) || description.includes(input) || location.includes(input)) {
                card.closest('tr').style.display = ''; // Show the card's row
            } else {
                card.closest('tr').style.display = 'none'; // Hide the card's row
            }
        });
    }

    // Add event listener to search input
    document.getElementById('searchInput').addEventListener('input', filterEvents);
</script>
