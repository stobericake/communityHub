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
            background-color: #C3DFE6; 
            color: black;
            text-decoration: none;
        }
        .donate-btn {
            margin-right: 10px;
            color: black;
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

            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = dbconnection.getConnection();

        
                    String countSql = "SELECT COUNT(*) as total FROM Events e JOIN Address a ON e.addressID = a.addressID";
                    PreparedStatement countStmt = conn.prepareStatement(countSql);
 
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

                    String sql = "SELECT * FROM Events e JOIN Address a ON e.addressID = a.addressID LIMIT ? OFFSET ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, eventsPerPage);
                    stmt.setInt(2, offset);
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
                <div  style="width: 100%; height:200px; ">
                    <img src="getImage.do?id=<%= id %>" alt="Image" class="w-100 h-100" style="object-fit: cover;" />
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
    </div>



    <script>
     function filterEvents() {
    var input = document.getElementById('searchInput').value.toLowerCase();
    var eventCards = document.querySelectorAll('.event-card');
    
    eventCards.forEach(function(card) {
        var title = card.getAttribute('data-title').toLowerCase();
        var description = card.getAttribute('data-description').toLowerCase();
        var location = card.getAttribute('data-location').toLowerCase();

        // Check if the input is found in any of the fields
        if (title.includes(input) || description.includes(input) || location.includes(input)) {
            card.closest('.col-md-3').style.display = ''; // Show the card
        } else {
            card.closest('.col-md-3').style.display = 'none'; // Hide the card
        }
    });
}

    </script>
</body>
</html>