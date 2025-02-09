<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalTime"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.cm.model.events"%>
<%@page import="com.cm.model.volunteer"%>
<!DOCTYPE html>
<%
    ArrayList<events> eventsList = (ArrayList<events>) request.getAttribute("eventsList");
    ArrayList<volunteer> volunteerList = (ArrayList<volunteer>) request.getAttribute("volunteerList");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalPages1 = (Integer) request.getAttribute("totalPages1");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer currentPage1 = (Integer) request.getAttribute("currentPage1");
    String status = (String) request.getAttribute("status");
    String activeTab = (String) request.getAttribute("activeTab");
%>  
<%
    String user = (String) session.getAttribute("userRole");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<style>

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
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Generate Report</title>
    </head>
    <body>
        <%@ include file="../header.jspf" %>

        <div class="container mt-5">
            <h4 class="fw-bold">GENERATE REPORT</h4>
            <p>Report Information Event and Volunteer</p>
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link <%= "events".equals(activeTab) ? "active" : ""%>" 
                       id="events-tab" 
                       data-bs-toggle="tab" 
                       href="#events" 
                       role="tab"
                       aria-controls="events" 
                       aria-selected="<%= "events".equals(activeTab)%>">
                        Events
                    </a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link <%= "volunteers".equals(activeTab) ? "active" : ""%>" 
                       id="volunteers-tab" 
                       data-bs-toggle="tab" 
                       href="#volunteers" 
                       role="tab"
                       aria-controls="volunteers" 
                       aria-selected="<%= "volunteers".equals(activeTab)%>">
                        Volunteers
                    </a>
                </li>
            </ul>
            <div class="tab-content mt-3">
                <!-- Events Tab -->
                <div class="tab-pane fade <%= "events".equals(activeTab) ? "show active" : ""%>" id="events" role="tabpanel">
                    <!-- Event -->
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-5 col-md-3 mb-3">
                                <div class="search-container col">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="eventSearchInput" placeholder="Search Events" oninput="filterEventTable()">
                                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    </div>
                                </div>
                            </div>
                            <div class="col"></div>
                            <div class="col-5 col-md-2 text-center">
                                <div class="dropdown">
                                    <button class="btn btn-light btn-outline-secondary dropdown-toggle" id="dropdownMenuButton" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <!-- Display the currently selected status -->
                                        <%= "All".equals(status) ? "All" : status%>
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                        <li><a class="dropdown-item" 
                                               href="?status=All&page=<%= currentPage%>&page2=<%= currentPage1%>&activeTab=events">All</a></li>    
                                        <li><a class="dropdown-item" 
                                               href="?status=Pending&page=<%= currentPage%>&page2=<%= currentPage1%>&activeTab=events">Pending</a></li>
                                        <li><a class="dropdown-item" 
                                               href="?status=Approved&page=<%= currentPage%>&page2=<%= currentPage1%>&activeTab=events">Approved</a></li>
                                        <li><a class="dropdown-item" 
                                               href="?status=Rejected&page=<%= currentPage%>&page2=<%= currentPage1%>&activeTab=events">Rejected</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <!--table-->
                        <table class="table">
                            <thead>
                                <tr>
                                    <td scope="col" class="col-1">
                                        <div>
                                            <input class="form-check-input" type="checkbox" id="eventCheckAll" aria-label="Check All">
                                        </div>
                                    </td>
                                    <th scope="col" class="col-1">ID</th>
                                    <th scope="col" class="col-6">Event Name</th>
                                    <th scope="col" class="text-center col-2">Date</th>
                                    <th scope="col" class="text-center col-2">Report</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <% if (eventsList != null && !eventsList.isEmpty()) {
                                        for (events event : eventsList) {
                                            String formattedDate = new SimpleDateFormat("dd/MM/YYYY").format(event.getDate());

                                            // Calculate event end time - reuse the same logic as for the Generate button
                                            String eventDateStr = new SimpleDateFormat("yyyy-MM-dd").format(event.getDate());
                                            String eventTimeStr = event.getTime() != null ? event.getTime().toString() : "00:00:00";
                                            String eventDateTimeStr = eventDateStr + " " + eventTimeStr;
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                                            LocalDateTime eventDateTime = LocalDateTime.parse(eventDateTimeStr, formatter);

                                            // Get duration
                                            Time duration = event.getDuration();
                                            LocalTime durationTime = duration != null ? duration.toLocalTime() : LocalTime.of(0, 0);

                                            // Calculate duration in milliseconds
                                            long durationInMillis = durationTime.getHour() * 60 * 60 * 1000L
                                                    + durationTime.getMinute() * 60 * 1000L
                                                    + durationTime.getSecond() * 1000L;

                                            // Calculate end time
                                            LocalDateTime eventEndTime = eventDateTime.plus(durationInMillis, ChronoUnit.MILLIS);

                                            // Check if event has completed
                                            boolean isEventCompleted = LocalDateTime.now().isAfter(eventEndTime);
                                %>
                                <tr>
                                    <td>
                                        <div>
                                            <input class="form-check-input row-checkbox" 
                                                   type="checkbox" 
                                                   data-event-id="<%=event.getEventID()%>" 
                                                   aria-label="Row Checkbox"
                                                   <%= isEventCompleted ? "" : "disabled"%>>
                                        </div>
                                    </td>
                                    <td><%=event.getEventID()%></td>
                                    <td><%=event.getName()%></td>
                                    <td class="text-center"><%=formattedDate%></td>
                                    <td class="text-center">
                                        <% if (isEventCompleted) {%>
                                        <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath()%>/AdminEvent?eventID=<%= event.getEventID()%>">
                                            <i class="bi bi-file-earmark-text me-2"></i>Generate
                                        </a>
                                        <% } else { %>
                                        <button class="btn btn-outline-secondary btn-sm" disabled>
                                            <i class="bi bi-file-earmark-text me-2"></i>Generate
                                        </button>
                                        <% } %>
                                    </td>
                                </tr>
                                <% }
        }%>
                            </tbody>
                        </table>
                        <!-- Pagination -->
                        <div class="col-12 d-flex justify-content-center">
                            <nav aria-label="Event Page navigation">
                                <ul class="pagination">
                                    <li class="page-item <%= currentPage == 1 ? "disabled" : ""%>">
                                        <a class="page-link" href="?status=<%= status%>&page=<%= currentPage - 1%>&page2=<%= currentPage1%>&activeTab=events" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <% for (int i = 1; i <= totalPages; i++) {%>
                                    <li class="page-item <%= currentPage == i ? "active" : ""%>">
                                        <a class="page-link" href="?status=<%= status%>&page=<%= i%>&page2=<%= currentPage1%>&activeTab=events"><%= i%></a>
                                    </li>
                                    <% }%>
                                    <li class="page-item <%= currentPage == totalPages ? "disabled" : ""%>">
                                        <a class="page-link" href="?status=<%= status%>&page=<%= currentPage + 1%>&page2=<%= currentPage1%>&activeTab=events" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                        <button id="generateEventReports" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-file-earmark-text me-2"></i>Generate Reports for Selected Events
                        </button>
                    </div>
                </div>

                <!-- Volunteer -->
                <div class="tab-pane fade <%= "volunteers".equals(activeTab) ? "show active" : ""%>" id="volunteers" role="tabpanel">
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-5 col-md-3 mb-3">
                                <div class="search-container col">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="volunteerSearchInput" placeholder="Search Volunteers" oninput="filterVolunteerTable()">
                                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!--table-->
                        <table class="table">
                            <thead>
                                <tr>
                                    <td scope="col" class="col-1">
                                        <div>
                                            <input class="form-check-input" type="checkbox" id="volunteerCheckAll" aria-label="Check All">
                                        </div>
                                    </td>
                                    <th scope="col" class="col-1">ID</th>
                                    <th scope="col" class="col-6">Volunteer Name</th>
                                    <th scope="col" class="text-center col-2">Contact Info</th>
                                    <th scope="col" class="text-center col-2">Report</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <% if (volunteerList != null && !volunteerList.isEmpty()) {
                                        for (volunteer vol : volunteerList) {
                                %>
                                <tr>
                                    <td>
                                        <div>
                                            <input class="form-check-input row-checkbox" type="checkbox" data-volunteer-id="<%=vol.getVolunteerID()%>" aria-label="Row Checkbox">
                                        </div>
                                    </td>
                                    <td><%=vol.getVolunteerID()%></td>
                                    <td><%=vol.getName()%></td>
                                    <td class="text-center"><%=vol.getContactInfo()%></td>
                                    <td class="text-center">
                                        <a class="btn btn-outline-secondary btn-sm" href="<%= request.getContextPath()%>/AdminVolunteer?volunteerID=<%= vol.getVolunteerID()%>">
                                            <i class="bi bi-file-earmark-text me-2"></i>Generate
                                        </a>
                                    </td>
                                </tr>
                                <% }
                                    }%>
                            </tbody>
                        </table>
                        <!-- Pagination -->
                        <div class="col-12 d-flex justify-content-center">
                            <nav aria-label="Volunteer Page navigation">
                                <ul class="pagination">
                                    <li class="page-item <%= currentPage1 == 1 ? "disabled" : ""%>">
                                        <a class="page-link" href="?status=<%= status%>&page=<%= currentPage%>&page2=<%= currentPage1 - 1%>&activeTab=volunteers" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <% for (int i = 1; i <= totalPages1; i++) {%>
                                    <li class="page-item <%= currentPage1 == i ? "active" : ""%>">
                                        <a class="page-link" href="?status=<%= status%>&page=<%= currentPage%>&page2=<%= i%>&activeTab=volunteers"><%= i%></a>
                                    </li>
                                    <% }%>
                                    <li class="page-item <%= currentPage1 == totalPages1 ? "disabled" : ""%>">
                                        <a class="page-link" href="?status=<%= status%>&page=<%= currentPage%>&page2=<%= currentPage1 + 1%>&activeTab=volunteers" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                        <button id="generateVolunteerReports" class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-file-earmark-text me-2"></i>Generate Reports for Selected Volunteers
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // Checkbox logic for Event and Volunteer
        const eventCheckAll = document.querySelector('#eventCheckAll');
        const eventRowCheckboxes = document.querySelectorAll('#events .row-checkbox:not([disabled])');

        const volunteerCheckAll = document.querySelector('#volunteerCheckAll');
        const volunteerRowCheckboxes = document.querySelectorAll('#volunteers .row-checkbox');

        function addCheckboxLogic(masterCheckbox, rowCheckboxes) {
            if (rowCheckboxes.length === 0) {
                masterCheckbox.disabled = true;
                return;
            }

            masterCheckbox.addEventListener('change', function () {
                rowCheckboxes.forEach(checkbox => {
                    if (!checkbox.disabled) {
                        checkbox.checked = this.checked;
                    }
                });
            });

            rowCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function () {
                    const enabledCheckboxes = Array.from(rowCheckboxes).filter(cb => !cb.disabled);
                    const allChecked = enabledCheckboxes.every(cb => cb.checked);
                    const someChecked = enabledCheckboxes.some(cb => cb.checked);

                    masterCheckbox.checked = allChecked;
                    masterCheckbox.indeterminate = someChecked && !allChecked;
                });
            });
        }

        addCheckboxLogic(eventCheckAll, eventRowCheckboxes);
        addCheckboxLogic(volunteerCheckAll, volunteerRowCheckboxes);

        document.getElementById('generateEventReports').addEventListener('click', function () {
            const selectedEvents = [];

            document.querySelectorAll('#events .row-checkbox:checked').forEach(checkbox => {
                const eventID = checkbox.getAttribute('data-event-id');
                if (eventID) {
                    selectedEvents.push(eventID);
                }
            });

            if (selectedEvents.length === 0) {
                alert('No events selected!');
                return;
            }

            selectedEvents.forEach(eventID => {
                const url = new URL("http://localhost:16113/CommunityHub/AdminEvent");
                url.searchParams.append("eventID", eventID);
                window.open(url.toString(), '_blank');
            });
        });

        document.getElementById('generateVolunteerReports').addEventListener('click', function () {
            const selectedVolunteers = [];

            document.querySelectorAll('#volunteers .row-checkbox:checked').forEach(checkbox => {
                const volunteerID = checkbox.getAttribute('data-volunteer-id');
                if (volunteerID) {
                    selectedVolunteers.push(volunteerID);
                }
            });

            if (selectedVolunteers.length === 0) {
                alert('No volunteers selected!');
                return;
            }

            selectedVolunteers.forEach(volunteerID => {
                const url = new URL("http://localhost:16113/CommunityHub/AdminVolunteer");
                url.searchParams.append("volunteerID", volunteerID);
                window.open(url.toString(), '_blank');
            });
        });
    });


    function filterEventTable() {
        // Get the search input value
        const searchValue = document.getElementById('eventSearchInput').value.toLowerCase();

        // Get all rows in the event table body
        const rows = document.querySelectorAll('#events tbody tr');

        // Loop through rows and hide or show based on search match
        rows.forEach(row => {
            const eventName = row.querySelector('td:nth-child(3)').textContent.toLowerCase(); // Event Name column
            const eventDate = row.querySelector('td:nth-child(4)').textContent.toLowerCase(); // Event Date column

            // Check if the search value matches the event name or date
            if (eventName.includes(searchValue) || eventDate.includes(searchValue)) {
                row.style.display = ''; // Show row
            } else {
                row.style.display = 'none'; // Hide row
            }
        });
    }

    function filterVolunteerTable() {
        // Get the search input value
        const searchValue = document.getElementById('volunteerSearchInput').value.toLowerCase();

        // Get all rows in the volunteer table body
        const rows = document.querySelectorAll('#volunteers tbody tr');

        // Loop through rows and hide or show based on search match
        rows.forEach(row => {
            const volunteerName = row.querySelector('td:nth-child(3)').textContent.toLowerCase(); // Volunteer Name column
            const volunteerContact = row.querySelector('td:nth-child(4)').textContent.toLowerCase(); // Contact Info column

            // Check if the search value matches the volunteer name or contact info
            if (volunteerName.includes(searchValue) || volunteerContact.includes(searchValue)) {
                row.style.display = ''; // Show row
            } else {
                row.style.display = 'none'; // Hide row
            }
        });
    }






</script>
