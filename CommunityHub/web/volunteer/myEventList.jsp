<%-- 
    Document   : myEventList
    Created on : Dec 15, 2024, 1:41:38 AM
    Author     : Rina
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Events</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to CSS file -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f8f9fa;
            }

            .container {
                margin: auto;
                padding: 10px;
            }

            header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px 0;
            }

            .input-group {
                max-width: 250px; 
            }  
            .search-bar {
            display: flex;
            justify-content: flex-end;
            margin: 20px 0;
        }

        .search-bar input {
            border-radius: 20px;
            padding: 10px;
            width: 100%;
            max-width: 300px;
        }

                     
            .event-table {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Poppins', sans-serif;
        }

        .event-table td {
            
        }
            
       /* Define fixed column widths */
        .event-table th:nth-child(1),
        .event-table td:nth-child(1) {
            width: 5%; /* First column is 10% */
            text-align: left;
        }

        .event-table th:nth-child(2),
        .event-table td:nth-child(2) {
            width: 30%; /* Second column is 30% */
            text-align: left;
        }

        .event-table th:nth-child(3),
        .event-table td:nth-child(3) {
            width: 25%; /* Third column is 20% */
            text-align: center;
        }

        .event-table th:nth-child(4),
        .event-table td:nth-child(4) {
            width: 25%; /* Fourth column is 20% */
            text-align: center;
        }

        .event-table th:nth-child(5),
        .event-table td:nth-child(5) {
            width: 15%; /* Fifth column is 20% */
            text-align: center;
            
        }
                                  
            .view-details-button {
                background-color: #C3DFE6;
                border-radius: 15px;
                border: none;
                color: black;
                padding: 10px 20px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                margin: 4px 2px;
                cursor: pointer;
            }
            .view-detail-button:hover{
                background-color: #F56476;
            }
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
    </style>
</head>
<body>
    <%@ include file="header.jspf" %>
    <div class="container">
        <header>
            <div class="col">
                <h3>MY EVENT</h3>
                <p>Events List</p>
            </div>
            <div class="col-md-4 offset-md-4">
                <input type="text" id="searchInput" class="form-control rounded" 
                       placeholder="Search events..." onkeyup="filterTable()">
            </div>
        </header>
        <div class="container">
        <ul class="list-group">
            <li class="list-group-item d-flex justify-content-between align-items-center" style="background-color: #2F6690; color: white;">
                <table class="event-table">
                    <tr>
                    <th>No.</th>
                    <th>Events</th>
                    <th>Date & Time</th>
                    <th>Task</th>
                    <th>View Details</th>
                </tr>
                </table>
            </li>
                <% 
                String loggedInUser = (String) session.getAttribute("volunteerID");
                String selectedTask = (String) session.getAttribute("selectedTask");
                int pageSize = 10; // Number of events per page
                int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int totalRecords = 0;
                int totalPages = 0;

                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = dbconnection.getConnection(); // Get DB connection

                    // Count total records
                    String countQuery = "SELECT COUNT(*) AS total FROM events e " +
                                        "INNER JOIN eventsVolunteer ev ON e.eventID = ev.eventID " +
                                        "WHERE ev.volunteerID = ?";
                    stmt = conn.prepareStatement(countQuery);
                    stmt.setString(1, loggedInUser);
                    rs = stmt.executeQuery();
                    if (rs.next()) {
                        totalRecords = rs.getInt("total");
                        totalPages = (int) Math.ceil(totalRecords / (double) pageSize);
                    }
                    rs.close();
                    stmt.close();

                     // Fetch paginated data
                    String sql ="SELECT e.eventID, e.name, e.date, e.time, a.state, t.description "+
                                "FROM events e " +
                                "INNER JOIN address a ON e.addressID = a.addressID " +
                                "INNER JOIN eventsVolunteer ev ON e.eventID = ev.eventID " +
                                "INNER JOIN task t ON ev.volunteerID = t.volunteerID AND e.eventID = t.eventID " +
                                "WHERE ev.volunteerID = ? "+
                                "LIMIT ? OFFSET ?";

                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, loggedInUser);
                    stmt.setInt(2, pageSize);
                    stmt.setInt(3, (currentPage - 1) * pageSize);
                    rs = stmt.executeQuery();

                    
                     String taskSql ="SELECT * FROM task where volunteerID = ?";
                     stmt.setString(1, loggedInUser);
                     ResultSet rsTask = stmt.executeQuery();

                    while (rs.next()) {
                        int index = 1;
                        int id = rs.getInt("e.eventID");
                        String title = rs.getString("e.name");
                        Date date = rs.getDate("e.date");
                        Time time = rs.getTime("e.time");
                        String task = rsTask.getString("description");
                        String location = rs.getString("a.state");

                        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");
                        String formattedDateTime = outputFormat.format(inputFormat.parse(date + " " + time));
                %>
               <li class="list-group-item d-flex justify-content-between align-items-center">
                    <table class="volunteerTable">
                        <tr>
                           <td><%= id %>.</td>
                            <td><%= title %></td>
                            <td><%= formattedDateTime %></td>                            
                            <td><%= task %></td>
                            <td><a href="myEventDetail.jsp?eventID=<%= id %>" class="view-details-button">View Details</a></td>
                        </tr>                                       

                </table>
                
                    
                <% 
                    } // End while
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
                %>
                </li>
            
        </div>
        <!-- Pagination -->
        <div class="col-12">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage - 1 %>" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= currentPage == i ? "active" : "" %>">
                            <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                        </li>
                    <% } %>
                    
                    <li class="page-item <%= currentPage == totalPages ? "disabled" : "" %>">
                        <a class="page-link" href="?page=<%= currentPage + 1 %>" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
                             <!-- Keep your existing filterEvents() function -->
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
</body>
</html>
