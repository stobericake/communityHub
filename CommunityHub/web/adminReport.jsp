<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Generate Report</title>
    </head>
    <body>
        <%@ include file="header.jspf" %>

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
                                        <input type="text" class="form-control" placeholder="search">
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
                                            <input class="form-check-input" type="checkbox" id="checkAll" aria-label="Check All">
                                        </div>
                                    </td>
                                    <th scope="col" class="col-1">ID</th>
                                    <th scope="col" class="col-6">Event Handle</th>
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
                                        <input type="text" class="form-control" placeholder="search">
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
                                            <input class="form-check-input" type="checkbox" id="checkAll" aria-label="Check All">
                                        </div>
                                    </td>
                                    <th scope="col" class="col-1">ID</th>
                                    <th scope="col" class="col-6">Volunteer Name</th>
                                    <th scope="col" class="text-center col-2">Date</th>
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
                                            <input class="form-check-input row-checkbox" type="checkbox" value="" aria-label="Row Checkbox">
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

                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

<script>
//    const eventCheckAll = document.querySelector('#nav-home #checkAll');
//    const eventRowCheckboxes = document.querySelectorAll('#nav-home .row-checkbox');
//
//    const volunteerCheckAll = document.querySelector('#nav-profile #checkAll');
//    const volunteerRowCheckboxes = document.querySelectorAll('#nav-profile .row-checkbox');
//
//    // Function to add checkbox logic
//    function addCheckboxLogic(masterCheckbox, rowCheckboxes) {
//        // Master checkbox controls row checkboxes
//        masterCheckbox.addEventListener('change', function () {
//            rowCheckboxes.forEach(checkbox => {
//                checkbox.checked = this.checked;
//            });
//        });
//
//        // Update master checkbox state when individual rows are toggled
//        rowCheckboxes.forEach(checkbox => {
//            checkbox.addEventListener('change', function () {
//                const allChecked = Array.from(rowCheckboxes).every(cb => cb.checked);
//                masterCheckbox.checked = allChecked;
//
//                // Update indeterminate state
//                if (!this.checked) {
//                    masterCheckbox.indeterminate = Array.from(rowCheckboxes).some(cb => cb.checked);
//                } else {
//                    masterCheckbox.indeterminate = false;
//                }
//            });
//        });
//    }
//
////    function updateDropdownText(selectedItem) {
////        // Get the dropdown button element
////        document.getElementById('dropdownMenuButton').textContent = selectedItem;
////    }
//
//    // Apply the logic to Event tab
//    addCheckboxLogic(eventCheckAll, eventRowCheckboxes);
//
//    // Apply the logic to Volunteer tab
//    addCheckboxLogic(volunteerCheckAll, volunteerRowCheckboxes);
    document.addEventListener("DOMContentLoaded", function () {
        // Event tab checkboxes logic
        const eventCheckAll = document.querySelector('#nav-home #checkAll');
        const eventRowCheckboxes = document.querySelectorAll('#nav-home .row-checkbox');

        
        const volunteerCheckAll = document.querySelector('#nav-profile #checkAll');
        const volunteerRowCheckboxes = document.querySelectorAll('#nav-profile .row-checkbox');

        
        function addCheckboxLogic(masterCheckbox, rowCheckboxes) {
            
            masterCheckbox.addEventListener('change', function () {
                rowCheckboxes.forEach(checkbox => {
                    checkbox.checked = this.checked;
                });
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


    });

</script>
