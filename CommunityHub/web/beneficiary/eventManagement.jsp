<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.events"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Event Management</title>

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
            .no-events-message {
                font-size: 1.1rem;
                color: #6c757d; /* Gray color */
                padding: 10px;
            }

        </style>
    </head>
    <body>
        <%@ include file="../header.jspf" %>

        <div class="container my-4">
            <div class="row align-items-center mb-4">
                <div class="col-md-4">
                    <h1 class="page-header">EVENT MANAGEMENT</h1>
                    <h6 class="page-subheader">The tables below show all of the events</h6>

                </div>

                <div class="col-md-4 offset-md-4">
                    <input type="text" id="searchInput" class="form-control rounded"
                           placeholder="Search by any field..." onkeyup="filterTable()"><br>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="sortBy" onchange="updateFilters()">
                        <option value="eventID" <%= "eventID".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Sort by Creation Order</option>
                        <option value="date" <%= "date".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Sort by Event Date</option>
                        <option value="donationLimit" <%= "donationLimit".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Sort by Donation Limit</option>
                        <option value="volunteerNeeded" <%= "volunteerNeeded".equals(request.getAttribute("sortBy")) ? "selected" : ""%>>Sort by Volunteers Needed</option>
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
                <div class="col-md-3 text-end">
                    <a href="beneficiary/createEvent.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-2"></i>Create Event
                    </a>
                </div>

            </div>

            <div class="card-body">
                <form action="updateEvent.do" method="post">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped" id="eventTable" >
                            <thead class="table-dark">
                                <tr>
                                    <th scope="col" width="25%">Event List</th>
                                    <th scope="col" width="20%">Date</th>
                                    <th scope="col" width="15%">Time</th>
                                    <th scope="col" width="20%">Place</th>
                                    <th scope="col" width="15%" class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<events> eventList = (List) request.getAttribute("event");
                                    List<address> addressList = (List) request.getAttribute("address");

                                    if (eventList.isEmpty()) {
                                %>
                                <tr>
                                    <td colspan="5" class="text-center">
                                        <div class="no-events-message" role="alert">
                                            No events have finished yet.
                                        </div>
                                    </td>
                                </tr>
                                <%
                                } else {
                                    for (int i = 0; i < eventList.size(); i++) {

                                        SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy");
                                        Date eventDate = eventList.get(i).getDate();
                                        String date = formatter.format(eventDate);
                                %>
                                <tr>
                                    <td class="fw-medium"><%= eventList.get(i).getName()%></td>
                                    <td><%= date%></td>
                                    <td><%= eventList.get(i).getTime()%></td>
                                    <td><%= addressList.get(i).getState()%></td>
                                    <td class="text-center">
                                        <div class="btn-group" role="group">
                                            <a href="eventDetailMgmt?id=<%= eventList.get(i).getEventID()%>" 
                                               class="btn btn-outline-primary btn-sm view-event-button" 
                                               aria-label="View Event <%= eventList.get(i).getEventID()%>">
                                                <i class="bi bi-eye me-2" aria-hidden="true"></i> View
                                            </a>
                                            <a href="updateEvent.do?editEventId=<%= eventList.get(i).getEventID()%>" 
                                               class="btn btn-outline-secondary btn-sm">
                                                <i class="bi bi-pencil"></i> Edit
                                            </a>
                                            <a href="#" class="btn btn-outline-danger btn-sm delete-link"
                                               data-bs-toggle="modal" data-bs-target="#deleteModal"
                                               data-event-id="<%= eventList.get(i).getEventID()%>">
                                                <i class="bi bi-trash"></i> Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                </form>
            </div>


            <!-- Delete Confirmation Modal -->
            <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            Are you sure you want to delete this event?
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <form id="deleteForm" action="updateEvent.do" method="GET">
                                <input type="hidden" name="eventDeleteId" id="eventIdToDelete">
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <%
                Integer currentPage = (Integer) request.getAttribute("currentPage");
                Integer totalPages = (Integer) request.getAttribute("totalPages");
            %>

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

            // Attach the filterTable function to the search input
            document.getElementById('searchInput').addEventListener('input', filterTable);

            document.addEventListener("DOMContentLoaded", function () {
                document.addEventListener("click", function (event) {
                    if (event.target.closest('.delete-link')) {
                        const deleteLink = event.target.closest('.delete-link');
                        const eventId = deleteLink.getAttribute('data-event-id');
                        console.log("Event ID:", eventId);

                        const eventIdInput = document.getElementById('eventIdToDelete');
                        if (eventIdInput) {
                            eventIdInput.value = eventId;
                        }
                    }
                });
            });

            function filterEvents() {
                var input = document.getElementById('searchInput').value.toLowerCase(); // Get search input value
                var rows = document.querySelectorAll('#eventTable tbody tr'); // Select all table rows

                rows.forEach(function (row) {
                    var cells = row.querySelectorAll('td'); // Get all cells in the row
                    var match = false;

                    // Check if any cell in the row matches the search input
                    cells.forEach(function (cell) {
                        if (cell.textContent.toLowerCase().includes(input)) {
                            match = true;
                        }
                    });

                    // Show or hide the row based on the match
                    if (match) {
                        row.style.display = ''; // Show the row
                    } else {
                        row.style.display = 'none'; // Hide the row
                    }
                });
            }



            function updateFilters() {
                const sortBy = document.getElementById('sortBy').value;
                const monthFilter = document.getElementById('monthFilter').value;
                const yearFilter = document.getElementById('yearFilter').value;

                let url = new URL(window.location.href);
                url.searchParams.set('sortBy', sortBy);
                if (monthFilter) {
                    url.searchParams.set('month', monthFilter);
                } else {
                    url.searchParams.delete('month');
                }
                if (yearFilter) {
                    url.searchParams.set('year', yearFilter);
                } else {
                    url.searchParams.delete('year');
                }
                url.searchParams.set('page', '1'); // Reset to first page when filters change
                window.location.href = url.toString();
            }

            // Attach the updateFilters function to the sort and filter dropdowns
            document.getElementById('sortBy').addEventListener('change', updateFilters);
            document.getElementById('monthFilter').addEventListener('change', updateFilters);
            document.getElementById('yearFilter').addEventListener('change', updateFilters);

        </script>
    </body>
</html>
