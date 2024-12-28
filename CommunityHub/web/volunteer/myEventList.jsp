<%-- 
    Document   : myEventList
    Created on : Dec 15, 2024, 1:41:38 AM
    Author     : Rina
--%>

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
                     
            .table {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Poppins', sans-serif;
            border-radius: 15px;
            border-color: #6c757d;
            border-width: 1px;
            overflow: hidden;
            table-layout: fixed;
            }
            
            .custom-thead{
                background-color: #2F6690; 
                color: white;
                text-align: left; /* Align headers to the left */
                padding: 10px;
            }
            
            .table th:nth-child(1), 
            .table td:nth-child(1) {
                width: 15%; /* Width for the first column */
                text-align: center; /* Optional */
            }

            .table th:nth-child(2), 
            .table td:nth-child(2) {
                width: 35%; /* Width for the second column */
            }

            .table th:nth-child(3), 
            .table td:nth-child(3) {
                width: 25%; /* Width for the third column */
            }

            .table th:nth-child(4), 
            .table td:nth-child(4) {
                width: 20%; /* Width for the fourth column */
            }

            .table th:nth-child(5), 
            .table td:nth-child(5) {
                text-align: center;
                width: 20%px; /* Width for the fifth column */
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
    </style>
</head>
<body>
    <%@ include file="../header.jspf" %>
    <div class="container">
        <header>
            <div class="col">
                <h3>MY EVENT</h3>
                <p>Events List</p>
            </div>
            <div class="input-group rounded">
                <input type="search" class="form-control rounded" placeholder="Search" aria-label="Search" aria-describedby="search-addon" />
                <span class="input-group-text border-0" id="search-addon">
                <i class="fas fa-search"></i>
                </span>
            </div>
        </header>
        <table class="table rounded">
            <thead class="custom-thead">
                <tr>
                    <th style="width: 50px;">No.</th>
                    <th>Events</th>
                    <th>Date & Time</th>
                    <th>Task</th>
                    <th>View Details</th>
                </tr>
            </thead>
            <tbody>
                    <% 
                    // Database Connection
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = dbconnection.getConnection(); // Get DB connection
                        String sql = "SELECT * from events e INNER JOIN address a ON e.addressID = a.addressID INNER eventsVolunteer ev ON e.event_id = ev.event_id;";
                        stmt = conn.prepareStatement(sql);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int id = rs.getInt("e.eventID");
                            String title = rs.getString("e.name");
                            Date date = rs.getDate("date");
                            Time time = rs.getTime("e.time");
                            String location = rs.getString("a.state");


                            // Parse and format
                            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                            SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");

                            String formattedDateTime = outputFormat.format(inputFormat.parse(date + " " + time));
                           
                       
                %>
                <tr>
                    <td style="width: 50px;"><%= id %></td>
                    <td><%= title %></td>
                    <td><%= formattedDateTime %></td>
                    <td>task</td>
                    <td><a href="myEventDetail.jsp" class="view-details-button">View Details</a></td>
                </tr>
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
            </tbody>
        </table>        
    </div>
</body>
</html>
