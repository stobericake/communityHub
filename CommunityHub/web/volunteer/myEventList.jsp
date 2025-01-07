<%-- 
    Document   : myEventList
    Created on : Dec 15, 2024, 1:41:38 AM
    Author     : Rina
--%>

<%@page import="com.cm.model.eventsVolunteer"%>
<%@page import="com.cm.model.task"%>
<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.events"%>
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

                     
            .volunteerTable {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Poppins', sans-serif;
        }

        .volunteerTable td {
            
        }
            
       /* Define fixed column widths */
        .volunteerTable th:nth-child(1),
        .volunteerTable td:nth-child(1) {
            width: 5%; /* First column is 10% */
            text-align: left;
        }

        .volunteerTable th:nth-child(2),
        .volunteerTable td:nth-child(2) {
            width: 30%; /* Second column is 30% */
            text-align: left;
        }

        .volunteerTable th:nth-child(3),
        .volunteerTable td:nth-child(3) {
            width: 25%; /* Third column is 20% */
            text-align: center;
        }

        .volunteerTable th:nth-child(4),
        .volunteerTable td:nth-child(4) {
            width: 25%; /* Fourth column is 20% */
            text-align: center;
        }

        .volunteerTable th:nth-child(5),
        .volunteerTable td:nth-child(5) {
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
    <%
                    List<events> events = (List) request.getAttribute("events");
                    List<address> addresses = (List) request.getAttribute("address");
                    List<task> tasks = (List) request.getAttribute("tasks");
                    List<eventsVolunteer> eventsV = (List) request.getAttribute("eventsV");
                    int totalPages = Integer.parseInt(request.getAttribute("totalPages").toString());
                    int currentPage = Integer.parseInt(request.getAttribute("currentPage").toString());

                    int volunteerId = Integer.parseInt(request.getSession().getAttribute("volunteer").toString());
                    if (volunteerId == 0) {
                        response.sendRedirect(request.getContextPath() + "/login.jsp");
                        return;
                    }
    %>
    <%@ include file="../header.jspf" %>
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
                <table class="volunteerTable">
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
                if (events != null && !events.isEmpty()) {
                    int index = 1;
                    int num = (currentPage - 1) * 4 + 1; // Start number for pagination
                        if (events != null && !events.isEmpty()) {
                    for (int i = 0; i < events.size(); i++) {
                        events event = events.get(i);
                        task task = tasks.get(i); // Assuming tasks and events are aligned
            
         String formattedDate = new SimpleDateFormat("dd/MM E").format(event.getDate());
         String formattedTime = new SimpleDateFormat("HH:mm").format(event.getTime());
            %>         
               <li class="list-group-item d-flex justify-content-between align-items-center">
                    <table class="volunteerTable">
                        <tr>
                           <td><%= index++%>.</td>
                           <td><%= event.getName() %></td>
                           <td><%= formattedDate %></td>
                           <td><%= task.getDescription() %></td>
                           
                            <td><a href="myEventDetail.jsp?eventID=<%= event.getEventID() %>" class="view-details-button">View Details</a></td>
                        </tr>                                       

                </table>
               </li>
                    
                 <% }
                        } else {
                %>
            <div> No events found.</div>
                               
                <% }
}%>
        <!-- Pagination -->
        <div class="container  mb-3">
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

    <script>
    function filterTable() {
        const input = document.getElementById('searchInput').value.toLowerCase();
        const rows = document.querySelectorAll('.list-group-item:not(:first-child)'); // Skip the header row

        rows.forEach(row => {
            const textContent = row.textContent.toLowerCase(); // Get all text content in the row
            row.style.display = textContent.includes(input) ? '' : 'none'; // Show/Hide row based on match
        });
    }
</script>


</body>
</html>
