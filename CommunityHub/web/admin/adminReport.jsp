<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
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
            <nav>
                <div class="nav nav-tabs" id="nav-tab" role="tablist">
                    <button class="nav-link active" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true">Event</button>
                    <button class="nav-link" id="nav-profile-tab" data-bs-toggle="tab" data-bs-target="#nav-profile" type="button" role="tab" aria-controls="nav-profile" aria-selected="false">Volunteer</button>

                </div>
            </nav>
            <div class="tab-content" id="nav-tabContent">
                <div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab" tabindex="0">
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
                                        Status
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                        <li><a class="dropdown-item" href="?status=All">All</a></li>    
                                        <li><a class="dropdown-item" href="?status=Pending" >Pending</a></li>
                                        <li><a class="dropdown-item" href="?status=Approved">Approved</a></li>
                                        <li><a class="dropdown-item" href="?status=Rejected">Rejected</a></li>
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
                                    <th scope="col" class="col-1">No</th>
                                    <th scope="col" class="col-6">Event Name</th>
                                    <th scope="col" class="text-center col-2">Date</th>
                                    <th scope="col" class="text-center col-2">Report</th>
                                </tr>
                            </thead>
                            <tbody class="table-group-divider">
                                <%
                                    String status = request.getParameter("status");
                                    Connection conn = null;
                                    PreparedStatement stmt = null;
                                    ResultSet rs = null;

                                    conn = dbconnection.getConnection();

//                                    String sql = "SELECT eventID, name, date FROM events";
//                                    stmt = conn.prepareStatement(sql);
//                                    rs = stmt.executeQuery();
                                    String sql = "SELECT eventID, name, date FROM events";
                                    if (status != null && !"All".equalsIgnoreCase(status)) {
                                        sql += " WHERE status = ?";
                                    }

                                    stmt = conn.prepareStatement(sql);

                                    int idstat = 0;
                                    if (status != null && !"All".equalsIgnoreCase(status)) {
                                        if (status.equalsIgnoreCase("Pending")) {
                                            idstat = 1;
                                        } else if (status.equalsIgnoreCase("Approved")) {
                                            idstat = 2;
                                        } else {
                                            idstat = 3;
                                        }

                                        stmt.setInt(1, idstat);
                                    }

                                    rs = stmt.executeQuery();

                                    int num = 0;
                                    while (rs.next()) {
//                                        String eventIDString = rs.getString("eventID");
//                                        int evt = (eventIDString != null && !eventIDString.isEmpty()) ? Integer.parseInt(eventIDString) : 0;

                                        int evt = rs.getInt("eventID");
                                        String ename = rs.getString("name");
                                        Date eventDate = rs.getDate("date");

                                        String formattedDate = new SimpleDateFormat("dd/MM/YYYY").format(eventDate);
                                        num++;
                                %>
                                <tr>
                                    <td>
                                        <div>
                                            <input class="form-check-input row-checkbox" type="checkbox" data-event-id="<%=evt%>" aria-label="Row Checkbox">
                                        </div>
                                    </td>
                                    <td class=""><%=num%></td>
                                    <td><%=ename%></td>
                                    <td class="text-center"><%=formattedDate%></td>
                                    <td class="text-center ">
                                        <a class="btn btn-info bg-purple rounded-4"  href="reportEvent.jsp?eventID=<%=evt%>">Generate</a>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        <button id="generateEventReports" class="btn btn-info bg-purple rounded-4">
                            Generate Reports for Selected Events
                        </button>
                    </div>
                </div>

                <!-- Volunteer -->
                <div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab" tabindex="0">
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
                                <%
                                    conn = dbconnection.getConnection();

                                    String sql1 = "SELECT * FROM volunteer";
                                    stmt = conn.prepareStatement(sql1);
                                    rs = stmt.executeQuery();

                                    int num1 = 0;
                                    while (rs.next()) {
                                        int vol = rs.getInt("volunteerID");
                                        String name = rs.getString("name");
                                        int contact = rs.getInt("contactInfo");
                                        num1++;
                                %>
                                <tr>
                                    <td>
                                        <div>
                                            <input class="form-check-input row-checkbox" type="checkbox" data-volunteer-id="<%=vol%>" aria-label="Row Checkbox">
                                        </div>
                                    </td>
                                    <td><%=num1%></td>
                                    <td><%=name%></td>
                                    <td class="text-center"><%=contact%></td>
                                    <td class="text-center ">
                                        <a class="btn btn-info bg-purple rounded-4"  href="reportVolunteer.jsp?volunteerID=<%=vol%>">Generate</a>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        <button id="generateVolunteerReports" class="btn btn-info bg-purple rounded-4">
                            Generate Reports for Selected Volunteers
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
        const eventRowCheckboxes = document.querySelectorAll('#nav-home .row-checkbox');

        const volunteerCheckAll = document.querySelector('#volunteerCheckAll');
        const volunteerRowCheckboxes = document.querySelectorAll('#nav-profile .row-checkbox');

        function addCheckboxLogic(masterCheckbox, rowCheckboxes) {
            masterCheckbox.addEventListener('change', function () {
                rowCheckboxes.forEach(checkbox => (checkbox.checked = this.checked));
            });

            rowCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function () {
                    const allChecked = Array.from(rowCheckboxes).every(cb => cb.checked);
                    masterCheckbox.checked = allChecked;

                    if (!this.checked) {
                        masterCheckbox.indeterminate = Array.from(rowCheckboxes).some(cb => cb.checked);
                    } else {
                        masterCheckbox.indeterminate = false;
                    }
                });
            });
        }

        addCheckboxLogic(eventCheckAll, eventRowCheckboxes);
        addCheckboxLogic(volunteerCheckAll, volunteerRowCheckboxes);

        document.getElementById('generateEventReports').addEventListener('click', function () {
            const selectedEvents = [];

            document.querySelectorAll('#nav-home .row-checkbox:checked').forEach(checkbox => {
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
                const url = new URL("http://localhost:16113/CommunityHub/admin/reportEvent.jsp");
                url.searchParams.append("eventID", eventID);
                window.open(url.toString(), '_blank');
            });
        });

        document.getElementById('generateVolunteerReports').addEventListener('click', function () {
            const selectedVolunteers = [];

            document.querySelectorAll('#nav-profile .row-checkbox:checked').forEach(checkbox => {
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
                const url = new URL("http://localhost:16113/CommunityHub/admin/reportVolunteer.jsp");
                url.searchParams.append("volunteerID", volunteerID);
                window.open(url.toString(), '_blank');
            });
        });
    });


    function filterEventTable() {
        // Get the search input value
        const searchValue = document.getElementById('eventSearchInput').value.toLowerCase();

        // Get all rows in the event table body
        const rows = document.querySelectorAll('#nav-home tbody tr');

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
        const rows = document.querySelectorAll('#nav-profile tbody tr');

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
