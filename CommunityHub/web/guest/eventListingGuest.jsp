<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.events"%>
<%@page import="java.util.List"%>
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
        </div>

        <!-- Events Grid -->
        <div class="row g-4">
            <% 
                List<events> events = (List) request.getAttribute("events");
                List<address> address = (List) request.getAttribute("address");
                
                int index=0;
                for (events event : events) {
            %>
            <div class="col-md-3">
                <div class="card h-100 event-card" data-title="<%= event.getName() %>" 
                     data-description="<%= event.getDescription() %>" data-location="<%= address.get(index).getCity() %>">
                    <div style="width: 100%; height:200px;">
                        <img src="getImage.do?type=events&id=<%= event.getEventID() %>" alt="Image" class="w-100 h-100" style="object-fit: cover;" />
                    </div>
                    <div class="card-body">
                        <h5 class="card-title styl"><%= event.getName() %></h5>
                        <p class="card-text text-truncate"><%= event.getDescription() %></p>

                        <div class="mb-3">
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-geo-alt-fill me-2"></i>
                                <small><%= address.get(index).getCity() %></small>
                            </div>
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-calendar-date me-2"></i>
                                <small><%= event.getDate() %> <%= event.getTime() %></small>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end align-items-center">
                            <a href="addDonor.do?eventID=<%= event.getEventID() %>" class="donate-btn"><i class="bi bi-coin" style="margin-right: 5px; color: black"></i>Donate</a>
                            <a href="eventDetailGuest?eventID=<%= event.getEventID() %>" class="volunteer-button">View Details</a>
                        </div>
                    </div>
                </div>
            </div>
            <% index++; } %>

            <!-- Pagination -->
            <div class="col-12">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li class="page-item <%= Integer.parseInt(request.getAttribute("currentPage").toString()) == 1 ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= Integer.parseInt(request.getAttribute("currentPage").toString()) - 1 %>" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>

                        <% 
                            int totalPages = Integer.parseInt(request.getAttribute("totalPages").toString());
                            for (int i = 1; i <= totalPages; i++) { 
                        %>
                            <li class="page-item <%= Integer.parseInt(request.getAttribute("currentPage").toString()) == i ? "active" : "" %>">
                                <a class="page-link" href="?page=<%= i %>"><%= i %></a>
                            </li>
                        <% } %>

                        <li class="page-item <%= Integer.parseInt(request.getAttribute("currentPage").toString()) == totalPages ? "disabled" : "" %>">
                            <a class="page-link" href="?page=<%= Integer.parseInt(request.getAttribute("currentPage").toString()) + 1 %>" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
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
