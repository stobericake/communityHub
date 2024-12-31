<%-- 
    Document   : EventListing
    Created on : Dec 25, 2024, 1:43:16 AM
    Author     : Rina
--%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Base64"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.InputStream"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Events Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif !important;
            background-color: #f8f9fa !important;
        }

        /* Keep your existing styles */
        .event-card {
            margin-bottom: 10px;
            transition: transform 0.2s;
        }

        .event-card:hover {
            transform: translateY(-5px);
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

        .category-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
            border-radius: 15px;
        }

        .event-price {
            color: #ff6600;
            font-weight: bold;
        }

        .event-image {
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }
        .text-truncate {
            white-space: nowrap;         
            overflow: hidden;            
            text-overflow: ellipsis;     
            display: block;              
        }
        .volunteer-button {
            padding: 10px;
            border: none;
            border-radius: 20px;
            background-color: #C3DFE6; /* Orange */
            color: black;
            text-decoration: none;
        }
        .donate-btn {
            margin-right: 10px;
            color: black;
        }
        /* Add pagination styles */
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
    <%@ include file="../header.jspf" %>
    <div class="container mt-4">
        <!-- Header Section -->
        <div class="row align-items-center mb-4">
            <div class="col-md-4">
                <h2>Featured Events</h2>
            </div>
             <div class="col-md-4 offset-md-4">
                <input type="text" id="searchInput" class="form-control rounded" 
                       placeholder="Search events..." onkeyup="filterEvents()">
            </div>
        </div>
        <!-- Events Grid -->
        <div class="row g-4">
            <%
            

                String user = (String) session.getAttribute("userRole");

                if (user == null) {
                    response.sendRedirect(request.getContextPath()+"/login.jsp");
                    return; 
                }
                String volunteerID = (String) session.getAttribute("volunteer");
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = dbconnection.getConnection();

                String query = "SELECT a.postalCode FROM volunteer v JOIN address a ON v.addressID = a.addressID WHERE v.volunteerID = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, volunteerID);
                rs = stmt.executeQuery();

                String postalCode = null;
                if (rs.next()) {
                    postalCode = rs.getString("postalCode");
                }
                rs.close();
                stmt.close();

                if (postalCode != null) {
                    String countSql = "SELECT COUNT(*) as total FROM Events e JOIN Address a ON e.addressID = a.addressID WHERE a.postalCode = ?";
                    PreparedStatement countStmt = conn.prepareStatement(countSql);
                    countStmt.setString(1, postalCode);
                    ResultSet countRs = countStmt.executeQuery();
                    countRs.next();
                    int totalEvents = countRs.getInt("total");
                    countRs.close();
                    countStmt.close();

                    // Pagination parameters
                    int eventsPerPage = 4;
                    int currentPage = request.getParameter("page") != null ? 
                    Integer.parseInt(request.getParameter("page")) : 1;
                    int offset = (currentPage - 1) * eventsPerPage;
                    int totalPages = (int) Math.ceil((double) totalEvents / eventsPerPage);

                    String sql = "SELECT * FROM Events e JOIN Address a ON e.addressID = a.addressID WHERE a.postalCode = ? LIMIT ? OFFSET ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, postalCode);
                    stmt.setInt(2, eventsPerPage);
                    stmt.setInt(3, offset);
                    rs = stmt.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("e.eventID");
                        String title = rs.getString("name");
                        String desc = rs.getString("description");
                        String location = rs.getString("city");
                        
                            
                        Date date = rs.getDate("date");
                        Time time = rs.getTime("time");
            %>
            <div class="col-md-3">
                <div class="card h-100 event-card" data-title="<%= title %>" 
                     data-description="<%= desc %>" data-location="<%= location %>">
                    <div class="position-relative">
                        <img src="getImage.do?id=<%= id %>" alt="Image" class="w-100 h-100" style="object-fit: cover;">
                    </div>
                    <div class="card-body">
                        <h5 class="card-title styl"><%= title %></h5>
                        <p class="card-text text-truncate"><%= desc %></p>
                        
                        <div class="mb-3">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-geo-alt-fill me-2"></i>
                                <small><%= location %></small>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-calendar-date me-2"></i>
                                <small><%= date %> <%= time %></small>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end align-items-center">                     
                            <a href="#" class="donate-btn" ><i class="bi bi-coin" style="margin-right: 5px; color: black"></i>Donate</a>
                            <a href="eventDetail.jsp?eventID=<%= id %>" class="volunteer-button">View Details</a>      
                        </div>
                    </div>
                </div>
            </div>
            <% 
                    }
            %>
            
            <!-- Pagination -->
            <div class="col-12">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= currentPage - 1 %>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        
                        <% for(int i = 1; i <= totalPages; i++) { %>
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
            <% } else { %>             
            <div class="error-message">Invalid Volunteer ID. Please try again.</div>
            <%                
                     }      
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            %>
        </div>
    </div>
    <!-- Keep your existing filterEvents() function -->
    <script>
        function filterEvents() {
            var input = document.getElementById('searchInput').value.toLowerCase();
            var eventCards = document.querySelectorAll('.event-card');
            
            eventCards.forEach(function(card) {
                var title = card.getAttribute('data-title').toLowerCase();
                var description = card.getAttribute('data-description').toLowerCase();
                var location = card.getAttribute('data-location').toLowerCase();

                if (title.includes(input) || description.includes(input) || location.includes(input)) {
                    card.closest('.col-md-3').style.display = '';
                } else {
                    card.closest('.col-md-3').style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
