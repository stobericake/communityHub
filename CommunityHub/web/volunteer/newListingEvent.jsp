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
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
                background-color: #f8f9fa !important;
            }

            .event-card {
                margin-bottom: 20px;
                transition: transform 0.2s;
            }

            .event-card:hover {
                transform: translateY(-5px);
            }

            .card-img-top {
                height: 200px;
                object-fit: cover;
            }

            .action-buttons {
                display: flex;
                gap: 10px;
            }

            .action-buttons .btn {
                flex: 1;
            }
            
            .btn-donor{
                background-color: blue;
            }
            
            btn-view {
                background-color: pink;
            }

            /* Updated Pagination Styles */
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

            .pagination .page-item.disabled .page-link {
                color: #6c757d;
                border-color: #6c757d;
                pointer-events: none;
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
        <div class="row mb-4">
            <div class="col-md-4">
                <h2>Featured Events</h2>
            </div>
            <div class="col-md-4 offset-md-4">
                    <div class="input-group">
                        <input type="text" id="searchInput" class="form-control" placeholder="Search events...">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="sortBy" onchange="updateFilters()">
                        <option value="eventID" <%= "eventID".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Sort by Creation Order</option>
                        <option value="date" <%= "date".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Sort by Event Date</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="monthFilter" onchange="updateFilters()">
                        <option value="">All Months</option>
                        <%
                            String[] months = {"January", "February", "March", "April", "May", "June",
                                "July", "August", "September", "October", "November", "December"};
                            for (int i = 0; i < months.length; i++) {
                                String selected = String.valueOf(i + 1).equals(request.getAttribute("monthFilter")) ? "selected" : "";
                        %>
                        <option value="<%= i + 1%>" <%= selected%>><%= months[i]%></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="yearFilter" onchange="updateFilters()">
                        <option value="">All Years</option>
                        <%
                            int currentYear = java.time.Year.now().getValue();
                            for (int year = currentYear - 5; year <= currentYear + 5; year++) {
                                String selected = String.valueOf(year).equals(request.getAttribute("yearFilter")) ? "selected" : "";
                        %>
                        <option value="<%= year%>" <%= selected%>><%= year%></option>
                        <% } %>
                    </select>
                </div>
       
        <!-- Events Grid -->
        <div class="row g-4">
        <%
            if (events != null && !events.isEmpty()) {
                int num = (currentPage - 1) * 5 + 1;// Start number for pagination
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
                String formattedDate = new SimpleDateFormat("dd/MM:").format(event.getDate());
                String formattedTime = new SimpleDateFormat("hh:mm a").format(event.getTime());
            %>            
            <div class="col-md-4">
                 <div class="card h-100 event-card shadow" data-title="<%= name%>" data-description="<%= desc%>" data-location="<%= city%>">
                    <a href="vEvent.do?eventID=<%= eventID %>">
                        <img src="getImage.do?type=events&id=<%= eventID %>"   class="card-img-top" alt="Event Image">
                    </a>
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title fw-bold"><%= name %></h5>
                        <p class="card-text" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= desc %></p>
                        <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-geo-alt-fill me-2"></i>
                                <small class="text-body-secondary"><%= city %></small>
                            </div>
                           <div class="d-flex align-items-center mb-3">
                                <i class="bi bi-clock-fill me-2"></i>
                                <small class="text-body-secondary"><%= formattedDate %> <%= formattedTime %></small>
                            </div>
                       
                        <div class="action-buttons mt-auto">
                        <button 
                            class="btn btn-dark" 
                            onclick="location.href='guest/donationForm.jsp?eventID=<%= eventID %>'">
                            <i class="bi bi-coin me-2"></i>
                            Donate
                        </button>
                            
                    </div>

                    </div>
                </div>
            </div>
                <% }
                  } else {
                %>
                <div class="col-12 text-center">
                    <p>No events found.</p>
                </div>
                               
                <% }%>
          
            <!-- Updated Pagination -->
            <div class="row mt-4">
                <div class="col-12">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item <%= currentPage == 1 ? "disabled" : ""%>">
                                <a class="page-link" href="?page=<%= currentPage - 1%>" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <% for (int i = 1; i <= totalPages; i++) {%>
                            <li class="page-item <%= currentPage == i ? "active" : ""%>">
                                <a class="page-link" href="?page=<%= i%>"><%= i%></a>
                            </li>
                            <% }%>
                            <li class="page-item <%= currentPage == totalPages ? "disabled" : ""%>">
                                <a class="page-link" href="?page=<%= currentPage + 1%>" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <script>
            function filterEvents() {
                var input = document.getElementById('searchInput').value.toLowerCase();
                var eventCards = document.querySelectorAll('.event-card');

                eventCards.forEach(function (card) {
                    var title = card.getAttribute('data-title').toLowerCase();
                    var description = card.getAttribute('data-description').toLowerCase();
                    var location = card.getAttribute('data-location').toLowerCase();

                    if (title.includes(input) || description.includes(input) || location.includes(input)) {
                        card.closest('.col-md-4').style.display = '';
                    } else {
                        card.closest('.col-md-4').style.display = 'none';
                    }
                });
            }

            function updateFilters() {
                const sortBy = document.getElementById('sortBy').value;
                const monthFilter = document.getElementById('monthFilter').value;
                const yearFilter = document.getElementById('yearFilter').value; // New year filter

                let url = new URL(window.location.href);
                url.searchParams.set('sortBy', sortBy);
                if (monthFilter) {
                    url.searchParams.set('month', monthFilter);
                } else {
                    url.searchParams.delete('month');
                }
                if (yearFilter) {
                    url.searchParams.set('year', yearFilter); // Add year filter to URL
                } else {
                    url.searchParams.delete('year');
                }
                url.searchParams.set('page', '1'); // Reset to first page when filters change
                window.location.href = url.toString();
            }

            document.getElementById('searchInput').addEventListener('input', filterEvents);
    </script>
</body>
</html>