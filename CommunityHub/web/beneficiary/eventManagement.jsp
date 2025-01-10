<%@page import="com.cm.model.address"%>
<%@page import="com.cm.model.events"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Event Management</title>

    </head>
    <body>
        <%@ include file="../header.jspf" %>

        <div class="container my-3">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="text-dark mb-2">Event Management</h1>
                    <h6 class="text-secondary">The tables below show all of the events</h6>
                    <a href="beneficiary/createEvent.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-2"></i>Create Event
                    </a>
                </div>

                <div class="col-md-4 offset-md-4">
                    <input type="text" id="searchInput" class="form-control rounded"
                           placeholder="Search by any field..." onkeyup="filterTable()"><br>

                </div>



            </div>



            <div class="card shadow-sm">
                <div class="card-body">
                    <form action="updateEvent.do" method="post">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped align-middle mb-0" id="eventTable" >
                                <thead class="table" style="background-color: #2F6690; color: white">
                                    <tr>
                                        <th scope="col" width="5%">NO</th>
                                        <th scope="col" width="25%">EVENT LIST</th>
                                        <th scope="col" width="20%">DATE</th>
                                        <th scope="col" width="15%">TIME</th>
                                        <th scope="col" width="20%">PLACE</th>
                                        <th scope="col" width="15%" class="text-center">ACTION</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        List<events> eventList = (List) request.getAttribute("event");
                                        List<address> addressList = (List) request.getAttribute("address");
                                        for (int i = 0; i < eventList.size(); i++) {
                                    %>
                                    <tr>
                                        <td><%= i + 1%></td>
                                        <td class="fw-medium"><%= eventList.get(i).getName()%></td>
                                        <td><%= eventList.get(i).getDate()%></td>
                                        <td><%= eventList.get(i).getTime()%></td>
                                        <td><%= addressList.get(i).getState()%></td>
                                        <td class="text-center">
                                            <div class="btn-group" role="group">
                                                <a href="updateEvent.do?editEventId=<%= eventList.get(i).getEventID()%>" 
                                                   class="btn btn-outline-primary btn-sm">
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
                                    %>
                                </tbody>
                            </table>
                        </div>

                    </form>
                </div>
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

            <!-- Pagination Controls -->


            <div class="d-flex justify-content-between align-items-center mt-4">

                <div>
                    <%
                        Integer currentPage = (Integer) request.getAttribute("currentPage");
                        Integer totalPages = (Integer) request.getAttribute("totalPages");
                    %>
                    <span>Page <%= currentPage%> of <%= totalPages%></span>
                </div>
                <div>
                    <nav>
                        <ul class="pagination">
                            <li class="page-item <%= currentPage == 1 ? "disabled" : ""%>">
                                <a class="page-link" href="?page=<%= currentPage - 1%>">Previous</a>
                            </li>
                            <% for (int i = 1; i <= totalPages; i++) {%>
                            <li class="page-item <%= i == currentPage ? "active" : ""%>">
                                <a class="page-link" href="?page=<%= i%>"><%= i%></a>
                            </li>
                            <% }%>
                            <li class="page-item <%= currentPage == totalPages ? "disabled" : ""%>">
                                <a class="page-link" href="?page=<%= currentPage + 1%>">Next</a>
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





            document.addEventListener("DOMContentLoaded", function () {
                // Add a click event listener to the document
                document.addEventListener("click", function (event) {
                    // Check if the clicked element has the class "delete-link"
                    if (event.target.closest('.delete-link')) {
                        // Get the delete-link element (use closest for nested elements like icons)
                        const deleteLink = event.target.closest('.delete-link');
                        // Retrieve the event ID from the data-event-id attribute
                        const eventId = deleteLink.getAttribute('data-event-id');
                        console.log("Event ID:", eventId); // Debugging output
                        // Set the value of the hidden input field
                        const eventIdInput = document.getElementById('eventIdToDelete');
                        if (eventIdInput) {
                            eventIdInput.value = eventId;
                        }
                    }
                });
            });



        </script>
    </body>
</html>
