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
                <h6 class="text-secondary">The tables below shows all of the events</h6>
            </div>
            <div>
                <a href="createEvent.jsp" class="btn btn-primary">
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
                           
                            <% 
                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;

                             session = request.getSession();
                                String beneficiaryID = session.getAttribute("beneficiary").toString();
                                try {
                                    conn = dbconnection.getConnection();
                                    String sql = "SELECT * from events e, address a WHERE e.addressID = a.addressID && beneficiaryID = ?";
                                    stmt = conn.prepareStatement(sql);
                                    stmt.setInt(1, Integer.parseInt(beneficiaryID));
                                    rs = stmt.executeQuery();
                                    int count=1;
                          
                                    while (rs.next()) {
                                        int id = rs.getInt("e.eventID");
                                        String title = rs.getString("e.name");
                                        Date date = rs.getDate("date");
                                        Time time = rs.getTime("e.time");
                                        String location = rs.getString("a.state");
                            %>
                            <tbody>
                                <tr>
                                    <td><%= count++ %></td>
                                    <td class="fw-medium"><%= title %></td>
                                    <td><%= date %></td>
                                    <td><%= time %></td>
                                    <td><%= location %></td>
                                    <td class="text-center">
                                        <div class="btn-group" role="group">
                                            <a href="../updateEvent.do?editEventId=<%= id %>" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="bi bi-pencil"></i> Edit
                                            </a>
                                            <a href="../updateEvent.do?eventDeleteId=<%= id %>" 
                                               class="btn btn-outline-danger btn-sm">
                                                <i class="bi bi-trash"></i> Delete
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                            <% 
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                                    try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                                }
                            %>
                        </table>
                    </div>
                </form>
            </div>
        </div>
    </div>

 
</body>
</html>