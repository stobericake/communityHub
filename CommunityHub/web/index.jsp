<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* Additional styles for event cards and search bar */
        .event-card {
            margin-bottom: 20px;
        }

        .event-card .btn-donate {
            background-color: #ff6600;
            color: white;
        }

        .event-card .btn-donate:hover {
            background-color: #e55b00;
        }

        /* Search Bar Styles */
        .search-bar {
            display: flex;
            justify-content: flex-end;
            margin-top: 10px;
        }

        .search-bar input {
            border-radius: 20px;
            padding: 10px;
            width: 100%;
            max-width: 300px;
        }

        /* Event Heading Alignment */
        .event-heading-container {
            margin-top: 20px;
        }

        .event-heading {
            padding: 20px 0;
            border: 1px solid #e55b00;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .event-heading h2 {
            margin: 0;
            font-weight: 700;
        }

        /* Event List Alignment */
        .event-list-container {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jspf" %> <!-- Assuming header contains register/login buttons -->

    <div class="container mt-4">
       <div class="row g-0">
    <div class="col md-4">
        <!-- Event Section -->
            <h2>Event</h2>
            <h4>Event List</h4>
     
           </div>
    
    <div class="col-md-4 justify-content-md-end">
    <div class="col-md-10 offset-md-5">
         <input type="text" id="searchInput" class="form-control rounded" placeholder="Search" onkeyup="filterEvents()">
    </div>
    <!-- Search Section with offset for alignment -->
</div>
   </div>
</div>

        <!-- Event List (Each Event inside its own container) -->
        <% 
            // Database Connection
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = dbconnection.getConnection(); // Get DB connection
                String sql = "SELECT * from events e, address a WHERE e.addressID = a.addressID";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                // Iterate through each event
                while (rs.next()) {
                    String title = rs.getString("name");
                    String desc = rs.getString("description");
                    String location = rs.getString("city");
                    Date date = rs.getDate("date");
                    Time time = rs.getTime("time");
        %>

        <!-- Event Container for Each Event -->
        <div class="container event-list-container shadow rounded p-4">
            <div class="event-card card mb-3" style="border: none;" data-title="<%= title %>" data-description="<%= desc %>" data-location="<%= location %>">
                <div class="row g-0">
                    <!-- Image Section (Left) -->
                    <div class="col-md-2">
                        <div class="card-body">
                            <img src="logo.png" class="img-fluid rounded-start" alt="Event Image">
                        </div>
                    </div>

                    <!-- Card Content Section (Right) -->
                    <div class="col-md-4">
                        <div class="card-body">
                            <!-- Title Section -->
                            <h5 class="card-title"><%= title %></h5>

                            <!-- Description Section -->
                            <div class="card-text">
                                <%= desc %>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-2"></div>

                    <!-- Event Details Section (Location, Time/Date, Donate Button) -->
                    <div class="col-md-4 d-flex flex-column align-items-end">
                        <div class="card-body">
                            <!-- Location with Icon -->
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-geo-alt-fill"></i> <!-- Location Icon -->
                                <span class="ms-2"><%= location %></span>
                            </div>

                            <!-- Time/Date with Icon -->
                            <div class="d-flex align-items-center mb-2">
                                <i class="bi bi-calendar-date"></i> <!-- Time/Date Icon -->
                                <span class="ms-2"><%= date %> <%= time %></span>
                            </div>

                            <!-- Donate Button -->
                            <a href="#" class="btn btn-primary">Donate</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.min.js"></script>

    <!-- JavaScript for Filtering Events -->
    <script>
       function filterEvents() {
    var input = document.getElementById('searchInput').value.toLowerCase();
    var eventContainers = document.querySelectorAll('.event-list-container');
    
    eventContainers.forEach(function(container) {
        var eventCard = container.querySelector('.event-card');
        var title = eventCard.getAttribute('data-title').toLowerCase();
        var description = eventCard.getAttribute('data-description').toLowerCase();
        var location = eventCard.getAttribute('data-location').toLowerCase();

        // If any of the event details match the search input
        if (title.includes(input) || description.includes(input) || location.includes(input)) {
            container.style.display = '';  // Show the entire event container
        } else {
            container.style.display = 'none';  // Hide the entire event container
        }
    });
}

    </script>
</body>
</html>
