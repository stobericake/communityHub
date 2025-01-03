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

        <div class="container my-5">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="text-dark mb-2">Event Management</h1>
                    <h6 class="text-secondary">The tables below show all of the events</h6>
                </div>
                <div>
                    <a href="beneficiary/createEvent.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-2"></i>Create Event
                    </a>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-body">
                    <form action="updateEvent.do" method="post">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped align-middle mb-0">
                                <thead class="table-light">
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
                                                <a href="updateEvent.do?eventDeleteId=<%= eventList.get(i).getEventID()%>" 
                                                   class="btn btn-outline-danger btn-sm">
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
    </body>
</html>
