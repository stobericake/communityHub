<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.hub.controller.dbconnection" %>

<!DOCTYPE html>
<html>
<head>
    <title>Donor List Overview</title>
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
            justify-content: center;
            margin-top: 20px;
        }

        .section-spacing {
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
            const rows = document.querySelectorAll('#donorTable tbody tr');

            rows.forEach(row => {
                const id = row.querySelector('td:nth-child(1)').textContent.toLowerCase();
                const name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
                const contact = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
                const amount = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                const event = row.querySelector('td:nth-child(5)').textContent.toLowerCase();
                const date = row.querySelector('td:nth-child(6)').textContent.toLowerCase();

                if (
                    id.includes(input) ||
                    name.includes(input) ||
                    contact.includes(input) ||
                    amount.includes(input) ||
                    event.includes(input) ||
                    date.includes(input)
                ) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
    </script>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <div class="container my-4">
        <!-- Donor List Overview Header -->
        <div class="row align-items-center mb-4">
            <div class="col-md-4">
                <h1 class="page-header">DONORS OVERVIEW</h1>
                <p class="page-subheader">Donors List</p>
            </div>
            
            <!-- Search Bar -->
            <div class="col-md-4 offset-md-4">
                <input type="text" id="searchInput" class="form-control rounded" 
                       placeholder="Search by any field..." onkeyup="filterTable()">
            </div>
        </div>

        <% 
            // Capture search parameters
            String searchName = request.getParameter("searchName");
            
            // Database Connection for pagination and search
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = dbconnection.getConnection(); //DB connection
                
                // Count the total donors with applied filters
                String countSql = "SELECT COUNT(*) as total FROM donor d " +
                                  "INNER JOIN donation dn ON d.donorID = dn.donorID " +
                                  "INNER JOIN events e ON dn.eventID = e.eventID " +
                                  "WHERE 1=1";

                if (searchName != null && !searchName.isEmpty()) {
                    countSql += " AND (d.donorID LIKE ? OR d.name LIKE ? OR d.contactInfo LIKE ? " +
                                "OR dn.amount LIKE ? OR e.name LIKE ? OR dn.date LIKE ?)";
                }

                stmt = conn.prepareStatement(countSql);

                if (searchName != null && !searchName.isEmpty()) {
                    String likePattern = "%" + searchName + "%";
                    stmt.setString(1, likePattern);
                    stmt.setString(2, likePattern);
                    stmt.setString(3, likePattern);
                    stmt.setString(4, likePattern);
                    stmt.setString(5, likePattern);
                    stmt.setString(6, likePattern);
                }

                rs = stmt.executeQuery();
                rs.next();
                int totalDonors = rs.getInt("total");
                
                // pagination parameters
                int donorsPerPage = 10;
                int currentPage = request.getParameter("page") != null ? 
                                  Integer.parseInt(request.getParameter("page")) : 1;
                int offset = (currentPage - 1) * donorsPerPage;
                int totalPages = (int) Math.ceil((double) totalDonors / donorsPerPage);

                
                String sql = "SELECT d.donorID, d.name, d.contactInfo, dn.amount, e.name AS eventName, dn.date AS dateDonated " +
                             "FROM donor d " +
                             "INNER JOIN donation dn ON d.donorID = dn.donorID " +
                             "INNER JOIN events e ON dn.eventID = e.eventID " +
                             "WHERE 1=1";

                if (searchName != null && !searchName.isEmpty()) {
                    sql += " AND (d.donorID LIKE ? OR d.name LIKE ? OR d.contactInfo LIKE ? " +
                           "OR dn.amount LIKE ? OR e.name LIKE ? OR dn.date LIKE ?)";
                }
                
                // apply pagination
                sql += " LIMIT ? OFFSET ?";

                stmt = conn.prepareStatement(sql);
                
                // set values for query
                int paramIndex = 1;
                if (searchName != null && !searchName.isEmpty()) {
                    String likePattern = "%" + searchName + "%";
                    stmt.setString(paramIndex++, likePattern);
                    stmt.setString(paramIndex++, likePattern);
                    stmt.setString(paramIndex++, likePattern);
                    stmt.setString(paramIndex++, likePattern);
                    stmt.setString(paramIndex++, likePattern);
                    stmt.setString(paramIndex++, likePattern);
                }
                stmt.setInt(paramIndex++, donorsPerPage);
                stmt.setInt(paramIndex++, offset);

                rs = stmt.executeQuery();
        %>
        
        <!-- donors List Table -->
        <div class="table-spacing table-responsive">
            <table id="donorTable" class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Contact Info</th>
                        <th>Amount (RM)</th>
                        <th>Event</th>
                        <th>Date Donated</th>
                    </tr>
                </thead>
                <tbody>
                <% 
                    while (rs.next()) {
                        int donorID = rs.getInt("donorID");
                        String name = rs.getString("name");
                        String contactInfo = rs.getString("contactInfo");
                        double amount = rs.getDouble("amount");
                        String eventName = rs.getString("eventName");
                        Date date = rs.getDate("dateDonated");
                %>
                    <tr>
                        <td><%= donorID %></td>
                        <td><%= name %></td>
                        <td><%= contactInfo %></td>
                        <td><%= amount %></td>
                        <td><%= eventName %></td>
                        <td><%= date %></td>
                    </tr>
                <% } // end while %>
                </tbody>
            </table>
        </div>
                
         <!-- Pagination -->
        <div class="pagination-container">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <!-- Previous Button -->
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>&searchName=<%= searchName != null ? searchName : "" %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <!-- Page Numbers -->
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>&searchName=<%= searchName != null ? searchName : "" %>"><%= i %></a>
                        </li>
                    <% } %>
                    <!-- Next Button -->
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>&searchName=<%= searchName != null ? searchName : "" %>" aria-label="Next">
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
