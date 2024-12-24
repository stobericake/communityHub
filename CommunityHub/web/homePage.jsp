<%-- 
    Document   : homePage
    Created on : Dec 13, 2024, 8:47:38 PM
    Author     : Rina
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.cm.model.events" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Event List</title>
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
            }

            .input-group {
                max-width: 250px; 
            }  

            .event-list {
                font-family: 'Poppins', sans-serif;
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .button-container {
              display: flex; /* Arrange buttons horizontally */
            }

            .volunteer-button, .donate-button {
               padding: 10px 20px;
               font-size: 16px;
               cursor: pointer;
            }
            
            .volunteer-button:hover, .donate-button:hover{
                background-color: #F56476;
            }

            .volunteer-button {
               border: none;
               border-radius: 10px 0 0 10px;
               background-color: #2F6690; /* Orange */
               color: white;
            }

            .donate-button {
               border-radius: 0 10px 10px 0;
               background-color: #C3DFE6;
               color: black;
               border-color: #C3DFE6;
               border-width: 0px;
            }
        </style>  

    </head>
    <body>
        <%@ include file="header.jspf" %>
        <div class="container">
        <header>
            <div class="col">
                <h3>EVENT</h3>
                <p>Events List</p>
            </div>
            <div class="input-group rounded">
                <input type="search" class="form-control rounded" placeholder="Search" aria-label="Search" aria-describedby="search-addon" />
                <span class="input-group-text border-0" id="search-addon">
                <i class="fas fa-search"></i>
                </span>
            </div>
        </header>
        
        <ul class="list-group">
            <% 
                // Database Connection
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = dbconnection.getConnection(); // Get DB connection
                    String sql = "SELECT * from events e, address a WHERE e.addressID = a.addressID";
                    stmt = conn.prepareStatement(sql);
                    rs = stmt.executeQuery();         
                          
                    // Iterate through each event
                    while (rs.next()) {
                        int id = rs.getInt("e.eventID");
                        String title = rs.getString("e.name");
                        String description = rs.getString("e.description");
                        Date date = rs.getDate("date");
                        Time time = rs.getTime("e.time");
                        String location = rs.getString("a.state");


                        // Parse and format
                        SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        SimpleDateFormat outputFormat = new SimpleDateFormat("MM/dd/yyyy - hh:mma");

                        String formattedDateTime = outputFormat.format(inputFormat.parse(date + " " + time));      
            %>
            <div class="card mb-3">
                <div class="card-body">
                    <div class="row align-items-center">  
                        <div class="col-auto">  
                            <img class="card-img-top" style="width: 150px;" src="assets/gotong_royong.png" alt="Event Image">
                        </div>
                        <div class="col">
                            <h3><%= title %></h3>
                            <p><%= description %></p>
                        </div>
                        <div class="col-auto">  
                            <div class="row">
                                <span><i class="bi bi-geo-alt"></i> <%= location %></span>
                            </div>
                            <div class="row">
                                <span><i class="bi bi-clock"></i> <%= formattedDateTime %></span>
                            </div>
                            <div class="row justify-content-end">  
                                <div class="button-container">
                                   <td><a href="eventDetail.jsp?eventID=<%= id %>" class="volunteer-button">View Details</a></td>
                                    <button class="donate-button">Donate</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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
            </ul>
            
            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-end">
                  <li class="page-item disabled">
                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                  </li>
                  <li class="page-item"><a class="page-link" href="#">1</a></li>
                  <li class="page-item"><a class="page-link" href="#">2</a></li>
                  <li class="page-item"><a class="page-link" href="#">3</a></li>
                  <li class="page-item">
                    <a class="page-link" href="#">Next</a>
                  </li>
                </ul>
             </nav>
    </div>
</body>
</html>