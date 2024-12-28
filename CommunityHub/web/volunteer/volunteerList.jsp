<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cm.controller.dbconnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Volunteer List Overview</title>
    <style>
        .table-dark th {
            background-color: #2F6690 !important;
        }

        .page-header {
            font-weight: bold;
            font-size: 1.5rem;
        }

        .page-subheader {
            font-size: 1.0rem;
            color: #6c757d;
        }

        /* Pagination styles */
        .pagination {
            justify-content: center;
        }

        .pagination .page-link {
            color: #2F6690;
            border-radius: 50%; /* Makes the button circular */
            width: 40px;        /* Fixed width for circular shape */
            height: 40px;       /* Fixed height for circular shape */
            display: flex;      /* Center the content inside */
            justify-content: center;
            align-items: center;
            border: 1px solid #2F6690; /* Add border for clarity */
            margin: 0 5px;     /* Add spacing between buttons */
        }

        .pagination .page-item.active .page-link {
            background-color: #2F6690;
            border-color: #2F6690;
            color: #C3DFE6;
        }

        .pagination-container {
            display: flex;
            justify-content: center; /* Center the pagination at the bottom */
            margin-top: 20px;
        }

        /* Search bar styling */
        .section-spacing {
            margin-top: 20px;
        }
        
        .table-spacing {
        margin-top: 30px; /* Adjust this value as needed */
        }

        .header-spacing {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <%@ include file="header2.jspf" %>
    <div class="container my-5">
        <!-- Volunteer List Overview Header -->
        <div class="header-spacing">
            <h1 class="page-header">VOLUNTEERS LIST OVERVIEW</h1>
            <p class="page-subheader">All Participants Data</p>
        </div>

        <!-- Search Bar -->
        <div class="section-spacing">
            <form method="get" action="">
                <div class="row align-items-center">
                    <div class="col-md-5">
                        <input 
                            type="text" 
                            class="form-control" 
                            id="searchName" 
                            name="searchName" 
                            placeholder="Search by name..." 
                            value="<%= request.getParameter("searchName") != null ? request.getParameter("searchName") : "" %>">
                    </div>
                    <div class="col-md-4">
                        <select id="eventFilter" name="eventFilter" class="form-select">
                            <option value="">Select Event</option>
                            <option value="Beach Cleanup" <%= "Beach Cleanup".equals(request.getParameter("eventFilter")) ? "selected" : "" %>>Beach Cleanup</option>
                            <option value="Charity Gala" <%= "Charity Gala".equals(request.getParameter("eventFilter")) ? "selected" : "" %>>Charity Gala</option>
                            <option value="Cloth Donation" <%= "Cloth Donation".equals(request.getParameter("eventFilter")) ? "selected" : "" %>>Cloth Donation</option>
                            <option value="Holiday Toy Drive" <%= "Holiday Toy Drive".equals(request.getParameter("eventFilter")) ? "selected" : "" %>>Holiday Toy Drive</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-primary w-100" type="submit">Search</button>
                    </div>
                </div>
            </form>
        </div>


        <% 
            // Capture search parameters
            String searchName = request.getParameter("searchName");
            String eventFilter = request.getParameter("eventFilter");

            // Database Connection for pagination and search
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = dbconnection.getConnection(); // Get DB connection

                // Count the total volunteers with applied filters
                String countSql = "SELECT COUNT(*) as total FROM Volunteer v " +
                                  "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                                  "INNER JOIN events e ON ev.eventID = e.eventID " +
                                  "WHERE 1=1";

                // Add conditions to the query if search parameters are provided
                if (searchName != null && !searchName.isEmpty()) {
                    countSql += " AND v.name LIKE ?";
                }
                if (eventFilter != null && !eventFilter.isEmpty()) {
                    countSql += " AND e.name = ?";
                }

                stmt = conn.prepareStatement(countSql);

                // Set values for the query
                int paramIndex = 1;
                if (searchName != null && !searchName.isEmpty()) {
                    stmt.setString(paramIndex++, "%" + searchName + "%");
                }
                if (eventFilter != null && !eventFilter.isEmpty()) {
                    stmt.setString(paramIndex++, eventFilter);
                }

                rs = stmt.executeQuery();
                rs.next();
                int totalVolunteers = rs.getInt("total");

                // Pagination parameters
                int volunteersPerPage = 10;
                int currentPage = request.getParameter("page") != null ? 
                                  Integer.parseInt(request.getParameter("page")) : 1;
                int offset = (currentPage - 1) * volunteersPerPage;
                int totalPages = (int) Math.ceil((double) totalVolunteers / volunteersPerPage);

                // Fetch volunteers for the current page with applied filters
                String sql = "SELECT v.volunteerID, v.name, v.contactInfo, v.username, e.name AS eventName, e.date AS dateJoined " +
                             "FROM Volunteer v " +
                             "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                             "INNER JOIN events e ON ev.eventID = e.eventID " +
                             "WHERE 1=1";

                // Add conditions to the query if search parameters are provided
                if (searchName != null && !searchName.isEmpty()) {
                    sql += " AND v.name LIKE ?";
                }
                if (eventFilter != null && !eventFilter.isEmpty()) {
                    sql += " AND e.name = ?";
                }

                // Apply pagination
                sql += " LIMIT ? OFFSET ?";

                stmt = conn.prepareStatement(sql);

                // Set values for the query
                paramIndex = 1;
                if (searchName != null && !searchName.isEmpty()) {
                    stmt.setString(paramIndex++, "%" + searchName + "%");
                }
                if (eventFilter != null && !eventFilter.isEmpty()) {
                    stmt.setString(paramIndex++, eventFilter);
                }
                stmt.setInt(paramIndex++, volunteersPerPage);
                stmt.setInt(paramIndex++, offset);

                rs = stmt.executeQuery();
        %>

        <!-- Volunteer List Table -->
        <div class="table-spacing table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Contact Info</th>
                        <th>Username</th>
                        <th>Event Joined</th>
                        <th>Date Joined</th>
                    </tr>
                </thead>
                <tbody>
                <%        
                        // Iterate through each volunteer
                        while (rs.next()) {
                            int volunteerID = rs.getInt("v.volunteerID");
                            String name = rs.getString("v.name");
                            String contactInfo = rs.getString("v.contactInfo");
                            String username = rs.getString("v.username");
                            String eventName = rs.getString("eventName");
                            Date date = rs.getDate("dateJoined");
                    %>
                        <tr>
                            <td><%= volunteerID %></td>
                            <td><%= name %></td>
                            <td><%= contactInfo %></td>
                            <td><%= username %></td>
                            <td><%= eventName %></td>
                            <td><%= date %></td>
                        </tr>
                    <% 
                        } // End while
                    %>
                </tbody>
            </table>
        </div>


        <!-- Pagination -->
        <div class="pagination-container">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <!-- Previous Button -->
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>&searchName=<%= searchName != null ? searchName : "" %>&eventFilter=<%= eventFilter != null ? eventFilter : "" %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <!-- Page Numbers -->
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>&searchName=<%= searchName != null ? searchName : "" %>&eventFilter=<%= eventFilter != null ? eventFilter : "" %>"><%= i %></a>
                        </li>
                    <% } %>

                    <!-- Next Button -->
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>&searchName=<%= searchName != null ? searchName : "" %>&eventFilter=<%= eventFilter != null ? eventFilter : "" %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>

        <% 
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</body>
</html>
