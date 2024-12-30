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
        
        .search-bar input {
            border-radius: 20px;
            padding: 10px;
            width: 100%;
            max-width: 300px;
        }
        
        .pagination {
            justify-content: center;
        }

        .pagination .page-link {
            color: #2F6690;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            justify-content: center;
            align-items: center;
            border: 1px solid #2F6690;
            margin: 0 5px;
        }

        .pagination .page-item.active .page-link {
            background-color: #2F6690;
            border-color: #2F6690;
            color: #C3DFE6;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .table-spacing {
            margin-top: 30px;
        }

        .header-spacing {
            margin-bottom: 15px;
        }
    </style>
    <script>
        function filterTable() {
            const input = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#volunteerTable tbody tr');

            rows.forEach(row => {
                const columns = row.querySelectorAll('td');
                const match = Array.from(columns).some(td =>
                    td.textContent.toLowerCase().includes(input)
                );

                row.style.display = match ? '' : 'none';
            });
        }
    </script>
</head>
<body>
    <%@ include file="header.jspf" %>
    <div class="container my-4">
        <!-- Volunteer List Overview Header -->
        <div class="row align-items-center mb-4">
            <div class="col-md-4">
                <h1 class="page-header">VOLUNTEERS LIST OVERVIEW</h1>
                <p class="page-subheader">All Participants Data</p>
            </div>

            <!-- Search Bar -->
            <div class="col-md-4 offset-md-4">
                <input type="text" id="searchInput" class="form-control rounded" 
                       placeholder="Search by any field..." onkeyup="filterTable()">
            </div>
        </div>

        <% 
            String searchName = request.getParameter("searchName");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = dbconnection.getConnection();

                // Count the total volunteers
                String countSql = "SELECT COUNT(*) as total FROM Volunteer v " +
                                  "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                                  "INNER JOIN events e ON ev.eventID = e.eventID " +
                                  "WHERE 1=1";

                if (searchName != null && !searchName.isEmpty()) {
                    countSql += " AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " + 
                                "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)";
                }

                stmt = conn.prepareStatement(countSql);

                if (searchName != null && !searchName.isEmpty()) {
                    String likePattern = "%" + searchName + "%";
                    for (int i = 1; i <= 6; i++) {
                        stmt.setString(i, likePattern);
                    }
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

                // Fetch volunteers
                String sql = "SELECT v.volunteerID, v.name, v.contactInfo, v.username, e.name AS eventName, e.date AS dateJoined " +
                             "FROM Volunteer v " +
                             "INNER JOIN eventsVolunteer ev ON v.volunteerID = ev.volunteerID " +
                             "INNER JOIN events e ON ev.eventID = e.eventID " +
                             "WHERE 1=1";

                if (searchName != null && !searchName.isEmpty()) {
                    sql += " AND (v.volunteerID LIKE ? OR v.name LIKE ? OR v.contactInfo LIKE ? " + 
                            "OR v.username LIKE ? OR e.name LIKE ? OR e.date LIKE ?)";
                }

                sql += " LIMIT ? OFFSET ?";
                stmt = conn.prepareStatement(sql);

                int paramIndex = 1;
                if (searchName != null && !searchName.isEmpty()) {
                    String likePattern = "%" + searchName + "%";
                    for (int i = 0; i < 6; i++) {
                        stmt.setString(paramIndex++, likePattern);
                    }
                }

                stmt.setInt(paramIndex++, volunteersPerPage);
                stmt.setInt(paramIndex++, offset);

                rs = stmt.executeQuery();
        %>

        <div class="table-spacing table-responsive">
            <table id="volunteerTable" class="table table-bordered table-striped">
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
                <% while (rs.next()) { %>
                    <tr>
                        <td><%= rs.getInt("volunteerID") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("contactInfo") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("eventName") %></td>
                        <td><%= rs.getDate("dateJoined") %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div class="pagination-container">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <!-- Previous -->
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>&searchName=<%= searchName != null ? searchName : "" %>">&laquo;</a>
                    </li>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>&searchName=<%= searchName != null ? searchName : "" %>"><%= i %></a>
                        </li>
                    <% } %>

                    <!-- Next -->
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>&searchName=<%= searchName != null ? searchName : "" %>">&raquo;</a>
                    </li>
                </ul>
            </nav>
        </div>

        <% 
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>
</body>
</html>
