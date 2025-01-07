<%--
    Document   : EventListing
    Created on : Dec 25, 2024, 1:43:16 AM
    Author     : Rina
--%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cm.model.address"%>
<%@ page import="java.util.ArrayList" %>
<%@page import="com.cm.model.events"%>
<%@page import="java.util.List"%>
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
    <%
    List<events> events = (List) request.getAttribute("events");
    List<address> addresses = (List) request.getAttribute("address");
    int totalPages = Integer.parseInt(request.getAttribute("totalPages").toString());
    int currentPage = Integer.parseInt(request.getAttribute("currentPage").toString());

    String volunteerId = request.getSession().getAttribute("volunteer").toString();
    if (volunteerId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
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
                if (events != null && !events.isEmpty()) {
                                        int num = (currentPage - 1) * 4 + 1; // Start number for pagination
                                        for (events event : events) {
                                            int eventID = event.getEventID();
                                            String name = event.getName();
                                            String desc = event.getDescription();
                                            String city = "";
                                            for (address addr : addresses) {
                                                if (addr.getAddressID() == event.getAddressID()) {
                                                    city = addr.getCity();
                                                    break; // Exit the loop once the match is found
                                                }
                                            }
                                            String formattedDate = new SimpleDateFormat("dd/MM E").format(event.getDate());
                                            String formattedTime = new SimpleDateFormat("HH:mm").format(event.getTime());
            %>            
            <div class="col-md-3">
                <div class="card h-100 event-card" data-title="<%= name%>" 
                     data-description="<%= desc %>" data-location="<%= city%>">
                    <div class="position-relative">
                        <img src="getImage.do?id=<%= eventID %>" alt="Image" class="w-100 h-100" style="object-fit: cover;">
                    </div>
                    <div class="card-body">
                        <h5 class="card-title styl"><%= name %></h5>
                        <p class="card-text text-truncate"><%= desc %></p>
                        
                        <div class="mb-3">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-geo-alt-fill me-2"></i>
                                <small><%= city %></small>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-calendar-date me-2"></i>
                                <small><%= formattedDate %> <%= formattedTime %> %></small>
                            </div>
                        </div>
<div class="d-flex justify-content-end align-items-center">                     
                            <a href="../guest/donationForm.jsp?eventID=<%= eventID %>" class="donate-btn" ><i class="bi bi-coin" style="margin-right: 5px; color: black"></i>Donate</a>
                            <a href="vEvent.do?eventID=<%= eventID %>" class="volunteer-button">View Details</a>      
                        </div>
                    </div>
                </div>
            </div>
                <% }
                                } else {
                %>
            <div> No events found.</div>
                               
                <% }%>
          
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

                if (title.includes(input)  description.includes(input)  location.includes(input)) {
                    card.closest('.col-md-3').style.display = '';
                } else {
                    card.closest('.col-md-3').style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>