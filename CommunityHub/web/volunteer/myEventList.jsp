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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Events</title>
    
        <style>
           .table-dark th {
                background-color: #2F6690 !important;
            }

            /* Pagination styles */
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

            .page-header {
                font-weight: bold;
                font-size: 1.5rem;
            }

            .page-subheader {
                font-size: 1.0rem;
                color: #6c757d;
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
     <div class="container my-4">
            <div class="row align-items-center mb-4">
                <div class="col-md-4">
                    <h1 class="page-header">MY EVENT</h1>
                    <h6 class="page-subheader">The tables below show all of the events that you joined</h6>
                </div>

                <div class="col-md-4 offset-md-4">
                    <input type="text" id="searchInput" class="form-control rounded"
                           placeholder="Search by any field..." onkeyup="filterTable()"><br>
                </div>
            </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-striped" id="eventTable" >
                    <thead class="table-dark">
                        <tr>
                            <th scope="col" width="25%">Events</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Task</th>
                            <th scope="col" width="10%" class="text-center">View Detail</th>
                        </tr>
                    </thead>
                    <tbody>
                <%
                    for (int i = 0; i < events.size(); i++) {
                        events event = events.get(i);
                        task task = tasks.get(i); // Assuming tasks and events are aligned
                        address add = addresses.get(i);
                        String formattedDate = new SimpleDateFormat("dd-MM-yyyy").format(event.getDate());
                        String formattedTime = new SimpleDateFormat("hh:mm a").format(event.getTime());

                        // Check if the task is null or if the task description is empty
                        String taskDescription = (task == null || task.getDescription() == null || task.getDescription().isEmpty()) 
                                                ? "Crew" 
                                                : task.getDescription();
                %>         
                <tr>
                    <td class="fw-medium"><%= event.getName() %></td>
                    <td><%= add.getState() %></td>
                    <td><%= formattedDate %></td>
                    <td><%= formattedTime %></td>
                    <td><%= taskDescription %></td> <!-- Display "Crew" if no task is assigned -->
                    <td class="text-center">
                        <a href="myDetail.do?eventID=<%= event.getEventID() %>">
                            <i class="bi bi-arrow-right-circle"></i>
                        </a>
                    </td>
                </tr>                                       
                <%
                    }
                %>
            </tbody>
                </table>
               </div>
        </div>

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
            const rows = document.querySelectorAll('#eventTable tbody tr');

            rows.forEach(row => {
                const cells = Array.from(row.querySelectorAll('td'));
                const match = cells.some(cell => cell.textContent.toLowerCase().includes(input));
                row.style.display = match ? '' : 'none';
            });
        }
    </script>
</body>
</html>
